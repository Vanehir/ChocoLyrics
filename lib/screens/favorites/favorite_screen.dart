import 'package:choco_lyrics/themes/colors/colors.dart';
import 'package:flutter/cupertino.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: beige,
      child: Center(
        child: Text('favorites coming soon'),
      ),
    );
  }
}
