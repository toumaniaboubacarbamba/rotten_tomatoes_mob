import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/genre.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/favorite_remote_data_source.dart';
import '../datasources/movie_remote_data_source.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final FavoriteRemoteDataSource favoriteDataSource;

  MovieRepositoryImpl(this.remoteDataSource, this.favoriteDataSource);

  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies({int page = 1}) async {
    try {
      final movies = await remoteDataSource.getPopularMovies(page: page);
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
  Future<Either<Failure, List<Genre>>> getGenres() async {
    try {
      final genres = await remoteDataSource.getGenres();
      return Right(genres);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Erreur serveur'));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getMoviesByGenre(int genreId) async {
    try {
      final movies = await remoteDataSource.getMoviesByGenre(genreId);
      return Right(movies);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Erreur serveur'));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavorite(
    Movie movie,
    String token,
  ) async {
    try {
      final result = await favoriteDataSource.toggleFavorite(token, movie);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Erreur serveur'));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getFavorites(String token) async {
    try {
      final movies = await favoriteDataSource.getFavorites(token);
      return Right(movies);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Erreur serveur'));
    }
  }
}
