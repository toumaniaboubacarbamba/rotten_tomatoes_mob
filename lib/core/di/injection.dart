import 'package:get_it/get_it.dart';
import 'package:rotten_tomatoes/features/movies/domain/usecases/get_popular_movie.dart';
import '../../features/movies/data/datasources/movie_remote_data_source.dart';
import '../../features/movies/data/repositories/movie_repository_impl.dart';
import '../../features/movies/domain/repositories/movie_repository.dart';
import '../../features/movies/presentation/cubit/movies_cubit.dart';
import '../network/dio_client.dart';

// "sl" = service locator — c'est notre boîte à dépendances
final sl = GetIt.instance;

void initDependencies() {
  // Cubit — registerFactory = nouvelle instance à chaque fois qu'on demande
  sl.registerFactory(() => MoviesCubit(sl()));

  // Use Case
  sl.registerLazySingleton(() => GetPopularMovies(sl()));

  // Repository — on enregistre l'interface mais on donne l'implémentation
  sl.registerLazySingleton<MovieRepository>(() => MovieRepositoryImpl(sl()));

  // DataSource
  sl.registerLazySingleton(() => MovieRemoteDataSource(sl()));

  // DioClient — registerLazySingleton = une seule instance pour toute l'app
  sl.registerLazySingleton(() => DioClient());
}
