import 'package:choco_lyrics/data/models/song.dart';
import 'package:choco_lyrics/data/repositories/spotify/spotify_repository.dart';
import 'package:choco_lyrics/screens/favorites/favorites_cubit.dart';
import 'package:choco_lyrics/screens/favorites/favorites_state.dart';
import 'package:choco_lyrics/screens/lyrics/lyrics_screen.dart';
import 'package:choco_lyrics/themes/colors/colors.dart';
import 'package:choco_lyrics/ui/cards/item_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: beige,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                tr('favorites.title'),
                style: const TextStyle(
                  color: darkBrown,
                  fontSize: 24,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<FavoritesCubit, FavoritesState>(
                builder: (context, state) {
                  if (state is FavoritesInitial) {
                    context.read<FavoritesCubit>().loadFavorites();
                    return const Center(child: CupertinoActivityIndicator());
                  }

                  if (state is! FavoritesLoaded) {
                    return const Center(child: CupertinoActivityIndicator());
                  }

                  return FutureBuilder<List<Song>>(
                    future: SpotifyRepository().getSongsById(
                      songIds: state.favoriteIds.toList(),
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CupertinoActivityIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }

                      final songs = snapshot.data ?? [];
                      if (songs.isEmpty) {
                        return Center(
                          child: Text('favorites.noSongs'.tr()),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          bottom: 100, // Per non nascondersi sotto la navbar
                        ),
                        itemCount: songs.length,
                        itemBuilder: (context, index) {
                          final song = songs[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ItemRow(
                              item: song,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => LyricsScreen(song: song),
                                  ),
                                );
                              },
                              onAddPressed: () {
                                context.read<FavoritesCubit>().toggleFavorite(song.id);
                              },
                              isFavorite: true,
                            ),
                          );
                        },
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