import 'package:dio/dio.dart';

class DioClient {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _apiKey = 'fdb757f2be0e9f840579c36755b25071';

  final Dio dio;

  DioClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: _baseUrl,
          queryParameters: {'api_key': _apiKey, 'language': 'fr-FR'},
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      ) {
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }
}
