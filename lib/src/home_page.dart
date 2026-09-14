import 'package:flutter/material.dart';

import 'royal_village_page.dart';
import 'royal_club_game_page.dart';
import 'royal_deal_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const double _artWidth = 941;
  static const double _artHeight = 1672;

  void _comingSoon(BuildContext context, String title) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF090909),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Color(0xFFE8C36A)),
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

  void _openRoyalDeal(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RoyalDealPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // The approved artwork is 9:16-ish. Keep its original aspect ratio on
          // every device. On very tall Fold screens the remaining space stays
          // black instead of stretching/blurring the design.
          final maxW = constraints.maxWidth;
          final maxH = constraints.maxHeight;
          final artAspect = _artWidth / _artHeight;

          double artW = maxW;
          double artH = artW / artAspect;
          if (artH > maxH) {
            artH = maxH;
            artW = artH * artAspect;
          }

          Rect zone(double l, double t, double r, double b) => Rect.fromLTRB(
                l * artW,
                t * artH,
                r * artW,
                b * artH,
              );

          final rm = zone(0.015, 0.188, 0.315, 0.706);
          final rc = zone(0.325, 0.245, 0.665, 0.706);
          final rv = zone(0.675, 0.188, 0.985, 0.706);
          final deal = zone(0.020, 0.716, 0.980, 0.884);
          final more = zone(0.340, 0.895, 0.660, 0.965);
          final menu = zone(0.000, 0.000, 0.140, 0.115);
          final bell = zone(0.860, 0.000, 1.000, 0.115);

          return ColoredBox(
            color: Colors.black,
            child: Center(
              child: SizedBox(
                width: artW,
                height: artH,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/image/Welcome.png',
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      filterQuality: FilterQuality.high,
                      isAntiAlias: true,
                      gaplessPlayback: true,
                      errorBuilder: (_, __, ___) => const ColoredBox(
                        color: Colors.black,
                        child: Center(
                          child: Text(
                            'ROYAL 1',
                            style: TextStyle(
                              color: Color(0xFFE8C36A),
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Only invisible hit areas sit above the approved artwork.
                    // No extra cards, text or effects are drawn over the image.
                    Positioned.fromRect(
                      rect: rm,
                      child: _TapZone(
                        onTap: () => _comingSoon(context, 'Royal Mall'),
                      ),
                    ),
                    Positioned.fromRect(
                      rect: rc,
                      child: _TapZone(onTap: () => _openRoyalClub(context)),
                    ),
                    Positioned.fromRect(
                      rect: rv,
                      child: _TapZone(onTap: () => _openRoyalVillage(context)),
                    ),
                    Positioned.fromRect(
                      rect: deal,
                      child: _TapZone(onTap: () => _openRoyalDeal(context)),
                    ),
                    Positioned.fromRect(
                      rect: more,
                      child: _TapZone(
                        onTap: () => _comingSoon(context, 'More'),
                      ),
                    ),
                    Positioned.fromRect(
                      rect: menu,
                      child: _TapZone(
                        onTap: () => _comingSoon(context, 'Menu'),
                      ),
                    ),
                    Positioned.fromRect(
                      rect: bell,
                      child: _TapZone(
                        onTap: () => _comingSoon(context, 'Notifications'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
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
