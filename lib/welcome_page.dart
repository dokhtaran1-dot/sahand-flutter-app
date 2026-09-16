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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;
          return Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/image/Welcome.png',
                fit: BoxFit.cover,
                alignment: Alignment.center,
                filterQuality: FilterQuality.high,
                gaplessPlayback: true,
              ),
              Positioned(
                left: w * 0.16,
                right: w * 0.16,
                top: h * 0.79,
                height: h * 0.13,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onEnter,
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
