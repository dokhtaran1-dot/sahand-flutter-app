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
        const Positioned(left: 0, top: -topCrop, width: width, height: 1536,
          child: Image(image: AssetImage(art), fit: BoxFit.fill, filterQuality: FilterQuality.high, excludeFromSemantics: true)),
        // Local restoration only: keep all original portal artwork untouched.
        Positioned(left: 0, top: 0, width: 320, height: 292,
          child: ClipRect(child: ShaderMask(
            blendMode: BlendMode.dstIn,
            shaderCallback: (rect) => const LinearGradient(
              colors: [Colors.white, Colors.white, Colors.transparent],
              stops: [0, .96, 1],
            ).createShader(rect),
            child: Stack(children: [
              Positioned(left: 0, top: -topCrop, width: width, height: 1536,
                child: Image.asset('assets/image/sc_restored_v22.png',
                  fit: BoxFit.fill, filterQuality: FilterQuality.high,
                  excludeFromSemantics: true)),
            ]),
          ))),
        const Positioned(left: 0, top: 1383, width: width, height: 45,
          child: ColoredBox(color: Color(0xFF030B08), child: Center(
            child: Text('ROYAL ONE  ·  V1.0.22  ·  POWERED BY SAHAND CONSORTIUM',
              style: TextStyle(color: Color(0xFFD7BE78), fontSize: 17, letterSpacing: 1.4))))),
        // Entire portals including their ENTER buttons are interactive.
        zone(33, 451, 306, 718, names[language]![0], () => open(0), radius: 145),
        zone(346, 451, 288, 718, names[language]![1], () => open(1), radius: 145),
        zone(641, 451, 301, 718, names[language]![2], () => open(2), radius: 145),
        for (var i = 0; i < 3; i++) zone(73 + i * 296, 1097, 235, 51,
          'ENTER ${names[language]![i]}', () => open(i), glow: true),
        zone(40, 76, 263, 207, names[language]![6], () => open(6), glow: true, radius: 70),
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
