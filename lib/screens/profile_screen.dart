import 'package:Netpilem/models/movie.dart';
import 'package:Netpilem/screens/detail_screen.dart';
import 'package:Netpilem/screens/widgets/favorite_grid.dart';
import 'package:Netpilem/screens/widgets/history_grid.dart';
import 'package:Netpilem/screens/widgets/save_grid.dart';
import 'package:Netpilem/services/api_services.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Movie> favoriteMovies = [];
  List<Movie> saveMovies = [];
  List<Movie> historyMovies = [];
  Map<int, bool> historyStatus = {};
  final ApiServices apiServices = ApiServices();
  Map<int, bool> favoriteStatus = {};
  Map<int, bool> saveStatus = {};
  bool isFavoriteGrid = false;
  bool isSaveGrid = false;
  bool isHistoryGrid = false;
  bool _isFavorite = false;
  bool _isSave = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadFavoriteMovies();
    _loadSaveMovies();
    _loadHistoryMovies();
    isHistoryGrid = true;
  }

  Future<void> _toggleFavorite(int movieId) async {
    setState(() {
      favoriteStatus[movieId] = !(favoriteStatus[movieId] ?? false);
      if (!favoriteStatus[movieId]!) {
        favoriteMovies.removeWhere((movie) => movie.id == movieId);
      }
    });
    await SharedPrefHelper.setFavoriteStatus(movieId, favoriteStatus[movieId]!);
  }

  Future<void> _toggleSave(int movieId) async {
    setState(() {
      saveStatus[movieId] = !(saveStatus[movieId] ?? false);
      if (!saveStatus[movieId]!) {
        saveMovies.removeWhere((movie) => movie.id == movieId);
      }
    });
    await SharedPrefHelper.setSaveStatus(movieId, saveStatus[movieId]!);
  }

  Future<void> _loadFavoriteMovies() async {
    await SharedPrefHelper.init();
    List<int> favoriteIds = await SharedPrefHelper.getAllFavoriteMovies();
    if (favoriteIds.isEmpty) {
      setState(() {
        _isFavorite = false;
        favoriteMovies = [];
      });
      return;
    }
    List<Map<String, dynamic>> movieData =
        await apiServices.getAllMovie(); // Ambil semua film dari API
    List<Movie> movies =
        movieData
            .map((json) => Movie.fromJson(json))
            .toList(); // Ubah data API menjadi list Movie
    List<Movie> favoriteList =
        movies
            .where((movie) => favoriteIds.contains(movie.id))
            .toList(); // Filter hanya yang ada di daftar favorit

    setState(() {
      favoriteMovies = favoriteList;
    });
  }

  Future<void> _loadSaveMovies() async {
    await SharedPrefHelper.init();
    List<int> saveIds = await SharedPrefHelper.getAllSavedMovies();
    if (saveIds.isEmpty) {
      setState(() {
        _isSave = false;
        saveMovies = [];
      });
      return;
    }
    List<Map<String, dynamic>> movieData =
        await apiServices.getAllMovie(); // Ambil semua film dari API
    List<Movie> movies =
        movieData
            .map((json) => Movie.fromJson(json))
            .toList(); // Ubah data API menjadi list Movie
    List<Movie> saveList =
        movies
            .where((movie) => saveIds.contains(movie.id))
            .toList(); // Filter hanya yang ada di daftar favorit

    setState(() {
      saveMovies = saveList;
    });
  }

  Future<void> _loadHistoryMovies() async {
    await SharedPrefHelper.init();
    List<int> historyIds = await SharedPrefHelper.getAllHistoryMovies();
    if (historyIds.isEmpty) {
      setState(() {
        historyMovies = [];
      });
      return;
    }

    List<Map<String, dynamic>> movieData = await apiServices.getAllMovie();
    List<Movie> movies = movieData.map((json) => Movie.fromJson(json)).toList();

    List<Movie> historyList =
        movies.where((movie) => historyIds.contains(movie.id)).toList();

    setState(() {
      historyMovies = historyList;
    });
  }

  void _setActiveGrid(String gridType) {
    setState(() {
      isHistoryGrid = gridType == "history";
      isFavoriteGrid = gridType == "favorite";
      isSaveGrid = gridType == "save";
    });
  }

  Future<void> _clearAllMovies() async {
    if (isFavoriteGrid) {
      await SharedPrefHelper.clearAllFavorites();
      setState(() {
        _isFavorite = false;
        favoriteMovies.clear();
        favoriteStatus.clear();
      });
      await Future.delayed(Duration(milliseconds: 100));
      for (var key in favoriteStatus.keys) {
        await SharedPrefHelper.setFavoriteStatus(key, false);
      }
      _loadFavoriteMovies();
    } else if (isSaveGrid) {
      await SharedPrefHelper.clearAllSaves();
      setState(() {
        _isSave = false;
        saveMovies.clear();
        saveStatus.clear();
      });
      await Future.delayed(Duration(milliseconds: 100));
      for (var key in saveStatus.keys) {
        await SharedPrefHelper.setSaveStatus(key, false);
      }
      _loadSaveMovies();
    } else if (isHistoryGrid) {
      await SharedPrefHelper.clearHistory(); // Hapus semua history dari SharedPreferences
      setState(() {
        historyMovies.clear();
        historyStatus.clear();
      });
       await Future.delayed(Duration(milliseconds: 50));
       await _loadHistoryMovies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/banner.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 200 - 50),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              width: 2,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: const AssetImage(
                              'images/Wahyu.jpg',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'W444YOU',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Image.asset('images/verified.png', width: 17, height: 17),
                    SizedBox(width: 8),
                    Text(
                      'He/him',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 86, 86, 86),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          '1000',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        Text(
                          'View',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 86, 86, 86),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '1000',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Favorite',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 86, 86, 86),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '1000',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 86, 86, 86),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.history,
                        color:
                            isHistoryGrid
                                ? const Color.fromARGB(255, 255, 17, 0)
                                : Colors.white,
                      ),
                      onPressed: () => _setActiveGrid("history"),
                    ),
                    const SizedBox(width: 120),
                    IconButton(
                      icon: Icon(
                        Icons.favorite,
                        color:
                            isFavoriteGrid
                                ? const Color.fromARGB(255, 255, 17, 0)
                                : Colors.white,
                      ),
                      onPressed: () => _setActiveGrid("favorite"),
                    ),
                    const SizedBox(width: 120),
                    IconButton(
                      icon: Icon(
                        Icons.bookmark,
                        color:
                            isSaveGrid
                                ? const Color.fromARGB(255, 255, 17, 0)
                                : Colors.white,
                      ),
                      onPressed: () => _setActiveGrid("save"),
                    ),
                  ],
                ),
                Divider(
                  color: const Color.fromARGB(255, 90, 90, 90), // Warna garis
                  thickness: 2, // Ketebalan garis
                  indent: 20, // Jarak dari kiri
                  endIndent: 20, // Jarak dari kanan
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: _clearAllMovies,
                        child: Text(
                          'Clear All',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //
                const SizedBox(height: 10),
                if (isFavoriteGrid)
                  FavoriteGrid(
                    favoriteMovies: favoriteMovies,
                    favoriteStatus: favoriteStatus,
                    onToggleFavorite: _toggleFavorite,
                  )
                else if (isSaveGrid)
                  SaveGrid(
                    saveMovies: saveMovies,
                    saveStatus: saveStatus,
                    onToggleSave: _toggleSave,
                  )
                else if (isHistoryGrid)
                  HistoryGrid(
                    historyMovies: historyMovies,
                    historyStatus: historyStatus,
                    onToggleHistory: (id) {},
                  ),
                //hilang
                Padding(padding: EdgeInsets.only(top: 20)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
