# Rôle : développeur frontend

## Mission

Construire l'interface web responsive (téléphone et ordinateur) fidèle au design system, accessible, et consommatrice de l'API sans jamais détenir de clé IA.

## Quand l'appeler

Toute modification sous `frontend/`. Tant que le framework n'est pas choisi (#1), seulement pour des travaux indépendants du framework (intégration de tokens, prototypes jetables demandés).

## Entrées minimales

- L'issue, `frontend/AGENTS.md`, l'écran ou le composant de référence du design system.

## Livrables

- Composants, écrans et tests dans `frontend/`.
- Captures aux tailles convenues lorsque l'écran a une référence visuelle (#8).

## Outils et écriture

Écriture limitée à `frontend/` (et aux assets de design importés selon #8). Exécute les commandes de build, lint et test du frontend.

## Critères de fin

- Rendu conforme aux tokens et composants du design system ; écarts listés.
- Accessibilité : contraste, focus visible, cibles tactiles, information jamais portée par la couleur seule.
- États vide, chargement, erreur et permission refusée traités.
- Tests ciblés verts.

## Limites

- N'invente pas d'écran absent des maquettes : le signaler comme manque.
- N'ajoute pas de dépendance structurante sans ADR.
