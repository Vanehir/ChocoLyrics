import 'package:choco_lyrics/core/secure_storage.dart';
import 'package:choco_lyrics/data/models/album.dart';
import 'package:choco_lyrics/data/models/artist.dart';
import 'package:choco_lyrics/data/models/song.dart';
import 'package:choco_lyrics/data/repositories/spotify/spotify_access_token.dart';
import 'package:choco_lyrics/data/repositories/spotify/spotify_constants.dart';
import 'package:dio/dio.dart';

enum SpotifySearchType { track, album, artist }

class SpotifyRepository {
  final Dio dio = Dio();
  final SecureStorage secureStorage = SecureStorage();
  final GetSpotifyAccessToken getSpotifyAccessToken = GetSpotifyAccessToken();

  // this is for the Authorization Code with PKCE, we do not need it right now
  /*
  late String codeVerifier;
  late String hashed;
  late String codeChallenge;

  Future<void> initialize() async {
    codeVerifier = getRandomString(64);
    hashed = await generateSha256Hash(codeVerifier);
    codeChallenge = base64.encode(hashed.codeUnits);
  }
  */

  // TODO the first half part of this functions in one function

  // get a playlist from Spotify by id
  Future<List<dynamic>> getPlaylist({required String idPlaylist}) async {
    try {
      await getSpotifyAccessToken.getAccessToken();
      String? token = await secureStorage.getItem(key: accessTokenKey);
      final response = await dio.get(
        '$playListUrl$idPlaylist',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        return _getList(response: response);
      } else {
        throw Exception('Failed to get playlist: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to get playlist: $e');
    }
  }

  // search from Spotify by track name, album name, artist name
  Future<List<dynamic>> getItemFromSearch(
      {required String query,
      required SpotifySearchType queryParameter}) async {
    try {
      await getSpotifyAccessToken.getAccessToken();
      String? token = await secureStorage.getItem(key: accessTokenKey);
      final response = await dio.get(
        '$searchUrl?q=$query&type=$queryParameter',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        return _getList(response: response, queryParameter: queryParameter);
      } else {
        throw Exception(
            'Failed to get item from search: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to get item from search: $e');
    }
  }

  Future<List<Song>> getSongsById({required List<String> songIds}) async {
    List<Song> songs = [];
    for (String songId in songIds) {
      Song song = await _getTrackById(idTrack: songId);
      songs.add(song);
    }
    return songs;
  }

  // [private] get a track from Spotify by id
  Future<Song> _getTrackById({required String idTrack}) async {
    try {
      await getSpotifyAccessToken.getAccessToken();
      String? token = await secureStorage.getItem(key: accessTokenKey);
      final response = await dio.get(
        '$trackUrl$idTrack',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        final song = Song.fromJson(response.data);
        return song;
      } else {
        throw Exception('Failed to get track: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to get track: $e');
    }
  }

  // [private] function to get the list of items from the response
  List<dynamic> _getList(
      {required Response<dynamic> response,
      SpotifySearchType? queryParameter}) {
    switch (queryParameter) {
      case SpotifySearchType.track:
        final songs =
            ((response.data['tracks']['items'] as List<dynamic>?) ?? [])
                .map((song) => Song.fromJson(song))
                .toList();
        return songs;
      case SpotifySearchType.album:
        final albums =
            ((response.data['albums']['items'] as List<dynamic>?) ?? [])
                .map((album) => Album.fromJson(album))
                .toList();
        return albums;
      case SpotifySearchType.artist:
        final artists =
            ((response.data['artists']['items'] as List<dynamic>?) ?? [])
                .map((artist) => Artist.fromJson(artist))
                .toList();
        return artists;
      default:
        final songs =
            ((response.data['tracks']['items'] as List<dynamic>?) ?? [])
                .map((song) => Song.fromJson(song['track']))
                .toList();
        return songs;
    }
  }
}
