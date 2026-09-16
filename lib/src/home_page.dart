import 'package:flutter/material.dart';

import 'royal_village_page.dart';
import 'royal_club_game_page.dart';
import 'royal_deal_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const double _designWidth = 1024;
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
                  isAntiAlias: true,
                  gaplessPlayback: true,
                ),
                Positioned(left: 0, top: 0, width: 145, height: 155, child: _TapZone(onTap: () => _comingSoon(context, 'Menu'))),
                Positioned(left: 875, top: 0, width: 149, height: 155, child: _TapZone(onTap: () => _comingSoon(context, 'Notifications'))),
                Positioned(left: 0, top: 280, width: 340, height: 815, child: _TapZone(onTap: () => _comingSoon(context, 'Royal Mall'))),
                Positioned(left: 332, top: 350, width: 356, height: 745, child: _TapZone(onTap: () => _openRoyalClub(context))),
                Positioned(left: 681, top: 280, width: 343, height: 815, child: _TapZone(onTap: () => _openRoyalVillage(context))),
                Positioned(left: 12, top: 1090, width: 1000, height: 270, child: _TapZone(onTap: () => _openRoyalDeal(context))),
                Positioned(left: 350, top: 1360, width: 332, height: 155, child: _TapZone(onTap: () => _comingSoon(context, 'More'))),
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
