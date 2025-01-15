class Artist {
  final String name;
  final List<String> genres;
  final String spotifyUrl;

  Artist({
    required this.name,
    required this.genres,
    required this.spotifyUrl,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      name: json['name'] ?? '',
      genres: List<String>.from(json['genres'] ?? []),
      spotifyUrl: json['external_urls']?['spotify'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Artist: $name, \n'
        'Genres: ${genres.join(', ')}, \n'
        'Spotify URL: $spotifyUrl\n';
  }
}
