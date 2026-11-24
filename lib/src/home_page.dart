import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'royal_mall_page.dart';
import 'royal_village_page.dart';
import 'royal_club_game_page.dart';
import 'royal_signature_page.dart';
import 'ettehad_page.dart';
import 'royal_harmonia_page.dart';
import 'heritage_page.dart';

/// Approved artwork is retained verbatim. The viewport excludes only the
/// captured phone system bars; all controls share the artwork coordinate space.
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const art = 'assets/image/royal_one_approved_v21.jpg';
  static const width = 972.0, topCrop = 72.0, height = 1428.0;
  String language = 'FA';
  final pages = const <Widget>[
    RoyalMallPage(), RoyalClubGamePage(), RoyalVillagePage(),
    EttehadPage(), RoyalSignaturePage(), RoyalHarmoniaPage(), HeritagePage(),
  ];
  static const names = {
    'FA': ['رویال مال', 'رویال کلاب', 'رویال ویلاژ کافه', 'اتحاد', 'سیگنچر', 'هارمونیا', 'میراث سهند'],
    'EN': ['Royal Mall', 'Royal Club', 'Royal Village Café', 'Ettehad', 'Signature', 'Harmonia', 'Sahand Heritage'],
    'AR': ['رويال مول', 'رويال كلوب', 'رويال فيلاج كافيه', 'اتحاد', 'سيغنتشر', 'هارمونيا', 'إرث سهند'],
  };
  void open(int index) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => pages[index]));

  void menu() => showModalBottomSheet<void>(
    context: context, backgroundColor: const Color(0xFF071711),
    builder: (sheet) => SafeArea(child: SingleChildScrollView(child: Column(
      mainAxisSize: MainAxisSize.min, children: [
        const Padding(padding: EdgeInsets.all(16), child: Text('ROYAL ONE', style: TextStyle(color: Color(0xFFE7C77D), letterSpacing: 3))),
        for (var i = 0; i < pages.length; i++) ListTile(
          title: Text(names[language]![i]), trailing: const Icon(Icons.chevron_right, color: Color(0xFFE7C77D)),
          onTap: () { Navigator.pop(sheet); open(i); },
        ),
      ],
    ))),
  );

  void languages() => showModalBottomSheet<void>(
    context: context, backgroundColor: const Color(0xFF071711),
    builder: (sheet) => SafeArea(child: Column(mainAxisSize: MainAxisSize.min, children: [
      for (final code in names.keys) ListTile(title: Text({'FA':'فارسی', 'EN':'English', 'AR':'العربية'}[code]!),
        trailing: language == code ? const Icon(Icons.check, color: Color(0xFFE7C77D)) : null,
        onTap: () { setState(() => language = code); Navigator.pop(sheet); menu(); }),
    ])),
  );

  Widget zone(double x, double y, double w, double h, String label, VoidCallback tap, {bool glow = false, double radius = 24}) => Positioned(
    left: x, top: y - topCrop, width: w, height: h,
    child: RoyalTouchTarget(label: label, onTap: tap, glow: glow, radius: radius),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF030B08),
    body: SafeArea(child: Center(child: FittedBox(fit: BoxFit.contain, child: SizedBox(
      width: width, height: height,
      child: ClipRect(child: Stack(children: [
        const Positioned(left: 0, top: -topCrop, width: width, height: 1536, child: Image(image: AssetImage(art), fit: BoxFit.fill, filterQuality: FilterQuality.high, excludeFromSemantics: true)),
        // Seven circular portals are restored as separate animated widgets.
        _RoyalOrb(left: 46, top: 330, size: 285, title: 'RM', subtitle: 'ROYAL MALL', tint: const Color(0xFF5DA9FF), image: art, alignment: const Alignment(-.9, 0), onTap: () => open(0)),
        _RoyalOrb(left: 345, top: 310, size: 300, title: 'RC', subtitle: 'ROYAL CLUB', tint: const Color(0xFFFFB75B), image: art, alignment: const Alignment(0, 0), onTap: () => open(1)),
        _RoyalOrb(left: 653, top: 330, size: 285, title: 'RV', subtitle: 'ROYAL VILLAGE', tint: const Color(0xFF65DB8B), image: art, alignment: const Alignment(.9, 0), onTap: () => open(2)),
        _RoyalOrb(left: 324, top: 650, size: 320, title: 'SC', subtitle: 'SAHAND CONSORTIUM', tint: const Color(0xFFE8C36A), image: 'assets/image/sc_restored_v22.png', alignment: const Alignment(-.7, -.8), onTap: () => open(6)),
        _RoyalOrb(left: 108, top: 1050, size: 206, title: 'RE', subtitle: 'ETTEHAD', tint: const Color(0xFFE8C36A), image: art, alignment: const Alignment(-.8, .9), onTap: () => open(3)),
        _RoyalOrb(left: 382, top: 1050, size: 206, title: 'RS', subtitle: 'SIGNATURE', tint: const Color(0xFFE8C36A), image: art, alignment: const Alignment(0, .9), onTap: () => open(4)),
        _RoyalOrb(left: 656, top: 1050, size: 206, title: 'RH', subtitle: 'HARMONIA', tint: const Color(0xFFE8C36A), image: art, alignment: const Alignment(.8, .9), onTap: () => open(5)),
        const Positioned(left: 0, top: 1383, width: width, height: 45,
          child: ColoredBox(color: Color(0xFF030B08), child: Center(
            child: Text('ROYAL ONE  ·  V1.0.23  ·  POWERED BY SAHAND CONSORTIUM',
              style: TextStyle(color: Color(0xFFD7BE78), fontSize: 17, letterSpacing: 1.4))))),
        // Portals own their circular hit areas; no oversized invisible rectangles overlap them.
        zone(40, 76, 263, 207, names[language]![6], () => open(6), glow: true, radius: 70),
        zone(680, 91, 187, 64, 'FA / EN / AR', languages),
        zone(875, 86, 66, 75, 'Menu', menu),
      ])),
    )))),
  );
}

