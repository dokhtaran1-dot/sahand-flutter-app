import 'package:flutter/material.dart';

class HeritagePage extends StatelessWidget {
  const HeritagePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF071711),
    appBar: AppBar(backgroundColor: const Color(0xFF071711), foregroundColor: const Color(0xFFE7C77D), title: const Text('SAHAND / HERITAGE')),
    body: Directionality(textDirection: TextDirection.rtl, child: ListView(padding: const EdgeInsets.all(28), children: [
      Text('SC', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'serif', fontSize: 100, color: Color(0xFFE7C77D))),
      Text('SAHAND CONSORTIUM\nSINCE 1351', textAlign: TextAlign.center, textDirection: TextDirection.ltr, style: TextStyle(letterSpacing: 3, height: 1.8, color: Color(0xFFE7C77D))),
      SizedBox(height: 40),
      Text('از پدر به پسر', style: TextStyle(fontSize: 30, color: Color(0xFFE7C77D))),
      SizedBox(height: 18),
      Text('سهند از سال ۱۳۵۱، با تأسیس کارخانه توسط پدر، آغاز شد؛ نامی که میراث آن در مسیر توسعهٔ کنسرسیوم سهند ادامه یافت.', style: TextStyle(fontSize: 18, height: 2)),
      Divider(height: 60, color: Color(0xFF806B40)),
      ClipRRect(borderRadius: BorderRadius.circular(24), child: Image.asset('assets/images/1.png', height: 320, fit: BoxFit.contain)),
      const SizedBox(height: 24),
      Text('حامد قنبری', style: TextStyle(fontSize: 30, color: Color(0xFFE7C77D))),
      SizedBox(height: 10),
      Text('رئیس کنسرسیوم سهند\nسومین وارث؛ ادامه‌دهندهٔ نام سهند', style: TextStyle(fontSize: 18, height: 2)),
      SizedBox(height: 28),
      Text('MBA · UOWD Dubai\nDALF C2 · Français', textDirection: TextDirection.ltr, style: TextStyle(height: 2, letterSpacing: 1)),
    ])),
  );
}
