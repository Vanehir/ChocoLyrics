import 'dart:convert';

import 'package:choco_lyrics/core/storage/secure_storage.dart';
import 'package:choco_lyrics/data/repositories/spotify/spotify_constants.dart';
import 'package:choco_lyrics/data/repositories/spotify/spotify_repository.dart';
import 'package:choco_lyrics/screens/tab_scaffold/tab_scaffold.dart';
import 'package:choco_lyrics/themes/light_theme.dart';
import 'package:choco_lyrics/ui/favorites/favorite_handler.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('it')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MainApp(),
    ),
  );

  // start area debug test
  final SpotifyRepository spotifyRepository = SpotifyRepository();
  final FavoriteHandler favoriteHandler = FavoriteHandler();
  final SecureStorage secureStorage = SecureStorage();
  final songsIds = [
    '19DHPlTC2gx1j4jrFzNbwL',
    '3zjwZqLebYTDvRS2RJH5Be',
    '4I2SWtTgB08SICbqN6983B'
  ];

  // clear storage
  await secureStorage.clearStorage();

  // adding the song
  await favoriteHandler.addFavorite(songsIds[1]);
  log('favorites: ${await secureStorage.getItem(key: favoritesKey)}');

  final songsFavorites = await spotifyRepository.getSongsById(
      songIds: await favoriteHandler.getFavorites());

  // print with the added song
  for (final song in songsFavorites) {
    log(song.toString());
  }

  // deleting the song
  await favoriteHandler.removeFavorite(songsIds[1]);

  final songsFavoritesAfterDelete = await spotifyRepository.getSongsById(
      songIds: await favoriteHandler.getFavorites());

  // print with the deleted song
  for (final song in songsFavoritesAfterDelete) {
    log(song.toString());
  }
  log('favorites: ${await secureStorage.getItem(key: favoritesKey)}');

  // end area debug test
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      // red debug banner disabled
      debugShowCheckedModeBanner: false,

      // light theme is set, but we still have to work on it
      theme: cupertinoCustomThemeLight,

      // localization stuff
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      // starting point, to change with splash screen
      home: const TabScaffold(),
    );
  }
}