import 'package:choco_lyrics/themes/colors/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:choco_lyrics/data/models/album.dart';
import 'package:choco_lyrics/data/models/song.dart';
import 'package:choco_lyrics/data/repositories/spotify/spotify_repository.dart';
import 'package:choco_lyrics/screens/lyrics/lyrics_screen.dart';
import 'package:choco_lyrics/ui/cards/song_row.dart';

class AlbumScreen extends StatefulWidget {
  final Album album;

  const AlbumScreen({
    super.key,
    required this.album,
  });

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  List<Song> _songs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
  try {
    final spotifyRepository = SpotifyRepository();
    final searchQuery = '${widget.album.artists.first.name} ${widget.album.name}';
    final results = await spotifyRepository.getItemFromSearch(
      query: searchQuery,
      queryParameter: SpotifySearchType.track,
    );

    // Filter songs by matching the album name and artist
    final albumSongs = results
        .whereType<Song>()
        .where((song) => song.album.name.toLowerCase() == widget.album.name.toLowerCase())
        .toList();

    setState(() {
      _songs = albumSongs;
      _isLoading = false;
    });
  } catch (e) {
    print('Error loading songs: $e');
    setState(() {
      _isLoading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: beige,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: beige,
        border: null,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            CupertinoIcons.back,
            color: darkBrown,
          ),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Album Cover
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.album.coverUrl),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: darkBrown.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Album Title
                    Text(
                      widget.album.name,
                      style: const TextStyle(
                        color: darkBrown,
                        fontSize: 24,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Artists
                    Text(
                      widget.album.artists
                          .map((artist) => artist.name)
                          .join(', '),
                      style: const TextStyle(
                        color: darkBrown,
                        fontSize: 16,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Total Tracks
                    Text(
                      '${widget.album.totalTracks} tracks • ${_songs.length} found',
                      style: TextStyle(
                        color: darkBrown.withOpacity(0.7),
                        fontSize: 14,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Songs List
                    if (_isLoading)
                      const Center(child: CupertinoActivityIndicator())
                    else if (_songs.isEmpty)
                      Center(
                        child: Text(
                          'No songs found',
                          style: TextStyle(
                            color: darkBrown.withOpacity(0.7),
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      )
                    else
                      ..._songs.asMap().entries.map((entry) {
                        final song = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            children: [
                              // Song Row
                              Expanded(
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
                                  onAddPressed: () {
                                    // TODO: implement add to favorites
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
