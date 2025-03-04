import 'dart:core';

import 'package:flutter/material.dart';
import 'package:pilem/models/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreens extends StatefulWidget {
    final Movie movie ;
  const DetailScreens({super.key, required this.movie});

  @override
  State<DetailScreens> createState() => _DetailScreensState();
}

class SharedPrefHelper {
  static SharedPreferences? _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<void> setFavoriteStatus(int movieId, bool isFavorite) async {
    await _preferences?.setBool('favorite_$movieId', isFavorite);
  }

  static bool getFavoriteStatus(int movieId) {
    return _preferences?.getBool('favorite_$movieId') ?? false;
  }

  static List<int> getAllFavoriteMovies(){
    final allKeys = _preferences?.getKeys() ?? {};
    List<int> favoriteMovies = [];
    for(String key in allKeys){
      if(key.startsWith('favorite_')){
        bool _isFavorite = _preferences?.getBool(key) ?? false;
        if(_isFavorite){
          int movieId = int.parse(key.split('_')[1]);
          favoriteMovies.add(movieId);

        }
      }
    }
    return favoriteMovies;
  }
}

class _DetailScreensState extends State<DetailScreens> {
  bool _isFavorite = false;

  void initState(){
    super.initState();
    _loadFavoriteStatus();
  }

   void _loadFavoriteStatus() {
    setState(() {
      _isFavorite = SharedPrefHelper.getFavoriteStatus(widget.movie.id);
    });
  }
  
   Future<void> _toggleFavorite() async {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    await SharedPrefHelper.setFavoriteStatus(widget.movie.id, _isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text(widget.movie.title,
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: Colors.red
      ),),
      centerTitle: true,
      backgroundColor: Colors.black,
      iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Padding(padding: EdgeInsets.only(top: 20),
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w500${widget.movie.backdropPath}',
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: IconButton(
                      icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                        size: 40,
                      ),
                      onPressed: _toggleFavorite,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
               Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Release Date',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.movie.releaseDate,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Column(
                        children: [
                          Text(
                            'Vote Average',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(
                                widget.movie.voteAverage.toString(),
                                style: 
                                Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                 const SizedBox(height: 16),
              Text(
                'Overview',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                widget.movie.overview,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)
              ),
            ],
          ),
        ),
      ),
    );
  }
}