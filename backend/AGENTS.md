# Backend — instructions locales

Complète [`AGENTS.md`](../AGENTS.md) à la racine, sans l'assouplir. Fiche du rôle : [`docs/agents/backend.md`](../docs/agents/backend.md).

## État

Squelette Spring Boot sans fonctionnalité (#5) : Java 21, Spring Boot 4.1.1, Maven 3.9.11 via `./mvnw` (empreinte vérifiée), package racine `app.revizo`. Voir l'[ADR 0002](../docs/adr/0002-backend-spring-boot-monolithe-modulaire.md). Structure des modules, conventions d'API et de tests : #6.

## Commandes

À lancer dans `backend/`.

| Besoin | Commande |
| --- | --- |
| Démarrer (port 8080) | `./mvnw spring-boot:run` |
| Tests | `./mvnw test` |
| Formater (google-java-format via Spotless) | `./mvnw spotless:apply` |
| Tout vérifier avant PR (versions d'outils, format, tests, archive) | `./mvnw verify` |

## Règles techniques déjà applicables

- Clés IA et autres secrets lus depuis l'environnement ou un gestionnaire de secrets.
- Chaque endpoint d'une ressource familiale a deux tests : refus anonyme et refus depuis une autre famille.
- Appels IA simulés dans les tests automatisés ; aucun appel payant en CI.
- Traitements longs (import, extraction, génération) : reprise possible, retries bornés, pas de double facturation.
- Journaux sans contenu de cours, sans secret et sans donnée personnelle d'enfant.
