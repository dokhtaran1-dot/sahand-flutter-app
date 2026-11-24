import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'welcome_page.dart';
import 'src/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const url = String.fromEnvironment('SUPABASE_URL');
  const anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  // Backend/session restore must never prevent the approved home screen from
  // launching. Authentication remains active whenever initialization succeeds.
  if (url.isNotEmpty && anonKey.isNotEmpty) {
    try {
      await Supabase.initialize(url: url, anonKey: anonKey);
    } catch (error, stackTrace) {
      debugPrint('Royal One: Supabase initialization failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      // RC pages report their own authentication errors if the backend is down.
    }
  }
  try {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
  } catch (error) {
    debugPrint('Royal One: Android system UI setup failed: $error');
  }
  runApp(const RoyalOneApp());
}

class RoyalOneApp extends StatelessWidget {
  const RoyalOneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ROYAL 1',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const _EntryGate(),
    );
  }
}

class _EntryGate extends StatefulWidget {
  const _EntryGate();

  @override
  State<_EntryGate> createState() => _EntryGateState();
}

class _EntryGateState extends State<_EntryGate> {
  bool entered = false;

  @override
  Widget build(BuildContext context) {
    if (entered) return const HomePage();
    return WelcomePage(onEnter: () => setState(() => entered = true));
  }
}
