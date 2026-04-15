import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/storageService.dart';

// --- Événements ---
abstract class ThemeEvent {}

class LoadTheme extends ThemeEvent {}

class ToggleTheme extends ThemeEvent {}

// --- État ---
class ThemeState {
  final bool isDark;
  ThemeState(this.isDark);
}

// --- BLoC ---
class ThemeViewModel extends Bloc<ThemeEvent, ThemeState> {
  final StorageService _storage;

  ThemeViewModel(this._storage) : super(ThemeState(true)) {
    // Enregistrement des handlers d'événements
    on<LoadTheme>(_onLoadTheme);
    on<ToggleTheme>(_onToggleTheme);
  }

  Future<void> _onLoadTheme(LoadTheme event, Emitter<ThemeState> emit) async {
    final isDark = await _storage.getTheme();
    emit(ThemeState(isDark));
  }

  Future<void> _onToggleTheme(ToggleTheme event, Emitter<ThemeState> emit) async {
    final newValue = !state.isDark;
    await _storage.saveTheme(newValue);
    emit(ThemeState(newValue));
  }
}