// ThemeViewModel est le BLoC qui gère l'état du thème (clair/sombre). Il utilise StorageService pour la logique métier de sauvegarde et récupération du thème, et expose des événements et états pour la UI.
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/storageService.dart';

class ThemeViewModel extends Cubit<bool> {
  final StorageService _storage;

  ThemeViewModel(this._storage) : super(true);

  Future<void> load() async {
    final isDark = await _storage.getTheme();
    emit(isDark);
  }

  Future<void> toggleTheme() async {
    final newValue = !state;
    await _storage.saveTheme(newValue);
    emit(newValue);
  }
}