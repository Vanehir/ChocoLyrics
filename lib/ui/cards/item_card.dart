import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:choco_lyrics/data/models/album.dart';
import 'package:choco_lyrics/data/models/artist.dart';
import 'package:choco_lyrics/data/models/song.dart';
import 'package:choco_lyrics/themes/colors/colors.dart';
import 'package:choco_lyrics/ui/search/add_button.dart';

class ItemRow extends StatelessWidget {
  final dynamic item;
  final VoidCallback? onTap;
  final VoidCallback? onAddPressed;
  final bool isFavorite;

  const ItemRow({
    super.key,
    required this.item,
    this.onTap,
    this.onAddPressed,
    this.isFavorite = false,
  });

  String _getTitle() {
    if (item is Song) return (item as Song).name;
    if (item is Album) return (item as Album).name;
    if (item is Artist) return (item as Artist).name;
    return '';
  }

  String _getSubtitle() {
    if (item is Song) {
      return (item as Song).artists.map((artist) => artist.name).join(', ');
    }
    if (item is Album) {
      final album = item as Album;
      return '${album.artists.map((artist) => artist.name).join(', ')} • ${album.totalTracks} tracks';
    }
    if (item is Artist && (item as Artist).genres.isNotEmpty) {
      return (item as Artist).genres.take(2).join(', ');
    }
    return '';
  }

  String _getImageUrl() {
    if (item is Song) return (item as Song).album.coverUrl;
    if (item is Album) return (item as Album).coverUrl;
    if (item is Artist) return (item as Artist).imageUrl;
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _getImageUrl();
    final bool isArtist = item is Artist;
    final bool showEmptyArtistImage = isArtist && imageUrl.isEmpty;

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
                image: !showEmptyArtistImage && imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.fill,
                        onError: (exception, stackTrace) {
                          print('Error loading image: $exception');
                        },
                      )
                    : null,
                color: showEmptyArtistImage ? Colors.grey[800] : null,
                borderRadius: BorderRadius.circular(4.38),
              ),
              child: showEmptyArtistImage
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
                    _getTitle(),
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
                  if (_getSubtitle().isNotEmpty)
                    Text(
                      _getSubtitle(),
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
            if (item is Song && onAddPressed != null) ...[
              const SizedBox(width: 10),
              AddButton(
                onPressed: onAddPressed!,
                isFavorite: isFavorite,
              ),
            ],
          ],
        ),
      ),
    );
  }
}