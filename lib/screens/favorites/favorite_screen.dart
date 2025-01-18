import 'dart:async';
import 'package:choco_lyrics/data/models/song.dart';
import 'package:choco_lyrics/data/repositories/spotify/spotify_repository.dart';
import 'package:choco_lyrics/screens/lyrics/lyrics_screen.dart';
import 'package:choco_lyrics/themes/colors/colors.dart';
import 'package:choco_lyrics/ui/cards/song_row.dart';
import 'package:choco_lyrics/ui/favorites/favorite_handler.dart';
import 'package:flutter/cupertino.dart';

// Create a stream controller at the global level
final _favoriteRefreshController = StreamController<void>.broadcast();

// Function to trigger refresh from anywhere in the app
void refreshFavorites() {
  _favoriteRefreshController.add(null);
}

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final FavoriteHandler _favoriteHandler = FavoriteHandler();
  final SpotifyRepository _spotifyRepository = SpotifyRepository();
  List<Song> _favoriteSongs = [];
  bool _isLoading = true;
  StreamSubscription? _refreshSubscription;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    
    // Subscribe to refresh events
    _refreshSubscription = _favoriteRefreshController.stream.listen((_) {
      _loadFavorites();
    });
  }

  @override
  void dispose() {
    _refreshSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final favoriteIds = await _favoriteHandler.getFavorites();
      print('Loading favorites: $favoriteIds');
      
      if (favoriteIds.isNotEmpty) {
        final songs = await _spotifyRepository.getSongsById(songIds: favoriteIds);
        if (mounted) {
          setState(() {
            _favoriteSongs = songs;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _favoriteSongs = [];
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error loading favorites: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _removeFavorite(Song song) async {
    await _favoriteHandler.removeFavorite(song.id);
    await _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: beige,
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: beige,
        border: null
      ),
      child: SafeArea(
        child: _isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : _favoriteSongs.isEmpty
                ? const Center(
                    child: Text(
                      'No favorites yet',
                      style: TextStyle(
                        color: darkBrown,
                        fontSize: 16,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: _favoriteSongs.length,
                    itemBuilder: (context, index) {
                      final song = _favoriteSongs[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: SongRow(
                          song: song,
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => LyricsScreen(song: song),
                              ),
                            );
                          },
                          onAddPressed: () => _removeFavorite(song),
                          isFavorite: true,
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}