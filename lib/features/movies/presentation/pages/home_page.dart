import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rotten_tomatoes/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rotten_tomatoes/features/auth/presentation/bloc/auth_event.dart';
import 'package:rotten_tomatoes/features/auth/presentation/pages/profil_page.dart';
import 'package:rotten_tomatoes/features/movies/presentation/cubit/movies_cubit.dart';
import 'package:rotten_tomatoes/features/movies/presentation/cubit/movies_states.dart';
import 'package:rotten_tomatoes/features/movies/presentation/cubit/search_cubit.dart';
import 'package:rotten_tomatoes/features/movies/presentation/cubit/search_state.dart';
import 'package:rotten_tomatoes/features/movies/presentation/pages/favorites_page.dart';
import 'package:rotten_tomatoes/features/movies/presentation/widgets/movie_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.red[700],
        title: const Text(
          'Rotten Tomatoes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesPage()),
              );
            },
          ),
          // Bouton profil
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
          ),
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
            },
            icon: Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),

      //BlocBuilder pour écouter les changements d'état du MoviesCubit et afficher les films en conséquence
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Rechercher un film...',
                hintStyle: TextStyle(color: Colors.grey[500]),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: IconButton(
                  onPressed: () {
                    context.read<SearchCubit>().clearSearch();
                  },
                  icon: const Icon(Icons.clear, color: Colors.grey),
                ),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (query) {
                context.read<SearchCubit>().search(query);
              },
            ),
          ),
          // Contenu — recherche ou liste populaire
          Expanded(
            child: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, searchState) {
                // Si recherche active → afficher résultats recherche
                if (searchState is SearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (searchState is SearchLoaded) {
                  return _buildGrid(context, searchState.movies);
                }

                if (searchState is SearchEmpty) {
                  return const Center(
                    child: Text(
                      '🎬 Aucun film trouvé',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                if (searchState is SearchError) {
                  return Center(
                    child: Text(
                      searchState.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                // Sinon → afficher films populaires
                return BlocBuilder<MoviesCubit, MoviesState>(
                  builder: (context, moviesState) {
                    if (moviesState is MoviesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (moviesState is MoviesLoaded) {
                      return _buildGrid(context, moviesState.movies);
                    }
                    if (moviesState is MoviesError) {
                      return Center(
                        child: Text(
                          moviesState.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget réutilisable pour afficher une grille de films
  Widget _buildGrid(BuildContext context, movies) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return MovieCard(movie: movies[index]);
      },
    );
  }
}
