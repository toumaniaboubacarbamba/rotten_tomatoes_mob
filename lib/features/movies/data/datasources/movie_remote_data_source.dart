import '../../../../core/network/dio_client.dart';
import '../../domain/entities/genre.dart';
import '../models/movie_model.dart';

class MovieRemoteDataSource {
  final DioClient dioClient;

  MovieRemoteDataSource(this.dioClient);

  // On ajoute le paramètre page
  Future<List<MovieModel>> getPopularMovies({int page = 1}) async {
    final response = await dioClient.dio.get(
      '/movie/popular',
      queryParameters: {'page': page},
    );
    final List results = response.data['results'];
    return results.map((json) => MovieModel.fromJson(json)).toList();
  }

  Future<List<MovieModel>> searchMovies(String query) async {
    final response = await dioClient.dio.get(
      '/search/movie',
      queryParameters: {'query': query},
    );
    final List results = response.data['results'];
    return results.map((json) => MovieModel.fromJson(json)).toList();
  }

  Future<List<Genre>> getGenres() async {
    final response = await dioClient.dio.get('/genre/movie/list');
    final List genres = response.data['genres'];
    return genres
        .map((json) => Genre(id: json['id'], name: json['name']))
        .toList();
  }

  Future<List<MovieModel>> getMoviesByGenre(int genreId) async {
    final response = await dioClient.dio.get(
      '/discover/movie',
      queryParameters: {'with_genres': genreId},
    );
    final List results = response.data['results'];
    return results.map((json) => MovieModel.fromJson(json)).toList();
  }
}
