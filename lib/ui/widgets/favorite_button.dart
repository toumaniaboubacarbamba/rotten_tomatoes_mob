import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rotten_tomatoes/entities/movie.dart';
import 'package:rotten_tomatoes/view_models/favorites_view_model.dart';

class FavoriteButton extends StatelessWidget {
  final Movie movie;

  const FavoriteButton({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesViewModel, FavoritesState>(
      buildWhen: (previous, current) {
        // OPTIMISATION : On ne reconstruit que si le statut favori de CE film a changé
        if (previous is! FavoritesLoaded || current is! FavoritesLoaded) {
          return true;
        }
        final wasFavorite = previous.movies.any((m) => m.id == movie.id);
        final isFavorite = current.movies.any((m) => m.id == movie.id);
        return wasFavorite != isFavorite;
      },
      builder: (context, state) {
        final isFavorite = state is FavoritesLoaded &&
            state.movies.any((m) => m.id == movie.id);

        return GestureDetector(
          onTap: () => context.read<FavoritesViewModel>().toggle(movie),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isFavorite
                  ? Colors.red.withValues(alpha: 0.3)
                  : Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
              size: 16,
            ),
          ),
        );
      },
    );
  }
}
