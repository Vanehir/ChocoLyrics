import 'package:choco_lyrics/data/repositories/spotify/spotify_repository.dart';
import 'package:choco_lyrics/screens/lyrics/lyrics_screen.dart';
import 'package:choco_lyrics/themes/colors/colors.dart';
import 'package:choco_lyrics/ui/search/filter_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:choco_lyrics/ui/search/search_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:choco_lyrics/data/models/song.dart';
import 'package:choco_lyrics/ui/components/song_row.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Song> _songs = [];
  bool _isLoading = false;

  Future<void> _searchSongs(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final spotifyRepository = SpotifyRepository();
      final results = await spotifyRepository.getItemFromSearch(
        query: query,
        queryParameter: 'track',
      );
      setState(() {
        _songs = results.cast<Song>();
      });
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: beige,
      child: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Explore Title
              Text(
                tr('explore.title'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: darkBrown,
                  fontSize: 35,
                  fontFamily: 'Calibri',
                  fontWeight: FontWeight.w700,
                  height: 0.46,
                  letterSpacing: 0.50,
                ),
              ),
              const SizedBox(height: 20),

              // Search Bar
              CustomSearchBar(
                controller: _searchController,
                onSubmitted: (value) {
                  _searchSongs(value);
                },
              ),
              const SizedBox(height: 20),

              // Filter Grid
              GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  FilterButton(filterText: 'Track'),
                  FilterButton(filterText: 'Album'),
                  FilterButton(filterText: 'Artist')
                ],
              ),

              const SizedBox(height: 20),

              // Song List
              Expanded(
                child: _isLoading
                    ? Center(child: CupertinoActivityIndicator())
                    : SingleChildScrollView(
                        child: Column(
                          children: _songs
                              .map((song) => Padding(
                                    padding: const EdgeInsets.only(bottom: 10.0),
                                    child: SongRow(
                                      song: song,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                LyricsScreen(song: song),
                                          ),
                                        );
                                      },
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
