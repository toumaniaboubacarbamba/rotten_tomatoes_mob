import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rotten_tomatoes/core/error/failures.dart';
import 'package:rotten_tomatoes/features/movies/data/datasources/movie_remote_data_source.dart';
import 'package:rotten_tomatoes/features/movies/domain/entities/movie.dart';
import 'package:rotten_tomatoes/features/movies/domain/repositories/movie_repository.dart';

// MovieRepositoryImpl est la classe qui implémente l'interface MovieRepository
class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  MovieRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies() async {
    try {
      //on demande les films populaires à la data source
      final movies = await remoteDataSource.getPopularMovies();
      //si tout se passe bien, on retourne une "Right" qui contient la liste des
      return Right(movies);
    } on DioException catch (e) {
      //si une erreur Dio se produit, on retourne une "Left" qui contient une Failure
      return Left(ServerFailure(e.message ?? 'Une erreur est survenue'));
    }
  }
}
