import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  final VoidCallback onEnter;

  const WelcomePage({
  super.key,
  required this.onEnter,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/image/welcome.png',
            fit: BoxFit.contain,
          ),
          Positioned(
            left: 70,
            right: 70,
            bottom: 115,
            height: 85,
            child: GestureDetector(
              onTap: onEnter,
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