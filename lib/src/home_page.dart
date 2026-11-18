import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'ettehad_page.dart';
import 'heritage_page.dart';
import 'royal_club_game_page.dart';
import 'royal_club_profile_page.dart';
import 'royal_one_my_profile_page.dart';
import 'royal_explore_page.dart';
import 'royal_harmonia_page.dart';
import 'royal_mall_page.dart';
import 'royal_signature_page.dart';
import 'royal_village_page.dart';
import 'rv_gallery_page.dart';

/// Royal One approved final poster, with native Flutter navigation hit targets.
/// UI images were supplied as approved artwork; no subtitles are regenerated.
/// The SC globe alone rotates gently, once every 85 seconds.
/// This artwork must be shipped with the APK; never replace it with plain circles.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  static const double _width = 998.0;
  static const double _height = 1511.0; // approved art after top 65px crop
  static const Color _gold = Color(0xFFE1BF7B);
  static const String _art = 'assets/image/royal_one_home_final_cropped.jpg';
  static const String _sc = 'assets/image/royal_one_sc_rotating.png';
  late final AnimationController _globe = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 85),
  );

  @override
  void initState() {
    super.initState();
    _globe.repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _globe.stop();
    } else if (!_globe.isAnimating) {
      _globe.repeat();
    }
  }

  @override
  void dispose() {
    _globe.dispose();
    super.dispose();
  }

  void _push(Widget destination) => Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => destination));

  void _openMenu() => showModalBottomSheet<void>(
    context: context,
    backgroundColor: const Color(0xFF071B12),
    showDragHandle: true,
    builder: (sheet) => SafeArea(child: ListView(
      shrinkWrap: true,
      children: [
        const ListTile(
          title: Text('ROYAL ONE', style: TextStyle(color: _gold)),
          subtitle: Text('One Entrance. A Whole Royal World.'),
        ),
        ...[
          ('SAHAND CONSORTIUM', const HeritagePage() as Widget),
          ('ROYAL MALL', const RoyalMallPage()),
          ('ROYAL CLUB', const RoyalClubGamePage()),
          ('ROYAL VILLAGE', const RoyalVillagePage()),
          ('ROYAL ETEHAD', const EttehadPage()),
          ('ROYAL SIGNITURE', const RoyalSignaturePage()),
          ('ROYAL HARMONIA', const RoyalHarmoniaPage()),
        ].map((entry) => ListTile(
          title: Text(entry.$1),
          trailing: const Icon(Icons.arrow_forward_ios, color: _gold),
          onTap: () {
            Navigator.of(sheet).pop();
            _push(entry.$2);
          },
        )),
      ],
    )),
  );

  void _languageChooser() => showModalBottomSheet<void>(
    context: context,
    backgroundColor: const Color(0xFF071B12),
    showDragHandle: true,
    builder: (sheet) => SafeArea(child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.all(12),
          child: Text('برای زبان‌های فارسی، انگلیسی و عربی،\nاز تنظیم زبان در صفحه مقصد استفاده کنید.',
              textAlign: TextAlign.center),
        ),
        ListTile(title: const Text('SAHAND CONSORTIUM • FA / EN / AR / FR'),
          onTap: () {Navigator.pop(sheet); _push(const HeritagePage());}),
      ],
    )),
  );

  Widget _hotspot({required String label, required double x,
      required double y, required double w, required double h,
      required VoidCallback onTap, bool circular = false}) {
    return Positioned(
      left: x, top: y - 65, width: w, height: h,
      child: Semantics(
        label: label, button: true,
        child: Material(
          color: Colors.transparent,
          shape: circular ? const CircleBorder() : null,
          child: InkWell(
            customBorder: circular ? const CircleBorder() : null,
            splashColor: const Color(0x55FFE39B),
            highlightColor: const Color(0x22FFE39B),
            onTap: onTap,
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.of(context).disableAnimations;
    return Scaffold(
      backgroundColor: const Color(0xFF03130D),
      body: SafeArea(child: Center(child: FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: _width, height: _height,
          child: ClipRect(child: Stack(children: [
            Positioned.fill(child: Image.asset(_art, key: const ValueKey('royal-one-approved-art'),
              fit: BoxFit.fill, filterQuality: FilterQuality.high,
              excludeFromSemantics: true)),
            // The static SC image is fully covered by this matching circular
            // crop. It is the only animated bubble on the home screen.
            Positioned(
              left: 384, top: 817 - 116 - 65,
              width: 232, height: 232,
              child: IgnorePointer(child: AnimatedBuilder(
                key: const ValueKey('royal-one-slow-sc-rotation'),
                animation: _globe,
                builder: (_, child) => Transform.rotate(
                  angle: reducedMotion ? 0 : 2 * math.pi * _globe.value,
                  child: child,
                ),
                child: ClipOval(child: Image.asset(_sc, fit: BoxFit.contain,
                  filterQuality: FilterQuality.high)),
              )),
            ),
            _hotspot(label: 'رویال مال | Royal Mall', x: 57, y: 408,
              w: 284, h: 288, circular: true,
              onTap: () => _push(const RoyalMallPage())),
            _hotspot(label: 'باشگاه مشتریان VIP | Royal Club', x: 337,
              y: 350, w: 327, h: 315, circular: true,
              onTap: () => _push(const RoyalClubGamePage())),
            _hotspot(label: 'کافه رویال ویلاژ | Royal Village',
              x: 658, y: 412, w: 292, h: 286, circular: true,
              onTap: () => _push(const RoyalVillagePage())),
            _hotspot(label: 'کنسرسیوم سهند | Sahand Consortium',
              x: 378, y: 701, w: 248, h: 235, circular: true,
              onTap: () => _push(const HeritagePage())),
            _hotspot(label: 'طراحی، ساخت، اجرا | Royal Etehad',
              x: 144, y: 1040, w: 188, h: 197, circular: true,
              onTap: () => _push(const EttehadPage())),
            _hotspot(label: 'خریدهای سیگنیچر | Royal Signiture',
              x: 385, y: 1040, w: 200, h: 198, circular: true,
              onTap: () => _push(const RoyalSignaturePage())),
            _hotspot(label: 'تبلیغات، سوشیال، فروش | Royal Harmonia',
              x: 656, y: 1040, w: 190, h: 201, circular: true,
              onTap: () => _push(const RoyalHarmoniaPage())),
            _hotspot(label: 'خانه | Home', x: 65, y: 1375,
              w: 176, h: 132, onTap: () {}),
            _hotspot(label: 'کشف | Explore', x: 245, y: 1375,
              w: 170, h: 132, onTap: () => _push(const RoyalExplorePage())),
            _hotspot(label: 'باشگاه مشتریان | Royal Club',
              x: 411, y: 1375, w: 181, h: 132,
              onTap: () => _push(const RoyalClubGamePage())),
            _hotspot(label: 'رزرو | Reservations', x: 594, y: 1375,
              w: 163, h: 132, onTap: () => _push(const RvGalleryPage())),
            _hotspot(label: 'حساب من | Profile', x: 758, y: 1375,
              w: 175, h: 132, onTap: () => _push(const RoyalOneMyProfilePage())),
            _hotspot(label: 'منو | Menu', x: 908, y: 75,
              w: 80, h: 65, onTap: _openMenu),
            _hotspot(label: 'انتخاب زبان | Languages',
              x: 728, y: 74, w: 180, h: 61, onTap: _languageChooser),
          ])),
        ),
      ))),
    );
  }
}
