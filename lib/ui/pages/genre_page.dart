import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rotten_tomatoes/entities/movie.dart';
import 'package:rotten_tomatoes/view_models/genre_view_model.dart';
import 'package:rotten_tomatoes/view_models/favorites_view_model.dart';
import 'package:rotten_tomatoes/ui/widgets/movie_grid.dart';
import 'package:rotten_tomatoes/ui/widgets/movie_card.dart';
import 'package:rotten_tomatoes/ui/pages/movie_detail_page.dart';

class GenrePage extends StatefulWidget {
  const GenrePage({super.key});

  @override
  State<GenrePage> createState() => _GenrePageState();
}

class _GenrePageState extends State<GenrePage> {
  @override
  void initState() {
    super.initState();
    context.read<GenreViewModel>().add(LoadGenres());
  }

  void _onMovieTap(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MovieDetailPage(movie: movie)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.category_outlined, color: Colors.red),
            SizedBox(width: 8),
            Text('Catégories', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: BlocBuilder<GenreViewModel, GenreState>(
        builder: (context, state) {
          if (state is GenreLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GenreError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          if (state is GenreLoaded) {
            return Column(
              children: [
                SizedBox(
                  height: 52,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    itemCount: state.genres.length,
                    itemBuilder: (context, index) {
                      final genre = state.genres[index];
                      final isSelected = state.selectedGenre?.id == genre.id;
                      return GestureDetector(
                        onTap: () =>
                            context.read<GenreViewModel>().add(SelectGenre(genre)),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.red
                                : isDark
                                    ? Colors.grey[900]
                                    : Colors.grey[200],
                            borderRadius: BorderRadius.circular(99),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.red
                                  : isDark
                                      ? Colors.grey[800]!
                                      : Colors.grey[300]!,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.red.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Text(
                            genre.name,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : theme.colorScheme.onSurface.withValues(
                                      alpha: 0.7,
                                    ),
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: state.selectedGenre == null
                      ? _buildEmptyState(theme, 'Sélectionne un genre',
                          'pour découvrir des films 🎬')
                      : state.movies.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : MovieGrid(
                              movies: state.movies,
                              padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                              itemBuilder: (context, movie) {
                                return BlocBuilder<FavoritesViewModel,
                                    FavoritesState>(
                                  buildWhen: (previous, current) {
                                    if (previous is! FavoritesLoaded ||
                                        current is! FavoritesLoaded) {
                                      return true;
                                    }
                                    final wasFav = previous.movies
                                        .any((m) => m.id == movie.id);
                                    final isFav = current.movies
                                        .any((m) => m.id == movie.id);
                                    return wasFav != isFav;
                                  },
                                  builder: (context, favState) {
                                    final isFavorite = favState
                                            is FavoritesLoaded &&
                                        favState.movies
                                            .any((m) => m.id == movie.id);
                                    return MovieCard(
                                      movie: movie,
                                      isFavorite: isFavorite,
                                      onToggleFavorite: () => context.read<FavoritesViewModel>().add(ToggleFavorite(movie)),
                                      onTap: () => _onMovieTap(movie),
                                    );
                                  },
                                );
                              },
                            ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.movie_filter,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
            size: 72,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
