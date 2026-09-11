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
      _currentSlide = (_currentSlide + 1