import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'page2_data_1.dart';
import 'page2_data_2.dart';
import 'page2_data_3.dart';
import 'page2_data_4.dart';
import 'page2_data_5.dart';
import 'royal_village_page.dart';
import 'royal_club_game_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static final Uint8List _page2Bytes = base64Decode(
    page2Data1 + page2Data2 + page2Data3 + page2Data4 + page2Data5,
  );

  void _comingSoon(BuildContext context, String title) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF090909),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: const BorderSide(color: Color(0xFFD7B45A))),
        content: Text('$title در حال تکمیل است', textAlign: TextAlign.center, textDirection: TextDirection.rtl, style: const TextStyle(color: Colors.white)),
      ));
  }

  void _openRoyalVillage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RoyalVillagePage()));
  }

  void _openRoyalClub(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RoyalClubGamePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(builder: (context, constraints) {
        final screenW = constraints.maxWidth;
        final screenH = constraints.maxHeight;
        const designW = 941.0;
        const designH = 1672.0;
        final imageScale = (screenW / designW) > (screenH / designH) ? (screenW / designW) : (screenH / designH);
        final imageW = designW * imageScale;
        final imageH = designH * imageScale;
        final left = (screenW - imageW) / 2;
        final top = (screenH - imageH) / 2;
        Rect zone(double x, double y, double w, double h) => Rect.fromLTWH(left + x * imageScale, top + y * imageScale, w * imageScale, h * imageScale);
        final rmZone = zone(18, 337, 281, 962);
        final rcZone = zone(307, 337, 313, 962);
        final rvZone = zone(630, 337, 293, 962);
        final moreZone = zone(315, 1400, 310, 105);
        return ClipRect(child: Stack(children: [
          Positioned(left: left, top: top, width: imageW, height: imageH, child: Image.memory(_page2Bytes, fit: BoxFit.fill, filterQuality: FilterQuality.high, gaplessPlayback: true)),
          Positioned.fromRect(rect: rmZone, child: _TapZone(onTap: () => _comingSoon(context, 'Royal Mall'))),
          Positioned.fromRect(rect: rcZone, child: _TapZone(onTap: () => _openRoyalClub(context))),
          Positioned.fromRect(rect: rvZone, child: _TapZone(onTap: () => _openRoyalVillage(context))),
          Positioned.fromRect(rect: moreZone, child: _TapZone(onTap: () => _comingSoon(context, 'More'))),
        ]));
      }),
    );
  }
}

class _TapZone extends StatelessWidget {
  final VoidCallback onTap;
  const _TapZone({required this.onTap});
  @override
  Widget build(BuildContext context) => Material(color: Colors.transparent, child: InkWell(splashColor: Colors.transparent, highlightColor: Colors.transparent, onTap: onTap));
}
