import 'package:equatable/equatable.dart';
import 'package:rotten_tomatoes/features/auth/domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// Etat initial de l'authentification, avant toute action
class AuthInitial extends AuthState {}

// Etat chargement lorsque l'utilisateur tente de se connecter
class AuthLoading extends AuthState {}

// Etat lorsque l'utilisateur est connecté avec succès
class Authenticated extends AuthState {
  final User user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

//Etat lorsque l'utilisateur est deconnecté
class Unauthenticated extends AuthState {}

// Etat lorsque la tentative de connexion a échoué
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
