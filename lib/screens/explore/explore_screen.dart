import 'package:choco_lyrics/data/models/album.dart';
import 'package:choco_lyrics/data/models/artist.dart';
import 'package:choco_lyrics/data/repositories/spotify/spotify_repository.dart';
import 'package:choco_lyrics/screens/lyrics/lyrics_screen.dart';
import 'package:choco_lyrics/themes/colors/colors.dart';
import 'package:choco_lyrics/ui/cards/album_row.dart';
import 'package:choco_lyrics/ui/cards/artist_row.dart';
import 'package:choco_lyrics/ui/search/filter_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:choco_lyrics/ui/search/search_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:choco_lyrics/data/models/song.dart';
import 'package:choco_lyrics/ui/cards/song_row.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _items = [];
  bool _isLoading = false;
  String _activeFilter = 'track';

  Future<void> _searchItems(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final spotifyRepository = SpotifyRepository();
      final results = await spotifyRepository.getItemFromSearch(
        query: query,
        queryParameter: _activeFilter,
      );
      setState(() {
        _items = results;
      });
    } catch (e) {
      print('Search error: $e');
      // You might want to show an error message to the user here
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildItemRow(dynamic item) {
    if (item is Song) {
      return SongRow(
        song: item,
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => LyricsScreen(song: item),
            ),
          );
        },
        onAddPressed: () {
          //TODO: implement add to favorites
        },
      );
    } else if (item is Album) {
      return AlbumRow(
        album: item,
        onTap: () {
          // TODO: Navigate to album details screen
          print('Album tapped: ${item.name}');
        },
        onAddPressed: () {
          // TODO: implement add to favorites
          print('Add album to favorites: ${item.name}');
        },
      );
    } else if (item is Artist) {
      return ArtistRow(
        artist: item,
        onTap: () {
          // TODO: Navigate to artist details screen
          print('Artist tapped: ${item.name}');
        },
        onAddPressed: () {
          // TODO: implement add to favorites
          print('Add artist to favorites: ${item.name}');
        },
      );
    }
    return const SizedBox.shrink();
  }

  void _toggleFilter(String filter) {
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
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: beige,
                boxShadow: [
                  BoxShadow(
                    color: darkBrown.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Text(
                    tr('explore.title'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: darkBrown,
                      fontSize: 35,
                      fontFamily: 'Calibri',
                      fontWeight: FontWeight.w700,
                      height: 0.46,
                      letterSpacing: 0.50,
                    ),
                  ),
                  const SizedBox(height: 20),
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
                          isActive: _activeFilter == 'track',
                          onTap: () => _toggleFilter('track'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilterButton(
                          filterText: 'Album',
                          isActive: _activeFilter == 'album',
                          onTap: () => _toggleFilter('album'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilterButton(
                          filterText: 'Artist',
                          isActive: _activeFilter == 'artist',
                          onTap: () => _toggleFilter('artist'),
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
                  : _items.isEmpty
                      ? Center(
                          child: Text(
                            _searchController.text.isEmpty
                                ? tr('explore.search_prompt')
                                : tr('explore.no_results'),
                            style: const TextStyle(
                              color: darkBrown,
                              fontSize: 16,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: _items
                                .map((item) => Padding(
                                      padding:
                                          const EdgeInsets.only(top: 10.0),
                                      child: _buildItemRow(item),
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
