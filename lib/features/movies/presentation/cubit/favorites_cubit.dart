import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/toggle_favorite.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final GetFavorites getFavorites;
  final ToggleFavorite toggleFavorite;

  FavoritesCubit({required this.getFavorites, required this.toggleFavorite})
    : super(FavoritesInitial());

  // Charge tous les favoris
  Future<void> loadFavorites() async {
    emit(FavoritesLoading());
    final result = await getFavorites();
    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (movies) => emit(FavoritesLoaded(movies)),
    );
  }

  // Ajoute ou retire un film des favoris
  Future<void> toggle(Movie movie) async {
    await toggleFavorite(movie);
    // On recharge la liste après chaque toggle
    await loadFavorites();
  }
}
