import 'package:choco_lyrics/ui/navigation/tabbar/tab_bar.dart';
import 'package:flutter/cupertino.dart';

class TabScaffold extends StatelessWidget {
  const TabScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: customTabBar,
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            return Placeholder();
          },
        );
      },
    );
  }
}
