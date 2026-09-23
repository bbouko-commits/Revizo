# Backend — instructions locales

Complète [`AGENTS.md`](../AGENTS.md) à la racine, sans l'assouplir. Fiche du rôle : [`docs/agents/backend.md`](../docs/agents/backend.md).

## État

Dossier réservé. Le projet Spring Boot sera initialisé par #5 et #6 selon l'[ADR 0002](../docs/adr/0002-backend-spring-boot-monolithe-modulaire.md) ; #5 fige les versions de Java, Spring Boot et Maven après nouvelle vérification. À compléter alors : commandes, structure des modules, conventions d'API et de tests.

## Règles techniques déjà applicables

- Clés IA et autres secrets lus depuis l'environnement ou un gestionnaire de secrets.
- Chaque endpoint d'une ressource familiale a deux tests : refus anonyme et refus depuis une autre famille.
- Appels IA simulés dans les tests automatisés ; aucun appel payant en CI.
- Traitements longs (import, extraction, génération) : reprise possible, retries bornés, pas de double facturation.
- Journaux sans contenu de cours, sans secret et sans donnée personnelle d'enfant.
