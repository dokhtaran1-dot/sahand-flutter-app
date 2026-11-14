import 'package:flutter/material.dart';
import 'rs/rs_site_mobile.dart'
    if (dart.library.html) 'rs/rs_site_web.dart' as rs;

/// Original Beyond Gravity design bundled as local Flutter assets.
class RoyalSignaturePage extends StatelessWidget {
  const RoyalSignaturePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF090C0A),
    appBar: AppBar(
      backgroundColor: const Color(0xFF090C0A),
      foregroundColor: const Color(0xFFDFC189),
      toolbarHeight: 44,
      centerTitle: true,
      title: const Text('ROYAL ONE / RS',
        style: TextStyle(letterSpacing: 2, fontSize: 12)),
    ),
    body: const SafeArea(top: false, child: rs.RsSiteView()),
  );
}
