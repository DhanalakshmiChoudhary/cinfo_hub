import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/movie.dart';
import '../services/serviceException.dart';
import '../utils/project_configurations.dart';

final movieServiceProvider = Provider<MovieService>((ref) {
  final config = ref.watch(projectConfigProvider);

  return MovieService(config, Dio());
});

class MovieService {
  MovieService(this._projectConfiguration, this._dio);

  final ProjectConfiguration _projectConfiguration;
  final Dio _dio;

  Future<List<Movie>> getMovies() async {
    try {
      final response = await _dio.get(
        "https://api.themoviedb.org/3/movie/now_playing?api_key=${_projectConfiguration.apiKey}&language=en-US&page=1",
      );

      final results = List<Map<String, dynamic>>.from(response.data['results']);

      List<Movie> movies = results
          .map((movieData) => Movie.fromMap(movieData))
          .toList(growable: false);
      return movies;
    } on DioError catch (dioError) {
      throw ServiceException.fromDioError(dioError);
    }
  }
}
