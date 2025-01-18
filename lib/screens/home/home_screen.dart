import 'package:choco_lyrics/data/repositories/spotify/spotify_constants.dart';
import 'package:choco_lyrics/data/repositories/spotify/spotify_repository.dart';
import 'package:choco_lyrics/screens/lyrics/lyrics_screen.dart';
import 'package:choco_lyrics/themes/colors/colors.dart';
import 'package:choco_lyrics/ui/navigation/components/song_card_big.dart';
import 'package:choco_lyrics/ui/navigation/components/song_card_small.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:choco_lyrics/data/models/song.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final SpotifyRepository spotifyRepository = SpotifyRepository();
  List<Song> topHits = [];
  List<Song> top50Global = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPlaylists();
  }

  Future<void> fetchPlaylists() async {
    try {
      final topHitsPlaylist = await spotifyRepository.getPlaylist(idPlaylist: todayTopHits);
      final top50GlobalPlaylist = await spotifyRepository.getPlaylist(idPlaylist: top50GlobalId);
      setState(() {
        // Explicitly cast the dynamic list to List<Song>
        topHits = (topHitsPlaylist).map((item) => item as Song).toList();
        top50Global = (top50GlobalPlaylist).map((item) => item as Song).toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching playlists: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        bottom: false,
        child: _isLoading 
          ? const Center(child: CupertinoActivityIndicator(radius: 20))
          : SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(vertical: 25).copyWith(bottom: 80),
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
                  itemCount: topHits.length,
                  itemBuilder: (context, index, realIndex) {
                    final song = topHits[index];
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0),
                      child: SongCardBig(
                        imageUrl: song.album.coverUrl,
                        title: song.name,
                        artist: song.artists.map((artist) => artist.name).join(', '),
                        onTap: () { 
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => LyricsScreen(song: song),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 270.0,
                    enlargeCenterPage: false,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
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
                // Replace GridView.builder with a custom solution
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: top50Global.map((song) {
                      return SizedBox(
                        width: (MediaQuery.of(context).size.width - 30) / 2, // Subtract padding and spacing
                        child: SongCardSmall(
                          imageUrl: song.album.coverUrl,
                          title: song.name,
                          artist: song.artists.map((artist) => artist.name).join(', '),
                          onTap: () => Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => LyricsScreen(song: song),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}