import 'package:flutter/foundation.dart';

class Movie{
  final int id;
  final String title, overview, posterPath,backdropPath, releaseDate;
  final double voteAverage;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.backdropPath,
  
  });

  factory Movie.fromJson(Map<String,dynamic>json){
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unknow Title',
      overview: json['overview'] ?? 'No Overview available',
      posterPath: json['poster_path'] ?? ' ',
      backdropPath: json['backdrop_path'] ?? ' ',
      releaseDate: json['release_date'] ?? ' ',
      voteAverage: json['vote_average'] ?? 0.toDouble(),
    );
  }
}