import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rotten_tomatoes/entities/movie.dart';
import 'package:rotten_tomatoes/ui/widgets/movie_card.dart';
import 'package:rotten_tomatoes/view_models/favorites_view_model.dart';

class MovieGrid extends StatelessWidget {
  final List<Movie> movies;
  final ScrollController? controller;
  final bool isLoadingMore;
  final EdgeInsetsGeometry padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const MovieGrid({
    super.key,
    required this.movies,
    this.controller,
    this.isLoadingMore = false,
    this.padding = const EdgeInsets.fromLTRB(12, 0, 12, 12),
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller,
      shrinkWrap: shrinkWrap,
      physics: physics,
      slivers: [
        SliverPadding(
          padding: padding,
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final movie = movies[index];
                
                // C'est ici que le parent (la grille) "pilote" l'enfant
                return BlocBuilder<FavoritesViewModel, FavoritesState>(
                  // Optimisation : on ne reconstruit QUE si CE film change
                  buildWhen: (previous, current) {
                    if (previous is! FavoritesLoaded || current is! FavoritesLoaded) return true;
                    final wasFav = previous.movies.any((m) => m.id == movie.id);
                    final isFav = current.movies.any((m) => m.id == movie.id);
                    return wasFav != isFav;
                  },
                  builder: (context, state) {
                    final isFavorite = state is FavoritesLoaded && 
                        state.movies.any((m) => m.id == movie.id);
                        
                    return MovieCard(
                      movie: movie,
                      isFavorite: isFavorite,
                      onToggleFavorite: () => context.read<FavoritesViewModel>().toggle(movie),
                    );
                  },
                );
              },
              childCount: movies.length,
            ),
          ),
        ),
        if (isLoadingMore)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(color: Colors.red),
              ),
            ),
          ),
      ],
    );
  }
}
