import 'package:choco_lyrics/data/repositories/spotify/spotify_constants.dart';
import 'package:choco_lyrics/data/repositories/spotify/spotify_repository.dart';
import 'package:choco_lyrics/screens/tab_scaffold/tab_scaffold.dart';
import 'package:choco_lyrics/themes/light_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

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

  // start area debug test api getPlaylist calls
  final SpotifyRepository spotifyRepository = SpotifyRepository();
  print('playlist start XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
  final songs = await spotifyRepository.getPlaylist(idPlaylist: todayTopHits);
  for (var song in songs) {
    print(song.toString());
  }
  print('playlist end XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');

  print('tracks start XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
  final tracksSearch = await spotifyRepository.getItemFromSearch(
      query: 'eminem', queryParameter: 'track');
  for (var track in tracksSearch) {
    print(track.toString());
  }
  print('tracks end XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');

  print('albums start XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
  final albumsSearch = await spotifyRepository.getItemFromSearch(
      query: 'eminem', queryParameter: 'album');
  for (var album in albumsSearch) {
    print(album.toString());
  }
  print('albums end XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');

  print('artists start XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
  final artistsSearch = await spotifyRepository.getItemFromSearch(
      query: 'eminem', queryParameter: 'artist');
  for (var artist in artistsSearch) {
    print(artist.toString());
  }
  print('artists end XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
  // end area debug test api getPlaylist calls
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

      // staring point, to change with splash screen
      home: const TabScaffold(),
    );
  }
}
