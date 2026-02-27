import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rotten_tomatoes/features/movies/domain/usecases/genre_state.dart';
import '../../domain/entities/genre.dart';
import '../../domain/usecases/get_genres.dart';
import '../../domain/usecases/get_movies_by_genre.dart';

class GenreCubit extends Cubit<GenreState> {
  final GetGenres getGenres;
  final GetMoviesByGenre getMoviesByGenre;

  GenreCubit({
    required this.getGenres,
    required this.getMoviesByGenre,
  }) : super(GenreInitial());

  // Charge tous les genres au démarrage
  Future<void> loadGenres() async {
    emit(GenreLoading());
    final result = await getGenres();
    result.fold(
      (failure) => emit(GenreError(failure.message)),
      (genres) => emit(GenreLoaded(genres: genres)),
    );
  }

  // Charge les films quand l'utilisateur sélectionne un genre
  Future<void> selectGenre(Genre genre) async {
    // On garde la liste des genres mais on indique le genre sélectionné
    final currentGenres = state is GenreLoaded
        ? (state as GenreLoaded).genres
        : <Genre>[];

    emit(GenreLoaded(
      genres: currentGenres,
      selectedGenre: genre,
      movies: const [],
    ));

    final result = await getMoviesByGenre(genre.id);
    result.fold(
      (failure) => emit(GenreError(failure.message)),
      (movies) => emit(GenreLoaded(
        genres: currentGenres,
        movies: movies,
        selectedGenre: genre,
      )),
    );
  }
}