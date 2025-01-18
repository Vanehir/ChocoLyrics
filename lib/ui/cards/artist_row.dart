import 'package:flutter/material.dart';
import 'package:choco_lyrics/data/models/artist.dart';
import 'package:choco_lyrics/themes/colors/colors.dart';
import 'package:choco_lyrics/ui/search/add_button.dart';

class ArtistRow extends StatelessWidget {
  final Artist artist;
  final VoidCallback? onTap;
  final VoidCallback onAddPressed;

  const ArtistRow({
    super.key,
    required this.artist,
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
                  image: NetworkImage(artist.imageUrl),
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
                    artist.name,
                    style: const TextStyle(
                      color: beige,
                      fontSize: 16,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      height: 1.21,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (artist.genres.isNotEmpty)
                    Text(
                      artist.genres.take(2).join(', '),
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