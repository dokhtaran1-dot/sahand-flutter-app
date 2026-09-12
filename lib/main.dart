import 'package:flutter/material.dart';

import 'welcome_page.dart';
import 'src/home_page.dart';

void main() {
  runApp(const EntryApp());
}

class EntryApp extends StatefulWidget {
  const EntryApp({super.key});

  @override
  State<EntryApp> createState() => _EntryAppState();
}

class _EntryAppState extends State<EntryApp> {
  bool _entered = false;

  @override
  Widget build(BuildContext context) {
    if (_entered) {
      return const MaterialApp(
        title: 'ROYAL 1',
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      );
    }

    return MaterialApp(
      title: 'ROYAL 1',
      debugShowCheckedModeBanner: false,
      home: WelcomePage(
        onEnter: () {
          setState(() {
            _entered = true;
          });
        },
      ),
    );
  }
}
