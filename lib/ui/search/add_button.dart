import 'package:choco_lyrics/themes/colors/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddButton extends StatefulWidget {
  final VoidCallback onPressed;

  const AddButton({super.key, required this.onPressed});

  @override
  _AddButtonState createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  bool isFilled = false;

  void _toggleIcon() {
    setState(() {
      isFilled = !isFilled;
    });
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFilled ? CupertinoIcons.add_circled_solid : CupertinoIcons.add_circled,
        size: 35,
        color: beige,
      ),
      onPressed: _toggleIcon,
    );
  }
}