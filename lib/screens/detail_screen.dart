import 'dart:core';

import 'package:Netpilem/models/movie.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class DetailScreens extends StatefulWidget {
  final Movie movie;
  const DetailScreens({super.key, required this.movie});

  @override
  State<DetailScreens> createState() => _DetailScreensState();
}

class SharedPrefHelper {
  static SharedPreferences? _preferences;

  static Future<void> clearAllFavorites() async {
    _preferences = await SharedPreferences.getInstance();
    List<String>? movieList = _preferences?.getStringList('favorite_movies');

    if (movieList != null) {
      for (var id in movieList) {
        await _preferences?.remove('favorite_$id');
      }
    }

    // Hapus daftar utama favorite_movies
    await _preferences?.remove('favorite_movies');
  }

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<void> setFavoriteStatus(int movieId, bool isFavorite) async {
    await _preferences?.setBool('favorite_$movieId', isFavorite);
    // Simpan ulang daftar favorit ke SharedPreferences
    List<int> favoriteMovies = getAllFavoriteMovies();
    if (isFavorite) {
      if (!favoriteMovies.contains(movieId)) {
        favoriteMovies.add(movieId);
      }
    } else {
      favoriteMovies.remove(movieId);
    }

    // Jika tidak ada film favorit, hapus key-nya
    if (favoriteMovies.isEmpty) {
      await _preferences?.remove('favorite_movies');
    } else {
      await _preferences?.setStringList(
        'favorite_movies',
        favoriteMovies.map((id) => id.toString()).toList(),
      );
    }
  }

  static bool getFavoriteStatus(int movieId) {
    return _preferences?.getBool('favorite_$movieId') ?? false;
  }

  static List<int> getAllFavoriteMovies() {
    List<String>? movieList = _preferences?.getStringList('favorite_movies');
    return movieList?.map(int.parse).toList() ?? [];
  }
}

class _DetailScreensState extends State<DetailScreens> {
  bool _isFavorite = false;

  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  void _loadFavoriteStatus() async {
    await SharedPrefHelper.init();
    bool status = SharedPrefHelper.getFavoriteStatus(widget.movie.id);
    setState(() {
      _isFavorite = status;
    });
  }

  Future<void> _toggleFavorite() async {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    await SharedPrefHelper.setFavoriteStatus(widget.movie.id, _isFavorite);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadFavoriteStatus(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: -150,
              child: Image.asset(
                "images/particle.png",
                height: MediaQuery.of(context).size.height * 0.4,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
            ),

            AppBar(
              title: Text(
                widget.movie.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 255, 17, 0),
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              iconTheme: IconThemeData(color: Colors.white),
              toolbarHeight: 80,
              elevation: 0,
              scrolledUnderElevation: 0,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20),
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
                        color: const Color.fromARGB(255, 255, 17, 0),
                        size: 40,
                      ),
                      onPressed: _toggleFavorite,
                    ),
                  ),
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
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.date_range,
                              color: const Color.fromARGB(255, 255, 17, 0),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.movie.releaseDate,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        Text(
                          'Vote Average',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              widget.movie.voteAverage.toString(),
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.white),
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.movie.overview,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
