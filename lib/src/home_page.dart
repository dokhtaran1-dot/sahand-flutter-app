import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'royal_village_page.dart';
import 'royal_club_page.dart';
import 'royal_mall_page.dart';
import 'point_of_return_page.dart';

/// Final Home poster layout (approved RC center artwork):
/// left = RM, center = RC, right = RV.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const double artWidth = 941;
  static const double artHeight = 1672;
  static const String artwork = 'assets/image/royal1_home_ultra.webp';

  void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  Widget _hotspot(BuildContext context, Rect rect, Widget page) =>
      Positioned.fromRect(
        rect: rect,
        child: Semantics(
          button: true,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _push(context, page),
            child: const SizedBox.expand(),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090705),
      body: Stack(
        fit: StackFit.expand,
        children: [
          ImageFiltered(
            imageFilter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Color(0x88000000),
                BlendMode.darken,
              ),
              child: Image.asset(artwork, fit: BoxFit.cover),
            ),
          ),
          Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final scale = (constraints.maxWidth / artWidth <
                        constraints.maxHeight / artHeight)
                    ? constraints.maxWidth / artWidth
                    : constraints.maxHeight / artHeight;

                return SizedBox(
                  width: artWidth * scale,
                  height: artHeight * scale,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: SizedBox(
                      width: artWidth,
                      height: artHeight,
                      child: Stack(
                        children: [
                          Image.asset(
                            artwork,
                            width: artWidth,
                            height: artHeight,
                            fit: BoxFit.fill,
                            filterQuality: FilterQuality.high,
                          ),

                          // FINAL ORDER: RM | RC | RV
                          _hotspot(
                            context,
                            const Rect.fromLTWH(12, 500, 296, 915),
                            const RoyalMallPage(),
                          ),
                          _hotspot(
                            context,
                            const Rect.fromLTWH(320, 500, 298, 915),
                            const RoyalClubPage(),
                          ),
                          _hotspot(
                            context,
                            const Rect.fromLTWH(630, 500, 299, 915),
                            const RoyalVillagePage(),
                          ),

                          // Bottom nav on final poster.
                          _hotspot(
                            context,
                            const Rect.fromLTWH(18, 1450, 170, 165),
                            const HomePage(),
                          ),
                          _hotspot(
                            context,
                            const Rect.fromLTWH(195, 1450, 185, 165),
                            const RoyalMallPage(),
                          ),
                          _hotspot(
                            context,
                            const Rect.fromLTWH(382, 1450, 185, 165),
                            const RoyalClubPage(),
                          ),
                          _hotspot(
                            context,
                            const Rect.fromLTWH(570, 1450, 190, 165),
                            const RoyalVillagePage(),
                          ),
                          _hotspot(
                            context,
                            const Rect.fromLTWH(760, 1450, 165, 165),
                            const RoyalClubPage(),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Positioned(
            top: 10,
            right: 10,
            child: SafeArea(
              child: Material(
                color: const Color(0xB8140E0A),
                borderRadius: BorderRadius.circular(28),
                child: TextButton.icon(
                  onPressed: () => _push(
                    context,
                    const PointOfReturnPage(),
                  ),
                  icon: const Icon(
                    Icons.menu_book,
                    color: Color(0xFFE8C478),
                    size: 18,
                  ),
                  label: const Text(
                    'آموزش مدیریت',
                    style: TextStyle(
                      color: Color(0xFFE8C478),
                      fontSize: 11,
                    ),
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
