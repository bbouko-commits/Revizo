# Rôles et orchestration

Huit rôles aident à découper le travail. Ils ne s'exécutent jamais tous : l'agent principal (la session Claude Code ou Codex qui reçoit la tâche) choisit les seuls rôles utiles.

## Deux niveaux à ne pas confondre

| Niveau | Emplacement | Nature |
| --- | --- | --- |
| Fiches de rôle | `docs/agents/*.md` | Documentation : mission, entrées, livrables, limites. Source de vérité. Aucun outil ne les exécute seules. |
| Adaptateurs Claude Code | `.claude/agents/*.md` | Sous-agents exécutables. Frontmatter + consigne courte qui renvoie à la fiche. |
| Adaptateurs Codex | `.codex/agents/*.toml` | Rôles exécutables via `spawn_agent`. Même consigne courte. |

Les adaptateurs ne recopient pas les fiches : modifier un rôle, c'est modifier sa fiche. Les adaptateurs ne fixent aucun modèle : il est hérité de la session ou configuré localement.

## Rôles

| Rôle | Fiche | Écrit dans | Appelé quand |
| --- | --- | --- | --- |
| Product owner | [product-owner.md](product-owner.md) | `docs/product/` | besoin ambigu, parcours ou décision produit |
| Architecte | [architect.md](architect.md) | `docs/adr/`, `docs/architecture/` | choix structurant, nouveau module ou contrat |
| Backend | [backend.md](backend.md) | `backend/`, contrat d'API | code serveur |
| Frontend | [frontend.md](frontend.md) | `frontend/` | code d'interface |
| Relecteur design | [design-reviewer.md](design-reviewer.md) | rien (rapport) | écran ou composant visible modifié |
| QA | [qa.md](qa.md) | fichiers de test | preuve des critères avant PR fonctionnelle |
| Relecteur sécurité | [security-reviewer.md](security-reviewer.md) | rien (rapport) | accès, données, secrets, IA, CI (obligatoire) |
| DevOps | [devops.md](devops.md) | `infra/`, `scripts/`, `.github/workflows/` | environnement, CI, livraison |

## Règles d'orchestration

1. **Choisir peu.** Partir de la table ci-dessus ; une tâche simple se fait sans sous-agent.
2. **Contexte borné.** Donner au sous-agent l'issue, les fichiers concernés et le livrable attendu, pas tout l'historique.
3. **Un seul écrivain par zone.** Deux sous-agents ne modifient jamais les mêmes fichiers en même temps. Les écritures se font en séquence ; les relectures peuvent être parallèles.
4. **Relecteur distinct.** Un changement sensible est relu par `security-reviewer`, jamais par l'agent qui l'a écrit.
5. **Pas de boucle.** Les sous-agents ne délèguent pas à d'autres sous-agents. Au plus un aller-retour correction → relecture par relecteur ; au-delà, l'agent principal s'arrête et remonte le désaccord au mainteneur.
6. **Autorisations inchangées.** Merge, publication, dépenses et accès aux secrets restent gouvernés par les autorisations réelles de l'utilisateur et de l'outil, quel que soit le rôle.

## Invocation

### Claude Code

Les sous-agents de `.claude/agents/` sont chargés au démarrage d'une session dans le dépôt. Demander explicitement : « Utilise le sous-agent `security-reviewer` sur le diff de cette branche. » Claude Code peut aussi déléguer seul d'après la `description`. Les relecteurs n'ont que `Read, Grep, Glob, Bash` ; `product-owner` et `architect` ont `Read, Grep, Glob, Edit, Write` ; `backend`, `frontend`, `qa` et `devops` héritent des outils de la session sauf `Agent`, pour éviter les délégations en chaîne.

### Codex

Les rôles de `.codex/agents/` sont proposés comme `agent_type` de l'outil `spawn_agent` (fonction multi-agents, active par défaut dans la version vérifiée). **Codex ne charge la configuration `.codex/` que si le projet est marqué de confiance** dans `~/.codex/config.toml` :

```toml
[projects."/chemin/absolu/vers/Revizo"]
trust_level = "trusted"
```

Demander ensuite : « Lance un agent `security-reviewer` sur le diff de cette branche. » Sans cette confiance, ou avec une version sans multi-agents, demander à Codex d'appliquer directement la fiche : « Applique `docs/agents/security-reviewer.md` à ce diff. »

## Compatibilité vérifiée

Vérifié le 2026-09-23 avec Claude Code 2.1.280 et Codex CLI 0.156.1. Détail et limites dans [`docs/development/agent-check.md`](../development/agent-check.md).

## Exemples

### Tâche simple : corriger le libellé d'un message d'erreur de l'API

- Rôle : aucun sous-agent. L'agent principal applique `backend/AGENTS.md`, corrige, lance les tests backend et ouvre la PR.
- Pourquoi : un seul fichier, pas de donnée sensible, pas d'écran modifié.

### Tâche transversale : #34 recadrer l'IA et régénérer sans perdre les corrections

| Étape | Rôle | Pourquoi | Écrit dans |
| --- | --- | --- | --- |
| 1 | product-owner | Préciser ce qu'est une « correction du parent » et ce qui se passe en cas de conflit | `docs/product/` |
| 2 | architect | Modèle de données des versions et règle de fusion ; ADR si le modèle change | `docs/adr/` |
| 3 | backend | Régénération qui préserve les éléments corrigés, reprise après interruption | `backend/` |
| 4 | frontend | Écran de recadrage et affichage des éléments préservés | `frontend/` |
| 5 | qa | Tests : corrections conservées, interruption et reprise, IA simulée en échec, accès inter-familles | fichiers de test |
| 6 (parallèle) | security-reviewer | Texte du parent et du cours envoyés à l'IA : injection d'instructions, fuite entre familles | rapport |
| 6 (parallèle) | design-reviewer | Conformité de l'écran au design system | rapport |

DevOps n'est pas appelé : ni CI ni infrastructure ne changent. Les étapes 3 et 4 écrivent dans des dossiers distincts et peuvent se suivre sans conflit ; le contrat d'API est fixé à l'étape 3 avant l'étape 4.
