import 'package:flutter/material.dart';

class RoyalVillageEntryPage extends StatelessWidget {
  const RoyalVillageEntryPage({super.key});

  static const String _art = 'assets/image/Rv_page2.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Image.asset(
                _art,
                width: double.infinity,
                fit: BoxFit.fitWidth,
                filterQuality: FilterQuality.high,
                isAntiAlias: true,
                gaplessPlayback: true,
              ),
            ),
            Positioned(
              top: 6,
              left: 6,
              child: SafeArea(
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  color: const Color(0xFFE8C36A),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black54,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
