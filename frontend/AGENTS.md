# Frontend — instructions locales

Complète [`AGENTS.md`](../AGENTS.md) à la racine, sans l'assouplir. Fiche du rôle : [`docs/agents/frontend.md`](../docs/agents/frontend.md).

## État

Dossier réservé. **Le framework n'est pas choisi** (#1) : n'initialisez aucun projet, n'installez aucune dépendance et ne produisez pas de code de framework ici avant l'ADR frontend accepté. À compléter ensuite : framework, versions, commandes, structure, conventions de tests.

## Règles techniques déjà applicables

- Interface responsive dès le départ : téléphone et ordinateur.
- Le design system Claude Design fait référence : ses tokens, typographies, composants et règles d'accessibilité priment sur tout style inventé. Son versionnement dans le dépôt est prévu par #8.
- Aucun appel direct à un fournisseur IA depuis le navigateur : tout passe par l'API.
