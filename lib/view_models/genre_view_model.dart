// GenreViewModel est le BLoC qui gère l'état de la sélection des genres et des films associés. Il utilise MovieManager pour la logique métier et expose des événements et états pour la UI.
import 'package:flutter_bloc/flutter_bloc.dart';
import '../engines/movie_manager.dart';
import '../entities/movie.dart';

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

// ── CUBIT ──
class GenreViewModel extends Cubit<GenreState> {
  final MovieManager _manager;

  GenreViewModel(this._manager) : super(GenreInitial());
  Future<void> loadGenres() async {
    emit(GenreLoading());
    try {
      final genres = await _manager.getGenres();
      emit(GenreLoaded(genres: genres));
    } catch (e) {
      emit(GenreError(e.toString()));
    }
  }

  Future<void> selectGenre(Genre genre) async {
    final currentGenres = state is GenreLoaded
        ? (state as GenreLoaded).genres
        : <Genre>[];

    emit(
      GenreLoaded(
        genres: currentGenres,
        selectedGenre: genre,
        movies: const [],
      ));

      try{
        final movies = await _manager.getMoviesByGenre(genre.id);
        emit(
          GenreLoaded(
            genres: currentGenres,
            selectedGenre: genre,
            movies: movies,
          ),
        );
      } catch(e){
        emit(GenreError(e.toString()));
      }
  }
}
