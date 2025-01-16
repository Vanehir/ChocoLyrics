import 'package:choco_lyrics/themes/colors/colors.dart';
import 'package:choco_lyrics/ui/navigation/components/song_card_big.dart';
import 'package:choco_lyrics/ui/navigation/components/song_card_small.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: const BoxDecoration(color: beige),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                itemCount: 10,
                itemBuilder: (context, index, realIndex) {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 5.0), // Reduced margin
                    child: SongCardBig(
                      imageUrl:
                          'https://www.teatrodellatoscana.it/media/news/Claudio-Bisio.jpg',
                      title: 'Zelig returns',
                      artist: 'Claudio Bisio',
                    ),
                  );
                },
                options: CarouselOptions(
                  height: 250.0,
                  enlargeCenterPage: false, // Changed to false
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  viewportFraction: 0.4, // Reduced to show more items
                  padEnds: false, // Prevents padding at the ends
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

              Flexible(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8, // Adjusted ratio
                  ),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        return SongCardSmall(
                          imageUrl:
                              'https://www.teatrodellatoscana.it/media/news/Claudio-Bisio.jpg',
                          title: 'Zelig returns',
                          artist: 'Claudio Bisio',
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
