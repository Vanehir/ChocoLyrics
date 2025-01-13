import 'package:choco_lyrics/screens/tab_scaffold/tab_scaffold.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      // Aggiunto home, non so come avviavi l'app prima lol
      home: TabScaffold(),
    );
  }
}
