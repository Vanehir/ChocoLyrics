class Artist {
  final String name;
  final List<String> genres;


  Artist({
    required this.name,
    required this.genres,

  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      name: json['name'] ?? '',
      genres: List<String>.from(json['genres'] ?? []),

    );
  }

  @override
  String toString() {
    return 'Artist: $name, \n'
        'Genres: ${genres.join(', ')}, \n';
  }
}
