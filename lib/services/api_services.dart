import 'dart:convert';

import 'package:http/http.dart' as http;
class ApiServices {
  static const String baseUrl = "http://api.themoviedb.org/3";
  static const String apiKey = "111da528829520d7b18c4dff07682941";

   Future<List<Map<String, dynamic>>> getAllMovie() async {
    return _fetchMovies("$baseUrl/movie/popular?api_key=$apiKey&language=en-US");
  }

  Future<List<Map<String, dynamic>>> getTrendingMovies() async {
    return _fetchMovies("$baseUrl/trending/movie/week?api_key=$apiKey&language=en-US");
  }

  Future<List<Map<String, dynamic>>> getPopularMovies() async {
    return _fetchMovies("$baseUrl/movie/popular?api_key=$apiKey&language=en-US");
  }

  Future<List<Map<String, dynamic>>> searchMovies(String query) async {
    return _fetchMovies("$baseUrl/search/movie?query=$query&api_key=$apiKey&language=en-US");
  }

  Future<List<Map<String, dynamic>>> _fetchMovies(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data["results"]);
      } else {
        throw Exception("Failed to load movies: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching movies: $e");
      return [];
    }
  }
}