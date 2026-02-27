import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rotten_tomatoes/features/movies/domain/usecases/get_popular_movie.dart';
import 'package:rotten_tomatoes/features/movies/presentation/cubit/movies_states.dart';

class MoviesCubit extends Cubit<MoviesState> {
  final GetPopularMovies getPopularMovies;

  MoviesCubit(this.getPopularMovies) : super(MoviesInitial());

  // Charge la première page — réinitialise tout
  Future<void> loadMovies() async {
    emit(MoviesLoading());
    final result = await getPopularMovies(page: 1);
    result.fold(
      (failure) => emit(MoviesError(failure.message)),
      (movies) => emit(MoviesLoaded(
        movies: movies,
        currentPage: 1,
      )),
    );
  }

  // Charge la page suivante — ajoute aux films existants
  Future<void> loadMoreMovies() async {
    // On vérifie qu'on est bien dans un état chargé
    if (state is! MoviesLoaded) return;
    final currentState = state as MoviesLoaded;

    // On vérifie qu'il reste des films à charger
    if (currentState.hasReachedMax) return;

    // On émet LoadingMore en gardant les films existants
    emit(MoviesLoadingMore(currentState.movies));

    final nextPage = currentState.currentPage + 1;
    final result = await getPopularMovies(page: nextPage);

    result.fold(
      (failure) => emit(MoviesError(failure.message)),
      (newMovies) {
        // Si TMDB retourne une liste vide → on a atteint la fin
        if (newMovies.isEmpty) {
          emit(MoviesLoaded(
            movies: currentState.movies,
            currentPage: currentState.currentPage,
            hasReachedMax: true,
          ));
        } else {
          // On combine les anciens films avec les nouveaux
          emit(MoviesLoaded(
            movies: [...currentState.movies, ...newMovies],
            currentPage: nextPage,
          ));
        }
      },
    );
  }
}