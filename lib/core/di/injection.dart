import 'package:get_it/get_it.dart';
import 'package:rotten_tomatoes/features/auth/domain/usecases/logout_usercase.dart';
import 'package:rotten_tomatoes/features/movies/domain/usecases/get_popular_movie.dart';
import 'package:rotten_tomatoes/features/movies/domain/usecases/search_movies.dart';
import 'package:rotten_tomatoes/features/movies/presentation/cubit/search_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_cached_user_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/movies/data/datasources/movie_remote_data_source.dart';
import '../../features/movies/data/repositories/movie_repository_impl.dart';
import '../../features/movies/domain/repositories/movie_repository.dart';
import '../../features/movies/presentation/cubit/movies_cubit.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

// "async" car SharedPreferences nécessite une attente
Future<void> initDependencies() async {
  // External — SharedPreferences doit être initialisé avant tout
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => DioClient());

  // Auth
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      logoutUseCase: sl(),
      getCachedUserUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCachedUserUseCase(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton(() => AuthRemoteDataSource(sl()));

  // Movies
  sl.registerFactory(() => SearchMovies(sl()));
  sl.registerFactory(() => SearchCubit(sl()));
  sl.registerFactory(() => MoviesCubit(sl()));
  sl.registerLazySingleton(() => GetPopularMovies(sl()));
  sl.registerLazySingleton<MovieRepository>(() => MovieRepositoryImpl(sl()));
  sl.registerLazySingleton(() => MovieRemoteDataSource(sl()));
}
