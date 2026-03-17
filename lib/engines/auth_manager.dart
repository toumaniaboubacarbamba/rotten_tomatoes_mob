//La logique métier AuthManager combine ApiService + StorageService pour login/register/logout.
import 'package:rotten_tomatoes/entities/account.dart';
import '../models/errors.dart';
import '../services/apiService.dart';
import '../services/storageService.dart';

class AuthManager {
  final ApiService _api;
  final StorageService _storage;

  AuthManager(this._api, this._storage);

  Future<Account> register(String name, String email, String password) async {
    final user = await _api.register(name, email, password);
    await _storage.saveUser(user);
    return user;
  }

  Future<Account> login(String email, String password) async {
    final user = await _api.login(email, password);
    await _storage.saveUser(user);
    return user;
  }

  Future<void> logout() async {
    final token = await _storage.getToken();
    if (token != null) await _api.logout(token);
    await _storage.clearUser();
  }

  Future<Account?> getCachedUser() async {
    return await _storage.getUser();
  }

  Future<Account> updateProfile(String name) async {
    final token = await _storage.getToken();
    if (token == null) throw AuthException('Non connecté');
    final user = await _api.updateProfile(token, name);
    await _storage.saveUser(user);
    return user;
  }

  Future<void> updatePassword(String current, String newPass) async {
    final token = await _storage.getToken();
    if (token == null) throw AuthException('Non connecté');
    await _api.updatePassword(token, current, newPass);
  }
}
