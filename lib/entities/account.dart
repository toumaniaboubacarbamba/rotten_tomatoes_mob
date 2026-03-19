//Les objets métier purs.Pas de JSON, pas de logique, juste les données qui persistent
import 'package:equatable/equatable.dart';

// Equatable est une bibliothèque qui permet de comparer des objets en se basant sur leurs propriétés plutôt 
//que sur leur référence en mémoire. Cela facilite la comparaison d'instances de classes.
class Account extends Equatable {
  final String id;
  final String email;
  final String name;
  final String token;
  final String? createdAt;

  const Account({
    required this.id,
    required this.email,
    required this.name,
    required this.token,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id];
}