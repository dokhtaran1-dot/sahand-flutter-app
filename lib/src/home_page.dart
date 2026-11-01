import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'royal_mall_page.dart';
import 'royal_village_page.dart';
import 'royal_club_game_page.dart';
import 'royal_signature_page.dart';
import 'ettehad_page.dart';
import 'royal_harmonia_page.dart';

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

  void _openEttehad(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EttehadPage()));
  }

  void _openRoyalSignature(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RoyalSignaturePage()));
  }

  void _openRoyalHarmonia(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RoyalHarmoniaPage()));
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
            child: FractionallySizedBox(
              widthFactor: .96,
              heightFactor: .96,
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

                    // Current Home.png layout — RM / RC / RV.
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
                      child: _TapZone(onTap: () => _openRoyalClub(context)),
                    ),
                    Positioned(
                      left: 620,
                      top: 590,
                      width: 290,
                      height: 690,
                      child: _TapZone(onTap: () => _openRoyalVillage(context)),
                    ),

                    // Bottom center navigation — exact order: RE | RS | RH.
                    Positioned(
                      left: 105,
                      top: 1438,
                      width: 731,
                      height: 178,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: _LuxuryBottomButton(
                              code: 'RE',
                              subtitle: 'ETTEHAD',
                              onTap: () => _openEttehad(context),
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Transform.translate(
                              offset: const Offset(0, -10),
                              child: _LuxuryBottomButton(
                                code: 'RS',
                                subtitle: 'SIGNATURE',
                                emphasized: true,
                                onTap: () => _openRoyalSignature(context),
                              ),
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: _LuxuryBottomButton(
                              code: 'RH',
                              subtitle: 'HARMONIA',
                              onTap: () => _openRoyalHarmonia(context),
                            ),
                          ),
                        ],
                      ),
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


class _LuxuryBottomButton extends StatelessWidget {
  final String code;
  final String subtitle;
  final VoidCallback onTap;
  final bool emphasized;

  const _LuxuryBottomButton({
    required this.code,
    required this.subtitle,
    required this.onTap,
    this.emphasized = false,
  });

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFD7B66D);
    return SizedBox(
      height: emphasized ? 160 : 142,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(emphasized ? 30 : 26),
          child: Ink(
            decoration: BoxDecoration(
              color: const Color(0xE615171C),
              borderRadius: BorderRadius.circular(emphasized ? 30 : 26),
              border: Border.all(
                color: gold,
                width: emphasized ? 2.4 : 1.6,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.55),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
                if (emphasized)
                  BoxShadow(
                    color: gold.withOpacity(.18),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  code,
                  style: TextStyle(
                    color: gold,
                    fontSize: emphasized ? 42 : 36,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 3.5,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(.78),
                    fontSize: emphasized ? 12 : 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.8,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
