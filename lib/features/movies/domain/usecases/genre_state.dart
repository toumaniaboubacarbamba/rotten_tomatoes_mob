import 'package:equatable/equatable.dart';
import '../../domain/entities/genre.dart';
import '../../domain/entities/movie.dart';

abstract class GenreState extends Equatable {
  const GenreState();

  @override
  List<Object> get props => [];
}

class GenreInitial extends GenreState {}

class GenreLoading extends GenreState {}

class GenreLoaded extends GenreState {
  final List<Genre> genres;
  final List<Movie> movies;
  final Genre? selectedGenre; // null = aucun genre sélectionné

  const GenreLoaded({
    required this.genres,
    this.movies = const [],
    this.selectedGenre,
  });

  @override
  List<Object> get props => [genres, movies];
}

class GenreError extends GenreState {
  final String message;
  const GenreError(this.message);

  @override
  List<Object> get props => [message];
}
