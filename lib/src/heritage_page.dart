import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
      const Divider(height: 60, color: Color(0xFF806B40)),
      Card(
        color: const Color(0xFF103D32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Color(0xFFE7C77D))),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PhilosophyBookPage())),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 18),
            child: Column(children: [
              Icon(Icons.auto_stories_outlined, color: Color(0xFFE7C77D), size: 48),
              SizedBox(height: 14),
              Text('فلسفه مدیریت مرگ', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFFE7C77D), fontSize: 26)),
              SizedBox(height: 8),
              Text('از فروپاشی تا احیا', style: TextStyle(color: Colors.white70, fontSize: 17)),
              SizedBox(height: 8),
              Text('کتاب کامل ۹ فصل · به قلم حامد قنبری درویش', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
              SizedBox(height: 20),
              Text('لمس کنید و کتاب را بخوانید  ←', style: TextStyle(color: Color(0xFFE7C77D), fontSize: 15)),
            ]),
          ),
        ),
      ),
      const Divider(height: 60, color: Color(0xFF806B40)),
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

class PhilosophyBookPage extends StatefulWidget {
  const PhilosophyBookPage({super.key});

  @override
  State<PhilosophyBookPage> createState() => _PhilosophyBookPageState();
}

class _PhilosophyBookPageState extends State<PhilosophyBookPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF071E1B))
      ..loadFlutterAsset('assets/heritage/philosophy_book.html');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF071E1B),
    appBar: AppBar(
      backgroundColor: const Color(0xFF071E1B),
      foregroundColor: const Color(0xFFE7C77D),
      title: const Text('فلسفه مدیریت مرگ'),
    ),
    body: WebViewWidget(controller: _controller),
  );
}
