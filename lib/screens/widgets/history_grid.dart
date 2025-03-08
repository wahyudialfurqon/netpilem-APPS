import 'package:Netpilem/models/movie.dart';
import 'package:Netpilem/screens/detail_screen.dart';
import 'package:flutter/material.dart';

class HistoryGrid extends StatelessWidget {
  final List<Movie> favoriteMovies;
  final Map<int, bool> favoriteStatus;
  final Function(int) onToggleFavorite;

  const HistoryGrid({
    Key? key,
    required this.favoriteMovies,
    required this.favoriteStatus,
    required this.onToggleFavorite,
  }) : super(key: key);

@override
  Widget build(BuildContext context) {
    return Expanded(
      child: favoriteMovies.isEmpty
          ? const Center(
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemCount: favoriteMovies.length,
              itemBuilder: (context, index) {
                final movie = favoriteMovies[index];
                return ClipRRect(
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreens(movie: movie),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0, right: 20, left: 20),
                      child: AspectRatio(
                        aspectRatio: 200 / 260,
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                                width: 200,
                                height: 260,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 30,
                              right: 0,
                              child: IconButton(
                                icon: Icon(
                                  favoriteStatus[movie.id] ?? true
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: const Color.fromARGB(255, 255, 17, 0),
                                  size: 30,
                                ),
                                onPressed: () => onToggleFavorite(movie.id),
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
    );
  }
}