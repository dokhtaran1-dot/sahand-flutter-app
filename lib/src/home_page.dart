import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'royal_village_page.dart';
import 'royal_mall_page.dart';
import 'royal_club_game_page.dart';
import 'royal_deal_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const double _artWidth = 960;
  static const double _artHeight = 1707;
  static const String _art = 'assets/image/royal1_home_ultra.webp';

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

  void _openRoyalMall(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RoyalMallPage()),
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fills very tall Fold screens so there are no empty black bands.
          ImageFiltered(
            imageFilter: ui.ImageFilter.blur(sigmaX: 22, sigmaY: 22),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.42),
                BlendMode.darken,
              ),
              child: Image.asset(
                _art,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                isAntiAlias: true,
              ),
            ),
          ),
          Center(
            child: FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: _artWidth,
                height: _artHeight,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      _art,
                      width: _artWidth,
                      height: _artHeight,
                      fit: BoxFit.fill,
                      filterQuality: FilterQuality.high,
                      isAntiAlias: true,
                      gaplessPlayback: true,
                    ),
                    Positioned(left: 0, top: 0, width: 135, height: 150,
                      child: _TapZone(onTap: () => _comingSoon(context, 'Menu'))),
                    Positioned(left: 825, top: 0, width: 135, height: 150,
                      child: _TapZone(onTap: () => _comingSoon(context, 'Notifications'))),
                    Positioned(left: 0, top: 300, width: 310, height: 875,
                      child: _TapZone(onTap: () => _openRoyalMall(context))),
                    Positioned(left: 305, top: 385, width: 350, height: 790,
                      child: _TapZone(onTap: () => _openRoyalClub(context))),
                    Positioned(left: 650, top: 300, width: 310, height: 875,
                      child: _TapZone(onTap: () => _openRoyalVillage(context))),
                    Positioned(left: 10, top: 1160, width: 940, height: 285,
                      child: _TapZone(onTap: () => _openRoyalDeal(context))),
                    Positioned(left: 330, top: 1450, width: 300, height: 180,
                      child: _TapZone(onTap: () => _comingSoon(context, 'More'))),
                  ],
                ),
              ),
            ),
          ),
        ],
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
