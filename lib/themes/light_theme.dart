import 'package:choco_lyrics/themes/colors/colors.dart';
import 'package:flutter/cupertino.dart';

const CupertinoThemeData cupertinoCustomThemeLight = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: beige,
    primaryContrastingColor: brown,
    textTheme: CupertinoTextThemeData(
        primaryColor: aubergine,
        textStyle: TextStyle(
            fontFamily: 'Montserrat', fontSize: 16, color: Color(0xFF713024))),
    barBackgroundColor: paleBrown,
    scaffoldBackgroundColor: beige);
