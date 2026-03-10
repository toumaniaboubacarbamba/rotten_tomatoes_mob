import '../entities/movie.dart';

abstract class FavoriteService {
  Future<List<Movie>> getFavorites(String token);
  Future<bool> toggleFavorite(String token, Movie movie);
}
