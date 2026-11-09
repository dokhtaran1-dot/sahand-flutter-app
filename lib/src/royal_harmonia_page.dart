import 'package:flutter/material.dart';
import 'rh/rh_site_mobile.dart'
    if (dart.library.html) 'rh/rh_site_web.dart' as rh;

/// Uses the complete, bundled RH site so its presentation remains identical.
class RoyalHarmoniaPage extends StatelessWidget {
  const RoyalHarmoniaPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF07100E),
    appBar: AppBar(
      backgroundColor: const Color(0xFF07100E),
      foregroundColor: const Color(0xFFD9C493),
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 44,
      centerTitle: true,
      title: const Text('ROYAL ONE / RH',
          style: TextStyle(letterSpacing: 2, fontSize: 12)),
    ),
    body: const SafeArea(top: false, child: rh.RhSiteView()),
  );
}
