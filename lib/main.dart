import 'package:flutter/material.dart';

import 'src/home_page.dart';

void main() {
  runApp(const RoyalOneApp());
}

class RoyalOneApp extends StatelessWidget {
  const RoyalOneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'ROYAL 1',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
