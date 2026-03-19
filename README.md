#  Rotten Tomatoes Mobile

Application Flutter de découverte de films, construite avec une architecture MVVM simple.

##  Fonctionnalités

- Authentification (inscription, connexion, déconnexion)
- Modification du profil et du mot de passe
- Liste des films populaires avec pagination
- Recherche de films en temps réel
- Filtrage par catégorie/genre
- Gestion des favoris (liés au compte utilisateur)
- Thème clair / sombre
- Notifications locales à la connexion
- Splash screen animé

##  Architecture MVVM Simple
```
lib/
├── entities/        # Objets métier purs (Account, Movie, Genre)
├── models/          # JSON + exceptions (UserModel, MovieModel, AppException)
├── services/        # Communication externe (ApiService, StorageService)
├── engines/         # Logique métier (AuthManager, MovieManager)
├── view_models/     # Cubits/Blocs (AuthViewModel, MoviesViewModel...)
├── ui/
│   ├── pages/       # Écrans de l'app
│   └── widgets/     # Composants réutilisables
├── utils/           # Utilitaires (AppTheme)
└── main.dart
```

##  Flux de données
```
UI → ViewModel → Engine → Service → API/Storage
             ↑_________________________________|
                      (état retourné)
```

##  APIs utilisées

- **TMDB** : `https://api.themoviedb.org/3` — Films, genres, recherche
- **Laravel** : `https://fullstack-mobile-budgetapp.onrender.com/api` — Auth, favoris

##  Stack technique

| Outil | Usage |
|-------|-------|
| Flutter | Framework UI |
| flutter_bloc | Gestion d'état (Cubit/Bloc) |
| dio | Requêtes HTTP |
| shared_preferences | Stockage local |
| equatable | Comparaison d'objets |
| flutter_local_notifications | Notifications locales |

##  Lancer le projet
## git bash
# Cloner le projet
git clone git@github.com:toumaniaboubacarbamba/rotten_tomatoes_mob.git

# Installer les dépendances
flutter pub get

# Lancer l'app
flutter run



##  Réalisé dans le cadre d'un stage Flutter