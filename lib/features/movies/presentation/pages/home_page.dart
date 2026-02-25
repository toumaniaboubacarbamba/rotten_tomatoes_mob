import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rotten_tomatoes/features/movies/presentation/cubit/movies_cubit.dart';
import 'package:rotten_tomatoes/features/movies/presentation/cubit/movies_states.dart';
import 'package:rotten_tomatoes/features/movies/presentation/widgets/movie_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Rotten Tomatoes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      //BlocBuilder pour écouter les changements d'état du MoviesCubit et afficher les films en conséquence
      body: BlocBuilder<MoviesCubit, MoviesState>(
        builder: (context, state) {
          // Si l'état est de chargement, on affiche un spinner
          if (state is MoviesLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          // Si l'état est de succès, on affiche la liste des films
          else if (state is MoviesLoaded) {
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: state.movies.length,
              itemBuilder: (context, index) {
                return MovieCard(movie: state.movies[index]);
              },
            );
          }
          if (state is MoviesError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),
            );
          }
          // Par défaut, on affiche un message d'accueil
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
