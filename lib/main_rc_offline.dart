import 'dart:math';
import 'package:flutter/material.dart';

/// Fully offline, zero-cost preview. No account, server writes, or real prizes.
void main() => runApp(const RcOfflineApp());

class RcOfflineApp extends StatelessWidget {
  const RcOfflineApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'ROYAL ONE RC TEST',
    theme: ThemeData.dark(useMaterial3: true),
    home: const RcOfflineGame(),
  );
}

class RcOfflineGame extends StatefulWidget {
  const RcOfflineGame({super.key});
  @override
  State<RcOfflineGame> createState() => _RcOfflineGameState();
}

class _RcOfflineGameState extends State<RcOfflineGame> {
  static const values = <int>[1,2,3,5,8,10,15,20,25,30,40,50,75,100,150,200,250,300,400,500,600,750,1000,1500,2000,3000];
  static const stages = <int>{6,11,15,18,20,21,22,23,24};
  final random = Random();
  late List<int> shuffled;
  int? chosen;
  final Map<int,int> opened = {};
  int? offer;
  int? awarded;
  int tickets = 25;
  int points = 0;
  bool claimedToday = true;
  bool active = false;
  String message = 'نسخه نمایشی آفلاین؛ بدون جایزه واقعی';
  @override
  void initState() { super.initState(); shuffled = List.of(values)..shuffle(random); }

  void start() {
    if (active || tickets < 3) return;
    setState(() {
      tickets -= 3;
      shuffled = List.of(values)..shuffle(random);
      chosen = null; opened.clear(); offer = null; awarded = null;
      active = true; message = 'چمدان خودت را انتخاب کن';
    });
  }

  void tapCase(int n) {
    if (!active || offer != null || awarded != null || opened.containsKey(n) || chosen == n) return;
    setState(() {
      if (chosen == null) {
        chosen = n; message = 'چمدان $n انتخاب شد';
      } else {
        opened[n] = shuffled[n - 1];
        message = 'چمدان $n: ${shuffled[n - 1]} RP';
        if (stages.contains(opened.length)) {
          final remaining = <int>[];
          for (var i = 1; i <= 26; i++) {
            if (!opened.containsKey(i)) remaining.add(shuffled[i - 1]);
          }
          final average = remaining.reduce((a,b) => a+b) / remaining.length;
          offer = (average * (0.35 + opened.length / 50)).round();
          message = 'بانکدار پیشنهاد داد: $offer RP';
        }
      }
    });
  }

  void finish(int amount) {
    setState(() {
      awarded = amount; points += amount; active = false; offer = null;
      message = '$amount RP فقط به کیف پول نمایشی اضافه شد';
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF061C16),
    appBar: AppBar(backgroundColor: const Color(0xFF061C16),
      title: const Text('ROYAL ONE · RC TEST')),
    body: SafeArea(child: Center(child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 680),
      child: ListView(padding: const EdgeInsets.all(18), children: [
        const Text('ROYAL CLUB', textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFFE8C36A), fontSize: 29, fontWeight: FontWeight.bold)),
        const Text('OFFLINE DEMO · NO REAL REWARDS', textAlign: TextAlign.center),
        const SizedBox(height: 14),
        Text('Tickets: $tickets     Demo RP: $points',
          textAlign: TextAlign.center, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 12),
        Text(message, textAlign: TextAlign.center,
          style: const TextStyle(color: Color(0xFFE8C36A))),
        const SizedBox(height: 16),
        Wrap(alignment: WrapAlignment.center, spacing: 8, children: [
          FilledButton(onPressed: active || tickets < 3 ? null : start,
            child: const Text('START DEAL · 3 TICKETS')),
          OutlinedButton(onPressed: claimedToday ? null : () {},
            child: const Text('Daily tickets (demo)')),
          OutlinedButton(onPressed: active ? null : () => setState(() {
            tickets = 25; points = 0; awarded = null; chosen = null;
            opened.clear(); offer = null; message = 'نمایش از نو شروع شد';
          }), child: const Text('RESET DEMO')),
        ]),
        const SizedBox(height: 16),
        GridView.builder(shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 26,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, mainAxisSpacing: 8, crossAxisSpacing: 8,
            childAspectRatio: 1.2),
          itemBuilder: (context, index) {
            final n = index + 1;
            final isMine = chosen == n;
            final revealed = opened[n];
            return InkWell(
              onTap: () => tapCase(n),
              child: Container(
                decoration: BoxDecoration(
                  color: isMine ? const Color(0xFF8B6B29) : const Color(0xFF143D31),
                  border: Border.all(color: const Color(0xFFE8C36A)),
                  borderRadius: BorderRadius.circular(10)),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.work_outline, color: Color(0xFFE8C36A)),
                  Text(revealed == null ? '$n' : '$revealed RP',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                  if (isMine) const Text('MY CASE', style: TextStyle(fontSize: 10)),
                ]),
              ),
            );
          }),
        const SizedBox(height: 16),
        if (offer != null) ...[
          Text('BANKER OFFER: $offer RP', textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, color: Color(0xFFE8C36A))),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            FilledButton(onPressed: () => finish(offer!), child: const Text('DEAL')),
            const SizedBox(width: 14),
            OutlinedButton(onPressed: () => setState(() {
              offer = null; message = 'NO DEAL · بازی ادامه دارد';
            }), child: const Text('NO DEAL')),
          ]),
        ],
        if (active && chosen != null && opened.length == 25 && offer == null)
          FilledButton(onPressed: () => finish(shuffled[chosen! - 1]),
            child: const Text('OPEN MY CASE')),
        const SizedBox(height: 16),
        const Text('امتیازها و تیکت‌ها فقط در حافظه گوشی هستند و با بستن برنامه پاک می‌شوند. این نسخه به Supabase متصل نیست.',
          textAlign: TextAlign.center),
      ]),
    ))),
  );
}
