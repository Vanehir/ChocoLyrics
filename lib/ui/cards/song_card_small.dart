import 'package:choco_lyrics/themes/colors/colors.dart';
import 'package:flutter/cupertino.dart';

class SongCardSmall extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String artist;
  final VoidCallback? onTap;

  const SongCardSmall({
    super.key,
    this.imageUrl,
    required this.title,
    required this.artist,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: constraints.maxWidth,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: darkBrown,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: darkBrownShadow,
                  blurRadius: 4,
                  offset: Offset(4, 4),
                  spreadRadius: 1,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image section
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: beige.withOpacity(0.2),
                    ),
                    child: imageUrl != null && imageUrl!.isNotEmpty
                        ? Image.network(
                            imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Icon(
                                  CupertinoIcons.music_note, 
                                  color: beige,
                                  size: constraints.maxWidth * 0.3,
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Icon(
                              CupertinoIcons.music_note, 
                              color: beige,
                              size: constraints.maxWidth * 0.3,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 8),
                
                // Title section
                Text(
                  title.isNotEmpty ? title : 'Unknown Title',
                  style: const TextStyle(
                    color: beige,
                    fontSize: 11,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                
                // Artist section
                Text(
                  artist.isNotEmpty ? artist : 'Unknown Artist',
                  style: const TextStyle(
                    color: beige,
                    fontSize: 9,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}