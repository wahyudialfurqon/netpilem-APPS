import 'dart:async';

import 'package:Netpilem/models/movie.dart';
import 'package:Netpilem/screens/detail_screen.dart';
import 'package:Netpilem/services/api_services.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomeScreen> {
  final ApiServices _apiServices = ApiServices();
  List<Movie> _allMovies = [];
  List<Movie> _popularMovies = [];
  List<Movie> _trendingMovies = [];
  List<String> imageList = ['images/1.png', 'images/2.png', 'images/3.png'];
  int _currentIndex = 0;
  late PageController _pageController;
  late Timer _timer;

  Future<void> _loadMovie() async {
    final List<Map<String, dynamic>> allMovieData =
        await _apiServices.getAllMovie();
    final List<Map<String, dynamic>> popularMovieData =
        await _apiServices.getPopularMovies();
    final List<Map<String, dynamic>> trendingMovieData =
        await _apiServices.getTrendingMovies();

    setState(() {
      _allMovies = allMovieData.map((e) => Movie.fromJson(e)).toList();
      _popularMovies = popularMovieData.map((e) => Movie.fromJson(e)).toList();
      _trendingMovies =
          trendingMovieData.map((e) => Movie.fromJson(e)).toList();
    });
  }

  @override
  void initState() {
    _loadMovie();
    super.initState();

    _pageController = PageController(initialPage: _currentIndex);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    //Timer delay
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentIndex < imageList.length - 1) {
        _currentIndex++;
      } else {
        _pageController.jumpToPage(0);
        _currentIndex = 0;
      }
      _pageController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
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
                  Positioned(
                    top: -50,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Image.asset(
                        'images/netLogo.png',
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 130),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "MOVIE",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "|",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                              SizedBox(width: 20),
                              Text(
                                "HOROR",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "COMEDY",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "SAD",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "A - Z",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "Cooming Soon",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        //
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: SizedBox(
                            height: 200, // Sesuaikan ukuran
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: imageList.length,
                              itemBuilder: (context, index) {
                                return Image.asset(
                                  imageList[index % imageList.length],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.error,
                                      size: 50,
                                      color: Colors.red,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),

                        const Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            "All Movie",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 250,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _allMovies.length,
                            itemBuilder: (BuildContext context, int index) {
                              final Movie movie = _allMovies[index];
                              return GestureDetector(
                                onTap:
                                    () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                DetailScreens(movie: movie),
                                      ),
                                    ),

                                child: Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Column(
                                    children: [
                                      Hero(
                                        tag: "LogoHero",
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: Image.network(
                                            'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                                            height: 240,
                                            width: 190,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Text(
                            "Popular Movie",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 250,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _popularMovies.length,
                            itemBuilder: (BuildContext context, int index) {
                              final Movie movie = _popularMovies[index];
                              return GestureDetector(
                                onTap:
                                    () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                DetailScreens(movie: movie),
                                      ),
                                    ),
                                child: Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Column(
                                    children: [
                                      Hero(
                                        tag: "LogoHero",
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: Image.network(
                                            'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                                            height: 240,
                                            width: 190,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Text(
                            "Trending Movie",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 250,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _trendingMovies.length,
                            itemBuilder: (BuildContext context, int index) {
                              final Movie movie = _trendingMovies[index];
                              return GestureDetector(
                                onTap:
                                    () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                DetailScreens(movie: movie),
                                      ),
                                    ),
                                child: Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Column(
                                    children: [
                                      Hero(
                                        tag: "LogoHero",
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: Image.network(
                                            'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                                            height: 240,
                                            width: 190,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
