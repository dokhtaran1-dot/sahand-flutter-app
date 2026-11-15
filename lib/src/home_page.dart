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

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late final AnimationController _portalMotion;

  @override
  void initState() {
    super.initState();
    _portalMotion = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _portalMotion.stop();
    } else if (!_portalMotion.isAnimating) {
      _portalMotion.repeat();
    }
  }

  @override
  void dispose() {
    _portalMotion.dispose();
    super.dispose();
  }

  /// Subtle vertical floating only: no spinning texts or dizzy effects.
  /// The original six functional entrances and the approved Heritage poster
  /// remain unchanged; only the main home hero is simplified.
  Widget floatingPortal({
    required double left,
    required double top,
    required double diameter,
    required String monogram,
    required String name,
    required VoidCallback onTap,
    required double phase,
    bool featured = false,
  }) => Positioned(
    left: left, top: top, width: diameter, height: diameter + 116,
    child: AnimatedBuilder(
      animation: _portalMotion,
      builder: (context, child) {
        final reduceMotion = MediaQuery.of(context).disableAnimations;
        final floatY = reduceMotion ? 0.0 :
            math.sin(_portalMotion.value * 2 * math.pi + phase) *
                (featured ? 12.0 : 9.0);
        return Transform.translate(offset: Offset(0, floatY), child: child);
      },
      child: RoyalTouchTarget(
        key: ValueKey('royal-home-portal-$monogram'),
        label: 'ENTER $name', onTap: onTap,
        radius: diameter / 2, child: Column(children: [
          Container(
            width: diameter, height: diameter,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                center: Alignment(-.35, -.45), radius: 1.05,
                colors: [Color(0xFF24533C), Color(0xFF0B2D20), Color(0xFF03150F)]),
              border: Border.all(color: const Color(0xFFDCC282),
                  width: featured ? 3 : 2),
              boxShadow: const [BoxShadow(
                color: Color(0x55705C27), blurRadius: 19, spreadRadius: 2)],
            ),
            child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(monogram, style: TextStyle(
                color: const Color(0xFFF1D897),
                fontFamily: 'serif', fontWeight: FontWeight.w500,
                fontSize: featured ? 82 : 70, letterSpacing: 4)),
              const SizedBox(height: 6),
              Container(width: diameter * .3, height: 1,
                color: const Color(0x77DCC282)),
            ])),
          ),
          const SizedBox(height: 18),
          Text(name, textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFFEEDBAD),
              fontSize: 20, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          const Text('ENTER', style: TextStyle(
            color: Color(0xFFA9A68D), fontSize: 15, letterSpacing: 3)),
        ]),
      ),
    ),
  );

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
        const Positioned(left: 0, top: -topCrop, width: width, height: 1536,
          child: Image(image: AssetImage(art), fit: BoxFit.fill, filterQuality: FilterQuality.high, excludeFromSemantics: true)),
        // Only the former large SC footprint is replaced by a compact logo.
        Positioned(left: 0, top: 0, width: 325, height: 292,
          child: DecoratedBox(
            key: const ValueKey('royal-home-sc-compact'),
            decoration: const BoxDecoration(gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [Color(0xFF04120D), Color(0xFF0B2D20), Color(0xFF03120C)])),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(width: 126, height: 126,
                decoration: BoxDecoration(shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFDCC282), width: 2),
                  gradient: const RadialGradient(colors: [
                    Color(0xFF20503B), Color(0xFF041B12)])),
                child: const Center(child: Text('SC',
                  style: TextStyle(fontFamily: 'serif', fontSize: 48,
                    color: Color(0xFFEAD49C), letterSpacing: 1.5)))),
              const SizedBox(height: 13),
              const Text('SAHAND CONSORTIUM',
                style: TextStyle(color: Color(0xFFDBC68F),
                  fontSize: 15, letterSpacing: 1.6)),
            ]),
          )),
        // Conceal the three fixed large portal artworks, not other sections.
        const Positioned(left: 0, top: 326, width: width, height: 795,
          child: DecoratedBox(decoration: BoxDecoration(
            gradient: RadialGradient(radius: 1.0,
              colors: [Color(0xFF0C3325), Color(0xFF03130D)])))),
        floatingPortal(left: 51, top: 474, diameter: 236,
          monogram: 'RM', name: names[language]![0],
          onTap: () => open(0), phase: 0),
        floatingPortal(left: 343, top: 436, diameter: 286,
          monogram: 'RC', name: names[language]![1],
          onTap: () => open(1), phase: 2.1, featured: true),
        floatingPortal(left: 684, top: 474, diameter: 236,
          monogram: 'RV', name: names[language]![2],
          onTap: () => open(2), phase: 4.2),
        const Positioned(left: 0, top: 1383, width: width, height: 45,
          child: ColoredBox(color: Color(0xFF030B08), child: Center(
            child: Text('ROYAL ONE  ·  V1.0.22  ·  POWERED BY SAHAND CONSORTIUM',
              style: TextStyle(color: Color(0xFFD7BE78), fontSize: 17, letterSpacing: 1.4))))),
        // Tapping the small SC opens the unchanged Heritage poster.
        zone(93, 78, 153, 173, names[language]![6],
          () => open(6), radius: 80),
        zone(680, 91, 187, 64, 'FA / EN / AR', languages),
        zone(875, 86, 66, 75, 'Menu', menu),
        zone(78, 1215, 214, 224, names[language]![3], () => open(3), glow: true, radius: 112),
        zone(377, 1215, 214, 224, names[language]![4], () => open(4), glow: true, radius: 112),
        zone(685, 1215, 214, 224, names[language]![5], () => open(5), glow: true, radius: 112),
      ])),
    )))),
  );
}

class RoyalTouchTarget extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool glow;
  final double radius;
  final Widget? child;
  const RoyalTouchTarget({super.key, required this.label, required this.onTap, this.glow = false, this.radius = 24, this.child});
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
        child: InkWell(onTap: widget.onTap, splashColor: const Color(0x66E7C77D), highlightColor: const Color(0x33E7C77D), child: widget.child)),
    )),
  );
}
