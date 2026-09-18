import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'royal_mall_page.dart';
import 'royal_village_page.dart';
import 'royal_club_game_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const double _artWidth = 941;
  static const double _artHeight = 1672;
  static const String _art = 'assets/image/Home.png';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          ImageFiltered(
            imageFilter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(.42),
                BlendMode.darken,
              ),
              child: Image.asset(_art, fit: BoxFit.cover),
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

                    // New Home.png layout — RM / RV / RC.
                    Positioned(
                      left: 20,
                      top: 590,
                      width: 290,
                      height: 690,
                      child: _TapZone(onTap: () => _openRoyalMall(context)),
                    ),
                    Positioned(
                      left: 320,
                      top: 590,
                      width: 290,
                      height: 690,
                      child: _TapZone(onTap: () => _openRoyalVillage(context)),
                    ),
                    Positioned(
                      left: 620,
                      top: 590,
                      width: 290,
                      height: 690,
                      child: _TapZone(onTap: () => _openRoyalClub(context)),
                    ),

                    // Bottom navigation.
                    Positioned(
                      left: 20,
                      top: 1480,
                      width: 180,
                      height: 150,
                      child: _TapZone(onTap: () {}),
                    ),
                    Positioned(
                      left: 200,
                      top: 1480,
                      width: 185,
                      height: 150,
                      child: _TapZone(onTap: () => _openRoyalClub(context)),
                    ),
                    Positioned(
                      left: 385,
                      top: 1450,
                      width: 175,
                      height: 185,
                      child: _TapZone(onTap: () {}),
                    ),
                    Positioned(
                      left: 560,
                      top: 1480,
                      width: 185,
                      height: 150,
                      child: _TapZone(onTap: () => _openRoyalVillage(context)),
                    ),
                    Positioned(
                      left: 745,
                      top: 1480,
                      width: 176,
                      height: 150,
                      child: _TapZone(onTap: () => _openRoyalClub(context)),
                    ),

                    // Top menu.
                    Positioned(
                      left: 825,
                      top: 15,
                      width: 105,
                      height: 105,
                      child: _TapZone(onTap: () => _openRoyalClub(context)),
                    ),
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
