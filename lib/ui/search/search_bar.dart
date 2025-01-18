import 'package:flutter/cupertino.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final String placeholder;

  const CustomSearchBar({super.key, 
    required this.controller,
    required this.onSubmitted,
    this.placeholder = 'Search',
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoSearchTextField(
      controller: controller,
      onSubmitted: onSubmitted,
      placeholder: placeholder,
    );
  }
}