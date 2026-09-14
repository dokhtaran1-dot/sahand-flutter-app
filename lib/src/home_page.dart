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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;

          Rect zone(double l, double t, double r, double b) =>
              Rect.fromLTRB(l * w, t * h, r * w, b * h);

          // Coordinates follow the approved 941x1672 Royal 1 artwork.
          final rm = zone(0.015, 0.20, 0.315, 0.80);
          final rc = zone(0.325, 0.20, 0.665, 0.80);
          final rv = zone(0.675, 0.20, 0.985, 0.80);
          final more = zone(0.34, 0.855, 0.66, 0.955);
          final menu = zone(0.00, 0.00, 0.14, 0.12);
          final bell = zone(0.86, 0.00, 1.00, 0.12);

          return Stack(
            fit: StackFit.expand,
            children: [
              // This asset is replaced by the exact HD approved page during build.
              Image.asset(
                'assets/image/Welcome.png',
                fit: BoxFit.fill,
                filterQuality: FilterQuality.high,
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
                rect: more,
                child: _TapZone(onTap: () => _comingSoon(context, 'More')),
              ),
              Positioned.fromRect(
                rect: menu,
                child: _TapZone(onTap: () => _comingSoon(context, 'Menu')),
              ),
              Positioned.fromRect(
                rect: bell,
                child: _TapZone(
                  onTap: () => _comingSoon(context, 'Notifications'),
                ),
              ),
            ],
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
