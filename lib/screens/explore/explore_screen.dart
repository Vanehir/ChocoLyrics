import 'dart:developer';

import 'package:choco_lyrics/data/models/album.dart';
import 'package:choco_lyrics/data/models/artist.dart';
import 'package:choco_lyrics/data/repositories/spotify/spotify_repository.dart';
import 'package:choco_lyrics/screens/album/album_screen.dart';
import 'package:choco_lyrics/screens/artist/artist_screen.dart';
import 'package:choco_lyrics/screens/favorites/favorite_screen.dart';
import 'package:choco_lyrics/screens/lyrics/lyrics_screen.dart';
import 'package:choco_lyrics/themes/colors/colors.dart';
import 'package:choco_lyrics/ui/cards/item_card.dart';
import 'package:choco_lyrics/ui/favorites/favorite_handler.dart';
import 'package:choco_lyrics/ui/search/filter_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:choco_lyrics/ui/search/search_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:choco_lyrics/data/models/song.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FavoriteHandler _favoriteHandler = FavoriteHandler();
  List<dynamic> _items = [];
  bool _isLoading = false;
  String? _error;
  SpotifySearchType _activeFilter = SpotifySearchType.track;
  Set<String> _favoriteIds = {};

  @override
  void initState() {
    super.initState();
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
    refreshFavorites();
  }

  Future<void> _searchItems(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _items = [];
    });

    try {
      final spotifyRepository = SpotifyRepository();
      final results = await spotifyRepository.getItemFromSearch(
        query: query,
        queryParameter: _activeFilter,
      );

      log('Results received: ${results.length}');
      if (results.isNotEmpty) {
        log('First result type: ${results.first.runtimeType}');
      }

      setState(() {
        _items = results;
        _isLoading = false;
      });
    } catch (e) {
      log('Search error: $e');
      setState(() {
        _error = 'explore.errorMessage'.tr();
        _isLoading = false;
      });
    }
  }

  Widget _buildItemRow(dynamic item) {
    return ItemRow(
      item: item,
      onTap: () {
        if (item is Song) {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => LyricsScreen(song: item),
            ),
          );
        } else if (item is Album) {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => AlbumScreen(album: item),
            ),
          );
        } else if (item is Artist) {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => ArtistScreen(artist: item),
            ),
          );
        }
      },
      onAddPressed: item is Song ? () => _handleFavorite(item) : null,
      isFavorite: item is Song ? _favoriteIds.contains(item.id) : false,
    );
  }

  void _toggleFilter(SpotifySearchType filter) {
    setState(() {
      _activeFilter = filter;
    });
    if (_searchController.text.isNotEmpty) {
      _searchItems(_searchController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: beige,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: beige,
                boxShadow: [
                  BoxShadow(
                    color: darkBrown.withAlpha(38),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  CustomSearchBar(
                    controller: _searchController,
                    onSubmitted: (value) {
                      _searchItems(value);
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: FilterButton(
                          filterText: 'Track',
                          isActive: _activeFilter == SpotifySearchType.track,
                          onTap: () => _toggleFilter(SpotifySearchType.track),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilterButton(
                          filterText: 'Album',
                          isActive: _activeFilter == SpotifySearchType.album,
                          onTap: () => _toggleFilter(SpotifySearchType.album),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilterButton(
                          filterText: 'Artist',
                          isActive: _activeFilter == SpotifySearchType.artist,
                          onTap: () => _toggleFilter(SpotifySearchType.artist),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CupertinoActivityIndicator())
                  : _error != null
                      ? Center(
                          child: Text(
                            _error!,
                            style: const TextStyle(
                              color: darkBrown,
                              fontSize: 16,
                            ),
                          ),
                        )
                      : _items.isEmpty
                          ? Center(
                              child: Text(
                                _searchController.text.isEmpty
                                    ? 'explore.emptyState.initial'.tr()
                                    : 'explore.emptyState.noResults'.tr(),
                                style: const TextStyle(
                                  color: darkBrown,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                                bottom: 100,
                              ),
                              itemCount: _items.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: _buildItemRow(_items[index]),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
