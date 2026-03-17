//  La logique métier MovieManager combine ApiService + StorageService  pour les films et favoris.
import '../entities/account.dart';
import 'package:rotten_tomatoes/services/apiService.dart';
import 'package:rotten_tomatoes/services/storageService.dart';

import '../entities/movie.dart';

class MovieManager {
  final ApiService _api;
  final StorageService _storage;

  MovieManager(this._api, this._storage);

  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    return _api.getPopularMovies(page: page);
  }

  Future<List<Movie>> searchMovies(String query) async {
    return _api.searchMovies(query);
  }

  Future<List<Genre>> getGenres() async {
    return _api.getGenres();
  }

  Future<List<Movie>> getMoviesByGenre(int genreId) async {
    return _api.getMoviesByGenre(genreId);
  }

  Future<List<Movie>> getFavorites() async {
    final token = await _storage.getToken();
    if (token == null) return [];
    return _api.getFavorites(token);
  }

  Future<bool> toggleFavorite(Movie movie) async {
    final token = await _storage.getToken();
    if (token == null) return false;
    return _api.toggleFavorite(token, movie);
  }
}
