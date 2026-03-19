//Storage service lit/ecrit les données en local (SharedPreferences). C'est lui qui gère le cache de l'utilisateur et le thème.
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/userModel.dart';
import '../entities/account.dart';

class StorageService {
  static const _userKey = 'cached_user';
  static const _themeKey = 'is_dark';

  Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    // jsonEncode convertit l'objet UserModel en une chaîne de caractères JSON, qui peut être stockée dans SharedPreferences.
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  //La fonction ne donne pas le résultat immédiatement. 
  //Elle promet de renvoyer soit une chaîne de caractères (String), soit rien du tout (null, d'où le ?) une fois le travail terminé.
  Future<Account?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_userKey);
    if (json == null) return null;
    return UserModel.fromJson(jsonDecode(json));
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  Future<String?> getToken() async {
    final user = await getUser();
    return user?.token;
  }

  Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }

  Future<bool> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? true;
  }
}
