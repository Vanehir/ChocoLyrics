import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.67,
      padding: const EdgeInsets.symmetric(horizontal: 19.69, vertical: 22.83),
      decoration: ShapeDecoration(
        color: const Color(0xFF2A0505),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.87),
        ),
      ),
      child: const Center(
        child: Text(
          'Filter',
          style: TextStyle(
            color: Color(0xFFF0DDA2),
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