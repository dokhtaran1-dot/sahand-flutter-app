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
                width: w,
                height: h,
                fit: BoxFit.fill,
                filterQuality: FilterQuality.high,
                gaplessPlayback: true,
              ),

              // ENTER THE ROYAL WORLD
              Positioned(
                left: w * 0.20,
                right: w * 0.20,
                top: h * 0.81,
                height: h * 0.105,
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
