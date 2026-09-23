# Frontend — instructions locales

Complète [`AGENTS.md`](../AGENTS.md) à la racine, sans l'assouplir. Fiche du rôle : [`docs/agents/frontend.md`](../docs/agents/frontend.md).

## État

Dossier réservé. Framework : **Angular en PWA** ([ADR 0001](../docs/adr/0001-frontend-angular-pwa.md)). Le projet est initialisé par #5 avec la CLI Angular, puis structuré par #7 ; d'ici là, n'installez aucune dépendance ici. À compléter alors : versions, commandes, structure, conventions de tests.

## Règles techniques déjà applicables

- Interface responsive dès le départ : téléphone et ordinateur.
- Le design system Claude Design fait référence : ses tokens, typographies, composants et règles d'accessibilité priment sur tout style inventé. Son versionnement dans le dépôt est prévu par #8.
- Aucun appel direct à un fournisseur IA depuis le navigateur : tout passe par l'API.
- Pas de bibliothèque de composants tierce qui impose son style : les composants sont construits sur les tokens et le CSS du design system.
- Aucune donnée privée (cours, supports, réponses) hors ligne au MVP : le service worker ne met pas en cache les appels à l'API, la déconnexion efface l'état local.
- Contenus générés et texte extrait affichés comme texte, jamais injectés comme HTML.
