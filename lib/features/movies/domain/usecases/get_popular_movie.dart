import 'package:dartz/dartz.dart';
import 'package:rotten_tomatoes/core/error/failures.dart';
import 'package:rotten_tomatoes/features/movies/domain/entities/movie.dart';
import 'package:rotten_tomatoes/features/movies/domain/repositories/movie_repository.dart';

class GetPopularMovie {
  final MovieRepository repository;

  GetPopularMovie(this.repository);

  Future<Either<Failure, List<Movie>>> call(){
    return repository.getPopularMovies();
  }
}