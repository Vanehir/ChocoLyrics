import 'package:choco_lyrics/screens/favorites/favorite_screen.dart';
import 'package:choco_lyrics/screens/home/home_screen.dart';
import 'package:choco_lyrics/screens/explore/explore_screen.dart';
import 'package:choco_lyrics/ui/navigation/tabbar/tab_bar.dart';
import 'package:flutter/cupertino.dart';

class TabScaffold extends StatelessWidget {
  const TabScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: getCustomTabBar(),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            switch (index) {
              case 0:
                return HomeScreen();
              case 1:
                return ExploreScreen();
              case 2:
                return FavoriteScreen();
              default:
                return HomeScreen();
            }
          },
        );
      },
    );
  }
}