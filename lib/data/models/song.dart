import 'package:choco_lyrics/data/models/artist.dart';

class Song {
  final String id;
  final String name;
  final int durationMs;
  final List<Artist> artists;
  final String albumCoverUrl;

  Song({
    required this.id,
    required this.name,
    required this.durationMs,
    required this.artists,
    required this.albumCoverUrl,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      durationMs: json['duration_ms'] ?? 0,
      artists: ((json['artists'] as List<dynamic>?) ?? [])
          .map((artist) => Artist.fromJson(artist))
          .toList(),
      albumCoverUrl: json['album']?['images']?[0]?['url'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Song: $name, \n'
        'Artists: ${artists.map((artist) => artist.name).join(', ')}, \n'
        'Duration: $durationMs, \n'
        'Album Cover URL: $albumCoverUrl\n';
  }
}
