import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/search_movies.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchMovies searchMovies;

  SearchCubit(this.searchMovies) : super(SearchInitial());

  Future<void> search(String query) async {
    // Si la recherche est vide on revient à l'état initial
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    final result = await searchMovies(query);

    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (movies) {
        // Si TMDB retourne une liste vide → état SearchEmpty
        if (movies.isEmpty) {
          emit(SearchEmpty());
        } else {
          emit(SearchLoaded(movies));
        }
      },
    );
  }

  // Réinitialise la recherche quand l'utilisateur ferme la barre
  void clearSearch() {
    emit(SearchInitial());
  }
}