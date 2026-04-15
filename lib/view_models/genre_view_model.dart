import 'package:flutter_bloc/flutter_bloc.dart';
import '../engines/movie_manager.dart';
import '../entities/movie.dart';

// ── EVENTS ──
abstract class GenreEvent {}

class LoadGenres extends GenreEvent {}

class SelectGenre extends GenreEvent {
  final Genre genre;
  SelectGenre(this.genre);
}

// ── STATES ──
abstract class GenreState {}

class GenreInitial extends GenreState {}

class GenreLoading extends GenreState {}

class GenreLoaded extends GenreState {
  final List<Genre> genres;
  final List<Movie> movies;
  final Genre? selectedGenre;
  GenreLoaded({
    required this.genres,
    this.movies = const [],
    this.selectedGenre,
  });
}

class GenreError extends GenreState {
  final String message;
  GenreError(this.message);
}

// ── BLOC ──
class GenreViewModel extends Bloc<GenreEvent, GenreState> {
  final MovieManager _manager;

  GenreViewModel(this._manager) : super(GenreInitial()) {
    on<LoadGenres>(_onLoadGenres);
    on<SelectGenre>(_onSelectGenre);
  }

  Future<void> _onLoadGenres(
      LoadGenres event, Emitter<GenreState> emit) async {
    emit(GenreLoading());
    try {
      final genres = await _manager.getGenres();
      emit(GenreLoaded(genres: genres));
    } catch (e) {
      emit(GenreError(e.toString()));
    }
  }

  Future<void> _onSelectGenre(
      SelectGenre event, Emitter<GenreState> emit) async {
    final currentGenres = state is GenreLoaded
        ? (state as GenreLoaded).genres
        : <Genre>[];

    emit(GenreLoaded(
      genres: currentGenres,
      selectedGenre: event.genre,
      movies: const [],
    ));

    try {
      final movies = await _manager.getMoviesByGenre(event.genre.id);
      emit(GenreLoaded(
        genres: currentGenres,
        selectedGenre: event.genre,
        movies: movies,
      ));
    } catch (e) {
      emit(GenreError(e.toString()));
    }
  }
}
