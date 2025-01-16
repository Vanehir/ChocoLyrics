import 'package:choco_lyrics/themes/colors/colors.dart';
import 'package:choco_lyrics/ui/components/song_card_big.dart';
import 'package:choco_lyrics/ui/components/song_card_small.dart';
import 'package:choco_lyrics/ui/components/song_row_placeholder.dart';
import 'package:choco_lyrics/ui/search/filter_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:choco_lyrics/ui/search/search_bar.dart';
import 'package:easy_localization/easy_localization.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: beige,
      child: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          // decoration: const BoxDecoration(color: beige),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Explore Title
              Text(
                tr('explore.title'),
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
              const SizedBox(height: 20),

              // Search Bar
              CustomSearchBar(
                controller: TextEditingController(),
                onChanged: (value) {
                  // TODO: Implement search functionality
                },
              ),
              const SizedBox(height: 20),

              // Filter Grid
              Container(
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    FilterButton(filterText: 'Track'),
                    FilterButton(filterText: 'Album'),
                    FilterButton(filterText: 'Artist'),
                    FilterButton(filterText: 'Pop'),
                    FilterButton(filterText: 'Rock'),
                    FilterButton(filterText: 'Classic'),
                    FilterButton(filterText: 'Hip/Hop'),
                    FilterButton(filterText: 'EDM'),
                    FilterButton(filterText: 'Metal'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Song List
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      // TODO: Change when API is ready
                      children: [
                        Container(
                          width: double.infinity,
                          child: Column(
                            // Add this Column widget
                            children: [
                              const SongRowPlaceHolder(
                                imageUrl:
                                    'https://i.scdn.co/image/ab67616d0000b27333ea9fb3fd69bca55a015229',
                                title: 'Merry-go-round',
                                artist: 'Joe Hisaishi',
                              ),
                              const SizedBox(height: 5),
                              const SongRowPlaceHolder(
                                imageUrl:
                                    'https://i.scdn.co/image/ab67616d0000b27333ea9fb3fd69bca55a015229',
                                title: 'Merry-go-round',
                                artist: 'Joe Hisaishi',
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                        ),
                      ],
                    ),
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
