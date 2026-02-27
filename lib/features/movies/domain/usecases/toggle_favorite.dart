import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class ToggleFavorite {
  final MovieRepository repository;

  ToggleFavorite(this.repository);

  // Ajoute le film si pas encore favori, le retire sinon
  Future<Either<Failure, bool>> call(Movie movie) {
    return repository.toggleFavorite(movie);
  }
}
