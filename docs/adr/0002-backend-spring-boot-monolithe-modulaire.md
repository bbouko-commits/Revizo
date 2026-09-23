# 0002 — Backend Spring Boot en monolithe modulaire, PostgreSQL et stockage objet privé

- **Statut** : proposé. Java et Spring Boot sont un choix déjà exprimé par le mainteneur ; le découpage, la base et le stockage sont des propositions. **#5, #6, #9 et #12 attendent l'acceptation de cet ADR.**
- **Date** : 2026-09-23
- **Décideur** : mainteneur du dépôt
- **Issues** : #1 ; impacte #5, #6, #9, #11, #12, #13

## Contexte

Le backend porte les données des familles, l'accès des enfants, les imports de photos, les traitements IA longs et leur coût. Il doit rester simple à faire tourner pour une petite équipe et servir un futur client mobile.

## Options

### Découpage

- **A — Monolithe modulaire** : une seule application déployée, des modules métier séparés par paquets et interfaces (voir [overview](../architecture/overview.md)). Simple à exploiter, transactions locales, redécoupable plus tard.
- **B — Microservices** : isolation forte, mais réseau, déploiements et observabilité multipliés sans besoin mesuré.

### Données

- **PostgreSQL** : relationnel adapté aux familles, cours, versions de supports et séances ; sert aussi de file de jobs (`SELECT … FOR UPDATE SKIP LOCKED`), sans broker.
- Alternative écartée pour le MVP : base documentaire, qui compliquerait les contrôles d'appartenance et les versions.

### Photos de cours

- **Stockage objet privé compatible S3** : originaux hors de la base, accès uniquement via l'API, suppression traçable. En local, un conteneur compatible S3 (#9).
- Alternative : fichiers sur disque, plus simple mais sans chemin propre vers l'hébergement.

## Décision proposée

- Java 21 LTS, Spring Boot 4.1.x, Maven avec wrapper (justification des versions dans l'[overview](../architecture/overview.md#versions-vérifiées-le-2026-09-23)).
- Monolithe modulaire, API REST JSON documentée en OpenAPI.
- PostgreSQL pour les données et la table de jobs ; migrations versionnées.
- Stockage objet privé compatible S3 pour les images, derrière une interface interne.
- Appels IA via une passerelle interne avec adaptateurs OpenAI et Anthropic, et un adaptateur simulé pour les tests (#13).

## Conséquences

- Une fois l'ADR accepté, #5 et #6 créent `backend/` sur ces versions ; #9 fournit PostgreSQL et le stockage S3 local en Docker.
- L'API doit pouvoir authentifier un client non navigateur (application Capacitor ou native) : à prévoir dans #11.
- Les choix précis (ORM ou SQL, outil de migration, bibliothèque OpenAPI, SDK des fournisseurs IA) sont faits et justifiés dans #6, #10 et #13.
- L'hébergement devra fournir PostgreSQL et un stockage objet privé (décision ouverte, #16).
- À revoir si un module exige un déploiement ou une montée en charge séparés, mesure à l'appui.

## Vérifications

- Spring Boot 4.1.1 est la dernière version stable sur Maven Central le 2026-09-23 (4.2.0-M1 est un jalon, écarté).
- JDK 21 et Maven 3.9.11 sont disponibles dans l'environnement de travail. Aucun projet n'a encore été compilé.
- Versions de PostgreSQL et de l'outil de stockage S3 local : non vérifiées, à figer avec #9.
