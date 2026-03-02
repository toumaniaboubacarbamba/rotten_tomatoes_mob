import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  /// Appelle le repository avec l'ordre logique utilisé dans la couche
  /// présentation : nom -> email -> mot de passe.
  ///
  /// Le repository se charge de transmettre ces valeurs correctement au
  /// datasource afin que l'API reçoive bien `name`, `email` et
  /// `password` (ainsi que `password_confirmation`).
  Future<Either<Failure, User>> call(
    String name,
    String email,
    String password,
  ) {
    return repository.register(name, email, password);
  }
}
