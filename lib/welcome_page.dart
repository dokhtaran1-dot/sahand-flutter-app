import 'dart:async';
import 'dart:math' as math;

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
  static const double _designWidth = 1024;
  static const double _designHeight = 1536;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ClipRect(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Keep the artwork proportional and fill the full screen without
            // stretching. This is the same 1024x1536 master layout used for
            // the final Royal 1 welcome artwork.
            final scale = math.max(
              constraints.maxWidth / _designWidth,
              constraints.maxHeight / _designHeight,
            );
            final canvasWidth = _designWidth * scale;
            final canvasHeight = _designHeight * scale;

            return OverflowBox(
              alignment: Alignment.center,
              minWidth: canvasWidth,
              maxWidth: canvasWidth,
              minHeight: canvasHeight,
              maxHeight: canvasHeight,
              child: SizedBox(
                width: canvasWidth,
                height: canvasHeight,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // FINAL FIRST-PAGE ARTWORK.
                    // Replace only assets/image/Welcome.png when artwork changes;
                    // the live carousel and button stay aligned automatically.
                    Image.asset(
                      'assets/image/Welcome.png',
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      filterQuality: FilterQuality.high,
                    ),

                    // LIVE TV: five images, each shown for exactly 2.5 seconds.
                    Positioned(
                      left: canvasWidth * 0.066,
                      right: canvasWidth * 0.066,
                      top: canvasHeight * 0.322,
                      height: canvasHeight * 0.270,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onHorizontalDragEnd: (details) {
                          final velocity = details.primaryVelocity ?? 0;
                          if (velocity < -120) {
                            _nextSlide();
                          } else if (velocity > 120) {
                            _previousSlide();
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8 * scale),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Container(color: Colors.black),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 420),
                                switchInCurve: Curves.easeOut,
                                switchOutCurve: Curves.easeIn,
                                transitionBuilder: (child, animation) =>
                                    FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
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

                              // Five clean carousel indicators.
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 10 * scale,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    _slides.length,
                                    (index) => AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 220),
                                      width: 8 * scale,
                                      height: 8 * scale,
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 5 * scale,
                                      ),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: index == _currentSlide
                                            ? const Color(0xFFE00020)
                                            : Colors.white.withOpacity(0.88),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black54,
                                            blurRadius: 4,
                                          ),
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
                    ),

                    // ENTER THE ROYAL WORD / ورود button hit area.
                    Positioned(
                      left: canvasWidth * 0.195,
                      right: canvasWidth * 0.195,
                      top: canvasHeight * 0.855,
                      height: canvasHeight * 0.095,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: widget.onEnter,
                        child: const SizedBox.expand(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
