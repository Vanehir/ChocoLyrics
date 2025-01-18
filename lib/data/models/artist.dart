class Artist {
  final String name;
  final String imageUrl;
  final List<String> genres;

  Artist({
    required this.name,
    required this.imageUrl,
    required this.genres,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      name: json['name'] ?? '',
      imageUrl: json['images']?[0]?['url'] ?? '',
      genres: List<String>.from(json['genres'] ?? []),
    );
  }

  @override
  String toString() {
    return 'Artist: $name, \n'
        'Genres: ${genres.join(', ')}, \n';
  }
}