import 'dart:convert';

class Movie {
  String movieTitle;
  String movieThumbnail;
  Movie({
    required this.movieTitle,
    required this.movieThumbnail,
  });

  String get fullImageUrl => 'https://image.tmdb.org/t/p/w200$movieThumbnail';

  Map<String, dynamic> toMap() {
    return {
      'title': movieTitle,
      'poster_path': movieThumbnail,
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      movieTitle: map['title'] ?? '',
      movieThumbnail: map['poster_path'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Movie.fromJson(String source) => Movie.fromMap(json.decode(source));
}
