import 'package:choco_lyrics/themes/colors/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

CupertinoTabBar getCustomTabBar({
  Color activeColor = beige,
  Color inactiveColor = darkBeige,
  Color? backgroundColor = darkBrownSemiTransparent,
}) {
  return CupertinoTabBar(
    activeColor: activeColor,
    inactiveColor: inactiveColor,
    backgroundColor: backgroundColor,
    height: 65,
    items: <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.home),
        label: 'tabBar.home'.tr(),
      ),
      BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.search),
        label: 'tabBar.search'.tr(),
      ),
      BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.bookmark_solid),
        label: 'tabBar.favorites'.tr(),
      ),
    ],
  );
}