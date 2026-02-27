import 'package:equatable/equatable.dart';
import '../../domain/entities/movie.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

// État initial — barre de recherche vide
class SearchInitial extends SearchState {}

// État chargement — on attend la réponse de TMDB
class SearchLoading extends SearchState {}

// État succès — on a les résultats
class SearchLoaded extends SearchState {
  final List<Movie> movies;
  const SearchLoaded(this.movies);

  @override
  List<Object> get props => [movies];
}

// État vide — recherche sans résultats
class SearchEmpty extends SearchState {}

// État erreur
class SearchError extends SearchState {
  final String message;
  const SearchError(this.message);

  @override
  List<Object> get props => [message];
}