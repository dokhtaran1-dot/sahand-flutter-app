import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

const _emerald = Color(0xFF061B13);
const _gold = Color(0xFFE5C37E);

/// The R1 heritage entry preserves the 1351 founding story and the original
/// nine-chapter book. The Founder title belongs exclusively to the father.
class HeritagePage extends StatelessWidget {
  const HeritagePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _emerald,
    appBar: AppBar(
      centerTitle: true, backgroundColor: _emerald,
      foregroundColor: _gold,
      title: const Text('SAHAND / HERITAGE',
        style: TextStyle(letterSpacing: 2.0, fontSize: 15)),
    ),
    body: Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 70),
        children: [
          const _HeritageSphere(),
          const SizedBox(height: 8),
          const Text('SAHAND CONSORTIUM', textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            style: TextStyle(color: _gold, letterSpacing: 3, fontSize: 15)),
          const SizedBox(height: 7),
          const Text('SINCE 1351 · TEHRAN',
            textAlign: TextAlign.center, textDirection: TextDirection.ltr,
            style: TextStyle(color: Color(0xFFB3A77E), letterSpacing: 2, fontSize: 11)),
          const SizedBox(height: 29),
          const Text('از پدر به پسر', textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30, color: _gold, fontWeight: FontWeight.w700)),
          const SizedBox(height: 15),
          const Text(
            'میراث یک نام؛ از کارخانهٔ سهند در سال ۱۳۵۱ تا توسعهٔ کنسرسیوم سهند.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFFE3DFCF), fontSize: 16, height: 2.1)),
          const SizedBox(height: 34),
          Semantics(
            label: 'تصویر تاریخی و اصلی بنیان‌گذار کارخانهٔ سهند',
            image: true,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF9B8255)),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: Color(0x442C7C56), blurRadius: 23)],
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                'assets/heritage/founder_original.jpg',
                width: double.infinity, fit: BoxFit.fitWidth,
                filterQuality: FilterQuality.high,
                errorBuilder: (_, __, ___) => const SizedBox(
                  height: 180,
                  child: Center(child: Text('تصویر تاریخی در دسترس نیست',
                    style: TextStyle(color: _gold))),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          const Text('تصویر اصلی بنیان‌گذار · سهند، از سال ۱۳۵۱',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFFC4AB76), fontSize: 13)),
          const SizedBox(height: 24),
          _heritagePanel(
            icon: Icons.auto_stories_outlined,
            eyebrow: 'THE ORIGIN · 1351',
            title: 'بنیان‌گذار سهند',
            subtitle: 'صفر قنبری درویش',
            description:
                'آغاز فعالیت کارخانهٔ سهند در خیابان مولوی تهران، سال ۱۳۵۱. '
                'ریشهٔ این مجموعه با تلاش نسل نخست و میراث پدر شکل گرفت.',
          ),
          const SizedBox(height: 15),
          _heritagePanel(
            icon: Icons.account_balance_outlined,
            eyebrow: 'THIRD GENERATION',
            title: 'سومین وارث',
            subtitle: 'حامد قنبری درویش',
            description:
                'رئیس کنسرسیوم سهند و ادامه‌دهندهٔ نامی که بنیان آن را پدر گذاشت؛ '
                'توسعهٔ میراث خانوادگی در ساختاری نو و چندشاخه.',
          ),
          const SizedBox(height: 32),
          Center(child: Container(height: 1, width: 110, color: _gold)),
          const SizedBox(height: 30),
          const Text('THE NINE-CHAPTER BOOK',
            textAlign: TextAlign.center, textDirection: TextDirection.ltr,
            style: TextStyle(color: Color(0xFFE6C885), letterSpacing: 2.2, fontSize: 12)),
          const SizedBox(height: 13),
          Semantics(
            button: true, label: 'خواندن کتاب کامل فلسفه مدیریت مرگ',
            child: Card(
              color: const Color(0xFF0E3827),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
                side: const BorderSide(color: _gold, width: 1.1)),
              child: InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PhilosophyBookPage())),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  child: Column(children: [
                    Icon(Icons.menu_book_outlined, color: _gold, size: 52),
                    SizedBox(height: 18),
                    Text('فلسفه مدیریت مرگ', textAlign: TextAlign.center,
                      style: TextStyle(color: _gold, fontSize: 25, fontWeight: FontWeight.bold)),
                    SizedBox(height: 6),
                    Text('از فروپاشی تا احیا', textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                    SizedBox(height: 10),
                    Text('کتاب کامل ۹ فصل · به قلم حامد قنبری درویش',
                      textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
                    SizedBox(height: 20),
                    Icon(Icons.arrow_forward_rounded, color: _gold, size: 28),
                  ]),
                ),
              ),
            ),
          ),
          const SizedBox(height: 38),
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0x889C8052))),
            child: Image.asset('assets/images/1.png', width: double.infinity,
              fit: BoxFit.fitWidth,
              errorBuilder: (context, error, stackTrace) => const SizedBox(
                height: 100,
                child: Center(child: Text('تصویر پرتره در دسترس نیست',
                  style: TextStyle(color: _gold))))),
          ),
          const SizedBox(height: 21),
          const Text('حامد قنبری درویش',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 27, color: _gold)),
          const SizedBox(height: 10),
          const Text('PRESIDENT · SAHAND CONSORTIUM',
            textAlign: TextAlign.center, textDirection: TextDirection.ltr,
            style: TextStyle(color: Color(0xFFB3A77E), letterSpacing: 1.6)),
          const SizedBox(height: 15),
          const Text('MBA · UOWD Dubai    |    DALF C2 · Français',
            textDirection: TextDirection.ltr, textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, height: 1.8, fontSize: 12)),
          const SizedBox(height: 38),
          const Text('A FATHER’S LEGACY. A SON’S CONTINUATION.',
            textDirection: TextDirection.ltr, textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFFBA9E68),
              fontSize: 10, letterSpacing: 1.0)),
        ],
      ),
    ),
  );

  static Widget _heritagePanel({
    required IconData icon,
    required String eyebrow,
    required String title,
    required String subtitle,
    required String description,
  }) => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: const Color(0xFF0D2E21),
      borderRadius: BorderRadius.circular(21),
      border: Border.all(color: const Color(0x887F6A42))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(icon, color: _gold, size: 30),
        const SizedBox(width: 12),
        Text(eyebrow, textDirection: TextDirection.ltr,
          style: const TextStyle(color: Color(0xFFE7C77D),
            fontSize: 10, letterSpacing: 1.5)),
      ]),
      const SizedBox(height: 12),
      Text(title, style: const TextStyle(
        color: Color(0xFFFFD99C), fontSize: 23)),
      const SizedBox(height: 8),
      Text(subtitle, style: const TextStyle(
        color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
      const SizedBox(height: 11),
      Text(description, style: const TextStyle(
        color: Color(0xFFCECBBF), fontSize: 14, height: 2.0)),
    ]),
  );
}