class RoyalTouchTarget extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool glow;
  final double radius;
  const RoyalTouchTarget({super.key, required this.label, required this.onTap, this.glow = false, this.radius = 24});
  @override
  State<RoyalTouchTarget> createState() => _RoyalTouchTargetState();
}
class _RoyalTouchTargetState extends State<RoyalTouchTarget> with SingleTickerProviderStateMixin {
  late final AnimationController pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200));
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations || !widget.glow) { pulse.stop(); } else { pulse.repeat(reverse: true); }
  }
  @override
  void dispose() { pulse.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Semantics(button: true, label: widget.label,
    child: Tooltip(message: widget.label, child: AnimatedBuilder(animation: pulse,
      builder: (_, child) => DecoratedBox(decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.radius),
        border: widget.glow ? Border.all(color: Color.lerp(const Color(0x22E7C77D), const Color(0xAAFFE5A0), pulse.value)!, width: 2) : null,
        boxShadow: widget.glow ? [BoxShadow(color: Color.lerp(Colors.transparent, const Color(0x44FFD577), pulse.value)!, blurRadius: 14)] : [],
      ), child: child),
      child: Material(color: Colors.transparent, borderRadius: BorderRadius.circular(widget.radius), clipBehavior: Clip.antiAlias,
        child: InkWell(onTap: widget.onTap, splashColor: const Color(0x66E7C77D), highlightColor: const Color(0x33E7C77D))),
    )),
  );
}


class _RoyalOrb extends StatefulWidget {
  final double left, top, size;
  final String title, subtitle, image;
  final Color tint;
  final Alignment alignment;
  final VoidCallback? onTap;
  const _RoyalOrb({required this.left, required this.top, required this.size, required this.title, required this.subtitle, required this.tint, required this.image, required this.alignment, this.onTap});
  @override
  State<_RoyalOrb> createState() => _RoyalOrbState();
}
class _RoyalOrbState extends State<_RoyalOrb> with SingleTickerProviderStateMixin {
  late final AnimationController spin = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 22),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      spin.stop();
      spin.value = 0;
    } else if (!spin.isAnimating) {
      spin.repeat();
    }
  }

  @override
  void dispose() {
    spin.dispose();
    super.dispose();
  }

  Widget sphere(double angle) {
    final light = Alignment(math.cos(angle), math.sin(angle));
    final shadow = Alignment(-math.cos(angle), -math.sin(angle));
    final art = ClipOval(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            widget.image,
            fit: BoxFit.cover,
            alignment: widget.alignment,
            color: const Color(0x9900140B),
            colorBlendMode: BlendMode.multiply,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: light,
                end: shadow,
                colors: [
                  widget.tint.withOpacity(.36),
                  Colors.transparent,
                  const Color(0x99000000),
                  widget.tint.withOpacity(.15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    final rim = Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: widget.tint, width: 7),
        gradient: SweepGradient(
          transform: GradientRotation(angle),
          colors: [
            Colors.transparent,
            const Color(0xFFFFF0B2),
            Colors.transparent,
            widget.tint.withOpacity(.35),
            Colors.transparent,
          ],
        ),
      ),
    );
    final label = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontSize: widget.size * .24,
              fontWeight: FontWeight.w900,
              color: const Color(0xFFFFE9B2),
              shadows: const [Shadow(color: Colors.black, blurRadius: 12)],
            ),
          ),
          Text(
            widget.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: widget.size * .058,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: widget.tint.withOpacity(.48),
            blurRadius: 28,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [art, rim, label],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.left,
      top: widget.top,
      width: widget.size,
      height: widget.size,
      child: Semantics(
        button: true,
        label: widget.subtitle,
        child: GestureDetector(
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: AnimatedBuilder(
            animation: spin,
            builder: (context, child) => sphere(spin.value * math.pi * 2),
          ),
        ),
      ),
    );
  }
}
