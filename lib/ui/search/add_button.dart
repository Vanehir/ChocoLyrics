import 'package:choco_lyrics/themes/colors/colors.dart';
import 'package:flutter/cupertino.dart';

class AddButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isFavorite;

  const AddButton({
    super.key,
    required this.onPressed,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 32,
        height: 32,
        child: Icon(
          isFavorite ? CupertinoIcons.add_circled_solid : CupertinoIcons.add_circled,
          color: isFavorite ? beige : darkBeige,
          size: 32,
        ),
      ),
    );
  }
}