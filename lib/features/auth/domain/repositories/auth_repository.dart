import 'package:dartz/dartz.dart';
import 'package:rotten_tomatoes/core/error/failures.dart';

abstract class AuthRepository {
  //Tente de connecter l'utilisateur avec les identifiants fournis
  Future<Either<String, Failure>> login(String username, String password);

  //Déconnecte l'utilisateur en supprimant les données de cache
  Future<Either<String, Unit>> logout();

  //Verifie si un utilisateur est déjà connecté en vérifiant le cache
  Future<Either<String, String>> getCacheUser();
}
