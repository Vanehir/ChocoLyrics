import 'package:flutter/material.dart';
import 'package:choco_lyrics/data/models/album.dart';
import 'package:choco_lyrics/themes/colors/colors.dart';
import 'package:choco_lyrics/ui/search/add_button.dart';

class AlbumRow extends StatelessWidget {
  final Album album;
  final VoidCallback? onTap;
  final VoidCallback onAddPressed;

  const AlbumRow({
    super.key,
    required this.album,
    this.onTap,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: darkBrown,
        ),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 65,
              height: 64,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(album.coverUrl),
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
                    album.name,
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
                    '${album.artists.map((artist) => artist.name).join(', ')} • ${album.totalTracks} tracks',
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
            AddButton(onPressed: onAddPressed),
          ],
        ),
      ),
    );
  }
}