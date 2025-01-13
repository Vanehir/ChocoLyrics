import 'package:choco_lyrics/themes/colors/colors.dart';
import 'package:flutter/cupertino.dart';

class FilterButton extends StatelessWidget {
  final String filterText;
  const FilterButton({
    super.key,
    required this.filterText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.67,
      padding: const EdgeInsets.symmetric(horizontal: 19.69, vertical: 22.83),
      decoration: BoxDecoration(
        color: darkBrown,
        borderRadius: BorderRadius.circular(7.87),
      ),
      child: Center(
        child: Text(
          filterText,
          style: const TextStyle(
            color: beige,
            fontSize: 15.75,
            fontFamily: 'Roboto', // TODO: Use a custom font
            fontWeight: FontWeight.w500,
            height: 1.20,
            letterSpacing: 0.39,
          ),
        ),
      ),
    );
  }
}
