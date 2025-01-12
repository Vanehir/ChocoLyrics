import 'package:flutter/cupertino.dart';

class CustomSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const CustomSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return CupertinoSearchTextField(
      onChanged: onChanged,
      placeholder: 'Search',
      padding: EdgeInsets.all(10.0),
    );
  }
}