// FavoritesViewModel est le BLoC qui gère l'état des films favoris. Il utilise MovieManager pour la logique métier et expose des événements et états pour la UI.
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rotten_tomatoes/core/services/notification_service.dart';
import '../engines/movie_manager.dart';
import '../entities/movie.dart';

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

// ── CUBIT ──
class FavoritesViewModel extends Cubit<FavoritesState> {
  final MovieManager _manager;

  FavoritesViewModel(this._manager) : super(FavoritesInitial());

  Future<void> load() async{
    emit(FavoritesLoading());
    try{
      final movies = await _manager.getFavorites();
      emit(FavoritesLoaded(movies));
    } catch(e){
      emit(FavoritesError(e.toString()));
    }
  }


  Future<void> toggle(Movie movie) async {
    try {
      final isFavorite = await _manager.toggleFavorite(movie);
      if(isFavorite) {
        NotificationService().showFavoriteNotification(movie.title);
      } else {
        NotificationService().showUnfavoriteNotification(movie.title);
      }
      await load();
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }
}