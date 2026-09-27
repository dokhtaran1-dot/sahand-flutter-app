import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'royal_village_page.dart';
import 'royal_club_page.dart';
import 'royal_mall_page.dart';
import 'point_of_return_page.dart';


/// Touch regions follow the currently bundled Home.png artwork.
/// The new RM/RC/RV poster must replace Home.png before reordering portals.
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static const double artWidth = 941;
  static const double artHeight = 1672;
  static const String artwork = 'assets/image/Home.png';

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
                        const RoyalMallPage()),
                      _hotspot(context, const Rect.fromLTWH(318, 520, 291, 922),
                        const RoyalVillagePage()),
                      _hotspot(context, const Rect.fromLTWH(621, 520, 291, 922),
                        const RoyalClubPage()),
                      // Existing poster bottom navigation: Home | Royal Club | R1 | Reservations | Profile.
                      _hotspot(context, const Rect.fromLTWH(212, 1495, 170, 130),
                        const RoyalClubPage()),
                      _hotspot(context, const Rect.fromLTWH(385, 1495, 160, 130),
                        const RoyalClubPage()),
                      _hotspot(context, const Rect.fromLTWH(548, 1495, 175, 130),
                        const RoyalVillagePage()),
                      _hotspot(context, const Rect.fromLTWH(725, 1495, 185, 130),
                        const RoyalClubPage()),
                    ]),
                  ),
                ),
              );
            }),
          ),
          Positioned(top: 12,right: 12,child:SafeArea(child:Material(color:const Color(0xDD170F0A),borderRadius:BorderRadius.circular(30),child:TextButton.icon(onPressed:()=>_push(context,const PointOfReturnPage()),icon:const Icon(Icons.menu_book,color:Color(0xFFE8C478)),label:const Text('آموزش مدیریت',style:TextStyle(color:Color(0xFFE8C478))))))),
        ],
      ),
    );
  }
}
