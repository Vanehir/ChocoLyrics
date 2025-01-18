import 'package:choco_lyrics/core/secure_storage.dart';
import 'package:choco_lyrics/data/repositories/spotify/spotify_constants.dart';
import 'package:choco_lyrics/data/repositories/spotify/spotify_keys.dart';
import 'package:dio/dio.dart';

class GetSpotifyRefreshToken {
  final Dio dio = Dio();
  final SecureStorage secureStorage = SecureStorage();

  Future<void> getRefreshToken() async {
    String? refreshToken = await secureStorage.getItem(key: refreshTokenKey);

    if (refreshToken == null) {
      throw Exception('No refresh token found');
    }

    final response = await dio.post(
      tokenUrl,
      data: {
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
        'client_id': clientId,
      },
      options: Options(
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      ),
    );
    if (response.statusCode == 200 && response.data != null) {
      secureStorage.setItem(
          key: refreshTokenKey, item: response.data[refreshTokenKey]);
    } else {
      throw Exception('Failed to refresh token: ${response.statusMessage}');
    }
  }
}
