import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

// État initial — on ne sait pas encore si l'utilisateur est connecté
class AuthInitial extends AuthState {}

// État chargement — pendant le login ou la vérification du cache
class AuthLoading extends AuthState {}

// État connecté — on a un utilisateur
class Authenticated extends AuthState {
  final User user;
  const Authenticated(this.user);

  @override
  List<Object> get props => [user];
}

// État déconnecté — pas d'utilisateur
class Unauthenticated extends AuthState {}

// État erreur — mauvais identifiants ou problème réseau
class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}
