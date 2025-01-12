import 'package:flutter/material.dart';
import 'package:chocolyrics/widgets/search_bar.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explore'),
      ),
      body: Column(
        children: [
          CustomSearchBar(
            onChanged: (String value) {
              // TODO: Implement search
            },
          ),
          Expanded(
            child: Center(
              child: Text('Elenco canzoni'),
            ),
          ),
        ],
      ),
    );
  }
}