import 'package:flutter_bloc/flutter_bloc.dart';
import '../engines/movie_manager.dart';
import '../entities/movie.dart';

// ── EVENTS ──
abstract class SearchEvent {}

class SearchMovies extends SearchEvent {
  final String query;
  SearchMovies(this.query);
}

class ClearSearch extends SearchEvent {}

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

// ── BLOC ──
class SearchViewModel extends Bloc<SearchEvent, SearchState> {
  final MovieManager _manager;

  SearchViewModel(this._manager) : super(SearchInitial()) {
    on<SearchMovies>(_onSearchMovies);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onSearchMovies(
      SearchMovies event, Emitter<SearchState> emit) async {
    if (event.query.isEmpty) {
      emit(SearchInitial());
      return;
    }
    emit(SearchLoading());
    try {
      final movies = await _manager.searchMovies(event.query);
      if (movies.isEmpty) {
        emit(SearchEmpty());
      } else {
        emit(SearchLoaded(movies));
      }
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  void _onClearSearch(ClearSearch event, Emitter<SearchState> emit) {
    emit(SearchInitial());
  }
}
