import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'royal_mall_page.dart';
import 'royal_village_page.dart';
import 'royal_club_game_page.dart';
import 'royal_signature_page.dart';
import 'ettehad_page.dart';
import 'royal_harmonia_page.dart';

/// The home artwork contains the old navigation bar in its bottom strip.
/// Crop that strip and render real, separately clickable Flutter controls.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const double _artWidth = 941;
  static const double _artHeight = 1672;
  static const double _visibleArtHeight = 1490;
  static const String _art = 'assets/image/Home.png';

  void _openRoyalMall(BuildContext context) => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const RoyalMallPage()),
      );

  void _openRoyalVillage(BuildContext context) => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const RoyalVillagePage()),
      );

  void _openRoyalClub(BuildContext context) => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const RoyalClubGamePage()),
      );

  void _openEttehad(BuildContext context) => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const EttehadPage()),
      );

  void _openRoyalSignature(BuildContext context) => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const RoyalSignaturePage()),
      );

  void _openRoyalHarmonia(BuildContext context) => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const RoyalHarmoniaPage()),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05070B),
      body: Stack(
        fit: StackFit.expand,
        children: [
          ImageFiltered(
            imageFilter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(.55),
                BlendMode.darken,
              ),
              child: Image.asset(_art, fit: BoxFit.cover),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: SizedBox(
                        width: _artWidth,
                        height: _visibleArtHeight,
                        child: ClipRect(
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                width: _artWidth,
                                height: _artHeight,
                                child: Image.asset(
                                  _art,
                                  fit: BoxFit.fill,
                                  filterQuality: FilterQuality.high,
                                  isAntiAlias: true,
                                ),
                              ),
                              // Restore the historical identity. The old
                              // artwork incorrectly says "Since 1991".
                              Positioned(
                                left: 104,
                                top: 99,
                                width: 164,
                                height: 26,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0B0809),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'SINCE 1351',
                                      style: TextStyle(
                                        color: Color(0xFFE9D7B2),
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.8,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
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
                ),
                _RoyalNavigation(
                  onEttehad: () => _openEttehad(context),
                  onSignature: () => _openRoyalSignature(context),
                  onHarmonia: () => _openRoyalHarmonia(context),
                ),
              ],
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
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
      );
}

class _RoyalNavigation extends StatelessWidget {
  final VoidCallback onEttehad;
  final VoidCallback onSignature;
  final VoidCallback onHarmonia;

  const _RoyalNavigation({
    required this.onEttehad,
    required this.onSignature,
    required this.onHarmonia,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 12, right: 12, top: 7, bottom: 3),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF020406), Color(0xFF15201D), Color(0xFF020406)],
        ),
        border: Border(
          top: BorderSide(color: Color(0xFFD6B875), width: 1.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 106,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _LuxuryBottomButton(
                    code: 'RE',
                    subtitle: 'ETTEHAD',
                    imageAsset: 'assets/image/monogram_re.webp',
                    onTap: onEttehad,
                  ),
                ),
                Expanded(
                  child: _LuxuryBottomButton(
                    code: 'RS',
                    subtitle: 'SIGNATURE',
                    imageAsset: 'assets/image/monogram_rs.webp',
                    emphasized: true,
                    onTap: onSignature,
                  ),
                ),
                Expanded(
                  child: _LuxuryBottomButton(
                    code: 'RH',
                    subtitle: 'HARMONIA',
                    imageAsset: 'assets/image/monogram_rh.webp',
                    onTap: onHarmonia,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 1),
          const Text(
            'ROYAL ONE  ·  V1.0.20  ·  POWERED BY SAHAND CONSORTIUM',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFAF9464),
              fontSize: 8,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _LuxuryBottomButton extends StatelessWidget {
  final String code;
  final String subtitle;
  final String imageAsset;
  final VoidCallback onTap;
  final bool emphasized;

  const _LuxuryBottomButton({
    required this.code,
    required this.subtitle,
    required this.imageAsset,
    required this.onTap,
    this.emphasized = false,
  });

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFD7B66D);
    final diameter = emphasized ? 104.0 : 92.0;

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
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
              if (emphasized)
                BoxShadow(color: gold.withOpacity(.22), blurRadius: 20, spreadRadius: 2),
            ],
          ),
          child: Semantics(
            button: true,
            label: 'ورود به $subtitle',
            child: Material(
              color: const Color(0xFF12171A),
              shape: CircleBorder(
                side: BorderSide(color: gold, width: emphasized ? 2.5 : 1.7),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        imageAsset,
                        width: emphasized ? 66 : 58,
                        height: emphasized ? 62 : 54,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                        isAntiAlias: true,
                        errorBuilder: (context, error, stackTrace) => Text(
                          code,
                          style: TextStyle(
                            color: gold,
                            fontSize: emphasized ? 30 : 27,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 3,
                            height: 1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Color(0xFFE9E4D7),
                          fontSize: 7,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
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
