import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rotten_tomatoes/features/auth/domain/usecases/logout_usercase.dart';
import '../../domain/usecases/get_cached_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCachedUserUseCase getCachedUserUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.getCachedUserUseCase,
  }) : super(AuthInitial()) {
    // On enregistre un handler pour chaque type d'event
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  // Vérifie si un utilisateur est déjà connecté au démarrage
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

  // Gère la déconnexion
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await logoutUseCase();
    emit(Unauthenticated());
  }
}