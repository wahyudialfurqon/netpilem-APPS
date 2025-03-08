import 'dart:async';
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

  static Future<void> clearAllSaves() async {
    _preferences = await SharedPreferences.getInstance();
    List<String>? movieList = _preferences?.getStringList('saved_movies');

    if (movieList != null) {
      for (var id in movieList) {
        await _preferences?.remove('save_$id');
      }
    }

    // Hapus daftar utama saved_movies
    await _preferences?.remove('saved_movies');
  }

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<void> setFavoriteStatus(int movieId, bool isFavorite) async {
    await _preferences?.setBool('favorite_$movieId', isFavorite);
    List<int> favoriteMovies = getAllFavoriteMovies();
    if (isFavorite) {
      if (!favoriteMovies.contains(movieId)) {
        favoriteMovies.add(movieId);
      }
    } else {
      favoriteMovies.remove(movieId);
    }

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

  // === DUPLIKASI LOGIC UNTUK SAVE ===
  static Future<void> setSaveStatus(int movieId, bool isSaved) async {
    await _preferences?.setBool('save_$movieId', isSaved);
    List<int> savedMovies = getAllSavedMovies();
    if (isSaved) {
      if (!savedMovies.contains(movieId)) {
        savedMovies.add(movieId);
      }
    } else {
      savedMovies.remove(movieId);
    }

    if (savedMovies.isEmpty) {
      await _preferences?.remove('saved_movies');
    } else {
      await _preferences?.setStringList(
        'saved_movies',
        savedMovies.map((id) => id.toString()).toList(),
      );
    }
  }

  static bool getSaveStatus(int movieId) {
    return _preferences?.getBool('save_$movieId') ?? false;
  }

  static List<int> getAllSavedMovies() {
    List<String>? movieList = _preferences?.getStringList('saved_movies');
    return movieList?.map(int.parse).toList() ?? [];
  }

  static Future<void> addToHistory(Movie movie) async {
    _preferences = await SharedPreferences.getInstance();
    List<String>? historyList =
        _preferences?.getStringList('history_movies') ?? [];

    // Tambahkan hanya jika belum ada di history
    if (!historyList.contains(movie.id.toString())) {
      historyList.add(movie.id.toString());
      await _preferences?.setStringList('history_movies', historyList);
      await _preferences?.setString('history_${movie.id}', movie.title);
    }
  }

  static List<int> getAllHistoryMovies() {
    List<String>? historyList = _preferences?.getStringList('history_movies');
    return historyList?.map(int.parse).toList() ?? [];
  }

  static Future<void> clearHistory() async {
    _preferences = await SharedPreferences.getInstance();
    List<String>? historyList = _preferences?.getStringList('history_movies');

    if (historyList != null) {
      for (var id in historyList) {
        await _preferences?.remove('history_$id');
      }
    }

    await _preferences?.remove('history_movies');
  }
}

class _DetailScreensState extends State<DetailScreens> {
  bool _isFavorite = false;
  bool _isSave = false;
  bool isOpened = true;
  Timer? _viewTimer;

  void initState() {
    super.initState();
    _loadFavoriteStatus();
    _loadSaveStatus();
     _viewTimer = Timer(Duration(seconds: 5), () {
      SharedPrefHelper.addToHistory(widget.movie);
    });
  }

  void _loadFavoriteStatus() async {
    await SharedPrefHelper.init();
    bool status = SharedPrefHelper.getFavoriteStatus(widget.movie.id);
    setState(() {
      _isFavorite = status;
    });
  }

  void _loadSaveStatus() async {
    await SharedPrefHelper.init();
    bool status = SharedPrefHelper.getSaveStatus(widget.movie.id);
    setState(() {
      _isSave = status;
    });
  }

  Future<void> _toggleFavorite() async {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    await SharedPrefHelper.setFavoriteStatus(widget.movie.id, _isFavorite);
  }

  Future<void> _toggleSave() async {
    setState(() {
      _isSave = !_isSave;
    });
    await SharedPrefHelper.setSaveStatus(widget.movie.id, _isSave);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadFavoriteStatus();
    _loadSaveStatus();
  }
  @override
  void dispose(){
    _viewTimer?.cancel();
    super.dispose();
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
      body: Stack(
        children: [
          Padding(
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
        ],
      ),
      floatingActionButton: Transform.translate(
        offset: Offset(0, -20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (isOpened) ...[
              FloatingActionButton(
                onPressed: _toggleFavorite, //
                backgroundColor: Colors.transparent, // Warna background FAB
                child: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color:
                      _isFavorite
                          ? const Color.fromARGB(
                            255,
                            255,
                            0,
                            0,
                          ) // Merah jika favorit
                          : const Color.fromARGB(
                            255,
                            255,
                            255,
                            255,
                          ), // Putih jika tidak
                  size: 25,
                ),
              ),
              const SizedBox(height: 10), // Spasi antar tombol
              FloatingActionButton(
                onPressed: _toggleSave, //
                backgroundColor: Colors.transparent, // Warna background FAB
                child: Icon(
                  _isSave ? Icons.bookmark : Icons.bookmark_border,
                  color:
                      _isSave
                          ? const Color.fromARGB(
                            255,
                            255,
                            0,
                            0,
                          ) // Merah jika favorit
                          : const Color.fromARGB(
                            255,
                            255,
                            255,
                            255,
                          ), // Putih jika tidak
                  size: 25,
                ),
              ),
              const SizedBox(height: 10),
            ],
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  isOpened = !isOpened;
                });
              },
              backgroundColor: Colors.transparent,
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                transitionBuilder:
                    (child, animation) =>
                        RotationTransition(turns: animation, child: child),
                child:
                    isOpened
                        ? Icon(
                          Icons.close,
                          key: ValueKey('close'),
                          color: const Color.fromARGB(255, 255, 17, 0),
                        )
                        : Icon(
                          Icons.menu,
                          key: ValueKey('menu'),
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
