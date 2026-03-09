import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rotten_tomatoes/features/movies/domain/entities/movie.dart';
import '../cubit/favorites_cubit.dart';
import '../cubit/favorites_state.dart';

class MovieDetailPage extends StatelessWidget {
  final Movie movie;
  const MovieDetailPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 450,
            pinned: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    movie.posterPath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[900],
                      child: const Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: 64,
                      ),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          theme.scaffoldBackgroundColor,
                          theme.scaffoldBackgroundColor.withValues(alpha: 0.3),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.3, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre + bouton favori
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          movie.title,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      BlocBuilder<FavoritesCubit, FavoritesState>(
                        builder: (context, state) {
                          final isFavorite =
                              state is FavoritesLoaded &&
                              state.movies.any((m) => m.id == movie.id);
                          return GestureDetector(
                            onTap: () =>
                                context.read<FavoritesCubit>().toggle(movie),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isFavorite
                                    ? Colors.red.withValues(alpha: 0.15)
                                    : theme.cardColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isFavorite
                                      ? Colors.red
                                      : theme.colorScheme.onSurface.withValues(
                                          alpha: 0.15,
                                        ),
                                ),
                              ),
                              child: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite
                                    ? Colors.red
                                    : theme.colorScheme.onSurface.withValues(
                                        alpha: 0.5,
                                      ),
                                size: 22,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Badge note
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.amber.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${movie.voteAverage.toStringAsFixed(1)}/10',
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  Divider(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                  ),
                  const SizedBox(height: 20),

                  // Synopsis
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Synopsis',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    movie.overview.isEmpty
                        ? 'Aucun synopsis disponible.'
                        : movie.overview,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.75,
                      ),
                      fontSize: 15,
                      height: 1.7,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
