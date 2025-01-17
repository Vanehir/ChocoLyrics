import 'package:choco_lyrics/data/models/song.dart';
import 'package:choco_lyrics/themes/colors/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SongRow extends StatelessWidget {
  final Song song;
  final VoidCallback? onTap;

  const SongRow({
    super.key,
    required this.song,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        color: darkBrown,
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
                      color: beige,
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
                      color: darkBeige,
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
      ),
    );
  }
}