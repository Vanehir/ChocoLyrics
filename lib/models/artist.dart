class Artist {
  final String name;
  final String spotifyUrl;

  Artist({
    required this.name,
    required this.spotifyUrl,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      name: json['name'] ?? '',
      spotifyUrl: json['external_urls']?['spotify'] ?? '',
    );
  }
}