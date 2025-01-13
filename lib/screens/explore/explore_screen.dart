import 'package:choco_lyrics/themes/colors/colors.dart';
import 'package:choco_lyrics/ui/components/song_row_placeholder.dart';
import 'package:choco_lyrics/ui/search/filter_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:choco_lyrics/ui/search/search_bar.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: const BoxDecoration(color: beige),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: double.infinity,
              child: Text(
                'Explore',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: darkBrown,
                  fontSize: 35,
                  fontFamily: 'Calibri', //TODO: Change font
                  fontWeight: FontWeight.w700,
                  height: 0.46,
                  letterSpacing: 0.50,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // SEARCH BAR //
            CustomSearchBar(
              controller: TextEditingController(),
              onChanged: (value) {
              // TODO: Implement search functionality
              },
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
                child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(8, (index) {
                  return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: FilterButton(),
                  );
                }),
                ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 340,
                    padding: const EdgeInsets.all(9),
                    decoration: ShapeDecoration(
                      color: Color(0xFF2A0505),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //TODO: Change to SongRow when API is ready
                        SongRowPlaceHolder(imageUrl: 'https://i.scdn.co/image/ab67616d0000b27333ea9fb3fd69bca55a015229', title: 'Merry-go-round', artist: 'Joe Hisaishi'),
                ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
