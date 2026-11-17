import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Shows only the room INTERIOR from the original complete salon catalogue.
///
/// Each approved portrait PNG is a catalogue sheet: top-left = the actual room
/// photograph; the rest includes Persian/English info, 10 birthday decorations
/// and up to 20 cake models. The whole unmodified sheet remains available in
/// the full catalogue viewer. We crop only the on-screen preview, not the asset.
///
/// Source poster coordinate system is 864 x 1536. Use fractional coordinates
/// so the preview remains correct if the poster is exported at a higher DPI.
class RvSalonInteriorImage extends StatelessWidget {
  const RvSalonInteriorImage({super.key, required this.asset});
  final String asset;

  static const double _posterWidth = 864;
  static const double _posterHeight = 1536;
  // Top-left main room photograph, excluding the information/cake grid.
  static const Rect _room = Rect.fromLTWH(.017, .022, .557, .237);

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, bounds) {
      final width = bounds.maxWidth;
      final height = bounds.maxHeight;
      if (!width.isFinite || !height.isFinite || width <= 0 || height <= 0) {
        return const SizedBox.shrink();
      }
      final scale = math.max(
        width / (_posterWidth * _room.width),
        height / (_posterHeight * _room.height),
      );
      final sourceWidth = _posterWidth * scale;
      final sourceHeight = _posterHeight * scale;
      final left = -sourceWidth * (_room.left + _room.width / 2) + width / 2;
      final top = -sourceHeight * (_room.top + _room.height / 2) + height / 2;

      return ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              left: left, top: top,
              width: sourceWidth, height: sourceHeight,
              child: Image.asset(
                asset, fit: BoxFit.fill,
                filterQuality: FilterQuality.high,
                gaplessPlayback: true,
                errorBuilder: (context, error, stack) => const ColoredBox(
                  color: Color(0xFF0B2B20),
                  child: Center(child: Icon(Icons.image_not_supported_outlined,
                    color: Color(0xFFE4C17B), size: 28)),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
