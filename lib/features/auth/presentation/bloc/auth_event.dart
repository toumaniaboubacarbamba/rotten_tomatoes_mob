import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

// Event déclenché au démarrage de l'app pour vérifier si déjà connecté
class AuthCheckRequested extends AuthEvent {}

// Event déclenché quand l'utilisateur clique sur "Se connecter"
class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

// Event déclenché quand l'utilisateur clique sur "Se déconnecter"
class LogoutRequested extends AuthEvent {}
