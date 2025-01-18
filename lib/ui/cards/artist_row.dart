import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:choco_lyrics/data/models/artist.dart';
import 'package:choco_lyrics/themes/colors/colors.dart';

class ArtistRow extends StatelessWidget {
  final Artist artist;
  final VoidCallback? onTap;

  const ArtistRow({
    super.key,
    required this.artist,
    this.onTap,
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
                image: artist.imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(artist.imageUrl),
                        fit: BoxFit.fill,
                        onError: (exception, stackTrace) {
                          // Fallback if image fails to load
                          print('Error loading artist image: $exception');
                        },
                      )
                    : null,
                color: artist.imageUrl.isEmpty ? Colors.grey[800] : null,
                borderRadius: BorderRadius.circular(4.38),
              ),
              child: artist.imageUrl.isEmpty
                  ? const Center(
                      child: Icon(
                        CupertinoIcons.person_fill,
                        color: beige,
                        size: 30,
                      ),
                    )
                  : null,
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
