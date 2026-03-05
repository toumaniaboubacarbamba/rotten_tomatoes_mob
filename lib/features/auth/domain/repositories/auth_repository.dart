import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  // Tente de connecter l'utilisateur et retourne soit une erreur soit un User
  Future<Either<Failure, User>> login(String email, String password);

  // Déconnecte l'utilisateur
  Future<Either<Failure, Unit>> logout();

  // Vérifie si un token est déjà sauvegardé localement
  Future<Either<Failure, User>> getCachedUser();

  /// Enregistre un nouvel utilisateur auprès de l'API.
  ///
  /// Les paramètres sont dans l'ordre logique utilisé depuis l'UI : **nom**,
  /// **email** puis **mot de passe**. Le code métier se charge ensuite de
  /// transmettre ces valeurs dans le bon ordre au datasource.
  Future<Either<Failure, User>> register(
    String name,
    String email,
    String password,
  );
  Future<Either<Failure, User>> updateProfile(String token, String name);
  Future<Either<Failure, Unit>> updatePassword(
    String token,
    String currentPassword,
    String newPassword,
  );
}
