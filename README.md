# Révizo

Révizo aide les enfants à préparer leurs interrogations : photographier un cours, préciser ce qu'il faut étudier et la date, générer résumés, flashcards et questionnaires, puis suivre des séances de révision. Le parent contrôle, corrige et recadre les contenus générés.

Nom du produit : Révizo (décision du mainteneur, #19). Identifiant technique sans accent : `revizo`.

## État

Squelettes backend et frontend sans fonctionnalité métier. La roadmap est suivie dans l'issue #45.

| Dossier | Contenu |
| --- | --- |
| `backend/` | API Java 21, Spring Boot 4.1, Maven Wrapper |
| `frontend/` | Application Angular 22 (PWA prévue) |
| `docs/` | Architecture, décisions (ADR), rôles des agents, workflow |
| `infra/` | Réservé à l'environnement Docker (#9) et au déploiement (#16) |
| `scripts/` | Contrôles locaux |

## Installation depuis un clone vierge

Prérequis :

- Git ;
- JDK 21 ou plus récent (le build compile en Java 21) ;
- Node.js 24.21 ou une version 24.x plus récente (`nvm use` dans `frontend/` lit `.nvmrc`), avec npm 11.19 ou plus récent ; `npm ci` refuse les autres versions ;
- sous Windows : Git Bash ou WSL pour `scripts/*.sh` et `./mvnw` (`mvnw.cmd` fonctionne aussi dans un terminal Windows).

Maven n'a pas besoin d'être installé : `backend/mvnw` télécharge la version prévue et vérifie son empreinte.

```bash
git clone https://github.com/bbouko-commits/Revizo.git
cd Revizo
(cd frontend && npm ci)
scripts/check.sh
```

`scripts/check.sh` doit se terminer par « Tous les contrôles sont passés. »

## Commandes

| Besoin | Backend (`cd backend`) | Frontend (`cd frontend`) |
| --- | --- | --- |
| Démarrer en développement | `./mvnw spring-boot:run` (port 8080) | `npm start` (port 4200) |
| Tests | `./mvnw test` | `npm run test:ci` (`npm test` en mode surveillance) |
| Formater | `./mvnw spotless:apply` | `npm run format` |
| Vérifier le format | `./mvnw spotless:check` | `npm run format:check` |
| Build complet | `./mvnw verify` (format, tests, archive) | `npm run build` |

Tout contrôler depuis la racine : `scripts/check.sh`. Documentation seule : `scripts/check-docs.sh`.

Copier `.env.example` en `.env` pour des valeurs locales. Le fichier `.env` est ignoré par Git et aucune variable n'est encore lue par l'application.

## Contribuer

- Règles communes (humains et agents) : [`AGENTS.md`](AGENTS.md)
- Workflow, Definition of Ready / Done : [`docs/development/workflow.md`](docs/development/workflow.md)
- Rôles et sous-agents : [`docs/agents/README.md`](docs/agents/README.md)
- Décisions techniques : [`docs/adr/`](docs/adr/)

Ce dépôt est public : n'y ajoutez aucun secret, aucun document scolaire réel et aucune donnée personnelle d'enfant.
