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
  static const width = 941.0, height = 1666.0;
  String language = 'FA';
  final pages = const <Widget>[
    RoyalMallPage(), RoyalClubGamePage(), RoyalVillagePage(),
    EttehadPage(), RoyalSignaturePage(), RoyalHarmoniaPage(), HeritagePage(),
  ];
  static const names = {
    'FA': ['رویال مال', 'رویال کلاب', 'رویال ویلیج کافه', 'اتحاد', 'سیگنچر', 'هارمونیا', 'میراث سهند'],
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
        // Keep the approved SC artwork untouched; animate a subtle rim glint only.
        const _ApprovedScGlint(left: 322, top: 725, size: 290),
        _OrbPortal(label: 'RM', left: 28, top: 420, size: 278, phase: 0.0, onTap: () => open(0)),
        _OrbPortal(label: 'RC', left: 300, top: 370, size: 350, phase: 0.14, onTap: () => open(1)),
        _OrbPortal(label: 'RV', left: 635, top: 420, size: 278, phase: 0.28, onTap: () => open(2)),
        _OrbPortal(label: 'SC', left: 322, top: 725, size: 290, phase: 0.42, onTap: () => open(6)),
        _OrbPortal(label: 'RE', left: 48, top: 1030, size: 270, phase: 0.56, onTap: () => open(3)),
        _OrbPortal(label: 'RS', left: 332, top: 1030, size: 270, phase: 0.70, onTap: () => open(4)),
        _OrbPortal(label: 'RH', left: 618, top: 1030, size: 270, phase: 0.84, onTap: () => open(5)),
        // Transparent controls only: preserve all existing typography in photo.
        zone(670, 12, 188, 60, 'FA / EN / AR', languages),
        zone(865, 8, 65, 70, 'Menu', menu),
        zone(47, 1400, 164, 174, 'Home', () {}),
        zone(213, 1400, 166, 174, 'Explore', () => open(6)),
        zone(380, 1400, 176, 174, 'Royal Club', () => open(1)),
        zone(557, 1400, 175, 174, 'Reservations', () => open(2)),
        zone(733, 1400, 164, 174, 'Profile', () => Navigator.of(context).push(
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
class _OrbPortal extends StatelessWidget {
  final String label;
  final double left, top, size, phase;
  final VoidCallback onTap;
  const _OrbPortal({required this.label, required this.left, required this.top,
    required this.size, required this.phase, required this.onTap});
  @override
  Widget build(BuildContext context) => Positioned(
    key: Key('orb:' + label), left: left, top: top, width: size, height: size,
    child: Semantics(button: true, label: label, child: GestureDetector(
      behavior: HitTestBehavior.opaque, onTap: onTap,
      child: const SizedBox.expand(),
    )),
  );
}

/// Real vertical-axis rotation of the SC sphere surface, not a moving border,
/// not a tilt of the entire Home image.
/// Both hemispheres use the connected SC monogram; the original name plaque stays readable.
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
  static const texturePath = 'assets/image/SC_upright_feathered.png';
  late final AnimationController _turn = AnimationController(
    vsync: this, duration: const Duration(seconds: 22));
  ui.Image? _texture;
  ui.Image? _front;

  @override
  void initState() {
    super.initState();
    _loadTexture();
  }

  Future<void> _loadTexture() async {
    try {
      Future<ui.Image> load(String path) async {
        final data = await rootBundle.load(path);
        final codec = await ui.instantiateImageCodec(
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
        try { return (await codec.getNextFrame()).image; }
        finally { codec.dispose(); }
      }
      final texture = await load(texturePath);
      ui.Image front;
      try { front = await load('assets/image/SC_owner_approved_front.png'); }
      catch (_) { texture.dispose(); rethrow; }
      if (!mounted) { texture.dispose(); front.dispose(); return; }
      setState(() { _texture = texture; _front = front; });
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
    _front?.dispose();
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
          if (_texture == null || _front == null) return const SizedBox.expand();
          return RepaintBoundary(child: CustomPaint(
            painter: _VerticalScSpherePainter(
              texture: _texture!,
              front: _front!,
              turn: _turn.value * math.pi * 2,
            ),
            child: const SizedBox.expand(),
          ));
        },
      ),
    ),
  );
}

class _VerticalScSpherePainter extends CustomPainter {
  final ui.Image texture;
  final ui.Image front;
  final double turn;

  const _VerticalScSpherePainter({required this.texture, required this.front, required this.turn});

  @override
  void paint(Canvas canvas, Size size) {
    final diameter = size.shortestSide;
    final center = Offset(size.width / 2, size.height / 2);
    final globe = Rect.fromCircle(center: center, radius: diameter / 2 - 1);
    final clip = Path()..addOval(globe);
    canvas.save();
    canvas.clipPath(clip, doAntiAlias: true);
    // Keep the approved front plaque level and readable throughout the spin.
    canvas.drawImageRect(front, Rect.fromLTWH(0, 0, front.width.toDouble(), front.height.toDouble()), globe,
      Paint()..filterQuality = FilterQuality.high);
    canvas.saveLayer(globe, Paint());

    // The screenshot supplies the *front* of the sphere. Its equirectangular
    // green-and-gold SC panorama supplies the back. A textured spherical mesh
    // advances around the vertical Y axis, so the sphere stays round while its
    // surface actually moves from left to right.
    const segments = 64;
    final positions = <Offset>[];
    final texCoords = <Offset>[];
    final faces = <int>[];
    final panoWidth = texture.width.toDouble();
    final panoHeight = texture.height.toDouble();

    for (var row = 0; row <= segments; row++) {
      final yn = -1.0 + 2.0 * row / segments;
      for (var col = 0; col <= segments; col++) {
        final xn = -1.0 + 2.0 * col / segments;
        final z = math.sqrt(math.max(0.0, 1.0 - xn * xn - yn * yn));
        final longitude = math.atan2(xn, z);
        final latitude = math.asin(yn.clamp(-1.0, 1.0));

        // Subtract turn: landmass and SC emblem travel LEFT -> RIGHT.
        // Unwrapped U + repeated ImageShader avoids a discontinuous seam.
        final u = (longitude - turn + math.pi) / (2 * math.pi);
        final v = (latitude + math.pi / 2) / math.pi;

        positions.add(Offset(
          globe.left + (xn + 1) * globe.width / 2,
          globe.top + (yn + 1) * globe.height / 2,
        ));
        texCoords.add(Offset(u * panoWidth, v * panoHeight));

        if (row < segments && col < segments) {
          final n = row * (segments + 1) + col;
          faces.addAll([n, n + 1, n + segments + 1]);
          faces.addAll([n + 1, n + segments + 2, n + segments + 1]);
        }
      }
    }

    final vertices = ui.Vertices(
      ui.VertexMode.triangles,
      positions,
      textureCoordinates: texCoords,
      indices: faces,
    );
    final surface = Paint()
      ..isAntiAlias = true
      ..filterQuality = FilterQuality.high
      ..shader = ui.ImageShader(
        texture, ui.TileMode.repeated, ui.TileMode.clamp,
        Matrix4.identity().storage,
      );
    canvas.drawVertices(vertices, ui.BlendMode.srcOver, surface);

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
    // The upper globe and connected SC rotate, while the original name plaque
    // remains fixed; feather the transition before the English text begins.
    canvas.drawRect(globe, Paint()
      ..blendMode = BlendMode.dstIn
      ..shader = ui.Gradient.linear(globe.topCenter, globe.bottomCenter,
        const [Colors.white, Colors.white, Colors.transparent, Colors.transparent],
        const [0, .53, .625, 1]));
    canvas.restore();
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
      old.turn != turn || old.texture != texture || old.front != front;
}

class _ApprovedScGlint extends StatefulWidget {
  final double left, top, size;
  const _ApprovedScGlint({required this.left, required this.top, required this.size});
  @override
  State<_ApprovedScGlint> createState() => _ApprovedScGlintState();
}
class _ApprovedScGlintState extends State<_ApprovedScGlint> with SingleTickerProviderStateMixin {
  late final AnimationController turn = AnimationController(vsync: this, duration: const Duration(seconds: 22));
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) { turn.stop(); }
    else if (!turn.isAnimating) { turn.repeat(); }
  }
  @override
  void dispose() { turn.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Positioned(left: widget.left, top: widget.top, width: widget.size, height: widget.size,
    child: IgnorePointer(child: AnimatedBuilder(animation: turn, builder: (_, __) => CustomPaint(
      painter: _ApprovedScGlintPainter(turn.value * 2 * math.pi), child: const SizedBox.expand()))));
}
class _ApprovedScGlintPainter extends CustomPainter {
  final double angle;
  const _ApprovedScGlintPainter(this.angle);
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCircle(center: size.center(Offset.zero), radius: size.shortestSide * .475);
    canvas.drawArc(rect, angle, .20, false, Paint()..color = const Color(0x99FFF0AC)..style = PaintingStyle.stroke..strokeWidth = 2..strokeCap = StrokeCap.round);
  }
  @override
  bool shouldRepaint(covariant _ApprovedScGlintPainter old) => old.angle != angle;
}
