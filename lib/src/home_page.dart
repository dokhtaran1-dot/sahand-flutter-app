import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'royal_village_page.dart';
import 'royal_signature_page.dart';
import 'royal_etehad_page.dart';
import 'royal_explore_page.dart';

/// Touch regions use the same 928 x 1648 coordinate space as the approved
/// Royal One poster. Contain fitting keeps art and hit targets aligned.
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static const double artWidth = 928;
  static const double artHeight = 1648;
  static const String artwork = 'assets/image/RoyalOne_Home_Final.png';

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
                Color(0x88000000), BlendMode.darken),
              child: Image.asset(artwork, fit: BoxFit.cover),
            ),
          ),
          Center(
            child: LayoutBuilder(builder: (context, constraints) {
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
                    child: Stack(children: [
                      Image.asset(artwork, width: artWidth,
                        height: artHeight, fit: BoxFit.fill,
                        filterQuality: FilterQuality.high),
                      // Full portals: tapping the art or ENTER works instantly.
                      _hotspot(context, const Rect.fromLTWH(15, 520, 291, 922),
                        const RoyalEtehadPage()),
                      _hotspot(context, const Rect.fromLTWH(318, 520, 291, 922),
                        const RoyalSignaturePage()),
                      _hotspot(context, const Rect.fromLTWH(621, 520, 291, 922),
                        const RoyalVillagePage()),
                      // Bottom navigation: Home | RE | RS | RV | Explore.
                      _hotspot(context, const Rect.fromLTWH(212, 1495, 170, 130),
                        const RoyalEtehadPage()),
                      _hotspot(context, const Rect.fromLTWH(385, 1495, 160, 130),
                        const RoyalSignaturePage()),
                      _hotspot(context, const Rect.fromLTWH(548, 1495, 175, 130),
                        const RoyalVillagePage()),
                      _hotspot(context, const Rect.fromLTWH(725, 1495, 185, 130),
                        const RoyalExplorePage()),
                    ]),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
