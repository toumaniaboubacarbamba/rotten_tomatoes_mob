import 'dart:convert';
import 'package:dio/dio.dart';
import '../../domain/entities/movie.dart';
import '../models/movie_model.dart';

class FavoriteRemoteDataSource {
  static const _baseUrl = 'https://fullstack-mobile-budgetapp.onrender.com/api';

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {'Accept': 'application/json'},
    ),
  );

  // On passe le token à chaque requête
  Options _authHeaders(String token) {
    return Options(
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
  }

  Future<List<Movie>> getFavorites(String token) async {
    final response = await _dio.get(
      '$_baseUrl/favorites',
      options: _authHeaders(token),
    );

    final List data = response.data;
    return data
        .map(
          (json) => MovieModel(
            // On force en int avec toInt()
            id: (json['movie_id'] as num).toInt(),
            title: json['title'] ?? '',
            overview: json['overview'] ?? '',
            posterPath: json['poster_path'] ?? '',
            voteAverage: (json['vote_average'] as num).toDouble(),
          ),
        )
        .toList();
  }

  Future<bool> toggleFavorite(String token, Movie movie) async {
    final response = await _dio.post(
      '$_baseUrl/favorites/toggle',
      data: {
        'movie_id': movie.id,
        'title': movie.title,
        'overview': movie.overview,
        'poster_path': movie.posterPath,
        'vote_average': movie.voteAverage,
      },
      options: _authHeaders(token),
    );

    return response.data['is_favorite'];
  }
}
