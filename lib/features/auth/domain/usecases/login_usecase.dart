import 'package:dartz/dartz.dart';
import 'package:rotten_tomatoes/core/error/failures.dart';
import 'package:rotten_tomatoes/features/auth/domain/entities/user.dart';
import 'package:rotten_tomatoes/features/auth/domain/repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase(this.repository);

  Future<Either<String, Failure>> call(String username, String password)  {
    return  repository.login(username, password);
  }
}
