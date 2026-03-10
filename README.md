# 🍅 Rotten Tomatoes Flutter

Une application mobile Flutter de découverte de films
construite avec une Clean Architecture, BLoC/Cubit
et l'API TMDB.

## ✨ Fonctionnalités

- 🔐 Authentification (Login / Register / Logout)
- 🎬 Liste des films populaires avec pagination infinie
- 🔍 Recherche de films en temps réel
- 🎭 Filtrage par catégorie / genre
- ❤️ Gestion des favoris (synchronisés via API)
- 👤 Page profil (modifier nom & mot de passe)
- 🌙 Thème clair / sombre persistant
- 🔔 Notifications locales
- 💫 Splash screen animé

## 🏛️ Architecture

Ce projet suit les principes de la **Clean Architecture**
organisée en 3 couches :

- **Domain** — Entités, interfaces Repositories, interfaces Services, Use Cases
- **Data** — Models, implémentations Services, implémentations Repositories
- **Presentation** — Cubits, BLoCs, Pages, Widgets

### Schéma des couches
```
Presentation (Cubit/BLoC)
       ↓
   Use Cases
       ↓
  Repositories (interface domain → implémentation data)
       ↓
   Services (interface domain → implémentation data)
```

### Pourquoi des Services ?

Les **interfaces** dans `domain/services/` définissent **le contrat** (quoi faire).
Les **implémentations** dans `data/services/` définissent **le comment** (Dio, Laravel, TMDB...).

> Si on change d'API demain, on crée une nouvelle implémentation
> sans toucher au reste du code.

## 🛠️ Technologies utilisées

| Package | Rôle |
|--------|------|
| flutter_bloc | Gestion d'état (Cubit & BLoC) |
| get_it | Injection de dépendances |
| dio | Requêtes HTTP |
| dartz | Programmation fonctionnelle (Either) |
| equatable | Comparaison d'objets |
| shared_preferences | Stockage local |
| flutter_local_notifications | Notifications locales |
| flutter_native_splash | Splash screen natif |
| bloc_test | Tests unitaires BLoC |

## 🌐 APIs utilisées

| API | Rôle |
|-----|------|
| [TMDB](https://www.themoviedb.org/) | Films, recherche, genres |
| [Laravel (Render)](https://fullstack-mobile-budgetapp.onrender.com) | Auth, favoris |

## 🚀 Lancer le projet

1. Clone le repo
```bash
git clone https://github.com/ton-username/rotten_tomatoes.git
```

2. Installe les dépendances
```bash
flutter pub get
```

3. Ajoute ta clé API TMDB dans
```
lib/core/network/dio_client.dart
```

4. Lance l'app
```bash
flutter run
```

## 🧪 Tests
```bash
flutter test
```

## 🔑 Identifiants de test
```
Email    : yami@test.com
Password : 123456
```

## 📁 Structure du projet
```
lib/
├── core/
│   ├── error/
│   ├── network/
│   ├── services/        ← NotificationService
│   ├── theme/           ← ThemeCubit, AppTheme
│   └── di/              ← injection.dart
└── features/
    ├── auth/
    │   ├── data/
    │   │   ├── services/        ← LaravelAuthService
    │   │   ├── models/
    │   │   └── repositories/
    │   ├── domain/
    │   │   ├── entities/
    │   │   ├── services/        ← AuthService (interface)
    │   │   ├── repositories/
    │   │   └── usecases/
    │   └── presentation/
    │       ├── bloc/
    │       └── pages/
    ├── movies/
    │   ├── data/
    │   │   ├── services/        ← TmdbMovieService, LaravelFavoriteService
    │   │   ├── models/
    │   │   └── repositories/
    │   ├── domain/
    │   │   ├── entities/
    │   │   ├── services/        ← MovieService, FavoriteService (interfaces)
    │   │   ├── repositories/
    │   │   └── usecases/
    │   └── presentation/
    │       ├── cubit/
    │       ├── pages/
    │       └── widgets/
    └── splash/
        └── presentation/
            └── pages/
```