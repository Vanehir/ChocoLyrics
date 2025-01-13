// import 'package:flutter/cupertino.dart';
// e l'import dell'oggetto Song dalla chiamata API

/*
class SongRow extends StatelessWidget {
  final Song song;

  const SongRow({
    super.key,
    required this.song,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            width: 65,
            height: 64,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(song.albumCoverUrl),
                fit: BoxFit.fill,
              ),
              borderRadius: BorderRadius.circular(4.38),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.name,
                  style: const TextStyle(
                    color: Color(0xFFF0DDA2),
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                    height: 1.21,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  song.artists.map((artist) => artist.name).join(', '),
                  style: const TextStyle(
                    color: Color(0xFFCA8D6D),
                    fontSize: 13,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                    height: 1.48,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const FlutterLogo(size: 35),
        ],
      ),
    );
  }
}
*/


// PLACEHOLDER //

import 'package:flutter/material.dart';

class SongRow extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String artist;

  const SongRow({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.artist,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            width: 65,
            height: 64,
            decoration: ShapeDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.fill,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.38),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFFF0DDA2),
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                    height: 1.21,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  artist,
                  style: const TextStyle(
                    color: Color(0xFFCA8D6D),
                    fontSize: 13,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                    height: 1.48,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const FlutterLogo(size: 35),
        ],
      ),
    );
  }
}