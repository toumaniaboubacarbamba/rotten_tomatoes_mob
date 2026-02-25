import 'package:flutter/material.dart';
import 'package:rotten_tomatoes/features/movies/domain/entities/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      //coins arrondis pour les cartes de films
      borderRadius: BorderRadius.circular(12),
      child: Stack(fit: StackFit.expand,
        children: [
          // affichage des films chargés depuis l'API
          Image.network(
            movie.posterPath,
            
          )
        ],
      ),
    );
  }
}
