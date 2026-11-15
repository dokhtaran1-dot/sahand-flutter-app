import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

const _bg = Color(0xFF06140F);
const _panel = Color(0xFF0C251B);
const _gold = Color(0xFFD8B874);
const _ivory = Color(0xFFF4EBDA);
const _muted = Color(0xFFBFB8A8);

/// The heritage page is an editorial family-history experience, not a
/// full-screen poster. Portraits are kept as the original supplied assets.
/// The Founder is the father; the son is the third heir and President.
class HeritagePage extends StatelessWidget {
  const HeritagePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _bg,
    appBar: AppBar(
      backgroundColor: _bg,
      foregroundColor: _gold,
      centerTitle: true,
      toolbarHeight: 58,
      title: const Text('SAHAND  ·  HERITAGE',
        style: TextStyle(fontFamily: 'serif', fontSize: 14,
          letterSpacing: 2.6, fontWeight: FontWeight.w600)),
    ),
    body: SafeArea(
      top: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 44),
              children: const [
                _HeritageMasthead(),
                SizedBox(height: 19),
                _GoldDivider(),
                SizedBox(height: 21),
                Text('از پدر به پسر',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _ivory, fontSize: 25,
                    fontWeight: FontWeight.w700, height: 1.45)),
                SizedBox(height: 6),
                Text('یک نام، یک ریشه، یک میراث ماندگار',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _muted, fontSize: 13,
                    height: 1.8)),
                SizedBox(height: 23),
                _FounderStoryCard(),
                SizedBox(height: 14),
                _SuccessorStoryCard(),
                SizedBox(height: 25),
                _GoldDivider(),
                SizedBox(height: 20),
                _BookEntry(),
                SizedBox(height: 26),
                Text('A FATHER’S LEGACY · A SON’S CONTINUATION',
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFFB29B6C),
                    fontSize: 10, letterSpacing: 1.1)),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _GoldDivider extends StatelessWidget {
  const _GoldDivider();
  @override
  Widget build(BuildContext context) => const Row(children: [
    Expanded(child: Divider(color: Color(0x665B6F59), thickness: 1)),
    SizedBox(width: 12),
    Icon(Icons.diamond_outlined, color: _gold, size: 15),
    SizedBox(width: 12),
    Expanded(child: Divider(color: Color(0x665B6F59), thickness: 1)),
  ]);
}

class _HeritageMasthead extends StatelessWidget {
  const _HeritageMasthead();

  @override
  Widget build(BuildContext context) => const Column(children: [
    SizedBox(height: 8),
    _HeritageSphere(),
    SizedBox(height: 1),
    Text('SAHAND CONSORTIUM',
      textAlign: TextAlign.center, textDirection: TextDirection.ltr,
      style: TextStyle(fontFamily: 'serif', fontSize: 17,
        color: _gold, letterSpacing: 2.7, fontWeight: FontWeight.w600)),
    SizedBox(height: 7),
    Text('TEHRAN  ·  EST. 1351',
      textAlign: TextAlign.center, textDirection: TextDirection.ltr,
      style: TextStyle(fontSize: 10,
        color: _muted, letterSpacing: 2.7)),
  ]);
}

/// Fully contained in its own box; the rings never overflow the top of page.
class _HeritageSphere extends StatefulWidget {
  const _HeritageSphere();
  @override
  State<_HeritageSphere> createState() => _HeritageSphereState();
}

class _HeritageSphereState extends State<_HeritageSphere>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
      vsync: this, duration: const Duration(seconds: 28));

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
    height: 212,
    child: AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final a = controller.value * math.pi * 2;
        return Stack(alignment: Alignment.center, children: [
          Transform.rotate(
            angle: a,
            child: Container(width: 192, height: 192,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0x887D967A), width: .75),
                gradient: const SweepGradient(colors: [
                  Color(0x0011AA88), Color(0x88D1AE66),
                  Color(0x0011AA88), Color(0x55B7D1A2),
                  Color(0x0011AA88),
                ]),
              )),
          ),
          Transform.rotate(
            angle: -a * .7,
            child: Container(width: 173, height: 173,
              decoration: BoxDecoration(shape: BoxShape.circle,
                border: Border.all(color: const Color(0xAA9A7E4A), width: .8))),
          ),
          Container(
            width: 153, height: 153,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                center: Alignment(-.36, -.5), radius: 1.2,
                colors: [Color(0xFF3C715A), Color(0xFF164433), _bg]),
              border: Border.all(color: _gold, width: 1.5),
              boxShadow: const [
                BoxShadow(color: Color(0x332D8D65),
                    blurRadius: 27, spreadRadius: 3),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('SC',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(fontFamily: 'serif',
                    fontSize: 60, color: _gold, letterSpacing: -3.5)),
                const SizedBox(height: 1),
                Container(height: 1, width: 65, color: _gold),
                const SizedBox(height: 7),
                const Text('1351',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(fontSize: 12,
                    letterSpacing: 3.5, color: _gold)),
              ],
            ),
          ),
        ]);
      },
    ),
  );
}

