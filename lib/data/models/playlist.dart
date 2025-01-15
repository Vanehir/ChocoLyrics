class Track {
  final String name;

  Track({required this.name});

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      name: json['name'] ?? '',
    );
  }
}
class Playlist {
  final String name;
  final List<Track> tracks;

  Playlist({required this.name, required this.tracks});

  factory Playlist.fromJson(Map<String, dynamic> json) {
    var tracksJson = json['tracks']['items'] as List;
    List<Track> trackList = tracksJson.map((trackJson) => Track.fromJson(trackJson['track'])).toList();

    return Playlist(
      name: json['name'] ?? '',
      tracks: trackList,
    );
  }
}