import 'package:flutter/material.dart';
import 'package:pilem/models/movie.dart';
import 'package:pilem/screens/detail_screen.dart';
import 'package:pilem/services/api_services.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Movie> favoriteMovies = [];
   final ApiServices apiServices = ApiServices();
   Map<int, bool> favoriteStatus = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadFavoriteMovies();
  }


  Future<void> _toggleFavorite(int movieId) async {
    setState(() {
      favoriteStatus[movieId] = !(favoriteStatus[movieId] ?? false);
      if(!favoriteStatus[movieId]!){
        favoriteMovies.removeWhere((movie)=> movie.id == movieId);
      }
    });
    await SharedPrefHelper.setFavoriteStatus(movieId, favoriteStatus[movieId]!);
  }
  Future<void> _loadFavoriteMovies() async {
    List<int> favoriteIds = await SharedPrefHelper.getAllFavoriteMovies();
    List<Map<String, dynamic>> movieData = await apiServices.getAllMovie();  // Ambil semua film dari API
    List<Movie> movies = movieData.map((json) => Movie.fromJson(json)).toList(); // Ubah data API menjadi list Movie
    List<Movie> favoriteList = movies.where((movie) => favoriteIds.contains(movie.id)).toList();  // Filter hanya yang ada di daftar favorit
    
    setState((){
      favoriteMovies = favoriteList;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
        appBar: AppBar(title: Text("Favorite Movies",
        style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.red
      ),),
      centerTitle: true,
      backgroundColor: Colors.black,
      toolbarHeight: 80,
      elevation: 0,
      scrolledUnderElevation: 0,
      ),
      body: favoriteMovies.isEmpty ? Center(
          child: Text(
            'No Favorite Here!',
            style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white
            ),
          )
        ) : GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.7,
          ),
          itemCount: favoriteMovies.length,
          itemBuilder: (context, index){
            final movie = favoriteMovies[index];
            return ClipRRect(
              child: GestureDetector(
                onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetailScreens(movie: movie)),
                ),
                child: Stack(
                  children: [
                    Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                      height: 260,
                      width: 210,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                    bottom: 40,
                    right: 10,
                    child: IconButton(
                      icon: Icon(
                        favoriteStatus[movie.id] ?? true ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                        size: 30,
                      ),
                      onPressed: () => _toggleFavorite(movie.id),
                    ),
                  )
                  ],
                ),
              ),
            );
          }
        )
    );
  }
}