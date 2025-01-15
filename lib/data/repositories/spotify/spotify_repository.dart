import 'package:choco_lyrics/core/secure_storage.dart';
import 'package:choco_lyrics/data/models/playlist.dart';
import 'package:choco_lyrics/data/models/song.dart';
import 'package:choco_lyrics/data/repositories/spotify/spotify_access_token.dart';
import 'package:choco_lyrics/data/repositories/spotify/spotify_constants.dart';
import 'package:dio/dio.dart';

class SpotifyRepository {
  final Dio dio = Dio();
  final SecureStorage secureStorage = SecureStorage();
  final GetSpotifyAccessToken getSpotifyAccessToken = GetSpotifyAccessToken();

  Future<Playlist> getPlaylist({required String idPlaylist}) async {
    try {
      await getSpotifyAccessToken.getAccessToken();
      String? token = await secureStorage.getItem(key: accessTokenKey);
      final response = await dio.get(
        'https://api.spotify.com/v1/playlists/3Xta6685JStp5fttgaWP7m',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        final playlist = Playlist.fromJson(response.data);
        return playlist;
      } else {
        throw Exception('Failed to get playlist: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to get playlist: $e');
    }
  }
}
