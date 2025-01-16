import 'package:choco_lyrics/data/repositories/spotify/spotify_constants.dart';
import 'package:choco_lyrics/data/repositories/spotify/spotify_repository.dart';
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
        topHits = topHitsPlaylist;
        top50Global = top50GlobalPlaylist;
      });
    } catch (e) {
      debugPrint('Error fetching playlists: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(vertical: 20),
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
                    margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0), // Increased margin
                    child: SongCardBig(
                    imageUrl: song.albumCoverUrl,
                    title: song.name,
                    artist: song.artists.map((artist) => artist.name).join(', '),
                    ),
                  );
                  },
                  options: CarouselOptions(
                  height: 270.0,
                  enlargeCenterPage: false,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
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
                GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: top50Global.length,
                  itemBuilder: (context, index) {
                    final song = top50Global[index];
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        return SongCardSmall(
                          imageUrl: song.albumCoverUrl,
                          title: song.name,
                          artist: song.artists.map((artist) => artist.name).join(', '),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}