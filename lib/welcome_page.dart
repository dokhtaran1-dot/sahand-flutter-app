import 'dart:async';

import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  final VoidCallback onEnter;

  const WelcomePage({
    super.key,
    required this.onEnter,
  });

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  static const double _designWidth = 941;
  static const double _designHeight = 1672;

  static const Color _gold = Color(0xFFFFD58A);
  static const Color _deepGold = Color(0xFFB56B17);
  static const Color _ice = Color(0xFF9FEAFF);
  static const Color _burgundy = Color(0xFF69000D);

  static const List<String> _slides = [
    'assets/image/screen_01.png',
    'assets/image/screen_02.png',
    'assets/image/screen_03.png',
    'assets/image/screen_04.png',
    'assets/image/screen_05.png',
  ];

  int _currentSlide = 0;
  Timer? _slideTimer;

  @override
  void initState() {
    super.initState();
    _startSlider();
  }

  void _startSlider() {
    _slideTimer?.cancel();
    _slideTimer = Timer.periodic(
      const Duration(milliseconds: 2500),
      (_) => _nextSlide(restartTimer: false),
    );
  }

  void _nextSlide({bool restartTimer = true}) {
    if (!mounted) return;
    setState(() {
      _currentSlide = (_currentSlide + 1) % _slides.length;
    });
    if (restartTimer) _startSlider();
  }

  void _previousSlide() {
    if (!mounted) return;
    setState(() {
      _currentSlide =
          (_currentSlide - 1 + _slides.length) % _slides.length;
    });
    _startSlider();
  }

  @override
  void dispose() {
    _slideTimer?.cancel();
    super.dispose();
  }

  Widget _buildTopBrand() {
    return const SizedBox(
      width: _designWidth,
      height: 390,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 42,
            child: SizedBox(
              width: 330,
              height: 220,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Positioned(
                    top: 16,
                    child: Text(
                      'R',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 178,
                        height: 1,
                        fontWeight: FontWeight.w600,
                        color: _gold,
                        shadows: [
                          Shadow(color: Color(0xFFFFF2C7), blurRadius: 4),
                          Shadow(color: _deepGold, blurRadius: 14),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 73,
                    top: 42,
                    child: Text(
                      '1',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 112,
                        height: 1,
                        fontWeight: FontWeight.w700,
                        color: _ice,
                        shadows: [
                          Shadow(color: Colors.white, blurRadius: 4),
                          Shadow(color: Color(0xFF009DFF), blurRadius: 18),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    child: Icon(
                      Icons.workspace_premium_rounded,
                      size: 40,
                      color: _gold,
                      shadows: [
                        Shadow(color: _deepGold, blurRadius: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 255,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'ROYAL ',
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 70,
                      fontWeight: FontWeight.w500,
                      color: _gold,
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(color: _deepGold, blurRadius: 10),
                      ],
                    ),
                  ),
                  TextSpan(
                    text: '1',
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 70,
                      fontWeight: FontWeight.w700,
                      color: _ice,
                      shadows: [
                        Shadow(color: Colors.white, blurRadius: 3),
                        Shadow(color: Color(0xFF009DFF), blurRadius: 14),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 355,
            child: Text(
              'WELCOME TO ROYAL FAMILY',
              style: TextStyle(
                fontFamily: 'serif',
                fontSize: 29,
                fontWeight: FontWeight.w400,
                letterSpacing: 6.2,
                color: _gold,
                shadows: [
                  Shadow(color: _deepGold, blurRadius: 7),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: _gold, width: 4),
        boxShadow: [
          BoxShadow(
            color: _gold.withOpacity(0.55),
            blurRadius: 14,
            spreadRadius: 1,
          ),
          const BoxShadow(
            color: Colors.black,
            blurRadius: 22,
            spreadRadius: 6,
          ),
        ],
      ),
      padding: const EdgeInsets.all(9),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: const Color(0xFF6B3F13), width: 2),
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragEnd: (details) {
            final velocity = details.primaryVelocity ?? 0;
            if (velocity < -100) {
              _nextSlide();
            } else if (velocity > 100) {
              _previousSlide();
            }
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 420),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                layoutBuilder: (currentChild, previousChildren) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      ...previousChildren,
                      if (currentChild != null) currentChild,
                    ],
                  );
                },
                child: Image.asset(
                  _slides[_currentSlide],
                  key: ValueKey<int>(_currentSlide),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  filterQuality: FilterQuality.high,
                  gaplessPlayback: true,
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 22,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _slides.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: index == _currentSlide ? 13 : 11,
                      height: index == _currentSlide ? 13 : 11,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == _currentSlide
                            ? const Color(0xFFFF001F)
                            : Colors.white.withOpacity(0.90),
                        boxShadow: const [
                          BoxShadow(color: Colors.black, blurRadius: 4),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnterButton() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onEnter,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(58),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8E0016), Color(0xFF3C0007)],
          ),
          border: Border.all(color: _gold, width: 3),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF001D).withOpacity(0.70),
              blurRadius: 18,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: _gold.withOpacity(0.35),
              blurRadius: 9,
            ),
          ],
        ),
        child: Stack(
          children: [
            const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'ENTER THE ROYAL WORD',
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 27,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.1,
                      color: _gold,
                      shadows: [
                        Shadow(color: _deepGold, blurRadius: 5),
                      ],
                    ),
                  ),
                  SizedBox(height: 1),
                  Text(
                    'ورود',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: 31,
                      fontWeight: FontWeight.w400,
                      color: _gold,
                      shadows: [
                        Shadow(color: _deepGold, blurRadius: 5),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Positioned(
              right: 36,
              top: 0,
              bottom: 0,
              child: Icon(
                Icons.chevron_right_rounded,
                size: 50,
                color: _gold,
                shadows: [Shadow(color: _deepGold, blurRadius: 6)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ClipRect(
        child: SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            alignment: Alignment.center,
            child: SizedBox(
              width: _designWidth,
              height: _designHeight,
              child: Stack(
                children: [
                  const Positioned.fill(
                    child: CustomPaint(painter: _LuxuryBackdropPainter()),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    child: _buildTopBrand(),
                  ),
                  Positioned(
                    left: 47,
                    right: 47,
                    top: 455,
                    height: 505,
                    child: _buildSlider(),
                  ),
                  Positioned(
                    left: 190,
                    right: 190,
                    top: 1450,
                    height: 108,
                    child: _buildEnterButton(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LuxuryBackdropPainter extends CustomPainter {
  const _LuxuryBackdropPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final background = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF080203),
          Color(0xFF090202),
          Color(0xFF050303),
          Color(0xFF080101),
        ],
        stops: [0.0, 0.36, 0.66, 1.0],
      ).createShader(rect);
    canvas.drawRect(rect, background);

    final burgundyGlow = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF7A0012).withOpacity(0.35),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width * 0.52, size.height * 0.70),
        radius: size.width * 0.78,
      ));
    canvas.drawRect(rect, burgundyGlow);

    // Red silk/light ribbons across the upper background.
    final ribbonPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4
      ..shader = const LinearGradient(
        colors: [
          Color(0x00000000),
          Color(0xFFFF001E),
          Color(0xFF4D000B),
          Color(0xFFFF001E),
          Color(0x00000000),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, 330));

    final ribbons = <Path>[
      Path()
        ..moveTo(-40, 75)
        ..cubicTo(210, -20, 250, 26, 460, 104)
        ..cubicTo(650, 175, 725, 80, 980, 18),
      Path()
        ..moveTo(-20, 18)
        ..cubicTo(190, 90, 270, 94, 430, 62)
        ..cubicTo(640, 20, 760, 150, 990, 130),
      Path()
        ..moveTo(5, 170)
        ..cubicTo(165, 93, 290, 125, 490, 188)
        ..cubicTo(690, 250, 810, 212, 950, 145),
    ];
    for (final path in ribbons) {
      canvas.drawPath(path, ribbonPaint);
    }

    final sparkle = Paint()
      ..color = const Color(0xFFFF1632)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(const Offset(288, 45), 8, sparkle);
    canvas.drawCircle(const Offset(770, 104), 5, sparkle);

    // Glossy black-marble floor.
    final floorRect = Rect.fromLTWH(0, 980, size.width, size.height - 980);
    final floor = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF090304), Color(0xFF080505), Color(0xFF020202)],
      ).createShader(floorRect);
    canvas.drawRect(floorRect, floor);

    final marbleRed = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = const Color(0xFF9E0017).withOpacity(0.42);
    final marbleGold = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = const Color(0xFFD39443).withOpacity(0.30);

    final marbleLines = <Path>[
      Path()
        ..moveTo(0, 1140)
        ..cubicTo(190, 1095, 340, 1175, 520, 1132)
        ..cubicTo(670, 1096, 820, 1160, 950, 1120),
      Path()
        ..moveTo(35, 1275)
        ..cubicTo(210, 1208, 320, 1320, 490, 1268)
        ..cubicTo(680, 1213, 760, 1318, 930, 1278),
      Path()
        ..moveTo(-20, 1398)
        ..cubicTo(190, 1350, 300, 1434, 492, 1382)
        ..cubicTo(690, 1328, 810, 1442, 970, 1390),
      Path()
        ..moveTo(156, 1002)
        ..cubicTo(210, 1130, 170, 1225, 260, 1320)
        ..cubicTo(330, 1394, 286, 1515, 350, 1660),
      Path()
        ..moveTo(720, 980)
        ..cubicTo(670, 1110, 750, 1210, 690, 1320)
        ..cubicTo(620, 1445, 710, 1540, 650, 1675),
    ];

    for (var i = 0; i < marbleLines.length; i++) {
      canvas.drawPath(marbleLines[i], i.isEven ? marbleRed : marbleGold);
    }

    // Soft reflections/glints in the floor.
    final glint = Paint()
      ..color = const Color(0xFFFFC268).withOpacity(0.78)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7);
    canvas.drawCircle(const Offset(454, 1246), 5, glint);
    canvas.drawCircle(const Offset(250, 1198), 4, glint);
    canvas.drawCircle(const Offset(735, 1338), 4, glint);

    final reflection = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFFFB84D).withOpacity(0.22),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 1000, size.width, 580));
    canvas.drawRect(Rect.fromLTWH(0, 1000, size.width, 580), reflection);

    // Small red-lit side bases like the approved artwork.
    final sideBase = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFDB001D), Color(0xFF3A0007)],
      ).createShader(const Rect.fromLTWH(0, 0, 90, 120));
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(75, 1115, 62, 92), const Radius.circular(7)),
      sideBase,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(size.width - 137, 1115, 62, 92), const Radius.circular(7)),
      sideBase,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
