import 'package:flutter/material.dart';

/// Displays the actual room photograph, extracted as a SEPARATE file from
/// the source room catalogue, with all four edges visible at every size.
/// Never substitute the advertising poster of people for a salon interior.
class RvSalonInteriorImage extends StatelessWidget {
  const RvSalonInteriorImage({super.key, required this.asset});
  final String asset;

  @override
  Widget build(BuildContext context) => Container(
    color: const Color(0xFF061710),
    alignment: Alignment.center,
    child: Image.asset(
      asset,
      fit: BoxFit.contain,
      alignment: Alignment.center,
      filterQuality: FilterQuality.high,
      gaplessPlayback: true,
      errorBuilder: (_, __, ___) => const Center(
        child: Icon(Icons.image_not_supported_outlined,
          color: Color(0xFFE4C17B), size: 32),
      ),
    ),
  );
}
