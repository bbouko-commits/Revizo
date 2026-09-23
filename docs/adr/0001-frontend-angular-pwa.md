# 0001 — Frontend en Angular, livré en PWA

- **Statut** : accepté
- **Date** : 2026-09-23
- **Décideur** : mainteneur du dépôt (confirmation dans #19)
- **Issues** : #1 ; impacte #5, #7, #8, #10, #18

## Contexte

L'interface doit être responsive (téléphone et ordinateur), fidèle au design system réalisé avec Claude Design, et pouvoir évoluer vers Android/iOS. Le mainteneur a de l'expérience Angular. Le choix devait se faire après inspection d'un export réel, traité comme une donnée (règle 4 d'`AGENTS.md`).

### Export inspecté

- Design system « Révizo », artefact Claude Design du mainteneur, version `1790155883-301d` lue le 2026-09-23.
- **Fichiers lus** : `project/README.md` (sha256 `61e24dce…aced0`) et `project/tokens.json` (sha256 `51a854fe…a7881`).
- **Constaté dans `tokens.json`** : 2 thèmes (clair, sombre), 5 thèmes de compagnon, familles Fredoka et Nunito avec 7 styles de texte, espacements sur base 4px, 4 rayons, une ombre.
- **Annoncé par le README, non vérifié fichier par fichier** : variables CSS générées (`tokens.css`), bibliothèque de classes CSS `rvz-*` sans dépendance (`components/bundle.css`), 11 composants, 13 écrans mobiles, 6 écrans PC, SVG et ressources PWA. Le README ne mentionne ni React ni un autre framework.
- **Écarts** : `project/tokens.css` n'était pas publié à l'emplacement attendu. Le README prévoit « le stockage de la clé IA côté client », contraire à la règle 2 d'`AGENTS.md` et à la décision #19 : ce point de l'export n'est pas suivi, la clé reste côté serveur.

L'inventaire complet (composants, écrans, SVG, licences) est l'objet de #8.

## Options

| Critère | Angular (TypeScript) | React (TypeScript) |
| --- | --- | --- |
| Reprise de l'export | Tokens et CSS `rvz-*` utilisables tels quels ; écrans à coder en composants | Identique : l'export ne fournit pas de code React à reprendre |
| Expérience du mainteneur | Connue | À acquérir |
| Accessibilité | Primitives du CDK Angular (focus, clavier, annonces) sans style imposé | Bibliothèques tierces sans style (plusieurs choix possibles) |
| Tests | Outils de test unitaires et de composants intégrés à la CLI ; E2E avec Playwright (#14) | Vitest et Testing Library à assembler ; E2E identique |
| Structure et maintenance | Routage, formulaires, HTTP et PWA fournis ; une version majeure tous les six mois environ, mises à jour guidées par la CLI | Bibliothèque d'interface : routage, formulaires et état à choisir et à maintenir séparément |
| Mobile | PWA officielle ; compatible Capacitor | PWA et Capacitor également possibles |
| Coût d'un retour arrière | Réécriture des écrans ; API, tokens et CSS conservés | Idem |

## Décision

Angular en TypeScript, livré comme application web responsive installable en PWA. Les écrans sont codés en composants Angular à partir des tokens et du CSS du design system, sans bibliothèque de composants tierce qui imposerait un autre style.

## Conséquences

- #5 initialise `frontend/` avec la CLI Angular, un lockfile et des versions figées ; #7 pose le socle responsive, le catalogue de composants et l'outillage de test.
- #8 versionne tokens, CSS et SVG dans le dépôt, vérifie les fichiers annoncés et régénère `tokens.css` depuis `tokens.json` s'il manque.
- #10 fournit un client typé à partir du contrat OpenAPI ; la méthode (génération ou écriture) y est choisie.
- Polices hébergées avec l'application (pas d'appel à Google Fonts), comme le recommande le design system.
- Le service worker ne met en cache que les fichiers de l'application ; aucune donnée privée hors ligne au MVP.
- À revoir si un besoin mobile ne peut être couvert ni par la PWA ni par Capacitor (#18).

## Vérifications

- Lus : README et `tokens.json` du design system. Non lus : `bundle.css`, écrans et SVG.
- Versions publiées sur npm le 2026-09-23 : `@angular/core` 22.1.7, `@angular/cli` et `@angular/pwa` 22.1.8. Aucun projet Angular n'a encore été compilé.
