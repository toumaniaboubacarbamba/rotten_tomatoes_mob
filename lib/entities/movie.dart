//Les objets métier purs Pas de JSON, pas de logique, juste les données qui persistent
import 'package:equatable/equatable.dart';
// Equatable est une bibliothèque qui permet de comparer des objets en se basant sur leurs propriétés plutôt 
//que sur leur référence en mémoire. Cela facilite la comparaison d'instances de classes, 
//notamment dans le contexte de la gestion d'état avec des blocs (BLoC) ou d'autres architectures réactives.
//En étendant Equatable, les classes Movie et Genre peuvent être comparées facilement,
// ce qui est particulièrement utile pour les tests unitaires et la gestion d'état dans une application Flutter.
class Movie extends Equatable {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final double voteAverage;

  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
  });

  @override
  List<Object?> get props => [id];
}

class Genre extends Equatable {
  final int id;
  final String name;

  const Genre({required this.id, required this.name});

  @override
  List<Object?> get props => [id];
}
