import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'generated/final420_0.dart';
import 'generated/final420_1.dart';
import 'generated/final420_2.dart';
import 'generated/final420_3.dart';
import 'generated/final420_4.dart';
import 'generated/final420_5.dart';

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
  static const List<String> _slides = [
    'assets/image/screen_01.png',
    'assets/image/screen_02.png',
    'assets/image/screen_03.png',
    'assets/image/screen_04.png',
    'assets/image/screen_05.png',
  ];

  late final Uint8List _backgroundBytes;
  Timer? _timer;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _backgroundBytes = base64Decode(
      final420_0 +
          final420_1 +
          final420_2 +
          final420_3 +
          final420_4 +
          final420_5,
    );
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 2500), (_) {
      if (!mounted) return;
      setState(() => _current = (_current + 1) % _slides.length);
    });
  }

  void _next() {
    setState(() => _current = (_current + 1) % _slides.length);
    _startTimer();
  }

  void _previous() {
    setState(() => _current = (_current - 1 + _slides.length) % _slides.length);
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;

          return Stack(
            fit: StackFit.expand,
            children: [
              Image.memory(
                _backgroundBytes,
                fit: BoxFit.fill,
                gaplessPlayback: true,
                filterQuality: FilterQuality.high,
              ),

              // TV content: every slide is shown completely. Nothing is cropped.
              Positioned(
                left: w * 0.067,
                right: w * 0.070,
                top: h * 0.290,
                height: h * 0.272,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onHorizontalDragEnd: (details) {
                    final velocity = details.primaryVelocity ?? 0;
                    if (velocity < -120) {
                      _next();
                    } else if (velocity > 120) {
                      _previous();
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(w * 0.006),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        const ColoredBox(color: Colors.black),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 420),
                          switchInCurve: Curves.easeOut,
                          switchOutCurve: Curves.easeIn,
                          transitionBuilder: (child, animation) =>
                              FadeTransition(opacity: animation, child: child),
                          layoutBuilder: (currentChild, previousChildren) => Stack(
                            fit: StackFit.expand,
                            children: [
                              ...previousChildren,
                              if (currentChild != null) currentChild,
                            ],
                          ),
                          child: Center(
                            child: Image.asset(
                              _slides[_current],
                              key: ValueKey(_current),
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.contain,
                              alignment: Alignment.center,
                              filterQuality: FilterQuality.high,
                              gaplessPlayback: true,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: h * 0.008,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _slides.length,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: index == _current ? w * 0.015 : w * 0.012,
                                height: index == _current ? w * 0.015 : w * 0.012,
                                margin: EdgeInsets.symmetric(horizontal: w * 0.007),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: index == _current
                                      ? const Color(0xFFE00020)
                                      : Colors.white.withOpacity(0.92),
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

              Positioned(
                left: w * 0.175,
                right: w * 0.175,
                top: h * 0.848,
                height: h * 0.083,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.white10,
                    highlightColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(w * 0.08),
                    onTap: widget.onEnter,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
