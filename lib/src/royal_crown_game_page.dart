import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class RoyalCrownGamePage extends StatefulWidget {
  const RoyalCrownGamePage({super.key});
  @override
  State<RoyalCrownGamePage> createState() => _RoyalCrownGamePageState();
}

class _RoyalCrownGamePageState extends State<RoyalCrownGamePage> {
  final Random _random = Random();
  Timer? _timer;
  int score = 0;
  int seconds = 60;
  int crown = 0;
  bool playing = false;

  void start() {
    _timer?.cancel();
    setState(() { score = 0; seconds = 60; crown = 0; playing = true; });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (seconds <= 1) {
        t.cancel();
        setState(() { seconds = 0; playing = false; });
        _finish();
      } else {
        setState(() { seconds--; crown = _random.nextInt(9); });
      }
    });
  }

  void hit() {
    if (!playing) return;
    setState(() { score += 100; crown = _random.nextInt(9); });
  }

  void _finish() {
    showDialog(context: context, builder: (_) => AlertDialog(
      backgroundColor: const Color(0xFF120909),
      title: const Text('THE ROYAL CROWN 👑', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFFD7B45A))),
      content: Text('امتیاز شما: $score\nبرای تاج هفته دوباره تلاش کن.', textAlign: TextAlign.center, textDirection: TextDirection.rtl, style: const TextStyle(color: Colors.white)),
      actionsAlignment: MainAxisAlignment.center,
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('ادامه', style: TextStyle(color: Color(0xFFD7B45A))))],
    ));
  }

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFD7B45A);
    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      appBar: AppBar(backgroundColor: Colors.black, foregroundColor: gold, centerTitle: true, title: const Text('THE ROYAL CROWN 👑')),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          const Text('چالش هفتگی رویال کلاب', textDirection: TextDirection.rtl, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text('فقط یک نفر تاج را می‌برد', textDirection: TextDirection.rtl, style: TextStyle(color: gold)),
          const SizedBox(height: 14),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('SCORE  $score', style: const TextStyle(color: gold, fontSize: 18, fontWeight: FontWeight.bold)),
            Text('00:${seconds.toString().padLeft(2, '0')}', style: const TextStyle(color: Colors.white, fontSize: 18)),
          ]),
          const SizedBox(height: 12),
          Expanded(child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), border: Border.all(color: gold, width: 1.5), gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF260909), Color(0xFF050505)])),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(), padding: const EdgeInsets.all(14),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
              itemCount: 9,
              itemBuilder: (_, i) => AnimatedOpacity(duration: const Duration(milliseconds: 120), opacity: playing && i == crown ? 1 : .08,
                child: InkWell(onTap: i == crown ? hit : null, borderRadius: BorderRadius.circular(20), child: Container(alignment: Alignment.center, decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: gold.withOpacity(.5))), child: const Text('👑', style: TextStyle(fontSize: 46)))),
              ),
            ),
          )),
          const SizedBox(height: 14),
          const Text('قهرمان هفته: یک شب ویژه برای برنده + 10 مهمان\nو اهدای تاج روی سن Royal Club', textAlign: TextAlign.center, textDirection: TextDirection.rtl, style: TextStyle(color: Colors.white, height: 1.6)),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, height: 54, child: ElevatedButton(onPressed: playing ? null : start, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6D0711), foregroundColor: gold, side: const BorderSide(color: gold), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), child: Text(playing ? 'در حال بازی...' : 'شروع بازی | PLAY NOW', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)))),
        ]),
      )),
    );
  }
}
