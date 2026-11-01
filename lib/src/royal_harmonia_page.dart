import 'package:flutter/material.dart';

class RoyalHarmoniaPage extends StatelessWidget {
  const RoyalHarmoniaPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF08090D),
    appBar: AppBar(
      backgroundColor: const Color(0xFF08090D),
      foregroundColor: const Color(0xFFD6B779),
      centerTitle: true,
      title: const Text('RH · ROYAL HARMONIA', style: TextStyle(letterSpacing: 1.8, fontSize: 15)),
    ),
    body: const SafeArea(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(28),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.auto_awesome, size: 72, color: Color(0xFFD6B779)),
            SizedBox(height: 22),
            Text('ROYAL HARMONIA', style: TextStyle(color: Color(0xFFF3EBDD), fontSize: 24, letterSpacing: 2.2)),
            SizedBox(height: 10),
            Text('RH', style: TextStyle(color: Color(0xFFD6B779), fontSize: 16, letterSpacing: 4)),
          ]),
        ),
      ),
    ),
  );
}
