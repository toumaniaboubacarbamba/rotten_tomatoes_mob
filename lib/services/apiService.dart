// Service qui gère les appels API vers TMDB et laravel. C'est la seule classe qui connaît les détails de l'API, les autres classes (ViewModels, etc.) ne font que l'appeler.
import 'package:dio/dio.dart';
import '../entities/movie.dart';
import '../models/userModel.dart';
import '../models/errors.dart';
import '../models/movieModel.dart';

class ApiService {
  static const _tmdbBase = 'https://api.themoviedb.org/3';
  static const _laravelBase = 'https://fullstack-mobile-budgetapp.onrender.com/api';
  static const _tmdbKey = 'fdb757f2be0e9f840579c36755b25071';

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {'Accept': 'application/json'},
    ),
  );

  Options _auth(String token) => Options(
    headers: {'Authorization': 'Bearer $token'},
  );

  // ── AUTH ───

  Future<UserModel> login(String email, String password) async {
    try {
      final res = await _dio.post(
        '$_laravelBase/login',
        data: {'email': email, 'password': password},
      );
      return UserModel(
        id: res.data['user']['id'].toString(),
        name: res.data['user']['name'],
        email: res.data['user']['email'],
        token: res.data['token'],
        createdAt: res.data['user']['created_at'],
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<UserModel> register(String name, String email, String password) async {
    try {
      final res = await _dio.post(
        '$_laravelBase/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password,
        },
      );
      return UserModel(
        id: res.data['user']['id'].toString(),
        name: res.data['user']['name'],
        email: res.data['user']['email'],
        token: res.data['token'],
        createdAt: res.data['user']['created_at'],
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> logout(String token) async {
    try {
      await _dio.post('$_laravelBase/logout', options: _auth(token));
    } catch (_) {}
  }

  Future<UserModel> updateProfile(String token, String name) async {
    try {
      final res = await _dio.put(
        '$_laravelBase/user/update',
        data: {'name': name},
        options: _auth(token),
      );
      return UserModel(
        id: res.data['user']['id'].toString(),
        name: res.data['user']['name'],
        email: res.data['user']['email'],
        token: token,
        createdAt: res.data['user']['created_at'],
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> updatePassword(
    String token,
    String current,
    String newPass,
  ) async {
    try {
      await _dio.put(
        '$_laravelBase/user/password',
        data: {
          'current_password': current,
          'password': newPass,
          'password_confirmation': newPass,
        },
        options: _auth(token),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ── MOVIES ───

  Future<List<MovieModel>> getPopularMovies({int page = 1}) async {
    final res = await _dio.get(
      '$_tmdbBase/movie/popular',
      queryParameters: {
        'api_key': _tmdbKey,
        'page': page,
        'language': 'fr-FR',
      },
    );
    final List results = res.data['results'];
    return results.map((j) => MovieModel.fromJson(j)).toList();
  }

  Future<List<MovieModel>> searchMovies(String query) async {
    final res = await _dio.get(
      '$_tmdbBase/search/movie',
      queryParameters: {
        'api_key': _tmdbKey,
        'query': query,
        'language': 'fr-FR',
      },
    );
    final List results = res.data['results'];
    return results.map((j) => MovieModel.fromJson(j)).toList();
  }

  Future<List<Genre>> getGenres() async {
    final res = await _dio.get(
      '$_tmdbBase/genre/movie/list',
      queryParameters: {'api_key': _tmdbKey, 'language': 'fr-FR'},
    );
    final List genres = res.data['genres'];
    return genres
        .map((j) => Genre(id: j['id'], name: j['name']))
        .toList();
  }

  Future<List<MovieModel>> getMoviesByGenre(int genreId) async {
    final res = await _dio.get(
      '$_tmdbBase/discover/movie',
      queryParameters: {
        'api_key': _tmdbKey,
        'with_genres': genreId,
        'language': 'fr-FR',
      },
    );
    final List results = res.data['results'];
    return results.map((j) => MovieModel.fromJson(j)).toList();
  }

  // ── FAVORITES ──

  Future<List<Movie>> getFavorites(String token) async {
    final res = await _dio.get(
      '$_laravelBase/favorites',
      options: _auth(token),
    );
    final List data = res.data;
    return data.map((j) => MovieModel(
      id: int.parse(j['movie_id'].toString()),
      title: j['title'] ?? '',
      overview: j['overview'] ?? '',
      posterPath: j['poster_path'] ?? '',
      voteAverage: double.parse(j['vote_average'].toString()),
    )).toList();
  }

  Future<bool> toggleFavorite(String token, Movie movie) async {
    final res = await _dio.post(
      '$_laravelBase/favorites/toggle',
      data: {
        'movie_id': movie.id,
        'title': movie.title,
        'overview': movie.overview,
        'poster_path': movie.posterPath,
        'vote_average': movie.voteAverage,
      },
      options: _auth(token),
    );
    return res.data['is_favorite'];
  }

  // ── HELPER ──

  Exception _handleError(DioException e) {
    if (e.response?.data?['errors'] != null) {
      final errors = e.response!.data['errors'] as Map;
      return AuthException(errors.values.first[0]);
    }
    return NetworkException(
      e.response?.data?['message'] ?? 'Erreur serveur',
    );
  }
}