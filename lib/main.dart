import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
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
