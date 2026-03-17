// AuthViewModel est le BLoC qui gère l'état de l'authentification (login, register, logout, update profile/password). Il utilise AuthManager pour la logique métier et expose des événements et états pour la UI.
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rotten_tomatoes/core/services/notification_service.dart';
import '../engines/auth_manager.dart';
import '../entities/account.dart';

// ── EVENTS ──
abstract class AuthEvent {}
class AuthCheckRequested extends AuthEvent {}
class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested(this.email, this.password);
}
class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  RegisterRequested(this.name, this.email, this.password);
}
class LogoutRequested extends AuthEvent {}
class UpdateProfileRequested extends AuthEvent {
  final String name;
  UpdateProfileRequested(this.name);
}
class UpdatePasswordRequested extends AuthEvent {
  final String current;
  final String newPass;
  UpdatePasswordRequested(this.current, this.newPass);
}

// ── STATES ──
abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class Authenticated extends AuthState {
  final Account user;
  Authenticated(this.user);
}
class Unauthenticated extends AuthState {}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
class AuthSuccess extends AuthState {
  final String message;
  AuthSuccess(this.message);
}

// ── BLOC ──
class AuthViewModel extends Bloc<AuthEvent, AuthState> {
  final AuthManager _manager;

  AuthViewModel(this._manager) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onCheck);
    on<LoginRequested>(_onLogin);
    on<RegisterRequested>(_onRegister);
    on<LogoutRequested>(_onLogout);
    on<UpdateProfileRequested>(_onUpdateProfile);
    on<UpdatePasswordRequested>(_onUpdatePassword);
  }

  Future<void> _onCheck(AuthCheckRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final user = await _manager.getCachedUser();
    if (user != null) {
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLogin(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _manager.login(event.email, event.password);
      NotificationService().showWelcomeNotification(user.name);
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegister(RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _manager.register(event.name, event.email, event.password);
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogout(LogoutRequested event, Emitter<AuthState> emit) async {
    await _manager.logout();
    emit(Unauthenticated());
  }

  Future<void> _onUpdateProfile(UpdateProfileRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _manager.updateProfile(event.name);
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onUpdatePassword(UpdatePasswordRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _manager.updatePassword(event.current, event.newPass);
      emit(AuthSuccess('Mot de passe modifié avec succès'));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}