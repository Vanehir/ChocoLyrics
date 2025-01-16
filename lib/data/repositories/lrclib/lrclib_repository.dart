import 'package:choco_lyrics/data/repositories/lrclib/lrclib_constants.dart';
import 'package:dio/dio.dart';

class LrcLibRepository {
  final Dio dio = Dio();

  Future<List<String>?> getLyrics(
      {required String artistName, required String songName}) async {
    try {
      final response = await dio.get(
        '$searchUrl $artistName $songName',
        options: Options(
          headers: {
            'Lrclib-Client':
                'ChocoLyrics (https://github.com/Vanehir/ChocoLyrics)'
          },
        ),
      );
      if (response.statusCode == 200) {
        final lyrics = (response.data[0]['plainLyrics'] as String).split('\n');
        return lyrics;
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to get lyrics');
      }
    } catch (e) {
      throw Exception('Error getting lyrics: $e');
    }
  }
}
