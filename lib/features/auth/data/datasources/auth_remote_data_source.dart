import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final SharedPreferences sharedPreferences;

  AuthRemoteDataSource(this.sharedPreferences);

  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));

    if (email == 'yami@gmail.com' && password == 'test123') {
      final user = UserModel(
        id: '1',
        email: email,
        name: 'Yami Sukehiro',
        token: 'fake_token_123',
      );
      await sharedPreferences.setString('cached_user', jsonEncode(user.toJson()));
      return user;
    }

    throw Exception('Email ou mot de passe incorrect');
  }

  // Simule une inscription — dans une vraie app ce serait un appel Dio
  Future<UserModel> register(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));

    // On vérifie que l'email n'est pas déjà utilisé
    if (email == 'yami@gmail.com') {
      throw Exception('Cet email est déjà utilisé');
    }

    // On crée le nouvel utilisateur
    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: name,
      token: 'token_${DateTime.now().millisecondsSinceEpoch}',
    );

    // On sauvegarde localement
    await sharedPreferences.setString('cached_user', jsonEncode(user.toJson()));

    return user;
  }

  Future<void> logout() async {
    await sharedPreferences.remove('cached_user');
  }

  Future<UserModel> getCachedUser() async {
    final userJson = sharedPreferences.getString('cached_user');

    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }

    throw Exception('Aucun utilisateur en cache');
  }
}