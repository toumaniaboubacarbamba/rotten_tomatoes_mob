import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

//Event pour vérifier si l'utilisateur est déjà connecté au lancement de l'application
class AuthCheckRequested extends AuthEvent {}

//Event pour tenter de connecter l'utilisateur avec un email et mot de passe
class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

//Event pour déconnecter l'utilisateur
class LogoutRequested extends AuthEvent {}
