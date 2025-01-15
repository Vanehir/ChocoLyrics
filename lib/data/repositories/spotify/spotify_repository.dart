import 'package:choco_lyrics/core/secure_storage.dart';
import 'package:choco_lyrics/data/models/song.dart';
import 'package:choco_lyrics/data/repositories/spotify/spotify_access_token.dart';
import 'package:choco_lyrics/data/repositories/spotify/spotify_constants.dart';
import 'package:dio/dio.dart';

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

  Future<List<Song>> getPlaylist({required String idPlaylist}) async {
    try {
      await getSpotifyAccessToken.getAccessToken();
      String? token = await secureStorage.getItem(key: accessTokenKey);
      final response = await dio.get(
        (playListUrl + idPlaylist),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      print('status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final List<Song> songs = [];
        for (var item in response.data['tracks']['items']) {
          songs.add(Song.fromJson(item));
        }
        return songs;
      } else {
        throw Exception('Failed to get playlist: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to get playlist: $e');
    }
  }
}
