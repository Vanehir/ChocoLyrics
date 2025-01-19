import 'package:choco_lyrics/screens/artist/artist_cubit.dart';
import 'package:choco_lyrics/screens/artist/artist_state.dart';
import 'package:choco_lyrics/screens/favorites/favorites_cubit.dart';
import 'package:choco_lyrics/screens/favorites/favorites_state.dart';
import 'package:choco_lyrics/themes/colors/colors.dart';
import 'package:choco_lyrics/ui/cards/item_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:choco_lyrics/data/models/artist.dart';
import 'package:choco_lyrics/data/models/song.dart';
import 'package:choco_lyrics/data/repositories/spotify/spotify_repository.dart';
import 'package:choco_lyrics/screens/lyrics/lyrics_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArtistScreen extends StatelessWidget {
  final Artist artist;

  const ArtistScreen({
    super.key,
    required this.artist,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ArtistCubit(
            spotifyRepository: SpotifyRepository(),
            artist: artist,
          )..loadTopSongs(),
        ),
      ],
      child: ArtistView(artist: artist),
    );
  }
}

class ArtistView extends StatelessWidget {
  final Artist artist;

  const ArtistView({
    super.key,
    required this.artist,
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
                      image: NetworkImage(artist.imageUrl),
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
                    // Artist Name
                    Text(
                      artist.name,
                      style: const TextStyle(
                        color: darkBrown,
                        fontSize: 24,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Genres
                    if (artist.genres.isNotEmpty)
                      Text(
                        artist.genres.join(', '),
                        style: const TextStyle(
                          color: darkBrown,
                          fontSize: 16,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    const SizedBox(height: 20),

                    BlocBuilder<ArtistCubit, ArtistState>(
                      builder: (context, state) {
                        return BlocBuilder<FavoritesCubit, FavoritesState>(
                          builder: (context, favoriteState) {
                            final favoriteIds = favoriteState is FavoritesLoaded 
                                ? favoriteState.favoriteIds 
                                : <String>{};

                            if (state is ArtistLoading) {
                              return const Center(child: CupertinoActivityIndicator());
                            }

                            if (state is ArtistError) {
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

                            if (state is ArtistLoaded) {
                              final songs = state.topSongs;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Section Title
                                  Text(
                                    "artist.topSongs".tr(
                                      namedArgs: {
                                        'maxSongs': songs.length.toString(),
                                        'artistName': artist.name,
                                      },
                                    ),
                                    style: const TextStyle(
                                      color: darkBrown,
                                      fontSize: 20,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  if (songs.isEmpty)
                                    Center(
                                      child: Text(
                                        'artist.noSongs'.tr(),
                                        style: TextStyle(
                                          color: darkBrown.withAlpha(179),
                                          fontSize: 14,
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    )
                                  else
                                    ...songs.map((song) {
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 10.0),
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
                                          onAddPressed: () => _handleFavorite(context, song),
                                          isFavorite: favoriteIds.contains(song.id),
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