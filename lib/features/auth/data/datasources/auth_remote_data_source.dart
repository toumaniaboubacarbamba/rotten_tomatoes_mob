import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final SharedPreferences sharedPreferences;
  static const _baseUrl = 'https://fullstack-mobile-budgetapp.onrender.com/api';

  // Dio dédié à l'auth — sans api_key TMDB
  final _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {'Accept': 'application/json'},
    ),
  );

  AuthRemoteDataSource(this.sharedPreferences);

  Future<UserModel> login(String email, String password) async {
    final response = await _dio.post(
      '$_baseUrl/login',
      data: {'email': email, 'password': password},
    );

    final user = UserModel(
      id: response.data['user']['id'].toString(),
      name: response.data['user']['name'],
      email: response.data['user']['email'],
      token: response.data['token'],
    );

    await sharedPreferences.setString('cached_user', jsonEncode(user.toJson()));
    return user;
  }

  Future<UserModel> register(String name, String email, String password) async {
    final response = await _dio.post(
      '$_baseUrl/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
      },
    );

    final user = UserModel(
      id: response.data['user']['id'].toString(),
      name: response.data['user']['name'],
      email: response.data['user']['email'],
      token: response.data['token'],
    );

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
