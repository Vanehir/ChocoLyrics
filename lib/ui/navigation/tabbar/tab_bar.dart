import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

CupertinoTabBar customTabBar = CupertinoTabBar(
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
