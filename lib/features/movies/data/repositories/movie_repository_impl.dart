import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rotten_tomatoes/features/movies/data/datasources/movie_local_data_source.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_remote_data_source.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource; // ← nouveau

  MovieRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies() async {
    try {
      final movies = await remoteDataSource.getPopularMovies();
      return Right(movies);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Erreur serveur'));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query) async {
    try {
      final movies = await remoteDataSource.searchMovies(query);
      return Right(movies);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Erreur serveur'));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavorite(Movie movie) async {
    try {
      final result = await localDataSource.toggleFavorite(movie);
      return Right(result);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getFavorites() async {
    try {
      final movies = await localDataSource.getFavorites();
      return Right(movies);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
