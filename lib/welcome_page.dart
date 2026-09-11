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
  final List<String> _slides = [
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double w = constraints.maxWidth;
          final double h = constraints.maxHeight;

          return Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/image/Welcome.png',
                fit: BoxFit.fill,
                filterQuality: FilterQuality.high,
              ),

              // TV / SLIDER
              Positioned(
                left: w * 0.235,
                width: w * 0.53,
                top: h * 0.500,
                height: h * 0.132,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),

                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },

                    layoutBuilder: (currentChild, previousChildren) {
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          ...previousChildren,
                          if (currentChild != null) currentChild,
                        ],
                      );
                    },

                    child: SizedBox.expand(
                      key: ValueKey<int>(_currentSlide),
                      child: Image.asset(
                        _slides[_currentSlide],
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                ),
              ),

              // LEFT ARROW
              Positioned(
                left: w * 0.145,
                top: h * 0.505,
                width: w * 0.10,
                height: h * 0.09,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _previousSlide,
                  child: const SizedBox.expand(),
                ),
              ),

              // RIGHT ARROW
              Positioned(
                right: w * 0.145,
                top: h * 0.505,
                width: w * 0.10,
                height: h * 0.09,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _nextSlide,
                  child: const SizedBox.expand(),
                ),
              ),

              // ENTER BUTTON
              Positioned(
                left: w * 0.235,
                right: w * 0.235,
                bottom: h * 0.105,
                height: h * 0.065,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: widget.onEnter,
                  child: const SizedBox.expand(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}