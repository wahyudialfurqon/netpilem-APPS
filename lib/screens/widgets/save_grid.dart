import 'package:Netpilem/models/movie.dart';
import 'package:Netpilem/screens/detail_screen.dart';
import 'package:flutter/material.dart';

class SaveGrid extends StatelessWidget {
  final List<Movie> saveMovies;
  final Map<int, bool> saveStatus;
  final Function(int) onToggleSave;

   const SaveGrid({
    Key? key,
    required this.saveMovies,
    required this.saveStatus,
    required this.onToggleSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: saveMovies.isEmpty
          ? const Center(
              child: Text(
                'No Save Here!',
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
              itemCount: saveMovies.length,
              itemBuilder: (context, index) {
                final movie = saveMovies[index];
                return ClipRRect(
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreens(movie: movie),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
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
                              bottom: 15,
                              right: 0,
                              child: IconButton(
                                icon: Icon(
                                  saveStatus[movie.id] ?? true
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  color: Colors.red,
                                  size: 30,
                                ),
                                onPressed: () => onToggleSave(movie.id),
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