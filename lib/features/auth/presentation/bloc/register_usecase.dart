import 'package:dartz/dartz.dart';
import 'package:rotten_tomatoes/features/auth/domain/entities/user.dart';
import 'package:rotten_tomatoes/features/auth/domain/repositories/auth_repository.dart';
import '../../../../core/error/failures.dart';

class RegisterUsecase {
  final AuthRepository repository;

  RegisterUsecase(this.repository);

  Future<Either<Failure, User>> call(String username, String password) {
    return repository.login(username, password);
  }
}
