import 'package:rotten_tomatoes/features/movies/domain/entities/movie.dart';
class MovieModel extends Movie {
  const MovieModel({
    required super.id,
    required super.title,
    required super.overview,
    required super.posterPath,
    required super.voteAverage,
  });

  // Cette méthode transforme le JSON brut de TMDB en objet MovieModel
  // "factory" veut dire : je construis et retourne un objet, pas juste un constructeur classique
  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      // TMDB nous donne juste "/abc.jpg", on reconstruit l'URL complète
      posterPath: 'https://image.tmdb.org/t/p/w500${json['poster_path']}',
      // TMDB renvoie parfois un int, parfois un double — on force en double
      voteAverage: (json['vote_average'] as num).toDouble(),
    );
  }
}