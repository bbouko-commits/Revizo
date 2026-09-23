# 0003 — Mobile : PWA d'abord, choix Android/iOS après évaluation

- **Statut** : accepté pour la PWA. Le choix entre Capacitor et un client natif n'est pas pris : il relève de #18.
- **Date** : 2026-09-23
- **Décideur** : mainteneur du dépôt
- **Issues** : #1, #18

## Contexte

Le produit démarre en web responsive. Une évolution vers Android et iOS est envisagée ensuite. Il faut savoir dès maintenant ce qui sera réutilisable et ce qui devra être réécrit.

## Options

| Option | Réutilisé | À écrire ou réécrire | Limites |
| --- | --- | --- | --- |
| **PWA** (installée depuis le navigateur) | Tout le frontend Angular | Manifeste, service worker, icônes (fournies par le design system) | Sur iOS, installation et notifications plus limitées ; pas de présence en store |
| **Capacitor** (application native qui affiche l'interface web) | Frontend Angular, API | Projets Android/iOS, accès caméra et fichiers via plugins, signature, publication | Une interface web dans une coque native, pas des écrans natifs ; cookies de session et service worker ne s'y comportent pas forcément comme dans un navigateur |
| **Client natif séparé** (Kotlin, Swift ou multiplateforme) | API et règles serveur uniquement | Toute l'interface mobile, par plateforme | Coût le plus élevé ; seulement si l'expérience l'exige |

Aucune option ne convertit automatiquement l'application web en application native.

## Décision

MVP en PWA installable. Capacitor est la première piste à évaluer dans #18, avec un prototype sur données synthétiques (caméra, import, authentification, liens profonds). Le client natif séparé n'est envisagé que si ce prototype montre un manque bloquant.

## Conséquences

- Le frontend évite les API propres au navigateur quand une abstraction simple permet de les remplacer plus tard (capture de photo, stockage local).
- L'API reste la seule source de vérité : un client mobile futur n'a besoin d'aucune logique métier supplémentaire. Son authentification (sessions hors navigateur) doit être prévue par #11 et vérifiée par le prototype de #18.
- Publication en store, comptes développeur et poste macOS pour iOS : coûts à estimer dans #18, rien n'est engagé maintenant.

## Vérifications

- `@angular/pwa` 22.1.8 et `@capacitor/core` 8.5.2 publiés sur npm le 2026-09-23. Aucun prototype réalisé.
