import 'package:rotten_tomatoes/core/network/dio_client.dart';
import 'package:rotten_tomatoes/features/movies/data/models/movie_model.dart';

class MovieRemoteDataSource {
  final DioClient dioClient;

  MovieRemoteDataSource(this.dioClient);

  Future<List<MovieModel>> getPopularMovies() async {
    //on appelle l'endpoint de TMDB pour les films populaires
    // TMDB nous renvoie un JSON avec une clé "results" qui contient la liste des films
    // Dio ajoute automatiquement l'URL de base + l'apiKey, donc on met juste le chemin de l'endpoint
    final response = await dioClient.dio.get('/movie/popular');

    final List results = response.data['results'];
    //on transforme chaque résultat JSON en MovieModel
    return results.map((json) => MovieModel.fromJson(json)).toList();
  }
}
