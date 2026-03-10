import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/entities/user.dart';
import '../../domain/services/auth_service.dart';
import '../models/user_model.dart';

class LaravelAuthService implements AuthService {
  final SharedPreferences sharedPreferences;
  static const _baseUrl = 'https://fullstack-mobile-budgetapp.onrender.com/api';

  final _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {'Accept': 'application/json'},
    ),
  );

  LaravelAuthService(this.sharedPreferences);

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/login',
        data: {'email': email, 'password': password},
      );
      final user = UserModel(
        id: response.data['user']['id'].toString(),
        name: response.data['user']['name'],
        email: response.data['user']['email'],
        token: response.data['token'],
        createdAt: response.data['user']['created_at'],
      );
      await sharedPreferences.setString(
        'cached_user',
        jsonEncode(user.toJson()),
      );
      return user;
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data['errors'] != null) {
        final errors = e.response!.data['errors'] as Map;
        throw Exception(errors.values.first[0]);
      }
      throw Exception(e.response?.data['message'] ?? 'Erreur serveur');
    }
  }

  @override
  Future<User> register(String name, String email, String password) async {
    try {
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
        createdAt: response.data['user']['created_at'],
      );
      await sharedPreferences.setString(
        'cached_user',
        jsonEncode(user.toJson()),
      );
      return user;
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data['errors'] != null) {
        final errors = e.response!.data['errors'] as Map;
        throw Exception(errors.values.first[0]);
      }
      throw Exception(e.response?.data['message'] ?? 'Erreur serveur');
    }
  }

  @override
  Future<void> logout(String token) async {
    try {
      await _dio.post(
        '$_baseUrl/logout',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } catch (_) {
    } finally {
      await sharedPreferences.remove('cached_user');
    }
  }

  @override
  Future<User> getCachedUser() async {
    final userJson = sharedPreferences.getString('cached_user');
    if (userJson != null) return UserModel.fromJson(jsonDecode(userJson));
    throw Exception('Aucun utilisateur en cache');
  }

  @override
  Future<User> updateProfile(String token, String name) async {
    try {
      final response = await _dio.put(
        '$_baseUrl/user/update',
        data: {'name': name},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final updatedUser = UserModel(
        id: response.data['user']['id'].toString(),
        name: response.data['user']['name'],
        email: response.data['user']['email'],
        token: token,
        createdAt: response.data['user']['created_at'],
      );
      await sharedPreferences.setString(
        'cached_user',
        jsonEncode(updatedUser.toJson()),
      );
      return updatedUser;
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data['errors'] != null) {
        final errors = e.response!.data['errors'] as Map;
        throw Exception(errors.values.first[0]);
      }
      throw Exception(e.response?.data['message'] ?? 'Erreur serveur');
    }
  }

  @override
  Future<void> updatePassword(
    String token,
    String currentPassword,
    String newPassword,
  ) async {
    try {
      await _dio.put(
        '$_baseUrl/user/password',
        data: {
          'current_password': currentPassword,
          'password': newPassword,
          'password_confirmation': newPassword,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data['errors'] != null) {
        final errors = e.response!.data['errors'] as Map;
        throw Exception(errors.values.first[0]);
      }
      throw Exception(e.response?.data['message'] ?? 'Erreur serveur');
    }
  }
}
