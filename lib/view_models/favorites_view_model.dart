import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rotten_tomatoes/services/notification_service.dart';
import '../engines/movie_manager.dart';
import '../entities/movie.dart';

// ── EVENTS ──
abstract class FavoritesEvent {}

class LoadFavorites extends FavoritesEvent {}

class ToggleFavorite extends FavoritesEvent {
  final Movie movie;
  ToggleFavorite(this.movie);
}

// ── STATES ──
abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Movie> movies;
  FavoritesLoaded(this.movies);
}

class FavoritesError extends FavoritesState {
  final String message;
  FavoritesError(this.message);
}

// ── BLOC ──
class FavoritesViewModel extends Bloc<FavoritesEvent, FavoritesState> {
  final MovieManager _manager;

  FavoritesViewModel(this._manager) : super(FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onLoadFavorites(
      LoadFavorites event, Emitter<FavoritesState> emit) async {
    emit(FavoritesLoading());
    try {
      final movies = await _manager.getFavorites();
      emit(FavoritesLoaded(movies));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> _onToggleFavorite(
      //Emitter est une classe capable d'émettre de nouveaux états.
      ToggleFavorite event, Emitter<FavoritesState> emit) async {
    try {
      final isFavorite = await _manager.toggleFavorite(event.movie);
      if (isFavorite) {
        NotificationService().showFavoriteNotification(event.movie.title);
      } else {
        NotificationService().showUnfavoriteNotification(event.movie.title);
      }
      // Recharger la liste après le toggle
      final movies = await _manager.getFavorites();
      emit(FavoritesLoaded(movies));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }
}
