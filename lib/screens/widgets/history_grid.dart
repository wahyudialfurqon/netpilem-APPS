import 'package:Netpilem/models/movie.dart';
import 'package:Netpilem/screens/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryGrid extends StatefulWidget {
  final List<Movie> historyMovies;
  final Map<int, bool> historyStatus;
  final Function(int) onToggleHistory;

  const HistoryGrid({
    Key? key,
    required this.historyMovies,
    required this.historyStatus,
    required this.onToggleHistory,
  }) : super(key: key);

  @override
  _HistoryGridState createState() => _HistoryGridState();
}

class _HistoryGridState extends State<HistoryGrid> {
  List<int> historyMovies = [];

  Future<void> _removeMovieFromHistory(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Ambil list history dari SharedPreferences
    List<String>? historyList = prefs.getStringList('history_movies');

    if (historyList != null) {
      historyList.remove(id.toString()); // Hapus film berdasarkan ID
      await prefs.setStringList(
        'history_movies',
        historyList,
      ); // Simpan kembali
    }

    setState(() {
      widget.historyMovies.removeWhere((movie) => movie.id == id);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      historyMovies =
          prefs.getStringList('history_movies')?.map(int.parse).toList() ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child:
          widget.historyMovies.isEmpty
              ? const Center(
                child: Text(
                  'No History Here!',
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
                itemCount: widget.historyMovies.length,
                itemBuilder: (context, index) {
                  final movie = widget.historyMovies[index];
                  if (!historyMovies.contains(movie.id)) return SizedBox();
                  return ClipRRect(
                    child: GestureDetector(
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreens(movie: movie),
                            ),
                          ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 0,
                          right: 20,
                          left: 20,
                        ),
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
                                    widget.historyStatus[movie.id] ?? false
                                        ? Icons.delete
                                        : Icons.delete_outline,
                                    color: const Color.fromARGB(
                                      255,
                                      255,
                                      17,
                                      0,
                                    ),
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    _removeMovieFromHistory(movie.id);
                                    widget.onToggleHistory(movie.id);
                                  },
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
