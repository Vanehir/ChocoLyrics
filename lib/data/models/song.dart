import 'package:choco_lyrics/data/models/album.dart';
import 'package:choco_lyrics/data/models/artist.dart';

class Song {
  final String id;
  final String name;
  final int durationMs;
  final List<Artist> artists;
  final Album album;

  Song({
    required this.id,
    required this.name,
    required this.durationMs,
    required this.artists,
    required this.album,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      durationMs: json['duration_ms'] ?? 0,
      artists: ((json['artists'] as List<dynamic>?) ?? [])
          .map((artist) => Artist.fromJson(artist))
          .toList(),
      album: Album.fromJson(json['album']),
    );
  }

  @override
  String toString() {
    return 'Song: $name, \n'
        'Artists: ${artists.map((artist) => artist.name).join(', ')}, \n'
        'Duration: $durationMs, \n'
        'Album: ${album.name}, \n'
        'Album Cover: ${album.coverUrl}\n';
  }
}
