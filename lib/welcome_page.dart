import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  final VoidCallback onEnter;

  const WelcomePage({super.key, required this.onEnter});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  static const double _designWidth = 941;
  static const double _designHeight = 1672;

  static const List<String> _slides = [
    'assets/image/screen_01.png',
    'assets/image/screen_02.png',
    'assets/image/screen_03.png',
    'assets/image/screen_04.png',
    'assets/image/screen_05.png',
  ];

  int _currentSlide = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(milliseconds: 2500),
      (_) => _next(restart: false),
    );
  }

  void _next({bool restart = true}) {
    if (!mounted) return;
    setState(() => _currentSlide = (_currentSlide + 1) % _slides.length);
    if (restart) _startTimer();
  }

  void _previous() {
    if (!mounted) return;
    setState(() {
      _currentSlide =
          (_currentSlide - 1 + _slides.length) % _slides.length;
    });
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ClipRect(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final scale = math.min(
              constraints.maxWidth / _designWidth,
              constraints.maxHeight / _designHeight,
            );
            final canvasWidth = _designWidth * scale;
            final canvasHeight = _designHeight * scale;

            return Center(
              child: SizedBox(
                width: canvasWidth,
                height: canvasHeight,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/image/Welcome.png',
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      filterQuality: FilterQuality.high,
                      gaplessPlayback: true,
                    ),

                    // Live TV inside the existing gold frame.
                    Positioned(
                      left: canvasWidth * .105,
                      right: canvasWidth * .105,
                      top: canvasHeight * .307,
                      height: canvasHeight * .298,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onHorizontalDragEnd: (details) {
                          final v = details.primaryVelocity ?? 0;
                          if (v < -120) {
                            _next();
                          } else if (v > 120) {
                            _previous();
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24 * scale),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              const ColoredBox(color: Colors.black),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 420),
                                switchInCurve: Curves.easeOut,
                                switchOutCurve: Curves.easeIn,
                                transitionBuilder: (child, animation) =>
                                    FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                                layoutBuilder:
                                    (currentChild, previousChildren) => Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    ...previousChildren,
                                    if (currentChild != null) currentChild,
                                  ],
                                ),
                                child: Image.asset(
                                  _slides[_currentSlide],
                                  key: ValueKey<int>(_currentSlide),
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                  filterQuality: FilterQuality.high,
                                  gaplessPlayback: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Keep the artwork's five indicators, while making the TV live.
                    Positioned(
                      left: canvasWidth * .10,
                      right: canvasWidth * .10,
                      top: canvasHeight * .295,
                      height: canvasHeight * .325,
                      child: IgnorePointer(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30 * scale),
                            border: Border.all(
                              color: const Color(0xFFE8C36A),
                              width: 1.5 * scale,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ENTER THE ROYAL WORLD / ورود.
                    Positioned(
                      left: canvasWidth * .105,
                      right: canvasWidth * .105,
                      top: canvasHeight * .793,
                      height: canvasHeight * .097,
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
