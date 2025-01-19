import 'package:choco_lyrics/screens/album/album_cubit.dart';
import 'package:choco_lyrics/screens/album/album_state';
import 'package:choco_lyrics/screens/favorites/favorites_cubit.dart';
import 'package:choco_lyrics/screens/favorites/favorites_state.dart';
import 'package:choco_lyrics/ui/cards/item_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:choco_lyrics/screens/favorites/favorite_screen.dart';
import 'package:choco_lyrics/themes/colors/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:choco_lyrics/data/models/album.dart';
import 'package:choco_lyrics/data/models/song.dart';
import 'package:choco_lyrics/data/repositories/spotify/spotify_repository.dart';
import 'package:choco_lyrics/screens/lyrics/lyrics_screen.dart';
import 'package:choco_lyrics/ui/favorites/favorite_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlbumScreen extends StatelessWidget {
  final Album album;

  const AlbumScreen({
    super.key,
    required this.album,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AlbumCubit(
            spotifyRepository: SpotifyRepository(),
            album: album,
          )..loadSongs(),
        ),
      ],
      child: AlbumView(album: album),
    );
  }
}

class AlbumView extends StatelessWidget {
  final Album album;

  const AlbumView({
    super.key,
    required this.album,
  });

  void _handleFavorite(BuildContext context, Song song) {
    context.read<FavoritesCubit>().toggleFavorite(song.id);
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
          child: Icon(
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
                      image: NetworkImage(album.coverUrl),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: darkBrown.withAlpha(51),
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
                      album.name,
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
                      album.artists.map((artist) => artist.name).join(', '),
                      style: const TextStyle(
                        color: darkBrown,
                        fontSize: 16,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    const SizedBox(height: 4),

                    BlocBuilder<AlbumCubit, AlbumState>(
                      builder: (context, state) {
                        return BlocBuilder<FavoritesCubit, FavoritesState>(
                          builder: (context, favoriteState) {
                            final favoriteIds = favoriteState is FavoritesLoaded
                                ? favoriteState.favoriteIds
                                : <String>{};

                            if (state is AlbumLoading) {
                              return const Center(
                                  child: CupertinoActivityIndicator());
                            }

                            if (state is AlbumError) {
                              return Center(
                                child: Text(
                                  state.message,
                                  style: TextStyle(
                                    color: darkBrown.withAlpha(179),
                                    fontSize: 14,
                                    fontFamily: 'Roboto',
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              );
                            }

                            if (state is AlbumLoaded) {
                              final songs = state.songs;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tr('album.totTracks', namedArgs: {
                                      'totalTracks':
                                          album.totalTracks.toString(),
                                      'foundSongs': songs.length.toString()
                                    }),
                                    style: TextStyle(
                                      color: darkBrown.withAlpha(179),
                                      fontSize: 14,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  if (songs.isEmpty)
                                    Center(
                                      child: Text(
                                        tr('album.noSongsFound'),
                                        style: TextStyle(
                                          color: darkBrown.withAlpha(179),
                                          fontSize: 14,
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    )
                                  else
                                    ...songs
                                        .where((song) => song != null)
                                        .map((song) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: ItemRow(
                                          item: song,
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
                                            _handleFavorite(context, song);
                                          },
                                          isFavorite: favoriteIds
                                              .contains((song as Song).id),
                                        ),
                                      );
                                    }),
                                ],
                              );
                            }

                            return const SizedBox.shrink();
                          },
                        );
                      },
                    ),
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
