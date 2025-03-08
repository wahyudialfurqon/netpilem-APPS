import 'package:Netpilem/models/movie.dart';
import 'package:Netpilem/screens/detail_screen.dart';
import 'package:Netpilem/services/api_services.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
      if (!favoriteStatus[movieId]!) {
        favoriteMovies.removeWhere((movie) => movie.id == movieId);
      }
    });
    await SharedPrefHelper.setFavoriteStatus(movieId, favoriteStatus[movieId]!);
  }

  Future<void> _loadFavoriteMovies() async {
    List<int> favoriteIds = await SharedPrefHelper.getAllFavoriteMovies();
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
                    Icon(
                      Icons.history, // Nama ikon
                      color: Colors.white, // Warna ikon
                      size: 20, // Ukuran ikon
                    ),
                    const SizedBox(width: 120),
                    Icon(
                      Icons.favorite, // Nama ikon
                      color: Colors.white, // Warna ikon
                      size: 20, // Ukuran ikon
                    ),
                    const SizedBox(width: 120),
                    Icon(
                      Icons.bookmark, // Nama ikon
                      color: Colors.white, // Warna ikon
                      size: 20, // Ukuran ikon
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
                      Text(
                        'Clear All',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                //
                //Disini
                //
                SizedBox(height: 10),
                Expanded(
                  child:
                      favoriteMovies.isEmpty
                          ? Center(
                            child: Text(
                              'No Favorite Here!',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          )
                          : GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.8,
                                ),
                            itemCount: favoriteMovies.length,
                            itemBuilder: (context, index) {
                              final movie = favoriteMovies[index];
                              return ClipRRect(
                                child: GestureDetector(
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
                                    padding: const EdgeInsets.only(top: 0, right:  20, left: 20),
                                    child: AspectRatio(
                                      aspectRatio: 200 / 260, 
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            child: Image.network(
                                              'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                                              width: 200,
                                              height: 260,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 35, 
                                            right: 0,
                                            child: IconButton(
                                              icon: Icon(
                                                favoriteStatus[movie.id] ?? true
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: Colors.red,
                                                size: 30,
                                              ),
                                              onPressed:
                                                  () => _toggleFavorite(movie.id),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
