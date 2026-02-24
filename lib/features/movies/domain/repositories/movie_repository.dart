import 'package:dartz/dartz.dart';
import 'package:rotten_tomatoes/core/error/failures.dart';
import 'package:rotten_tomatoes/features/movies/domain/entities/movie.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> getPopularMovies();
}
