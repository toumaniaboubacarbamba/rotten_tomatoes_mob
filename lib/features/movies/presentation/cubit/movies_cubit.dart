// chef d'orchestration qui appele UseCase et émet les états correspondants

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rotten_tomatoes/features/movies/domain/usecases/get_popular_movie.dart';
import 'package:rotten_tomatoes/features/movies/presentation/cubit/movies_states.dart';

class MoviesCubit extends Cubit<MoviesState> {
  final GetPopularMovies getPopularMovies;

  //on demarre avec l'état initial
  MoviesCubit(this.getPopularMovies) : super(MoviesInitial());

  Future<void> loadMovies() async {
    // on émet l'état de chargement
    emit(MoviesLoading());

    // on appelle le UseCase pour récupérer les films populaires
    final result = await getPopularMovies();

    //fold() est une méthode de Either qui nous permet de gérer les deux cas : échec (Left) ou succès (Right)
    result.fold(
      (failure) => emit(MoviesError(failure.message)),
      (movies) => emit(MovieLoaded(movies)),
    );
  }
}
