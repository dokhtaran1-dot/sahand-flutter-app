import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'royal_mall_page.dart';
import 'royal_village_page.dart';
import 'royal_club_game_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const double _artWidth = 960;
  static const double _artHeight = 1707;
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

                    // Final order requested: RM / RV / RC.
                    Positioned(
                      left: 15,
                      top: 520,
                      width: 295,
                      height: 760,
                      child: _TapZone(onTap: () => _openRoyalMall(context)),
                    ),
                    Positioned(
                      left: 325,
                      top: 520,
                      width: 310,
                      height: 760,
                      child: _TapZone(onTap: () => _openRoyalVillage(context)),
                    ),
                    Positioned(
                      left: 650,
                      top: 520,
                      width: 295,
                      height: 760,
                      child: _TapZone(onTap: () => _openRoyalClub(context)),
                    ),

                    // Bottom central R1 acts as Home; no fourth game card here.
                    Positioned(
                      left: 350,
                      top: 1430,
                      width: 260,
                      height: 210,
                      child: _TapZone(onTap: () {}),
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
