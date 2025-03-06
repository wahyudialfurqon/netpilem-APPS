import 'dart:async';

import 'package:Netpilem/models/movie.dart';
import 'package:Netpilem/screens/detail_screen.dart';
import 'package:Netpilem/services/api_services.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiServices _apiServices = ApiServices();
  final TextEditingController _searchController = TextEditingController();
  List<Movie> _searchResults = [];
  Timer? _debounce;

  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController.addListener(_searchMovies);
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchMovies();
    });
  }

  void _searchMovies() async {
    if (_searchController.text.isEmpty) {
      setState(() {
        _searchResults.clear();
      });
      return;
    }

    final List<Map<String, dynamic>> _searchData = await _apiServices
        .searchMovies(_searchController.text);

    setState(() {
      _searchResults = _searchData.map((e) => Movie.fromJson(e)).toList();
    });
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
                "Search Movies",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 255, 17, 0),
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              toolbarHeight: 80,
              elevation: 0,
              scrolledUnderElevation: 0,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              cursorColor: Colors.white,
              controller: _searchController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search movies ...',
                hintStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.white, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.white),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search, color: const Color.fromARGB(255, 255, 17, 0)),
                  onPressed: _searchMovies,
                ),
              ),
            ),
          ),
          Expanded(
            child:
                _searchResults.isEmpty
                    ? const Center(
                      child: Text(
                        'No Movies Found!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    )
                    : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final movie = _searchResults[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            height: 220, // tinggi agar gambar tidak terpotong
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
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
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 150, // Perbesar lebar gambar
                                      height: 200, // Perbesar tinggi gambar
                                      decoration: BoxDecoration(
                                        image:
                                            movie.posterPath != null &&
                                                    movie.posterPath.isNotEmpty
                                                ? DecorationImage(
                                                  image: NetworkImage(
                                                    'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                                                  ),
                                                  fit:
                                                      BoxFit
                                                          .cover, // Gambar terisi penuh
                                                )
                                                : null,
                                      ),
                                      child:
                                          movie.posterPath == null ||
                                                  movie.posterPath.isEmpty
                                              ? const Icon(
                                                Icons.image_not_supported,
                                                size: 80,
                                              )
                                              : null,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ), // jarak antara gambar dan teks
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            movie.title,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            movie.releaseDate,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
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
        ],
      ),
    );
  }
}
