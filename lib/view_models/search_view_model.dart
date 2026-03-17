// SearchViewModel est le BLoC qui gère l'état de la recherche de films. Il utilise MovieManager pour la logique métier et expose des événements et états pour la UI.
import 'package:flutter_bloc/flutter_bloc.dart';
import '../engines/movie_manager.dart';
import '../entities/movie.dart';

// ── STATES ──

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Movie> movies;
  SearchLoaded(this.movies);
}

class SearchEmpty extends SearchState {}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}

// ── CUBIT ──
class SearchViewModel extends Cubit<SearchState> {
  final MovieManager _manager;

  SearchViewModel(this._manager) : super(SearchInitial());

  Future<void> search(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }
    emit(SearchLoading());
    try {
      final movies = await _manager.searchMovies(query);
      if (movies.isEmpty) {
        emit(SearchEmpty());
      } else {
        emit(SearchLoaded(movies));
      }
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  void clearSearch() => emit(SearchInitial());
}
