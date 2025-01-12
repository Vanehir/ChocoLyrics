/* 
  This file contains the main screen of the app, which is the screen 
  that contains the bottom navigation bar and the screens that are navigated to.
*/
import 'package:chocolyrics/screens/explore_screen.dart';
import 'package:chocolyrics/screens/favorites_screen.dart';
import 'package:chocolyrics/screens/home_screen.dart';
import 'package:chocolyrics/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedTab = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const FavoritesScreen(),
    const ExploreScreen(),
  ];

  void _onPressedTab(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedTab], 
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedTab,
        onTap: _onPressedTab,
      ),
    );
  }
}