import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'ettehad_page.dart';
import 'royal_club_game_page.dart';
import 'royal_harmonia_page.dart';
import 'royal_mall_page.dart';
import 'royal_signature_page.dart';
import 'royal_village_page.dart';

/// The approved full-bleed artwork supplies the upper three gateways.
/// The three lower monograms are independently animated, accessible controls.
class GalaxyHomePage extends StatelessWidget {
  const GalaxyHomePage({super.key});

  static const String artwork = 'assets/image/royal_one_home_classic_full.webp';
  static const double artworkWidth = 998;
  static const double artworkHeight = 1576;
  static const double upperArtworkHeight = 1218;

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030806),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ClipRect(
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: SizedBox(
                    width: artworkWidth,
                    height: upperArtworkHeight,
                    child: Stack(
                      clipBehavior: Clip.hardEdge,
                      children: [
                        const Positioned(
                          left: 0,
                          top: 0,
                          width: artworkWidth,
                          height: artworkHeight,
                          child: Image(
                            image: AssetImage(artwork),
                            fit: BoxFit.fill,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                        Positioned(
                          left: 0,
                          top: 389,
                          width: 333,
                          height: 827,
                          child: _GatewayTapZone(
                            label: 'Royal Mall',
                            onTap: () => _open(context, const RoyalMallPage()),
                          ),
                        ),
                        Positioned(
                          left: 333,
                          top: 389,
                          width: 333,
                          height: 827,
                          child: _GatewayTapZone(
                            label: 'Royal Club',
                            onTap: () => _open(context, const RoyalClubGamePage()),
                          ),
                        ),
                        Positioned(
                          left: 666,
                          top: 389,
                          width: 332,
                          height: 827,
                          child: _GatewayTapZone(
                            label: 'Royal Village Cafe',
                            onTap: () => _open(context, const RoyalVillagePage()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _GalaxyNavigation(
              onEttehad: () => _open(context, const EttehadPage()),
              onSignature: () => _open(context, const RoyalSignaturePage()),
              onHarmonia: () => _open(context, const RoyalHarmoniaPage()),
            ),
          ],
        ),
      ),
    );
  }
}

class _GatewayTapZone extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _GatewayTapZone({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'ورود به $label',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
      ),
    );
  }
}

/// The orbs travel along three tiny, phase-shifted elliptical orbits. They
/// never cross one another, and their individual hit targets travel with them.
class _GalaxyNavigation extends StatefulWidget {
  final VoidCallback onEttehad;
  final VoidCallback onSignature;
  final VoidCallback onHarmonia;

  const _GalaxyNavigation({
    required this.onEttehad,
    required this.onSignature,
    required this.onHarmonia,
  });

  @override
  State<_GalaxyNavigation> createState() => _GalaxyNavigationState();
}

class _GalaxyNavigationState extends State<_GalaxyNavigation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _orbit;

  @override
  void initState() {
    super.initState();
    _orbit = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
  }

  @override
  void dispose() {
    _orbit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navHeight =
        (MediaQuery.sizeOf(context).height * .21).clamp(136.0, 176.0).toDouble();

    return Container(
      width: double.infinity,
      height: navHeight,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF030807), Color(0xFF0D1A15), Color(0xFF030605)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border(top: BorderSide(color: Color(0xFF9B8252), width: .8)),
      ),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                AnimatedBuilder(
                  animation: _orbit,
                  builder: (context, child) => CustomPaint(
                    painter: _GalaxyFieldPainter(progress: _orbit.value),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: _OrbitingMonogram(
                        animation: _orbit,
                        phase: 0,
                        label: 'Ettehad Sazeh Royal',
                        crop: const Rect.fromLTWH(65, 1236, 226, 226),
                        onTap: widget.onEttehad,
                      ),
                    ),
                    Expanded(
                      child: _OrbitingMonogram(
                        animation: _orbit,
                        phase: 2 * math.pi / 3,
                        label: 'Royal Signature',
                        crop: const Rect.fromLTWH(376, 1229, 246, 246),
                        emphasized: true,
                        onTap: widget.onSignature,
                      ),
                    ),
                    Expanded(
                      child: _OrbitingMonogram(
                        animation: _orbit,
                        phase: 4 * math.pi / 3,
                        label: 'Royal Harmonia',
                        crop: const Rect.fromLTWH(704, 1236, 226, 226),
                        onTap: widget.onHarmonia,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 5, left: 8, right: 8),
            child: Text(
              'ROYAL ONE  ·  V1.0.21  ·  POWERED BY SAHAND CONSORTIUM',
              maxLines: 1,
              overflow: TextOverflow.fade,
              softWrap: false,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFC2A56F),
                fontSize: 8,
                fontWeight: FontWeight.w500,
                letterSpacing: .65,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrbitingMonogram extends StatelessWidget {
  final Animation<double> animation;
  final double phase;
  final String label;
  final Rect crop;
  final bool emphasized;
  final VoidCallback onTap;

  const _OrbitingMonogram({
    required this.animation,
    required this.phase,
    required this.label,
    required this.crop,
    required this.onTap,
    this.emphasized = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final diameter = math.min(
          constraints.maxWidth * (emphasized ? .88 : .82),
          emphasized ? 112.0 : 103.0,
        );
        return Center(
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              final theta = animation.value * 2 * math.pi + phase;
              return Transform.translate(
                offset: Offset(5.0 * math.cos(theta), 7.5 * math.sin(theta)),
                child: Transform.rotate(
                  angle: .018 * math.sin(theta),
                  child: child,
                ),
              );
            },
            child: Semantics(
              button: true,
              label: 'ورود به $label',
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: diameter,
                    height: diameter,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFAD966C), width: .6),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF9F7E43).withOpacity(.15),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: _CircularArtworkCrop(source: crop),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Extract each approved classical seal at render time from the same source
/// image; this preserves the exact antique-metal artwork without flattened
/// copies or a second manually maintained image set.
class _CircularArtworkCrop extends StatelessWidget {
  final Rect source;

  const _CircularArtworkCrop({required this.source});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = constraints.maxWidth / source.width;
        return ClipOval(
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned(
                left: -source.left * scale,
                top: -source.top * scale,
                width: GalaxyHomePage.artworkWidth * scale,
                height: GalaxyHomePage.artworkHeight * scale,
                child: const Image(
                  image: AssetImage(GalaxyHomePage.artwork),
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GalaxyFieldPainter extends CustomPainter {
  final double progress;

  const _GalaxyFieldPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(1351);
    final t = progress * 2 * math.pi;

    // Tiny, understated celestial dust; each twinkles but does not jitter.
    for (var i = 0; i < 42; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = .45 + random.nextDouble() * 1.1;
      final opacity = .10 + .20 * (1 + math.sin(t + i * 1.73)) / 2;
      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()..color = const Color(0xFFDCC390).withOpacity(opacity),
      );
    }

    for (var index = 0; index < 3; index++) {
      final center = Offset(size.width * (index + .5) / 3, size.height * .56);
      final radius = math.min(size.width / 3 * .38, size.height * .36);
      canvas.drawOval(
        Rect.fromCenter(center: center, width: radius * 2.25, height: radius * .85),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = .8
          ..color = const Color(0xFFB39A66).withOpacity(.11),
      );

      final phase = index * 2 * math.pi / 3;
      final glint = Offset(
        center.dx + radius * 1.12 * math.cos(t + phase),
        center.dy + radius * .42 * math.sin(t + phase),
      );
      canvas.drawCircle(
        glint,
        1.6,
        Paint()..color = const Color(0xFFEBD3A1).withOpacity(.7),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GalaxyFieldPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
