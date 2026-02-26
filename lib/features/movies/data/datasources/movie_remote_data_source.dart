import '../../../../core/network/dio_client.dart';
import '../models/movie_model.dart';

class MovieRemoteDataSource {
  final DioClient dioClient;

  MovieRemoteDataSource(this.dioClient);

  Future<List<MovieModel>> getPopularMovies() async {
    final response = await dioClient.dio.get('/movie/popular');
    final List results = response.data['results'];
    return results.map((json) => MovieModel.fromJson(json)).toList();
  }

  // Nouvel endpoint TMDB pour la recherche
  Future<List<MovieModel>> searchMovies(String query) async {
    final response = await dioClient.dio.get(
      '/search/movie',
      queryParameters: {'query': query},
    );
    final List results = response.data['results'];
    return results.map((json) => MovieModel.fromJson(json)).toList();
  }
}