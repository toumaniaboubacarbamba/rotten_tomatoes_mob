import '../entities/movie.dart';
import '../entities/genre.dart';

abstract class MovieService {
  Future<List<Movie>> getPopularMovies({int page = 1});
  Future<List<Movie>> searchMovies(String query);
  Future<List<Genre>> getGenres();
  Future<List<Movie>> getMoviesByGenre(int genreId);
}
