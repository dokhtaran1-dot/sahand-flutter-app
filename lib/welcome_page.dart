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
  late Timer _slideTimer;
  late Timer _clockTimer;
  DateTime _now = DateTime.now();

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
        if (mounted) {
          setState(() {
            _now = DateTime.now();
          });
        }
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

  String get _timeText {
    final hour = _now.hour.toString().padLeft(2, '0');
    final minute = _now.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  void dispose() {
    _slideTimer.cancel();
    _clockTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/image/Welcome.png',
            fit: BoxFit.fill,
            filterQuality: FilterQuality.high,
          ),

          // ساعت واقعی
          Positioned(
            top: 28,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Center(
                child: Text(
                  _timeText,
                  style: const TextStyle(
                    color: Color(0xFFFFD979),
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2,
                    shadows: [
                      Shadow(
                        blurRadius: 8,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // تلویزیون / اسلایدشو
          Positioned(
            left: 38,
            right: 38,
            top: MediaQuery.of(context).size.height * 0.50,
            height: MediaQuery.of(context).size.height * 0.16,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child: Image.asset(
                  _slides[_currentSlide],
                  key: ValueKey(_currentSlide),
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
          ),

          // فلش چپ
          Positioned(
            left: 8,
            top: MediaQuery.of(context).size.height * 0.54,
            child: IconButton(
              onPressed: _previousSlide,
              icon: const Icon(
                Icons.chevron_left,
                size: 38,
                color: Color(0xFFFFD979),
              ),
            ),
          ),

          // فلش راست
          Positioned(
            right: 8,
            top: MediaQuery.of(context).size.height * 0.54,
            child: IconButton(
              onPressed: _nextSlide,
              icon: const Icon(
                Icons.chevron_right,
                size: 38,
                color: Color(0xFFFFD979),
              ),
            ),
          ),

          // دکمه ENTER روی همان محل تصویر
          Positioned(
            left: 55,
            right: 55,
            bottom: 95,
            height: 78,
            child: GestureDetector(
              onTap: widget.onEnter,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}