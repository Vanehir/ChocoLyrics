import 'package:flutter/cupertino.dart';

class SongRowPlaceHolder extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String artist;

  const SongRowPlaceHolder({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.artist,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: ShapeDecoration(
        color: const Color(0xFF2A0505),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: 65,
            height: 64,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(4.38),
            ),
          ),
          const SizedBox(width: 12),
          // Title and artist
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFFF0DDA2),
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis, // Handles long text
                ),
                const SizedBox(height: 4),
                Text(
                  artist,
                  style: const TextStyle(
                    color: Color(0xFFCA8D6D),
                    fontSize: 13,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Plus button
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              child: const Icon(
                CupertinoIcons.add_circled,
                size: 35,
                color: Color(0xFFF0DDA2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}