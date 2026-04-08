import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rotten_tomatoes/view_models/auth_view_model.dart';
import 'package:rotten_tomatoes/view_models/favorites_view_model.dart';
import 'package:rotten_tomatoes/view_models/movies_view_model.dart';
import 'package:rotten_tomatoes/view_models/search_view_model.dart';
import 'package:rotten_tomatoes/ui/pages/login_page.dart';
import 'package:rotten_tomatoes/ui/pages/profil_page.dart';
import 'package:rotten_tomatoes/ui/pages/favorites_page.dart';
import 'package:rotten_tomatoes/ui/pages/genre_page.dart';
import 'package:rotten_tomatoes/ui/widgets/movie_grid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<FavoritesViewModel>().load();
    context.read<MoviesViewModel>().loadMovies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<MoviesViewModel>().loadMoreMovies();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<AuthViewModel, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[700],
          elevation: 0,
          title: const Row(
            children: [
              Icon(Icons.movie_filter, color: Colors.white, size: 22),
              SizedBox(width: 8),
              Text(
                'Rotten Tomatoes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.category_outlined, color: Colors.white),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GenrePage()),
              ),
            ),
            BlocBuilder<FavoritesViewModel, FavoritesState>(
              builder: (context, favState) {
                int count = favState is FavoritesLoaded
                    ? favState.movies.length
                    : 0;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.favorite_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const FavoritesPage(),
                        ),
                      ),
                    ),
                    if (count > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '$count',
                            style: const TextStyle(
                              color: Colors.red,
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
            IconButton(
              icon: const Icon(Icons.person_outlined, color: Colors.white),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              color: Colors.red[700],
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Rechercher un film...',
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      _searchController.clear();
                      context.read<SearchViewModel>().clearSearch();
                    },
                    icon: Icon(
                      Icons.clear,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: (query) =>
                    context.read<SearchViewModel>().search(query),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Text(
                    'Films populaires',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: const Text(
                      '🔥 Tendances',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<SearchViewModel, SearchState>(
                builder: (context, searchState) {
                  if (searchState is SearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (searchState is SearchLoaded) {
                    return MovieGrid(movies: searchState.movies);
                  }
                  if (searchState is SearchEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 56,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.3,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Aucun film trouvé',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                              fontSize: 16,
                            ),
                          ),
                        ],
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
                  
                  return BlocBuilder<MoviesViewModel, MoviesState>(
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
                        
                        return MovieGrid(
                          movies: movies,
                          controller: _scrollController,
                          isLoadingMore: state is MoviesLoadingMore,
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
      ),
    );
  }
}
