import 'package:choco_lyrics/data/models/artist.dart';

class Song {
  final String id;
  final String name;
  final int durationMs;
  final String spotifyUrl;
  final List<Artist> artists;
  final String albumCoverUrl;

  Song({
    required this.id,
    required this.name,
    required this.durationMs,
    required this.spotifyUrl,
    required this.artists,
    required this.albumCoverUrl,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    // Aggiunto null check e valori di default
    return Song(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      durationMs: json['duration_ms'] ?? 0,
      spotifyUrl: json['external_urls']?['spotify'] ?? '',
      artists: ((json['artists'] as List?) ?? [])
          .map((artist) => Artist.fromJson(artist))
          .toList(),
      albumCoverUrl: json['album']?['images']?[0]?['url'] ?? '',
    );
  }
}