import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rotten_tomatoes/core/di/injection.dart';
import 'package:rotten_tomatoes/features/movies/presentation/cubit/movies_cubit.dart';

void main() {
  initDependencies(); // on initialise les dépendances avant de lancer l'app
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    //On crée un BlocProvider pour fournir le MoviesCubit à toute l'application
    return BlocProvider(
      create: (_) =>
          sl<MoviesCubit>()
            ..loadMovies(), // on charge les films dès que le Cubit est créé
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Rotten Tomatoes',
        theme: ThemeData.dark(),
        //home: const HomePage(),
      ),
    );
  }
}
