import 'package:choco_lyrics/data/models/album.dart';
import 'package:choco_lyrics/data/models/artist.dart';
import 'package:choco_lyrics/data/repositories/spotify/spotify_repository.dart';
import 'package:choco_lyrics/screens/album/album_screen.dart';
import 'package:choco_lyrics/screens/artist/artist_screen.dart';
import 'package:choco_lyrics/screens/explore/explore_cubit.dart';
import 'package:choco_lyrics/screens/explore/explore_state.dart';
import 'package:choco_lyrics/screens/favorites/favorites_cubit.dart';
import 'package:choco_lyrics/screens/favorites/favorites_state.dart';
import 'package:choco_lyrics/screens/lyrics/lyrics_screen.dart';
import 'package:choco_lyrics/themes/colors/colors.dart';
import 'package:choco_lyrics/ui/cards/item_card.dart';
import 'package:choco_lyrics/ui/search/filter_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:choco_lyrics/ui/search/search_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:choco_lyrics/data/models/song.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<FavoritesCubit>().loadFavorites();
  }

  void _handleSearch(String query) {
    context.read<ExploreCubit>().searchItems(query);
  }

  void _handleFavorite(Song song) {
    context.read<FavoritesCubit>().toggleFavorite(song.id);
  }

  void _toggleFilter(SpotifySearchType filter) {
    context.read<ExploreCubit>().toggleFilter(filter);
    if (_searchController.text.isNotEmpty) {
      _handleSearch(_searchController.text);
    }
  }

  Widget _buildItemRow(dynamic item, Set<String> favoriteIds) {
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
      isFavorite: item is Song ? favoriteIds.contains(item.id) : false,
    );
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
                    onSubmitted: _handleSearch,
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<ExploreCubit, ExploreState>(
                    builder: (context, state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: FilterButton(
                              filterText: 'Track',
                              isActive:
                                  state.activeFilter == SpotifySearchType.track,
                              onTap: () =>
                                  _toggleFilter(SpotifySearchType.track),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FilterButton(
                              filterText: 'Album',
                              isActive:
                                  state.activeFilter == SpotifySearchType.album,
                              onTap: () =>
                                  _toggleFilter(SpotifySearchType.album),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FilterButton(
                              filterText: 'Artist',
                              isActive: state.activeFilter ==
                                  SpotifySearchType.artist,
                              onTap: () =>
                                  _toggleFilter(SpotifySearchType.artist),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<ExploreCubit, ExploreState>(
                builder: (context, state) {
                  return BlocBuilder<FavoritesCubit, FavoritesState>(
                    builder: (context, favoritesState) {
                      final favoriteIds = favoritesState is FavoritesLoaded
                          ? favoritesState.favoriteIds
                          : <String>{};

                      if (state is ExploreLoading) {
                        return const Center(
                            child: CupertinoActivityIndicator());
                      }

                      if (state is ExploreError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: const TextStyle(
                              color: darkBrown,
                              fontSize: 16,
                            ),
                          ),
                        );
                      }

                      if (state is ExploreLoaded) {
                        if (state.items.isEmpty) {
                          return Center(
                            child: Text(
                              _searchController.text.isEmpty
                                  ? 'explore.emptyState.initial'.tr()
                                  : 'explore.emptyState.noResults'.tr(),
                              style: const TextStyle(
                                color: darkBrown,
                                fontSize: 16,
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                            bottom: 100,
                          ),
                          itemCount: state.items.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: _buildItemRow(
                                state.items[index],
                                favoriteIds,
                              ),
                            );
                          },
                        );
                      }

                      return Center(
                        child: Text(
                          'explore.emptyState.initial'.tr(),
                          style: const TextStyle(
                            color: darkBrown,
                            fontSize: 16,
                          ),
                        ),
                      );
                    },
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
