import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  // Tente de connecter l'utilisateur et retourne soit une erreur soit un User
  Future<Either<Failure, User>> login(String username, String password);

  // Déconnecte l'utilisateur
  Future<Either<Failure, Unit>> logout();

  // Vérifie si un token est déjà sauvegardé localement
  Future<Either<Failure, User>> getCachedUser();
}