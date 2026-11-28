import 'dart:math';
import 'package:flutter/material.dart';

/// Offline-only skill-game demos. Points are not redeemable.
class RcMiniGame extends StatefulWidget {
  const RcMiniGame({super.key, required this.crown});
  final bool crown;
  @override
  State<RcMiniGame> createState() => _RcMiniGameState();
}

class _RcMiniGameState extends State<RcMiniGame> {
  final Random rng = Random();
  late int target;
  late List<int> icons;
  int guesses = 0;
  bool finished = false;
  int award = 0;

  @override
  void initState() {
    super.initState();
    target = rng.nextInt(9);
    icons = List.generate(9, (i) => widget.crown ? 0 : (i == target ? 1 : 0));
  }

  void choose(int i) {
    if (finished) return;
    setState(() {
      guesses++;
      if (i == target) {
        finished = true;
        award = max(5, (widget.crown ? 20 : 15) - (guesses - 1) * 3);
      } else if (guesses >= 4) {
        finished = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFE8BF69);
    return Scaffold(
      backgroundColor: const Color(0xFF03150F),
      appBar: AppBar(backgroundColor: const Color(0xFF03150F),
        title: Text(widget.crown ? 'CROWN · 2 TICKETS' : 'FIND DIFFERENCE · 1 TICKET')),
      body: SafeArea(child: Center(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: ListView(padding: const EdgeInsets.all(22), children: [
          Icon(widget.crown ? Icons.workspace_premium : Icons.search, size: 72, color: gold),
          const SizedBox(height: 16),
          Text(widget.crown ? 'تاج پنهان را پیدا کن' : 'نماد متفاوت را پیدا کن',
            textAlign: TextAlign.center, style: const TextStyle(fontSize: 23, color: gold)),
          const SizedBox(height: 8),
          Text(widget.crown ? 'یکی از ۹ صندوق، تاج سلطنتی دارد.' :
            'از میان ۹ نماد، تنها یکی متفاوت است.',
            textAlign: TextAlign.center),
          const SizedBox(height: 22),
          GridView.builder(shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 9,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, mainAxisSpacing: 12, crossAxisSpacing: 12),
            itemBuilder: (context, i) => InkWell(
              onTap: () => choose(i),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF76521E), Color(0xFF133D2E)]),
                  border: Border.all(color: gold, width: 1.5),
                  borderRadius: BorderRadius.circular(14)),
                child: Center(child: Icon(widget.crown ?
                  (finished && i == target ? Icons.workspace_premium : Icons.inventory_2_outlined) :
                  (icons[i] == 1 ? Icons.star_rounded : Icons.star_outline_rounded),
                  color: gold, size: 43)),
              ),
            )),
          const SizedBox(height: 20),
          Text(finished ? (award > 0 ? 'بردی! +$award امتیاز نمایشی' :
            'این دور تمام شد؛ امتیازی دریافت نشد') :
            'تلاش: $guesses از ۴', textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, color: gold)),
          const SizedBox(height: 16),
          if (finished) FilledButton(
            onPressed: () => Navigator.pop(context, award),
            child: const Text('بازگشت به Royal Club')),
          const SizedBox(height: 18),
          const Text('نسخه آفلاین آزمایشی · بدون جایزه واقعی',
            textAlign: TextAlign.center, style: TextStyle(color: Colors.white60)),
        ]),
      ))),
    );
  }
}
