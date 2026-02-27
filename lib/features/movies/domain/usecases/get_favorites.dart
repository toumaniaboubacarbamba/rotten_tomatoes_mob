import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetFavorites {
  final MovieRepository repository;

  GetFavorites(this.repository);

  Future<Either<Failure, List<Movie>>> call() {
    return repository.getFavorites();
  }
}
