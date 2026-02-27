import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie_model.dart';
import '../../domain/entities/movie.dart';

class MovieLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const _favoritesKey = 'favorites';

  MovieLocalDataSource(this.sharedPreferences);

  Future<List<Movie>> getFavorites() async {
    final favoritesJson = sharedPreferences.getString(_favoritesKey);

    if (favoritesJson == null) return [];

    final List decoded = jsonDecode(favoritesJson);
    return decoded.map((json) => MovieModel.fromJson(json)).toList();
  }

  Future<bool> toggleFavorite(Movie movie) async {
    final favorites = await getFavorites();

    // On vérifie si le film est déjà en favori
    final isFavorite = favorites.any((m) => m.id == movie.id);

    if (isFavorite) {
      // On le retire
      favorites.removeWhere((m) => m.id == movie.id);
    } else {
      // On l'ajoute
      favorites.add(movie);
    }

    // On sauvegarde la nouvelle liste
    final encoded = jsonEncode(
      favorites
          .map(
            (m) => MovieModel(
              id: m.id,
              title: m.title,
              overview: m.overview,
              posterPath: m.posterPath,
              voteAverage: m.voteAverage,
            ).toJson(),
          )
          .toList(),
    );

    await sharedPreferences.setString(_favoritesKey, encoded);

    // On retourne true si ajouté, false si retiré
    return !isFavorite;
  }
}
