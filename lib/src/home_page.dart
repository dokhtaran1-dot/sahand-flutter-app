import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'royal_mall_page.dart';
import 'royal_village_page.dart';
import 'royal_club_game_page.dart';
import 'royal_signature_page.dart';
import 'ettehad_page.dart';
import 'royal_harmonia_page.dart';
import 'heritage_page.dart';
import 'royal_club_profile_page.dart';

/// Approved artwork is retained verbatim. The viewport excludes only the
/// captured phone system bars; all controls share the artwork coordinate space.
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const art = 'assets/image/ROYAL_ONE_HOME_APPROVED_FINAL.png';
  static const width = 972.0, height = 1428.0;
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
    left: x, top: y, width: w, height: h,
    child: RoyalTouchTarget(label: label, onTap: tap, glow: glow, radius: radius),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF030B08),
    body: SafeArea(child: Center(child: FittedBox(fit: BoxFit.contain, child: SizedBox(
      width: width, height: height,
      child: ClipRect(child: Stack(children: [
        // Original seven-orb photograph; never layer new drawn spheres on it.
        const Positioned.fill(child: Image(image: AssetImage(art),
          fit: BoxFit.fill, filterQuality: FilterQuality.high, excludeFromSemantics: true)),
        // Move SC globe artwork across its OWN VERTICAL AXIS (22 seconds).
        // All other spheres remain the owner's approved high-quality artwork.
        const _VerticalSpinningSc(left: 375, top: 599, size: 222),
        _OrbPortal(label: 'RM', left: 79, top: 330, size: 249, phase: 0.0, onTap: () => open(0)),
        _OrbPortal(label: 'RC', left: 347, top: 274, size: 283, phase: 0.14, onTap: () => open(1)),
        _OrbPortal(label: 'RV', left: 659, top: 333, size: 250, phase: 0.28, onTap: () => open(2)),
        _OrbPortal(label: 'SC', left: 372, top: 597, size: 226, phase: 0.42, onTap: () => open(6)),
        _OrbPortal(label: 'RE', left: 152, top: 912, size: 188, phase: 0.56, onTap: () => open(3)),
        _OrbPortal(label: 'RS', left: 398, top: 912, size: 188, phase: 0.70, onTap: () => open(4)),
        _OrbPortal(label: 'RH', left: 648, top: 912, size: 188, phase: 0.84, onTap: () => open(5)),
        // Transparent controls only: preserve all existing typography in photo.
        zone(693, 0, 172, 75, 'FA / EN / AR', languages),
        zone(867, 0, 86, 81, 'Menu', menu),
        zone(68, 1228, 174, 155, 'Home', () {}),
        zone(246, 1228, 166, 155, 'Explore', () => open(6)),
        zone(413, 1228, 165, 155, 'Royal Club', () => open(1)),
        zone(581, 1228, 162, 155, 'Reservations', () => open(2)),
        zone(745, 1228, 165, 155, 'Profile', () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const RoyalClubProfilePage()))),
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


 
/// Only an invisible circular tap region and a tiny 22-second moving rim glint.
/// The seven spheres and their text are preserved in the approved image.
class _OrbPortal extends StatefulWidget {
  final String label;
  final double left, top, size, phase;
  final VoidCallback onTap;
  const _OrbPortal({
    required this.label, required this.left, required this.top,
    required this.size, required this.phase, required this.onTap,
  });
  @override
  State<_OrbPortal> createState() => _OrbPortalState();
}

class _OrbPortalState extends State<_OrbPortal> with SingleTickerProviderStateMixin {
  late final AnimationController orbit = AnimationController(
    vsync: this, duration: const Duration(seconds: 22));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      orbit.stop();
      orbit.value = 0;
    } else if (!orbit.isAnimating) {
      orbit.repeat();
    }
  }

  @override
  void dispose() {
    orbit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Positioned(
    key: Key('orb:' + widget.label),
    left: widget.left, top: widget.top,
    width: widget.size, height: widget.size,
    child: Semantics(
      button: true,
      label: widget.label,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: widget.onTap,
          customBorder: const CircleBorder(),
          splashColor: const Color(0x20FFE9B0),
          child: AnimatedBuilder(
            animation: orbit,
            builder: (_, __) => IgnorePointer(
              child: CustomPaint(
                painter: _OrbRimGlint((orbit.value + widget.phase) * math.pi * 2),
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _OrbRimGlint extends CustomPainter {
  final double angle;
  const _OrbRimGlint(this.angle);
  @override
  void paint(Canvas canvas, Size size) {
    final r = size.shortestSide / 2 - 3;
    final oval = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2), radius: r);
    final glow = Paint()
      ..color = const Color(0x55FFF3BD)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawArc(oval, angle, .22, false, glow);
  }
  @override
  bool shouldRepaint(covariant _OrbRimGlint old) => old.angle != angle;
}


/// Real vertical-axis rotation of the SC sphere surface, not a moving border,
/// not a tilt of the entire Home image, and not an extra opaque logo disc.
/// One frame from the owner's approved photo is remapped along globe meridians.
/// Back-facing longitudes mirror the reference where a back texture is absent.
class _VerticalSpinningSc extends StatefulWidget {
  final double left, top, size;
  const _VerticalSpinningSc({
    required this.left, required this.top, required this.size,
  });

  @override
  State<_VerticalSpinningSc> createState() => _VerticalSpinningScState();
}

class _VerticalSpinningScState extends State<_VerticalSpinningSc>
    with SingleTickerProviderStateMixin {
  static const texturePath = 'assets/image/ROYAL_ONE_SC_GLOBE_TEXTURE.png';
  late final AnimationController _turn = AnimationController(
    vsync: this, duration: const Duration(seconds: 22));
  ui.Image? _texture;

  @override
  void initState() {
    super.initState();
    _loadTexture();
  }

  Future<void> _loadTexture() async {
    try {
      final data = await rootBundle.load(texturePath);
      final codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
      final frame = await codec.getNextFrame();
      codec.dispose();
      if (!mounted) {
        frame.image.dispose();
        return;
      }
      setState(() => _texture = frame.image);
    } catch (error) {
      debugPrint('SC globe texture unavailable: $error');
      // Original sphere stays visible beneath the overlay.
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _turn.stop();
      _turn.value = 0;
    } else if (!_turn.isAnimating) {
      _turn.repeat();
    }
  }

  @override
  void dispose() {
    _turn.dispose();
    _texture?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Positioned(
    left: widget.left,
    top: widget.top,
    width: widget.size,
    height: widget.size,
    child: IgnorePointer(
      child: AnimatedBuilder(
        animation: _turn,
        builder: (_, __) {
          if (_texture == null) return const SizedBox.expand();
          return CustomPaint(
            painter: _VerticalScSpherePainter(
              texture: _texture!,
              turn: _turn.value * math.pi * 2,
            ),
            child: const SizedBox.expand(),
          );
        },
      ),
    ),
  );
}

class _VerticalScSpherePainter extends CustomPainter {
  final ui.Image texture;
  final double turn;

  const _VerticalScSpherePainter({required this.texture, required this.turn});

  @override
  void paint(Canvas canvas, Size size) {
    final diameter = size.shortestSide;
    final center = Offset(size.width / 2, size.height / 2);
    final globe = Rect.fromCircle(center: center, radius: diameter / 2 - 1);
    final clip = Path()..addOval(globe);
    canvas.save();
    canvas.clipPath(clip, doAntiAlias: true);

    // Each thin slice shows a different globe longitude. The edge slices
    // compress towards the rim, creating a round, revolving sphere instead of
    // a flat photo flipping like a card. Negative phase moves the surface
    // visually left-to-right, around the sphere's vertical axis.
    const strips = 180;
    final sw = texture.width.toDouble();
    final sh = texture.height.toDouble();
    final dw = globe.width / strips;
    final paint = Paint()..filterQuality = FilterQuality.medium;
    for (var i = 0; i < strips; i++) {
      final x = (i + .5) / strips * 2 - 1;
      final longitude = math.asin(x.clamp(-1.0, 1.0));
      final globeLongitude = longitude + math.pi / 2 - turn;
      final sample = (1 - math.cos(globeLongitude)) / 2;
      final sourceX = (sample * (sw - 1)).clamp(0.0, sw - 2).toDouble();
      final source = Rect.fromLTWH(sourceX, 0, 2, sh);
      final destination = Rect.fromLTWH(
        globe.left + i * dw, globe.top, dw + .8, globe.height);
      canvas.drawImageRect(texture, source, destination, paint);
    }

    final lighting = Paint()
      ..shader = ui.Gradient.linear(
        Offset(globe.left, globe.center.dy),
        Offset(globe.right, globe.center.dy),
        const [
          Color(0x77000705),
          Color(0x00000000),
          Color(0x00000000),
          Color(0x68000803),
        ],
        const [0, .28, .64, 1],
      );
    canvas.drawRect(globe, lighting);
    canvas.restore();

    // The reference's orbital rings remain part of the untouched backdrop.
    // Only a subtle boundary blends the animated globe into those rings.
    canvas.drawCircle(
      center,
      diameter / 2 - 1,
      Paint()
        ..color = const Color(0x77F0C46A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
  }

  @override
  bool shouldRepaint(covariant _VerticalScSpherePainter old) =>
      old.turn != turn || old.texture != texture;
}
