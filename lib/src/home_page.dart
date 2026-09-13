import 'package:flutter/material.dart';

import 'royal_village_page.dart';
import 'royal_club_game_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _comingSoon(BuildContext context, String title) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF090909),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Color(0xFFD7B45A)),
          ),
          content: Text(
            '$title در حال تکمیل است',
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
  }

  void _openRoyalVillage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RoyalVillagePage()),
    );
  }

  void _openRoyalClub(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RoyalClubGamePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;

            Rect normalized(double x, double y, double width, double height) {
              return Rect.fromLTWH(x * w, y * h, width * w, height * h);
            }

            // Tap zones match the exact approved 941x1672 artwork.
            final rmZone = normalized(0.02, 0.20, 0.30, 0.58);
            final rcZone = normalized(0.325, 0.20, 0.335, 0.58);
            final rvZone = normalized(0.665, 0.20, 0.315, 0.58);
            final moreZone = normalized(0.33, 0.835, 0.34, 0.08);

            return Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/image/royal1_page2_final.jpg',
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                  gaplessPlayback: true,
                  errorBuilder: (context, error, stackTrace) {
                    return const ColoredBox(
                      color: Colors.black,
                      child: Center(
                        child: Text(
                          'ROYAL 1',
                          style: TextStyle(
                            color: Color(0xFFD7B45A),
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Positioned.fromRect(
                  rect: rmZone,
                  child: _TapZone(
                    onTap: () => _comingSoon(context, 'Royal Mall'),
                  ),
                ),
                Positioned.fromRect(
                  rect: rcZone,
                  child: _TapZone(onTap: () => _openRoyalClub(context)),
                ),
                Positioned.fromRect(
                  rect: rvZone,
                  child: _TapZone(onTap: () => _openRoyalVillage(context)),
                ),
                Positioned.fromRect(
                  rect: moreZone,
                  child: _TapZone(
                    onTap: () => _comingSoon(context, 'More'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TapZone extends StatelessWidget {
  final VoidCallback onTap;

  const _TapZone({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
    );
  }
}
