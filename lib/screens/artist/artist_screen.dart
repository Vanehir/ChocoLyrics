import 'package:choco_lyrics/screens/favorites/favorite_screen.dart';
import 'package:choco_lyrics/themes/colors/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:choco_lyrics/data/models/artist.dart';
import 'package:choco_lyrics/data/models/song.dart';
import 'package:choco_lyrics/data/repositories/spotify/spotify_repository.dart';
import 'package:choco_lyrics/screens/lyrics/lyrics_screen.dart';
import 'package:choco_lyrics/ui/cards/song_row.dart';
import 'package:choco_lyrics/ui/favorites/favorite_handler.dart';

class ArtistScreen extends StatefulWidget {
  final Artist artist;

  const ArtistScreen({
    super.key,
    required this.artist,
  });

  @override
  State<ArtistScreen> createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  List<Song> _topSongs = [];
  bool _isLoading = true;
  static const int maxSongs = 20;
  final FavoriteHandler _favoriteHandler = FavoriteHandler();
  Set<String> _favoriteIds = {};

  @override
  void initState() {
    super.initState();
    _loadTopSongs();
    _loadFavoriteIds();
  }

  Future<void> _loadFavoriteIds() async {
    final favorites = await _favoriteHandler.getFavorites();
    setState(() {
      _favoriteIds = favorites.toSet();
    });
  }

  Future<void> _handleFavorite(Song song) async {
    final favorites = await _favoriteHandler.getFavorites();
    if (favorites.contains(song.id)) {
      await _favoriteHandler.removeFavorite(song.id);
      setState(() {
        _favoriteIds.remove(song.id);
      });
    } else {
      await _favoriteHandler.addFavorite(song.id);
      setState(() {
        _favoriteIds.add(song.id);
      });
    }
    refreshFavorites(); // Trigger refresh of favorites
  }

  Future<void> _loadTopSongs() async {
    try {
      final spotifyRepository = SpotifyRepository();
      final results = await spotifyRepository.getItemFromSearch(
        query: widget.artist.name,
        queryParameter: SpotifySearchType.track,
      );

      // Filter songs by matching the artist
      final artistSongs = results
          .whereType<Song>()
          .where((song) => song.artists.any((artist) =>
              artist.name.toLowerCase() == widget.artist.name.toLowerCase()))
          .take(maxSongs)
          .toList();

      setState(() {
        _topSongs = artistSongs;
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
              // Artist Image
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.artist.imageUrl),
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
                    // Artist Name
                    Text(
                      widget.artist.name,
                      style: const TextStyle(
                        color: darkBrown,
                        fontSize: 24,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Genres
                    if (widget.artist.genres.isNotEmpty)
                      Text(
                        widget.artist.genres.join(', '),
                        style: const TextStyle(
                          color: darkBrown,
                          fontSize: 16,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    const SizedBox(height: 20),

                    // Section Title
                    Text(
                      "Top 20 ${widget.artist.name} songs",
                      style: TextStyle(
                        color: darkBrown,
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Songs List
                    if (_isLoading)
                      const Center(child: CupertinoActivityIndicator())
                    else if (_topSongs.isEmpty)
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
                      ..._topSongs.asMap().entries.map((entry) {
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
                                  onAddPressed: () => _handleFavorite(song),
                                  isFavorite: _favoriteIds.contains(song.id),
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