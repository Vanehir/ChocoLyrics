import 'package:choco_lyrics/models/artist.dart';

class Album {
  final String id;
  final String name;
  final List<Artist> artists;
  final String coverUrl;
  final int totalTracks;

  Album({
    required this.id,
    required this.name,
    required this.artists,
    required this.coverUrl,
    required this.totalTracks,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      artists: ((json['artists'] as List?) ?? [])
          .map((a) => Artist.fromJson(a))
          .toList(),
      coverUrl: json['images']?[0]?['url'] ?? '',
      totalTracks: json['total_tracks'] ?? 0,
    );
  }
}