class _HeritageSphere extends StatefulWidget {
  const _HeritageSphere();
  @override
  State<_HeritageSphere> createState() => _HeritageSphereState();
}

class _HeritageSphereState extends State<_HeritageSphere>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 18));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      controller.stop();
    } else if (!controller.isAnimating) {
      controller.repeat();
    }
  }

  @override
  void dispose() { controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 294,
    child: AnimatedBuilder(animation: controller, builder: (context, _) {
      final angle = controller.value * 2 * math.pi;
      return Stack(alignment: Alignment.center, children: [
        Transform.rotate(
          angle: angle,
          child: Container(
            height: 266, width: 266,
            decoration: BoxDecoration(shape: BoxShape.circle,
              border: Border.all(color: const Color(0x777FBEA2)),
              gradient: const SweepGradient(colors: [
                Color(0x007FBEA2), Color(0x99D7BF78),
                Color(0x007FBEA2), Color(0x66D7BF78),
                Color(0x007FBEA2),
              ])),
          ),
        ),
        Transform.rotate(
          angle: -angle * .65,
          child: Container(
            height: 244, width: 244,
            decoration: BoxDecoration(shape: BoxShape.circle,
              border: Border.all(color: const Color(0x669B8050), width: 1.5)),
          ),
        ),
        Container(
          height: 195, width: 195,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              center: Alignment(-.38, -.4), radius: 1.15,
              colors: [Color(0xFF41715A), Color(0xFF143F30), Color(0xFF06190F)]),
            border: Border.all(color: _gold, width: 2.0),
            boxShadow: const [
              BoxShadow(color: Color(0x66459871), blurRadius: 56, spreadRadius: 8),
              BoxShadow(color: Color(0x558C7439), blurRadius: 23, offset: Offset(5, 5))],
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('SC', style: TextStyle(fontFamily: 'serif',
              fontSize: 82, color: Color(0xFFEDD099), letterSpacing: -5)),
            Container(height: 1, width: 94, color: _gold),
            const SizedBox(height: 9),
            const Text('1351', style: TextStyle(
              letterSpacing: 5, color: _gold, fontSize: 16)),
          ]),
        ),
      ]);
    }),
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
      backgroundColor: const Color(0xFF071E1B), foregroundColor: _gold,
      title: const Text('فلسفه مدیریت مرگ'),
    ),
    body: WebViewWidget(controller: _controller),
  );
}
