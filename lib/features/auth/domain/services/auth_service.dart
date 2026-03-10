import '../entities/user.dart';

abstract class AuthService {
  Future<User> login(String email, String password);
  Future<User> register(String name, String email, String password);
  Future<void> logout(String token);
  Future<User> getCachedUser();
  Future<User> updateProfile(String token, String name);
  Future<void> updatePassword(
    String token,
    String currentPassword,
    String newPassword,
  );
}
