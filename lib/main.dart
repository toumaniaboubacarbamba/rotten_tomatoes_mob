// main.dart est le point d'entrée de l'application. Il initialise les services, les managers et les BLoCs, et configure le thème et la navigation de l'app.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rotten_tomatoes/core/services/notification_service.dart';
import 'package:rotten_tomatoes/utils/app_theme.dart';
import 'engines/auth_manager.dart';
import 'engines/movie_manager.dart';
import 'services/apiService.dart';
import 'services/storageService.dart';
import 'ui/splash/splash_page.dart';
import 'view_models/auth_view_model.dart';
import 'view_models/movies_view_model.dart';
import 'view_models/search_view_model.dart';
import 'view_models/favorites_view_model.dart';
import 'view_models/genre_view_model.dart';
import 'view_models/theme_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final api = ApiService();
    final storage = StorageService();
    final authManager = AuthManager(api, storage);
    final movieManager = MovieManager(api, storage);
    // MultiBlocProvider permet de fournir tous les BLoCs nécessaires à l'app dès le départ, pour que n'importe quelle page puisse y accéder facilement.
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthViewModel(authManager)..add(AuthCheckRequested()),
        ),
        BlocProvider(create: (_) => MoviesViewModel(movieManager)),
        BlocProvider(create: (_) => SearchViewModel(movieManager)),
        BlocProvider(create: (_) => FavoritesViewModel(movieManager)),
        BlocProvider(create: (_) => GenreViewModel(movieManager)..loadGenres()),
        BlocProvider(create: (_) => ThemeViewModel(storage)..load()),
      ],
      // BlocBuilder écoute les changements de thème pour appliquer le thème clair/sombre à toute l'app.
      child: BlocBuilder<ThemeViewModel, bool>(
        builder: (context, isDark) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Rotten Tomatoes',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            home: const SplashPage(),
          );
        },
      ),
    );
  }
}
