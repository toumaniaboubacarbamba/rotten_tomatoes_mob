import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/services/auth_service.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;
  final SharedPreferences sharedPreferences;

  AuthRepositoryImpl(this.authService, this.sharedPreferences);

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final user = await authService.login(email, password);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      final userJson = sharedPreferences.getString('cached_user');
      String token = '';
      if (userJson != null) {
        final user = UserModel.fromJson(jsonDecode(userJson));
        token = user.token;
      }
      await authService.logout(token);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCachedUser() async {
    try {
      final user = await authService.getCachedUser();
      return Right(user);
    } catch (e) {
      return Left(CacheFailure('Aucun utilisateur connecté'));
    }
  }

  @override
  Future<Either<Failure, User>> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final user = await authService.register(name, email, password);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile(String token, String name) async {
    try {
      final user = await authService.updateProfile(token, name);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updatePassword(
    String token,
    String currentPassword,
    String newPassword,
  ) async {
    try {
      await authService.updatePassword(token, currentPassword, newPassword);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
