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
  DateTime _now = DateTime.now();

  Timer? _slideTimer;
  Timer? _clockTimer;

  @override
  void initState() {
    super.initState();

    _slideTimer = Timer.periodic(
      const Duration(seconds: 2),
      (_) => _nextSlide(),
    );

    _clockTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (!mounted) return;
        setState(() {
          _now = DateTime.now();
        });
      },
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

  String _two(int n) => n.toString().padLeft(2, '0');

  @override
  void dispose() {
    _slideTimer?.cancel();
    _clockTimer?.cancel();
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
              Image.asset(
                'assets/image/Welcome.png',
                fit: BoxFit.fill,
                filterQuality: FilterQuality.high,
              ),

              // ساعت واقعی - بالا سمت چپ
              Positioned(
                top: h * 0.032,
                left: w * 0.075,
                child: Text(
                  '${_two(_now.hour)}:${_two(_now.minute)}',
                  style: TextStyle(
                    color: const Color(0xFFFFE3A1),
                    fontSize: w * 0.038,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                    shadows: const [
                      Shadow(
                        blurRadius: 8,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),

              // TV - فقط داخل قاب
              Positioned(
                left: w * 0.245,
                width: w * 0.51,
                top: h * 0.474,
                height: h * 0.105,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Image.asset(
                      _slides[_currentSlide],
                      key: ValueKey(_currentSlide),
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
              ),

              // فلش چپ - ناحیه لمس نامرئی
              Positioned(
                left: w * 0.16,
                top: h * 0.49,
                width: w * 0.09,
                height: h * 0.08,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _previousSlide,
                  child: const SizedBox.expand(),
                ),
              ),

              // فلش راست - ناحیه لمس نامرئی
              Positioned(
                right: w * 0.16,
                top: h * 0.49,
                width: w * 0.09,
                height: h * 0.08,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _nextSlide,
                  child: const SizedBox.expand(),
                ),
              ),

              // ENTER
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