class _FounderStoryCard extends StatelessWidget {
  const _FounderStoryCard();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: _panel,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0x887C653D), width: .8),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(child: Padding(
          padding: const EdgeInsets.fromLTRB(1, 8, 12, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('THE FOUNDER  ·  1351',
                textDirection: TextDirection.ltr,
                style: TextStyle(fontSize: 10,
                  letterSpacing: 1, color: _gold)),
              SizedBox(height: 11),
              Text('صفر قنبری درویش',
                style: TextStyle(fontSize: 18,
                  color: _ivory, fontWeight: FontWeight.w800,
                  height: 1.5)),
              SizedBox(height: 4),
              Text('بنیان‌گذار کارخانه سهند',
                style: TextStyle(fontSize: 13, color: _gold)),
              SizedBox(height: 12),
              Text('تهران، خیابان مولوی · سال ۱۳۵۱',
                style: TextStyle(fontSize: 12,
                  color: _muted, height: 1.8)),
              SizedBox(height: 6),
              Text('آغاز میراثی که نسل‌های بعد نام آن را حفظ کردند.',
                style: TextStyle(fontSize: 12,
                  color: _muted, height: 1.85)),
            ],
          ),
        )),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset('assets/heritage/founder_original.jpg',
            width: 125, height: 176,
            fit: BoxFit.cover, alignment: Alignment.topCenter,
            filterQuality: FilterQuality.high,
            errorBuilder: (_, __, ___) => const SizedBox(
              width: 125, height: 176,
              child: ColoredBox(color: Color(0xFF15392C),
                child: Icon(Icons.history_edu_outlined,
                  size: 35, color: _gold))),
          ),
        ),
      ],
    ),
  );
}

class _SuccessorStoryCard extends StatelessWidget {
  const _SuccessorStoryCard();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF0A2018),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0x557C653D), width: .8),
    ),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('THE THIRD HEIR',
            textDirection: TextDirection.ltr,
            style: TextStyle(color: _gold, fontSize: 10, letterSpacing: 1.8)),
          SizedBox(height: 10),
          Text('حامد قنبری درویش',
            style: TextStyle(color: _ivory,
              fontSize: 18, fontWeight: FontWeight.w800)),
          SizedBox(height: 5),
          Text('رئیس کنسرسیوم سهند · سومین وارث',
            style: TextStyle(color: _gold, fontSize: 12, height: 1.8)),
          SizedBox(height: 11),
          Text('ادامه‌دهندهٔ میراث پدر و توسعه‌دهندهٔ آن در قالب کنسرسیوم سهند.',
            style: TextStyle(color: _muted, fontSize: 12, height: 1.9)),
          SizedBox(height: 10),
          Text('MBA · UOWD Dubai  |  DALF C2',
            textDirection: TextDirection.ltr,
            style: TextStyle(color: Color(0xFFAD9F81), fontSize: 10)),
        ],
      )),
      const SizedBox(width: 11),
      ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset('assets/images/1.png',
          width: 94, height: 135,
          fit: BoxFit.cover, alignment: Alignment.topCenter,
          filterQuality: FilterQuality.high,
          errorBuilder: (_, __, ___) => const SizedBox(
            width: 94, height: 135,
            child: ColoredBox(color: Color(0xFF15392C),
              child: Icon(Icons.person_outline, color: _gold, size: 30))),
        ),
      ),
    ]),
  );
}

class _BookEntry extends StatelessWidget {
  const _BookEntry();
  @override
  Widget build(BuildContext context) => Material(
    color: const Color(0xFF0D3125),
    borderRadius: BorderRadius.circular(18),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => const PhilosophyBookPage())),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xAAAB9158), width: .8),
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Row(children: [
          Icon(Icons.auto_stories_outlined, color: _gold, size: 32),
          SizedBox(width: 13),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('فلسفه مدیریت مرگ',
                style: TextStyle(color: _ivory,
                  fontSize: 18, fontWeight: FontWeight.w700)),
              SizedBox(height: 5),
              Text('از فروپاشی تا احیا · کتاب کامل ۹ فصل',
                style: TextStyle(color: _muted, fontSize: 12)),
              SizedBox(height: 5),
              Text('به قلم حامد قنبری درویش',
                style: TextStyle(color: _gold, fontSize: 11)),
            ],
          )),
          Icon(Icons.arrow_back_ios_new_rounded, color: _gold, size: 17),
        ]),
      ),
    ),
  );
}

/// Retain the existing full nine-chapter book and its local offline asset.
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
      foregroundColor: _gold,
      title: const Text('فلسفه مدیریت مرگ'),
    ),
    body: WebViewWidget(controller: _controller),
  );
}
