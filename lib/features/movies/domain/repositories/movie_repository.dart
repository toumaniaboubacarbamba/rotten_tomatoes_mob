import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/movie.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> getPopularMovies();
  Future<Either<Failure, List<Movie>>> searchMovies(String query);

  // Nouvelles méthodes pour les favoris
  Future<Either<Failure, bool>> toggleFavorite(Movie movie);
  Future<Either<Failure, List<Movie>>> getFavorites();
}
