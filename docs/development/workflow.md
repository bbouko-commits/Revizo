# Workflow de développement

Ce document détaille le cycle issue → PR. Les règles non négociables (merge, secrets, données) sont dans [`AGENTS.md`](../../AGENTS.md) et ne sont pas répétées ici.

## Cycle

1. **Issue prête** (voir Definition of Ready).
2. **Branche courte** depuis `main` à jour : `<type>/<issue>-<sujet>`, par exemple `feat/27-import-photos`, `fix/35-reprise-seance`, `docs/4-workflow`. Types : `feat`, `fix`, `docs`, `chore`, `refactor`, `test`, `ci`. Une branche imposée par l'outil (agent cloud) est acceptée si la PR référence l'issue.
3. **Implémentation** limitée au périmètre de l'issue. Un besoin découvert en route devient une nouvelle issue.
4. **Vérifications** ciblées : tests et contrôles du dossier modifié, puis relecture du diff.
5. **PR** vers `main` avec le modèle `.github/pull_request_template.md`.
6. **Revue humaine**, puis merge manuel par le mainteneur.

`main` reste intégrable à tout moment : dès que du code et une CI existent, elle compile et ses tests passent.

## Lier PR et issues

- `Closes #n` uniquement si la PR couvre **tous** les critères d'acceptation de l'issue.
- `Refs #n` pour une contribution partielle ; la PR liste alors ce qui reste.
- Une issue n'est jamais fermée à la main avant intégration de sa réalisation.
- Une case d'issue n'est cochée que sur preuve (test, commande, capture), jamais sur la base d'un plan.

## PR dépendantes

Par défaut, on attend le merge de la PR dont on dépend. Si un travail doit avancer avant, la PR dépendante :

- part de la branche de la PR amont et cible cette branche, ou `main` en mode brouillon ;
- l'indique en tête de description (« Dépend de #n ») ;
- est rebasée ou mise à jour après le merge amont.

## Definition of Ready

Une issue est prête lorsque :

- [ ] le problème et le résultat attendu sont décrits ;
- [ ] le périmètre et le hors-périmètre sont explicites ;
- [ ] les critères d'acceptation sont observables ;
- [ ] les dépendances sont fusionnées ou une stratégie est écrite ;
- [ ] les décisions qui la bloquent sont prises, ou l'issue est marquée bloquée.

## Definition of Done

Une PR est terminée lorsque :

- [ ] chaque critère d'acceptation a une preuve, ou est déclaré non couvert (`Refs` au lieu de `Closes`) ;
- [ ] les tests ciblés et les contrôles disponibles passent ; ceux non exécutés sont listés avec la raison ;
- [ ] le diff a été relu : pas de secret, pas de donnée réelle, pas de code mort ;
- [ ] les rôles de revue requis ont rendu leur avis (voir [`docs/agents/README.md`](../agents/README.md)) ;
- [ ] la documentation touchée est à jour ;
- [ ] un humain a relu et fusionné.

## Priorités, lots et blocages

Sans labels configurés, chaque issue indique dans sa description sa priorité et son lot ; les blocages sont signalés par commentaire :

- **Priorité** : `P0` cadrage et fondations, `P1` parcours MVP et pilote, `P2` futur ou extension à confirmer.
- **Lot** : MVP ou futur. Ce qui n'est pas nécessaire au premier jalon démontrable (#45) est classé futur.
- **Blocage** : un commentaire court « Bloqué par #n » ou « Bloqué par décision : … », retiré une fois levé.

Les labels `P0`, `P1`, `P2`, `bloqué`, `décision` peuvent être créés dans GitHub ; ce n'est pas requis.

## Décisions techniques (ADR)

Une décision structurante (framework, stockage, fournisseur, modèle d'accès) est consignée dans `docs/adr/NNNN-titre.md` à partir de [`docs/adr/0000-modele.md`](../adr/0000-modele.md). Statut `proposé` jusqu'à l'accord du mainteneur, puis `accepté`. Un ADR accepté n'est pas réécrit : un nouvel ADR le remplace.

## CI

Aucun workflow n'existe encore (#15). Dès qu'il existe, ses checks sont requis avant merge. Les workflows ont des permissions minimales et n'exposent aucun secret aux PR provenant de forks.

## Réglages GitHub à faire à la main

Aucun fichier du dépôt ne configure ces réglages. Recommandations pour `main` (Settings → Rules ou Branches) :

| Réglage | Valeur recommandée | Remarque |
| --- | --- | --- |
| Pull request obligatoire avant merge | Oui | Interdit le push direct sur `main`. |
| Approbations requises | 0 tant que le mainteneur est seul | GitHub n'autorise pas l'auteur à approuver sa propre PR ; la revue humaine reste le merge manuel du mainteneur. Passer à 1 dès qu'un second relecteur existe. |
| Checks requis | Ceux de #15, une fois créés | |
| Force-push et suppression de `main` | Interdits | |
| Allow auto-merge (Settings → General) | Désactivé | Aucun merge automatique. |
| Environnement `production` | Approbation manuelle requise | À configurer avec #16. |

État actuel : ces réglages ne sont pas vérifiés par les agents ; le mainteneur confirme lorsqu'ils sont appliqués.
