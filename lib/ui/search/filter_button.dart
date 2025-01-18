import 'package:flutter/material.dart';
import 'package:choco_lyrics/themes/colors/colors.dart';

class FilterButton extends StatelessWidget {
  final String filterText;
  final bool isActive;
  final VoidCallback onTap;

  const FilterButton({
    super.key,
    required this.filterText,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isActive ? darkBrown : Colors.transparent,
          border: Border.all(
            color: darkBrown,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Center(
          child: Text(
            filterText,
            style: TextStyle(
              color: isActive ? beige : darkBrown,
              fontSize: 16,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}