import 'package:choco_lyrics/themes/colors/colors.dart';
import 'package:flutter/cupertino.dart';

enum SongCardSize { big, small }

class SongCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String artist;
  final VoidCallback? onTap;
  final SongCardSize size;

  const SongCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.artist,
    this.onTap,
    this.size = SongCardSize.big,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isBig = size == SongCardSize.big;
        
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(isBig ? 8 : 8),
            decoration: BoxDecoration(
              color: darkBrown,
              borderRadius: BorderRadius.circular(isBig ? 16 : 8),
              boxShadow: [
                BoxShadow(
                  color: darkBrownShadow,
                  blurRadius: isBig ? 8 : 4,
                  offset: Offset(isBig ? 8 : 4, isBig ? 8 : 4),
                  spreadRadius: isBig ? 2 : 1,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: isBig ? 150 : double.infinity,
                  height: isBig ? 150 : constraints.maxWidth - 16,
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(isBig ? 8 : 4),
                    ),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: isBig ? 16 : 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: beige,
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isBig ? 8 : 4),
                Text(
                  artist,
                  style: const TextStyle(
                    color: beige,
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}