import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  final VoidCallback onEnter;

  const WelcomePage({super.key, required this.onEnter});

  static const String _art = 'assets/image/Welcome.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            _art,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            filterQuality: FilterQuality.high,
            isAntiAlias: true,
            gaplessPlayback: true,
          ),
          // The original artwork already contains the Enter button.
          // This transparent zone makes that button functional.
          Positioned(
            left: MediaQuery.sizeOf(context).width * .12,
            right: MediaQuery.sizeOf(context).width * .12,
            bottom: MediaQuery.sizeOf(context).height * .035,
            height: MediaQuery.sizeOf(context).height * .16,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onEnter,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
