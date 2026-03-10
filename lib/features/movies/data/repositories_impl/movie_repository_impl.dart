import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/genre.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../domain/services/favorite_service.dart';
import '../../domain/services/movie_service.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieService movieService;
  final FavoriteService favoriteService;

  MovieRepositoryImpl(this.movieService, this.favoriteService);

  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies({int page = 1}) async {
    try {
      final movies = await movieService.getPopularMovies(page: page);
      return Right(movies);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Erreur serveur'));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query) async {
    try {
      final movies = await movieService.searchMovies(query);
      return Right(movies);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Erreur serveur'));
    }
  }

  @override
  Future<Either<Failure, List<Genre>>> getGenres() async {
    try {
      final genres = await movieService.getGenres();
      return Right(genres);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Erreur serveur'));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getMoviesByGenre(int genreId) async {
    try {
      final movies = await movieService.getMoviesByGenre(genreId);
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
      final result = await favoriteService.toggleFavorite(token, movie);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Erreur serveur'));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getFavorites(String token) async {
    try {
      final movies = await favoriteService.getFavorites(token);
      return Right(movies);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Erreur serveur'));
    }
  }
}
