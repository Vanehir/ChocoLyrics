/* 
* Starting point of the app
*/
import 'package:chocolyrics/screens/main_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChocoLyrics',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: const MainScreen(),  // Usa MainScreen come home
    );
  }
}