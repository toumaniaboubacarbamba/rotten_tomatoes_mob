import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final SharedPreferences sharedPreferences;

  AuthRemoteDataSource(this.sharedPreferences);

  Future<UserModel> login(String email, String password) async {
    // On simule un appel serveur avec un délai de 2 secondes
    await Future.delayed(const Duration(seconds: 2));

    // On vérifie les identifiants — dans une vraie app ce serait une requête Dio
    if (email == 'test@gmail.com' && password == '123456') {
      final user = UserModel(
        id: '1',
        email: email,
        name: 'Test User',
        token: 'fake_token_123',
      );

      // On sauvegarde l'utilisateur localement
      await sharedPreferences.setString(
        'cached_user',
        jsonEncode(user.toJson()),
      );

      return user;
    }

    // Mauvais identifiants → on lance une exception
    throw Exception('Email ou mot de passe incorrect');
  }

  Future<void> logout() async {
    // On supprime l'utilisateur sauvegardé
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
