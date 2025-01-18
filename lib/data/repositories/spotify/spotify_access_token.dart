import 'package:choco_lyrics/core/storage/secure_storage.dart';
import 'package:choco_lyrics/utilities/base64_encode.dart';
import 'package:dio/dio.dart';
import 'package:choco_lyrics/data/repositories/spotify/spotify_constants.dart';
import 'package:choco_lyrics/data/repositories/spotify/spotify_keys.dart';

class GetSpotifyAccessToken {
  final Dio dio = Dio();
  final SecureStorage secureStorage = SecureStorage();

  Future<void> getAccessToken() async {
    final response = await dio.post(
      tokenUrl,
      data: {'grant_type': 'client_credentials'},

      // this is for the Authorization Code with PKCE, we do not need it right now, and maybe will never need it
      /*
      data: FormData.fromMap({
        'client_id': clientId,
        'grant_type': 'authorization_code',
        'code_verifier': codeVerifier,
      }),
      */

      options: Options(
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization':
              'Basic ${base64EncodeString('$clientId:$clientSecret')}',
        },
      ),
    );
    if (response.statusCode == 200 && response.data != null) {
      await secureStorage.setItem(
          key: accessTokenKey, item: response.data[accessTokenKey]);
    } else {
      throw Exception(
          'Failed to authenticate with Spotify: ${response.statusMessage}');
    }
  }
}
