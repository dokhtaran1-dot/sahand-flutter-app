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

                    // Replace the old image-baked RE/RC/RH navigation
                    // with an opaque, clearly native RE/RS/RH footer.
                    Positioned(
                      left: 246,
                      top: 1500,
                      width: 450,
                      height: 154,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: const Color(0xFF070A09),
                          borderRadius: BorderRadius.circular(27),
                          border: Border.all(
                            color: const Color(0xFFB38A45),
                            width: 1.4,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: _LuxuryBottomButton(
                                  code: 'RE',
                                  subtitle: 'ETTEHAD',
                                  onTap: () => _openEttehad(context),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Transform.translate(
                                  offset: const Offset(0, -5),
                                  child: _LuxuryBottomButton(
                                    code: 'RS',
                                    subtitle: 'SIGNATURE',
                                    emphasized: true,
                                    onTap: () => _openRoyalSignature(context),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
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
                      ),
                    ),
                    Positioned(
                      left: 384,
                      top: 1653,
                      width: 170,
                      height: 14,
                      child: const Center(
                        child: Text(
                          'ROYAL ONE  ·  1.0.18',
                          style: TextStyle(
                            color: Color(0xFFE7C78E),
                            fontSize: 10,
                            letterSpacing: 1.1,
                          ),
                        ),
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
    final diameter = emphasized ? 116.0 : 102.0;

    // Three true circles: RE · RS · RH. RS keeps the larger central accent.
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: diameter,
        height: diameter,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.65),
                blurRadius: 18,
                offset: const Offset(0, 7),
              ),
              if (emphasized)
                BoxShadow(
                  color: gold.withOpacity(.26),
                  blurRadius: 23,
                  spreadRadius: 3,
                ),
            ],
          ),
          child: Semantics(
            button: true,
            label: 'ورود به $subtitle',
            child: Material(
              color: const Color(0xFF12171A),
              shape: CircleBorder(
                side: BorderSide(color: gold, width: emphasized ? 2.8 : 1.8),
              ),
              clipBehavior: Clip.antiAlias,
              child: Ink(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: Alignment(-0.3, -0.5),
                    radius: 1.15,
                    colors: [Color(0xFF27302A), Color(0xFF12171A)],
                  ),
                ),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onTap,
                  splashColor: gold.withOpacity(.16),
                  highlightColor: gold.withOpacity(.08),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        code,
                        style: TextStyle(
                          color: gold,
                          fontSize: emphasized ? 34 : 29,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 3.5,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(.85),
                          fontSize: emphasized ? 9 : 8,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
