import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class ToggleFavorite {
  final MovieRepository repository;
  ToggleFavorite(this.repository);

  Future<Either<Failure, bool>> call(Movie movie, String token) {
    return repository.toggleFavorite(movie, token);
  }
}
