import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rotten_tomatoes/core/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/toggle_favorite.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final GetFavorites getFavoritesUseCase;
  final ToggleFavorite toggleFavoriteUseCase;
  final SharedPreferences sharedPreferences;

  FavoritesCubit({
    required this.getFavoritesUseCase,
    required this.toggleFavoriteUseCase,
    required this.sharedPreferences,
  }) : super(FavoritesInitial());

  // Récupère le token depuis SharedPreferences
  String _getToken() {
    final userJson = sharedPreferences.getString('cached_user');
    if (userJson != null) {
      final user = jsonDecode(userJson);
      return user['token'];
    }
    return '';
  }

  Future<void> loadFavorites() async {
    emit(FavoritesLoading());
    final token = _getToken();
    final result = await getFavoritesUseCase(token);
    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (movies) => emit(FavoritesLoaded(movies)),
    );
  }

  Future<void> toggle(Movie movie) async {
    final token = _getToken();
    final result = await toggleFavoriteUseCase(movie, token);
    result.fold((failure) => null, (isFavorite) {
      if (isFavorite) {
        NotificationService().showFavoriteNotification(movie.title);
      } else {
        NotificationService().showUnfavoriteNotification(movie.title);
      }
    });
    await loadFavorites();
  }
}
