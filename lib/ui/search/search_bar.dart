import 'package:flutter/cupertino.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String placeholder;

  const CustomSearchBar({super.key, 
    required this.controller,
    required this.onChanged,
    this.placeholder = 'Search',
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoSearchTextField(
      controller: controller,
      onChanged: onChanged,
      placeholder: placeholder,
    );
  }
}