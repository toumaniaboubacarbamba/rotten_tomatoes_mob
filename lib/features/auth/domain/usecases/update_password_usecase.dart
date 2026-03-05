import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class UpdatePasswordUseCase {
  final AuthRepository repository;
  UpdatePasswordUseCase(this.repository);

  Future<Either<Failure, Unit>> call(
      String token, String currentPassword, String newPassword) {
    return repository.updatePassword(token, currentPassword, newPassword);
  }
}