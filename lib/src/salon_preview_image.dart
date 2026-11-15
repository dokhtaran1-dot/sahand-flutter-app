import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A photo-only preview of the approved 864x1536 salon booking artwork.
///
/// The original posters contain date, time, cakes and other booking UI in
/// their lower two thirds. Those controls must not be rendered as tiny,
/// non-interactive decorations inside the RV orbit or gallery cards.
/// This widget crops the top 25% of the source, leaving the untouched
/// approved poster for the actual booking page.
class SalonPreviewImage extends StatelessWidget {
  const SalonPreviewImage({
    super.key,
    required this.asset,
    this.alignment = Alignment.topCenter,
  });

  final String asset;
  final Alignment alignment;

  static const double _sourceWidth = 864;
  static const double _sourceHeight = 1536;
  static const double _maxVisibleHeightFraction = .245;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      if (!size.hasBoundedWidth || !size.hasBoundedHeight) {
        return const ColoredBox(color: Color(0xFF0C2B20));
      }
      final width = size.maxWidth;
      final height = size.maxHeight;
      if (width <= 0 || height <= 0) return const SizedBox.shrink();

      // Preserve original aspect ratio; scale sufficiently to ensure
      // the visible source area ends above the poster's booking controls.
      final expandedWidth = math.max(
        width,
        height * _sourceWidth / (_sourceHeight * _maxVisibleHeightFraction),
      );
      final expandedHeight = expandedWidth * _sourceHeight / _sourceWidth;

      return ClipRect(
        child: OverflowBox(
          alignment: alignment,
          minWidth: expandedWidth,
          maxWidth: expandedWidth,
          minHeight: expandedHeight,
          maxHeight: expandedHeight,
          child: Image.asset(
            asset,
            width: expandedWidth,
            height: expandedHeight,
            fit: BoxFit.fill,
            filterQuality: FilterQuality.high,
            gaplessPlayback: true,
            errorBuilder: (_, __, ___) => const ColoredBox(
              color: Color(0xFF0B281F),
              child: Center(
                child: Icon(Icons.photo_outlined,
                    color: Color(0xFFD6B15E), size: 42),
              ),
            ),
          ),
        ),
      );
    });
  }
}
