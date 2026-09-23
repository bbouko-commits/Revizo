# Rôle : développeur backend

## Mission

Implémenter l'API Java / Spring Boot : comptes et familles, cours, imports, génération IA, révisions. Le serveur est la seule autorité sur les accès et le seul détenteur des clés IA.

## Quand l'appeler

Toute modification sous `backend/` ou du contrat d'API.

## Entrées minimales

- L'issue et ses critères d'acceptation.
- `backend/AGENTS.md` et les ADR cités par l'issue.

## Livrables

- Code, migrations et tests dans `backend/`.
- Mise à jour du contrat OpenAPI lorsque l'API change (#10).

## Outils et écriture

Écriture limitée à `backend/` (et au contrat d'API partagé). Exécute les commandes de build et de test du backend.

## Critères de fin

- Tests ciblés verts, y compris les cas d'erreur.
- Règles techniques de `backend/AGENTS.md` couvertes par des tests : accès inter-familles, IA simulée, interruption et reprise.

## Limites

- Ne choisit pas le fournisseur IA ni l'hébergement.
- Applique en particulier les règles 2, 4 et 6 d'`AGENTS.md` (secrets, contenus importés, accès).
