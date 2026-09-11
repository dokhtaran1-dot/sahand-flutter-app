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

  final List<String> _slides = const [
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
    _slideTimer = Timer.periodic(
      const Duration(seconds: 2),
      (_) => _nextSlide(),
    );
  }

  void _nextSlide() {
    if (!mounted) return;
    setState(() {
      _currentSlide = (_currentSlide + 1) % _slides.length;
    });
  }

  void _previousSlide() {
    if (!mounted) return;
    setState(() {
      _currentSlide =
          (_currentSlide - 1 + _slides.length) % _slides.length;
    });
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
            // Scale the complete 1024 x 1536 design uniformly. This removes
            // distortion while keeping every interactive layer locked to the
            // same coordinates as the background artwork.
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
                    Image.asset(
                      'assets/image/Welcome.png',
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                    ),

                    // TV / SLIDER
                    Positioned(
                      left: canvasWidth * 0.235,
                      width: canvasWidth * 0.53,
                      top: canvasHeight * 0.515,
                      height: canvasHeight * 0.132,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8 * scale),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
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
                          ),
                        ),
                      ),
                    ),

                    // LEFT ARROW
                    Positioned(
                      left: canvasWidth * 0.145,
                      top: canvasHeight * 0.520,
                      width: canvasWidth * 0.10,
                      height: canvasHeight * 0.09,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: _previousSlide,
                        child: const SizedBox.expand(),
                      ),
                    ),

                    // RIGHT ARROW
                    Positioned(
                      right: canvasWidth * 0.145,
                      top: canvasHeight * 0.520,
                      width: canvasWidth * 0.10,
                      height: canvasHeight * 0.09,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: _nextSlide,
                        child: const SizedBox.expand(),
                      ),
                    ),

                    // ENTER BUTTON
                    Positioned(
                      left: canvasWidth * 0.235,
                      right: canvasWidth * 0.235,
                      bottom: canvasHeight * 0.055,
                      height: canvasHeight * 0.075,
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
