import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rotten_tomatoes/features/auth/domain/usecases/get_cached_user_usecase.dart';
import 'package:rotten_tomatoes/features/auth/domain/usecases/login_usecase.dart';
import 'package:rotten_tomatoes/features/auth/domain/usecases/logout_usercase.dart';
import 'package:rotten_tomatoes/features/auth/presentation/bloc/auth_event.dart';
import 'package:rotten_tomatoes/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCachedUserUseCase getCachedUserUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.getCachedUserUseCase,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
  }

  //Vérifie si l'utilisateur est déjà connecté au lancement de l'application
  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await getCachedUserUseCase();
    result.fold(
      (failure) => emit(Unauthenticated()),
      (user) => emit(Authenticated(user)),
    );
  }

  // Gère la tentative de connexion
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await loginUseCase(event.email, event.password);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  // Gère la déconnexion de l'utilisateur
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await logoutUseCase();
    emit(Unauthenticated());
  }
}
