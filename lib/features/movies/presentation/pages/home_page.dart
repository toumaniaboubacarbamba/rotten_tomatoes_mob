import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rotten_tomatoes/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rotten_tomatoes/features/auth/presentation/bloc/auth_event.dart';
import 'package:rotten_tomatoes/features/auth/presentation/pages/profil_page.dart';
import 'package:rotten_tomatoes/features/movies/presentation/cubit/favorites_cubit.dart';
import 'package:rotten_tomatoes/features/movies/presentation/cubit/favorites_state.dart';
import 'package:rotten_tomatoes/features/movies/presentation/cubit/movies_cubit.dart';
import 'package:rotten_tomatoes/features/movies/presentation/cubit/movies_states.dart';
import 'package:rotten_tomatoes/features/movies/presentation/cubit/search_cubit.dart';
import 'package:rotten_tomatoes/features/movies/presentation/cubit/search_state.dart';
import 'package:rotten_tomatoes/features/movies/presentation/pages/favorites_page.dart';
import 'package:rotten_tomatoes/features/movies/presentation/pages/genre_page.dart';
import 'package:rotten_tomatoes/features/movies/presentation/widgets/movie_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // On écoute le scroll pour détecter la fin de liste
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Si on est à 200px de la fin → on charge la page suivante
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<MoviesCubit>().loadMoreMovies();
    }
  }

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
            icon: const Icon(Icons.category, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GenrePage()),
              );
            },
          ),
          // Afficher l'icône favoris avec un badge indiquant le nombre de films favoris
          BlocBuilder<FavoritesCubit, FavoritesState>(
            builder: (context, favState) {
              int count = 0;
              if (favState is FavoritesLoaded) {
                count = favState.movies.length;
              }

              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const FavoritesPage(),
                        ),
                      );
                    },
                  ),
                  if (count > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$count',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
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

                // Films populaires avec pagination
                return BlocBuilder<MoviesCubit, MoviesState>(
                  builder: (context, state) {
                    if (state is MoviesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is MoviesError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    if (state is MoviesLoaded || state is MoviesLoadingMore) {
                      final movies = state is MoviesLoaded
                          ? state.movies
                          : (state as MoviesLoadingMore).movies;

                      return CustomScrollView(
                        controller: _scrollController,
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.all(12),
                            sliver: SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.65,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                  ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) =>
                                    MovieCard(movie: movies[index]),
                                childCount: movies.length,
                              ),
                            ),
                          ),

                          // Spinner en bas pendant le chargement de la page suivante
                          if (state is MoviesLoadingMore)
                            const SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                        ],
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
