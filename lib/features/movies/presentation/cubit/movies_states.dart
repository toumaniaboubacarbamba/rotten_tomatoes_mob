// Les états de l'application concernant les films

import 'package:equatable/equatable.dart';
import 'package:rotten_tomatoes/features/movies/domain/entities/movie.dart';

abstract class MoviesState extends Equatable {
  @override
  List<Object?> get props => [];
}

// État initial, avant de charger les films
class MoviesInitial extends MoviesState {}

// État de chargement, pendant que les films sont en train d'être récupérés
class MoviesLoading extends MoviesState {}

// État de succès, lorsque les films ont été récupérés avec succès
class MovieLoaded extends MoviesState {
  final List<Movie> movies;
  const MovieLoaded(this.movies);

// 
  @override
  List<Object?> get props => [movies];
}

// État d'erreur, lorsque la récupération des films a échoué
class MoviesError extends MoviesState {
  final String message;
  const MoviesError(this.message);

  @override
  List<Object?> get props => [message];
}
