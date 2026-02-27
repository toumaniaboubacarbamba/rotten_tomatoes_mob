import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/genre.dart';
import '../entities/movie.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> getPopularMovies({int page = 1});
  Future<Either<Failure, List<Movie>>> searchMovies(String query);
  Future<Either<Failure, bool>> toggleFavorite(Movie movie);
  Future<Either<Failure, List<Movie>>> getFavorites();
  Future<Either<Failure, List<Genre>>> getGenres();
  Future<Either<Failure, List<Movie>>> getMoviesByGenre(int genreId);
}
