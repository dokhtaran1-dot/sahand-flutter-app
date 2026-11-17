import 'dart:math' as math;
import 'package:flutter/material.dart';

/// The source PNG is a room+event catalogue sheet. The original room photo
/// occupies the upper-left panel. Display the ENTIRE photo panel using contain,
/// never BoxFit.cover: no part of the room photograph is cut off even when
/// it appears in a square card, a round portal, or the expanded room viewer.
/// The full original catalogue remains accessible on the detail page.
class RvSalonInteriorImage extends StatelessWidget {
  const RvSalonInteriorImage({super.key, required this.asset});
  final String asset;

  // Fractional dimensions of the photo panel in the approved 864x1536 sheet.
  static const Size poster = Size(864, 1536);
  static const Rect roomPanel = Rect.fromLTWH(.017, .022, .557, .237);
  static const Color background = Color(0xFF061710);

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, bounds) {
      final width = bounds.maxWidth;
      final height = bounds.maxHeight;
      if (!width.isFinite || !height.isFinite || width <= 0 || height <= 0) {
        return const SizedBox.shrink();
      }

      final sourceRoomWidth = poster.width * roomPanel.width;
      final sourceRoomHeight = poster.height * roomPanel.height;
      // CONTAIN: all four edges of the original room panel remain visible.
      final scale = math.min(width / sourceRoomWidth,
          height / sourceRoomHeight);
      final roomWidth = sourceRoomWidth * scale;
      final roomHeight = sourceRoomHeight * scale;
      final sourceWidth = poster.width * scale;
      final sourceHeight = poster.height * scale;

      return ColoredBox(
        color: background,
        child: Center(
          child: SizedBox(
            width: roomWidth,
            height: roomHeight,
            child: ClipRect(
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  Positioned(
                    left: -sourceWidth * roomPanel.left,
                    top: -sourceHeight * roomPanel.top,
                    width: sourceWidth,
                    height: sourceHeight,
                    child: Image.asset(
                      asset,
                      fit: BoxFit.fill,
                      filterQuality: FilterQuality.high,
                      gaplessPlayback: true,
                      errorBuilder: (_, __, ___) => const ColoredBox(
                        color: background,
                        child: Center(child: Icon(
                          Icons.image_not_supported_outlined,
                          color: Color(0xFFE4C17B), size: 28)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
