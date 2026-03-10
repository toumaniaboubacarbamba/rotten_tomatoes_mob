import 'package:get_it/get_it.dart';
import 'package:rotten_tomatoes/features/auth/data/services/laravel_auth_service.dart';
import 'package:rotten_tomatoes/features/auth/domain/services/auth_service.dart';
import 'package:rotten_tomatoes/features/auth/domain/usecases/logout_usercase.dart';
import 'package:rotten_tomatoes/features/auth/domain/usecases/update_password_usecase.dart';
import 'package:rotten_tomatoes/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:rotten_tomatoes/features/movies/data/services/laravel_favorite_service.dart';
import 'package:rotten_tomatoes/features/movies/data/services/tmdb_movie_service.dart';
import 'package:rotten_tomatoes/features/movies/domain/services/favorite_service.dart';
import 'package:rotten_tomatoes/features/movies/domain/services/movie_service.dart';
import 'package:rotten_tomatoes/features/movies/domain/usecases/get_favorites.dart';
import 'package:rotten_tomatoes/features/movies/domain/usecases/get_genres.dart';
import 'package:rotten_tomatoes/features/movies/domain/usecases/get_movies_by_genre.dart';
import 'package:rotten_tomatoes/features/movies/domain/usecases/get_popular_movie.dart';
import 'package:rotten_tomatoes/features/movies/domain/usecases/toggle_favorite.dart';
import 'package:rotten_tomatoes/features/movies/presentation/cubit/favorites_cubit.dart';
import 'package:rotten_tomatoes/features/movies/presentation/cubit/genre_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/data/repositories_impl/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_cached_user_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/movies/data/repositories_impl/movie_repository_impl.dart';
import '../../features/movies/domain/repositories/movie_repository.dart';
import '../../features/movies/domain/usecases/search_movies.dart';
import '../../features/movies/presentation/cubit/movies_cubit.dart';
import '../../features/movies/presentation/cubit/search_cubit.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => DioClient());

  // Auth
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      logoutUseCase: sl(),
      getCachedUserUseCase: sl(),
      registerUseCase: sl(),
      updateProfileUseCase: sl(),
      updatePasswordUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdatePasswordUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCachedUserUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );

  // Movies
  sl.registerFactory(() => MoviesCubit(sl()));
  sl.registerFactory(() => SearchCubit(sl()));
  sl.registerFactory(
    () => FavoritesCubit(
      getFavoritesUseCase: sl(),
      toggleFavoriteUseCase: sl(),
      sharedPreferences: sl(),
    ),
  );
  sl.registerFactory(() => GenreCubit(getGenres: sl(), getMoviesByGenre: sl()));
  sl.registerLazySingleton(() => GetPopularMovies(sl()));
  sl.registerLazySingleton(() => SearchMovies(sl()));
  sl.registerLazySingleton(() => GetFavorites(sl()));
  sl.registerLazySingleton(() => ToggleFavorite(sl()));
  sl.registerLazySingleton(() => GetGenres(sl()));
  sl.registerLazySingleton(() => GetMoviesByGenre(sl()));
  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<AuthService>(() => LaravelAuthService(sl()));
  sl.registerLazySingleton<MovieService>(() => TmdbMovieService(sl()));
  sl.registerLazySingleton<FavoriteService>(() => LaravelFavoriteService());
}
