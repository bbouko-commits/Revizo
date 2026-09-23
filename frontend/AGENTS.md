# Frontend — instructions locales

Complète [`AGENTS.md`](../AGENTS.md) à la racine, sans l'assouplir. Fiche du rôle : [`docs/agents/frontend.md`](../docs/agents/frontend.md).

## État

Squelette Angular 22 sans fonctionnalité (#5), créé avec la CLI : composants autonomes, routage, CSS, tests unitaires Vitest avec jsdom, pas de rendu serveur. PWA, socle responsive, design system et structure : #7 et #8 ([ADR 0001](../docs/adr/0001-frontend-angular-pwa.md)).

- Node 24 (version exacte dans `.nvmrc`), npm 11, dépendances figées par `package-lock.json` : installer avec `npm ci`.
- Scripts d'installation des dépendances : refusés par défaut. `.npmrc` active `strict-allow-scripts` (échec de `npm ci` si un paquet à script n'est pas listé) et `engine-strict` (échec hors Node 24). La liste `allowScripts` de `package.json` refuse `@parcel/watcher`, `esbuild`, `fsevents`, `lmdb` et `msgpackr-extract` : build et tests n'en ont pas besoin. N'en autorisez un que pour un besoin vérifié.

## Commandes

À lancer dans `frontend/`.

| Besoin | Commande |
| --- | --- |
| Installer | `npm ci` |
| Démarrer (port 4200) | `npm start` |
| Tests (une passe) | `npm run test:ci` |
| Formater (Prettier) | `npm run format` |
| Vérifier le format | `npm run format:check` |
| Build de production | `npm run build` |

## Règles techniques déjà applicables

- Interface responsive dès le départ : téléphone et ordinateur.
- Le design system Claude Design fait référence : ses tokens, typographies, composants et règles d'accessibilité priment sur tout style inventé. Son versionnement dans le dépôt est prévu par #8.
- Aucun appel direct à un fournisseur IA depuis le navigateur : tout passe par l'API.
- Pas de bibliothèque de composants tierce qui impose son style : les composants sont construits sur les tokens et le CSS du design system.
- Aucune donnée privée (cours, supports, réponses) hors ligne au MVP : le service worker ne met pas en cache les appels à l'API, la déconnexion efface l'état local.
- Contenus générés et texte extrait affichés comme texte, jamais injectés comme HTML.
