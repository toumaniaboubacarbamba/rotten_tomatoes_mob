import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rotten_tomatoes/core/services/notification_service.dart';
import 'package:rotten_tomatoes/core/theme/app_theme.dart';
import 'engines/auth_manager.dart';
import 'engines/movie_manager.dart';
import 'services/api.dart';
import 'services/storage.dart';
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

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthViewModel(authManager)..add(AuthCheckRequested()),
        ),
        BlocProvider(create: (_) => MoviesViewModel(movieManager)),
        BlocProvider(create: (_) => SearchViewModel(movieManager)),
        BlocProvider(
          create: (_) => FavoritesViewModel(movieManager)..load(),
        ),
        BlocProvider(
          create: (_) => GenreViewModel(movieManager)..loadGenres(),
        ),
        BlocProvider(
          create: (_) => ThemeViewModel(storage)..load(),
        ),
      ],
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
