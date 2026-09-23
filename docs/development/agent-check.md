# Vérifier que les agents lisent les consignes

À refaire après une modification de `AGENTS.md`, `CLAUDE.md`, des adaptateurs de rôles ou une mise à jour majeure d'un outil.

## Tâche exemple

Depuis la racine du dépôt, poser à l'agent, sans lui indiquer de fichier :

> Réponds sans utiliser d'outil. 1) Cite le titre de la règle non négociable n°3. 2) Liste les sous-agents ou rôles du projet disponibles. 3) Quelle commande de contrôle est disponible aujourd'hui ?

Réponse attendue :

1. « Dépôt public : données synthétiques uniquement. »
2. Les huit rôles : `product-owner`, `architect`, `backend`, `frontend`, `design-reviewer`, `qa`, `security-reviewer`, `devops`.
3. `scripts/check-docs.sh` ; les commandes de build et de test n'existent pas encore (#5).

Puis lancer `scripts/check-docs.sh` : il doit afficher `Documentation OK (8 rôles).`

## Comment chaque outil trouve les consignes

| Outil | Consignes communes | Instructions locales | Rôles exécutables |
| --- | --- | --- | --- |
| Claude Code | `CLAUDE.md`, qui importe `AGENTS.md` avec `@AGENTS.md` | `backend/CLAUDE.md` et `frontend/CLAUDE.md` importent l'`AGENTS.md` du dossier ; chargés quand l'agent lit des fichiers de ce dossier | `.claude/agents/*.md` |
| Codex | `AGENTS.md` de la racine du dépôt jusqu'au dossier courant, concaténés dans cet ordre ; `CLAUDE.md` n'est pas lu | Uniquement si Codex est lancé dans le dossier, sinon via la règle « lire l'`AGENTS.md` local » de la racine | `.codex/agents/*.toml`, **seulement si le projet est de confiance** |

## Résultats du 2026-09-23

| Vérification | Outil et version | Méthode | Résultat |
| --- | --- | --- | --- |
| Tâche exemple | Claude Code 2.1.280 | `claude -p` dans une copie du dépôt | Réponses 1 à 3 conformes ; les huit sous-agents listés |
| Tâche exemple | Codex CLI 0.156.1 | — | **Non exécutée** : pas de compte ni de clé API Codex dans l'environnement de vérification. Les éléments de réponse sont présents dans l'entrée du modèle (ligne suivante) ; les noms des rôles figurent aussi dans `AGENTS.md`, donc la question 2 ne dépend pas de la confiance du projet. |
| Consignes racine chargées | Codex CLI 0.156.1 | `codex debug prompt-input` depuis la racine, sans clé API | `AGENTS.md` présent dans l'entrée du modèle |
| Consignes locales | Codex CLI 0.156.1 | idem depuis `backend/` puis `frontend/` | `AGENTS.md` racine puis celui du dossier, dans cet ordre |
| Rôles exécutables | Codex CLI 0.156.1 | `codex exec` vers un serveur local simulé, projet marqué de confiance ; lecture de la requête envoyée | Les huit rôles proposés comme `agent_type` de `spawn_agent`, sans avertissement de rôle mal formé |
| Consignes locales à la demande | Claude Code 2.1.280 | Session de travail sur #5 : lecture et édition de fichiers de `backend/` | `backend/CLAUDE.md` (et donc `backend/AGENTS.md`) chargé automatiquement |
| Contrôle des liens et adaptateurs | — | `scripts/check-docs.sh` | OK ; dans une copie altérée, lien cassé (fichier accentué), section de fiche manquante et adaptateur orphelin sont signalés, et les liens valides avec titre, chevrons, `%20`, ancre ou chemin racine ne le sont pas |

## Limites connues

- **Codex, sans confiance** : `.codex/agents/` est ignoré sans message. Utiliser alors la fiche directement (« Applique `docs/agents/qa.md` »).
- **Codex, restrictions des rôles** : un agent créé par `spawn_agent` peut lui-même créer des agents ; la consigne « ne délègue pas » n'est qu'une instruction. L'effet de `sandbox_mode = "read-only"` sur les relecteurs n'a pas été observé sur une vraie exécution de modèle.
- **Codex, instructions locales** : lancé depuis la racine, Codex ne charge pas `backend/AGENTS.md` ou `frontend/AGENTS.md` ; il dépend de la règle de la racine qui demande de les lire.
- **Claude Code, relecteurs** : leur outil `Bash` permet techniquement d'écrire ; la lecture seule est une consigne, les autorisations de la session s'appliquent.
- Les deux outils évoluent vite : refaire cette vérification après une mise à jour.
