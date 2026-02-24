 Rotten Tomatoes Flutter

Une application mobile Flutter de découverte de films 
construite avec une Clean Architecture, BLoC/Cubit 
et l'API TMDB.

  Fonctionnalités

-  Authentification (Login / Register / Logout)
-  Liste des films populaires avec pagination infinie
-  Recherche de films en temps réel
-  Filtrage par catégorie / genre
-  Gestion des favoris (stockage local)
- Page profil utilisateur

 Architecture

Ce projet suit les principes de la Clean Architecture 
organisée en 3 couches :

- **Domain** — Entités, Repositories (interfaces), Use Cases
- **Data** — Models, DataSources, Repositories (implémentations)
- **Presentation** — Cubits, BLoCs, Pages, Widgets

 Technologies utilisées

| Package | Rôle |
|--------|------|
| flutter_bloc | Gestion d'état (Cubit & BLoC) |
| get_it | Injection de dépendances |
| dio | Requêtes HTTP |
| dartz | Programmation fonctionnelle (Either) |
| equatable | Comparaison d'objets |
| shared_preferences | Stockage local |
| bloc_test | Tests unitaires BLoC |

API

Ce projet utilise l'API [TMDB](https://www.themoviedb.org/) 
pour récupérer les données des films.

 Lancer le projet

1. Clone le repo
   git clone https://github.com/ton-username/rotten_tomatoes.git

2. Installe les dépendances
   flutter pub get

3. Ajoute ta clé API TMDB dans
   lib/core/network/dio_client.dart

4. Lance l'app
   flutter run

  Tests

   flutter test

  Identifiants de test

   Email    : test@gmail.com
   Password : 123456

  Structure du projet

lib/
├── core/
│   ├── error/
│   ├── network/
│   └── di/
└── features/
    ├── auth/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    └── movies/
        ├── data/
        ├── domain/
        └── presentation/
