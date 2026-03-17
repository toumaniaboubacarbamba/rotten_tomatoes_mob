import 'package:flutter_bloc/flutter_bloc.dart';
import '../engines/movie_manager.dart';
import '../entities/movie.dart';

// ── STATES ────────────────────────────────────────
abstract class MoviesState {}
class MoviesInitial extends MoviesState {}
class MoviesLoading extends MoviesState {}
class MoviesLoadingMore extends MoviesState {
  final List<Movie> movies;
  MoviesLoadingMore(this.movies);
}
class MoviesLoaded extends MoviesState {
  final List<Movie> movies;
  final int currentPage;
  final bool hasReachedMax;
  MoviesLoaded({
    required this.movies,
    required this.currentPage,
    this.hasReachedMax = false,
  });
}
class MoviesError extends MoviesState {
  final String message;
  MoviesError(this.message);
}

// ── CUBIT ─────────────────────────────────────────
class MoviesViewModel extends Cubit<MoviesState> {
  final MovieManager _manager;

  MoviesViewModel(this._manager) : super(MoviesInitial());

  Future<void> loadMovies() async {
    emit(MoviesLoading());
    try {
      final movies = await _manager.getPopularMovies(page: 1);
      emit(MoviesLoaded(movies: movies, currentPage: 1));
    } catch (e) {
      emit(MoviesError(e.toString()));
    }
  }

  Future<void> loadMoreMovies() async {
    if (state is! MoviesLoaded) return;
    final current = state as MoviesLoaded;
    if (current.hasReachedMax) return;

    emit(MoviesLoadingMore(current.movies));
    try {
      final nextPage = current.currentPage + 1;
      final newMovies = await _manager.getPopularMovies(page: nextPage);
      if (newMovies.isEmpty) {
        emit(MoviesLoaded(
          movies: current.movies,
          currentPage: current.currentPage,
          hasReachedMax: true,
        ));
      } else {
        emit(MoviesLoaded(
          movies: [...current.movies, ...newMovies],
          currentPage: nextPage,
        ));
      }
    } catch (e) {
      emit(MoviesError(e.toString()));
    }
  }
}