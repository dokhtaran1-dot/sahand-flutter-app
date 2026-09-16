import 'package:flutter/material.dart';

import 'royal_village_page.dart';
import 'royal_club_game_page.dart';
import 'royal_deal_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const double _designWidth = 864;
  static const double _designHeight = 1536;

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
      body: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.fill,
          alignment: Alignment.center,
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            width: _designWidth,
            height: _designHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/image/Home.png',
                  width: _designWidth,
                  height: _designHeight,
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                  gaplessPlayback: true,
                ),

                // Menu
                Positioned(
                  left: 0,
                  top: 0,
                  width: 125,
                  height: 155,
                  child: _TapZone(onTap: () => _comingSoon(context, 'Menu')),
                ),

                // Notifications
                Positioned(
                  left: 735,
                  top: 0,
                  width: 129,
                  height: 155,
                  child: _TapZone(
                    onTap: () => _comingSoon(context, 'Notifications'),
                  ),
                ),

                // RM — Royal Mall
                Positioned(
                  left: 0,
                  top: 290,
                  width: 286,
                  height: 800,
                  child: _TapZone(
                    onTap: () => _comingSoon(context, 'Royal Mall'),
                  ),
                ),

                // RC — Royal Club
                Positioned(
                  left: 285,
                  top: 365,
                  width: 295,
                  height: 725,
                  child: _TapZone(onTap: () => _openRoyalClub(context)),
                ),

                // RV — Royal Village
                Positioned(
                  left: 578,
                  top: 290,
                  width: 286,
                  height: 800,
                  child: _TapZone(onTap: () => _openRoyalVillage(context)),
                ),

                // Royal Deal — only the banner itself
                Positioned(
                  left: 12,
                  top: 1100,
                  width: 840,
                  height: 255,
                  child: _TapZone(onTap: () => _openRoyalDeal(context)),
                ),

                // More
                Positioned(
                  left: 300,
                  top: 1365,
                  width: 264,
                  height: 140,
                  child: _TapZone(onTap: () => _comingSoon(context, 'More')),
                ),
              ],
            ),
          ),
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
