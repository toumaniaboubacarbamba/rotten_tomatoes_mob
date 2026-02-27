import '../../domain/entities/movie.dart';

class MovieModel extends Movie {
  const MovieModel({
    required super.id,
    required super.title,
    required super.overview,
    required super.posterPath,
    required super.voteAverage,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      posterPath:
          'https://image.tmdb.org/t/p/w500${json['poster_path'] ?? json['posterPath']}',
      voteAverage: (json['vote_average'] ?? json['voteAverage'] as num)
          .toDouble(),
    );
  }

  // Nécessaire pour sauvegarder les favoris localement
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'posterPath': posterPath,
      'voteAverage': voteAverage,
    };
  }
}
