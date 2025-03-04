import 'package:flutter/material.dart';
import 'package:pilem/models/movie.dart';
import 'package:pilem/screens/detail_screen.dart';
import 'package:pilem/services/api_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomeScreen> {
  final ApiServices _apiServices =  ApiServices();
  List<Movie> _allMovies = [];
  List<Movie> _popularMovies = [];
  List<Movie> _trendingMovies = [];

  Future<void> _loadMovie() async {
    final List<Map<String, dynamic>> allMovieData = 
    await _apiServices.getAllMovie();
    final List<Map<String, dynamic>> popularMovieData = 
    await _apiServices.getPopularMovies();
     final List<Map<String, dynamic>> trendingMovieData = 
    await _apiServices.getTrendingMovies();

    setState((){
      _allMovies = allMovieData.map((e) => Movie.fromJson(e)).toList();
      _popularMovies = popularMovieData.map((e) => Movie.fromJson(e)).toList();
      _trendingMovies = trendingMovieData.map((e) => Movie.fromJson(e)).toList();
    });
  }
  @override
  void initState() {
    _loadMovie();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
      flexibleSpace: SizedBox.expand(
        child: Hero(
          tag: "LogoHero",
          child: Image.asset(
            "images/netpilem.png",
            height: 280,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Text("Gambar tidak ditemukan!", style: TextStyle(color: Colors.red));
            },
          ),
        ),
      ),
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: 280,
      backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.only(top: 20), 
              child: Text("All Movie",
              style: TextStyle(
                fontWeight:  FontWeight.bold,
                color: Colors.white,
              ))),
              SizedBox(
                height: 290,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _allMovies.length,
                  itemBuilder: (BuildContext context, int index){
                    final Movie movie = _allMovies[index];
                    return GestureDetector(
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DetailScreens(movie: movie)),
                        ),
          
                    child: Padding(padding: 
                    EdgeInsets.all(4),
                      child: Column(
                        children: [
                          Hero(
                            tag: "LogoHero",
                            child: Image.network('https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                            height: 260,
                            width: 210,
                            fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                    );
                  }
                ),
              ),
              const Padding(padding: EdgeInsets.all(2.0), 
              child: Text("Popular Movie",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ))),
              SizedBox(
                height: 290,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _popularMovies.length,
                  itemBuilder: (BuildContext context, int index){
                    final Movie movie = _popularMovies[index];
                     return GestureDetector(
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DetailScreens(movie: movie)),
                        ),
                    child: Padding(padding: 
                    EdgeInsets.all(4),
                      child: Column(
                        children: [
                           Hero(
                            tag: "LogoHero",
                             child: Image.network('https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                              height: 260,
                              width: 210,
                              fit: BoxFit.cover,
                              ),
                           ),
                        ],
                      ),
                    ),
                    );
                  }
                ),
              ),
              const Padding(padding: EdgeInsets.all(2.0), 
              child: Text("Trending Movie",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white,))),
              SizedBox(
               height: 290,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _trendingMovies.length,
                  itemBuilder: (BuildContext context, int index){
                    final Movie movie = _trendingMovies[index];
                     return GestureDetector(
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DetailScreens(movie: movie)),
                        ),
                    child: Padding(padding: 
                    EdgeInsets.all(4),
                      child: Column(
                        children: [
                           Hero(
                            tag: "LogoHero",
                             child: Image.network('https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                            height: 260,
                            width: 210, 
                            fit: BoxFit.cover,
                            ),
                           ),
                        ],
                      ),
                    ),
                    );
                  }
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}