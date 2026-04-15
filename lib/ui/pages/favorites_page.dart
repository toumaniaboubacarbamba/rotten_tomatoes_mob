import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rotten_tomatoes/entities/movie.dart';
import 'package:rotten_tomatoes/view_models/favorites_view_model.dart';
import 'package:rotten_tomatoes/ui/widgets/movie_grid.dart';
import 'package:rotten_tomatoes/ui/widgets/movie_card.dart';
import 'package:rotten_tomatoes/ui/pages/movie_detail_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    context.read<FavoritesViewModel>().add(LoadFavorites());
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

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.favorite, color: Colors.red),
            SizedBox(width: 8),
            Text('Mes Favoris', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: BlocBuilder<FavoritesViewModel, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is FavoritesError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          if (state is FavoritesLoaded) {
            if (state.movies.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite_border,
                        color: Colors.red.withValues(alpha: 0.5),
                        size: 56,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Aucun favori pour le moment',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Appuie sur ❤️ sur un film pour l'ajouter",
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.4,
                        ),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    '${state.movies.length} film${state.movies.length > 1 ? 's' : ''} sauvegardé${state.movies.length > 1 ? 's' : ''}',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: MovieGrid(
                    movies: state.movies,
                    itemBuilder: (context, movie) {
                      // On utilise un BlocBuilder local ici aussi pour la réactivité
                      return BlocBuilder<FavoritesViewModel, FavoritesState>(
                        buildWhen: (previous, current) {
                          if (previous is! FavoritesLoaded || current is! FavoritesLoaded) return true;
                          final wasFav = previous.movies.any((m) => m.id == movie.id);
                          final isFav = current.movies.any((m) => m.id == movie.id);
                          return wasFav != isFav;
                        },
                        builder: (context, favState) {
                          final isFavorite = favState is FavoritesLoaded && 
                              favState.movies.any((m) => m.id == movie.id);
                              
                          return MovieCard(
                            movie: movie,
                            isFavorite: isFavorite,
                            onToggleFavorite: () =>
                                context.read<FavoritesViewModel>().add(ToggleFavorite(movie)),
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
}
