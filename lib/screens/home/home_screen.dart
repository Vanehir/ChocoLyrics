import 'package:choco_lyrics/screens/home/home_cubit.dart';
import 'package:choco_lyrics/screens/home/home_state.dart';
import 'package:choco_lyrics/data/repositories/spotify/spotify_repository.dart';
import 'package:choco_lyrics/screens/lyrics/lyrics_screen.dart';
import 'package:choco_lyrics/themes/colors/colors.dart';
import 'package:choco_lyrics/ui/cards/song_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(
        spotifyRepository: SpotifyRepository(),
      )..loadPlaylists(),
      child: const HomeScreenView(),
    );
  }
}

class HomeScreenView extends StatelessWidget {
  const HomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        bottom: false,
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.status == HomeStatus.loading) {
              return const Center(
                child: CupertinoActivityIndicator(radius: 20),
              );
            }

            if (state.status == HomeStatus.failure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Something went wrong: ${state.errorMessage}',
                      textAlign: TextAlign.center,
                    ),
                    CupertinoButton(
                      onPressed: () {
                        context.read<HomeCubit>().loadPlaylists();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 25)
                    .copyWith(bottom: 80),
                decoration: const BoxDecoration(color: beige),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Home Title
                    Text(
                      'home.title'.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: darkBrown,
                        fontSize: 50,
                        fontFamily: 'Calibri',
                        fontWeight: FontWeight.w700,
                        height: 0.46,
                        letterSpacing: 0.50,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Today's top hits carousel
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'home.firstPlaylist'.tr(),
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    CarouselSlider.builder(
                      itemCount: state.topHits.length,
                      itemBuilder: (context, index, realIndex) {
                        final song = state.topHits[index];
                        return Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 20.0),
                          child: SongCard(
                            imageUrl: song.album.coverUrl,
                            title: song.name,
                            artist: song.artists
                                .map((artist) => artist.name)
                                .join(', '),
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) =>
                                      LyricsScreen(song: song),
                                ),
                              );
                            },
                            size: SongCardSize.big,
                          ),
                        );
                      },
                      options: CarouselOptions(
                        height: 270.0,
                        enlargeCenterPage: false,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        viewportFraction: 0.4,
                        padEnds: false,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Top 50 Global
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'home.secondPlaylist'.tr(),
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: state.top50Global.map((song) {
                          return SizedBox(
                            width: (MediaQuery.of(context).size.width - 30) / 2,
                            child: SongCard(
                              imageUrl: song.album.coverUrl,
                              title: song.name,
                              artist: song.artists
                                  .map((artist) => artist.name)
                                  .join(', '),
                              onTap: () => Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) =>
                                      LyricsScreen(song: song),
                                ),
                              ),
                              size: SongCardSize.small,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
