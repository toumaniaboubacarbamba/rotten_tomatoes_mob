import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rotten_tomatoes/core/di/injection.dart';
import 'package:rotten_tomatoes/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rotten_tomatoes/features/auth/presentation/bloc/auth_event.dart';
import 'package:rotten_tomatoes/features/auth/presentation/bloc/auth_state.dart';
import 'package:rotten_tomatoes/features/auth/presentation/pages/login_page.dart';
import 'package:rotten_tomatoes/features/movies/presentation/cubit/movies_cubit.dart';
import 'package:rotten_tomatoes/features/movies/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Nécessaire pour les opérations asynchrones avant runApp
  await initDependencies(); // on initialise les dépendances avant de lancer l'app
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // On utilise MultiBlocProvider pour injecter tous les Cubits/BLoCs nécessaires à l'application
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()..add(AuthCheckRequested())),
        BlocProvider(create: (_) => sl<MoviesCubit>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Rotten Tomatoes',
        theme: ThemeData.dark(),
        // BlocBuilder écoute AuthBloc pour décider quelle page afficher
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading || state is AuthInitial) {
              // Pendant la vérification du cache → écran de chargement
              return const Scaffold(
                backgroundColor: Colors.black,
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (state is Authenticated) {
              // Connecté → on charge les films et on affiche HomePage
              context.read<MoviesCubit>().loadMovies();
              return const HomePage();
            }
            // Pas connecté → LoginPage
            return const LoginPage();
          },
        ),
      ),
    );
  }
}
