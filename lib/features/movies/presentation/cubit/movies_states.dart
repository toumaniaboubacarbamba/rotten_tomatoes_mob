import 'package:equatable/equatable.dart';
import '../../domain/entities/movie.dart';

abstract class MoviesState extends Equatable {
  const MoviesState();

  @override
  List<Object> get props => [];
}

class MoviesInitial extends MoviesState {}

class MoviesLoading extends MoviesState {}

// pagination
// On garde les films existants visibles pendant le chargement
class MoviesLoadingMore extends MoviesState {
  final List<Movie> movies;
  const MoviesLoadingMore(this.movies);

  @override
  List<Object> get props => [movies];
}

class MoviesLoaded extends MoviesState {
  final List<Movie> movies;
  final int currentPage;
  final bool hasReachedMax; // true = plus de films à charger

  const MoviesLoaded({
    required this.movies,
    required this.currentPage,
    this.hasReachedMax = false,
  });

  @override
  List<Object> get props => [movies, currentPage, hasReachedMax];
}

class MoviesError extends MoviesState {
  final String message;
  const MoviesError(this.message);

  @override
  List<Object> get props => [message];
}
