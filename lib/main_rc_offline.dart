import 'dart:math';
import 'package:flutter/material.dart';

/// Isolated, free, offline Royal Club visual preview. No prizes or server writes.
void main() => runApp(const RcOfflineApp());

const gold = Color(0xFFE8BF69);
const dark = Color(0xFF03150F);
const emerald = Color(0xFF063A2C);

class RcOfflineApp extends StatelessWidget {
  const RcOfflineApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'ROYAL ONE · Royal Club',
    theme: ThemeData.dark(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: dark,
      colorScheme: ColorScheme.fromSeed(seedColor: gold, brightness: Brightness.dark),
    ),
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
  bool active = false;
  String message = 'برای شروع بازی، دکمه طلایی را لمس کنید';
  @override
  void initState() { super.initState(); shuffled = List.of(values)..shuffle(random); }

  void start() {
    if (active || tickets < 3) return;
    setState(() {
      tickets -= 3;
      shuffled = List.of(values)..shuffle(random);
      chosen = null; opened.clear(); offer = null; awarded = null;
      active = true; message = 'یک چمدان برای خودتان انتخاب کنید';
    });
  }

  void tapCase(int n) {
    if (!active || offer != null || awarded != null || opened.containsKey(n) || chosen == n) return;
    setState(() {
      if (chosen == null) {
        chosen = n; message = 'چمدان شماره $n متعلق به شماست؛ چمدان‌های دیگر را باز کنید';
      } else {
        opened[n] = shuffled[n - 1];
        message = 'چمدان $n باز شد: ${shuffled[n - 1]} RP';
        if (stages.contains(opened.length)) {
          final remaining = <int>[];
          for (var i = 1; i <= 26; i++) {
            if (!opened.containsKey(i)) remaining.add(shuffled[i - 1]);
          }
          final average = remaining.reduce((a,b) => a+b) / remaining.length;
          offer = (average * (0.35 + opened.length / 50)).round();
          message = 'تماس بانکدار! پیشنهاد جدید آماده است';
        }
      }
    });
  }

  void finish(int amount) {
    setState(() {
      awarded = amount; points += amount; active = false; offer = null;
      message = '$amount امتیاز نمایشی به حساب شما اضافه شد';
    });
  }

  void reset() => setState(() {
    tickets = 25; points = 0; active = false; awarded = null; chosen = null;
    opened.clear(); offer = null; message = 'نسخه آزمایشی از ابتدا شروع شد';
  });

  void info(String title, String body) => showDialog<void>(
    context: context, builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF09291F),
      title: Text(title, style: const TextStyle(color: gold)),
      content: Text(body),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('بستن'))],
    ),
  );

  Widget panel({required Widget child, EdgeInsets padding = const EdgeInsets.all(12)}) => Container(
    padding: padding,
    decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [Color(0xFF103D2D), Color(0xFF02120D)]),
      border: Border.all(color: gold.withValues(alpha: 0.65)),
      borderRadius: BorderRadius.circular(18),
      boxShadow: [BoxShadow(color: gold.withValues(alpha: 0.12), blurRadius: 18)],
    ),
    child: child,
  );

  Widget pill(IconData icon, String label) => Expanded(child: panel(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 11),
    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon, color: gold, size: 17), const SizedBox(width: 5),
      Flexible(child: FittedBox(fit: BoxFit.scaleDown, child: Text(label,
        style: const TextStyle(color: gold, fontSize: 13, fontWeight: FontWeight.bold)))),
    ]),
  ));

  Widget caseTile(int n) {
    final mine = chosen == n;
    final value = opened[n];
    return InkWell(
      key: Key('case_$n'),
      onTap: () => tapCase(n),
      borderRadius: BorderRadius.circular(11),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 330),
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: value != null ? [const Color(0xFF14271E), const Color(0xFF08120D)] :
              mine ? [const Color(0xFFAC833B), const Color(0xFF39290E)] :
              [const Color(0xFFB38B3E), const Color(0xFF372708), const Color(0xFF8C672D)]),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: mine ? Colors.white : gold, width: mine ? 2.5 : 1.2),
          boxShadow: value == null ? [BoxShadow(color: gold.withValues(alpha: 0.28), blurRadius: 10)] : [],
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(value == null ? Icons.work_rounded : Icons.lock_open_rounded,
            color: value == null ? const Color(0xFFFFE7A1) : gold,
            size: 26),
          const SizedBox(height: 2),
          FittedBox(child: Text(value == null ? '$n' : '$value RP',
            style: const TextStyle(fontSize: 16, color: Color(0xFFFFE4A2), fontWeight: FontWeight.w800))),
          if (mine) const Text('MY CASE', style: TextStyle(fontSize: 8, color: Colors.white)),
        ]),
      ),
    );
  }

  Widget action(String label, VoidCallback? onPressed, {bool primary = false}) =>
    Container(
      decoration: BoxDecoration(
        gradient: primary ? const LinearGradient(colors: [Color(0xFF91601F), Color(0xFFFFD989), Color(0xFF986C27)]) : null,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: gold),
      ),
      child: TextButton(onPressed: onPressed, style: TextButton.styleFrom(
        foregroundColor: primary ? dark : gold,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15)),
        child: Text(label, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w800))),
    );

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: LayoutBuilder(builder: (context, bounds) {
      final width = min(bounds.maxWidth, 620.0);
      final columns = width < 380 ? 4 : 6;
      return Center(child: SizedBox(width: width, child: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [Color(0xFF071B14), Color(0xFF00503A), Color(0xFF02120B), Color(0xFF061A12)])),
        child: ListView(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), children: [
          const Center(child: Icon(Icons.shield_outlined, color: gold, size: 33)),
          const Text('ROYAL ONE', textAlign: TextAlign.center, style: TextStyle(
            fontFamily: 'serif', fontSize: 37, color: gold, letterSpacing: 3, fontWeight: FontWeight.bold)),
          const Text('Royal Club', textAlign: TextAlign.center, style: TextStyle(
            fontFamily: 'serif', fontSize: 23, color: gold, fontStyle: FontStyle.italic)),
          const SizedBox(height: 14),
          Row(children: [
            pill(Icons.confirmation_number_outlined, 'Tickets: $tickets'),
            const SizedBox(width: 6),
            pill(Icons.stars_rounded, 'RP: $points'),
            const SizedBox(width: 6),
            pill(Icons.emoji_events_outlined, 'DEMO'),
          ]),
          const SizedBox(height: 20),
          const Text('DEAL / NO DEAL', textAlign: TextAlign.center, style: TextStyle(
            fontFamily: 'serif', color: gold, fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          Container(height: 145, alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(80),
              gradient: RadialGradient(colors: [gold.withValues(alpha: 0.3), emerald, dark]),
              border: Border.all(color: gold.withValues(alpha: 0.55))),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.work_rounded, size: 78, color: gold),
              const Text('ROYAL CLUB', style: TextStyle(color: gold, letterSpacing: 3)),
            ])),
          const SizedBox(height: 12),
          const Text('بازی معامله — شانس، استراتژی، برد بزرگ', textAlign: TextAlign.center,
            style: TextStyle(color: gold, fontSize: 15)),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 13)),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            itemCount: 26,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns, mainAxisSpacing: 8, crossAxisSpacing: 7, childAspectRatio: 0.95),
            itemBuilder: (context, i) => caseTile(i + 1)),
          const SizedBox(height: 20),
          if (offer != null) ...[
            panel(child: Column(children: [
              const Icon(Icons.phone_in_talk_rounded, color: gold, size: 32),
              Text('BANKER OFFER: $offer RP', textAlign: TextAlign.center,
                style: const TextStyle(color: gold, fontSize: 23, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                action('DEAL', () => finish(offer!), primary: true),
                action('NO DEAL', () => setState(() {
                  offer = null; message = 'NO DEAL — بازی ادامه دارد';
                })),
              ]),
            ])),
            const SizedBox(height: 12),
          ],
          if (active && chosen != null && opened.length == 25 && offer == null)
            action('OPEN MY CASE', () => finish(shuffled[chosen! - 1]), primary: true),
          if (!active) action('START DEAL  ·  3 TICKETS', tickets >= 3 ? start : null, primary: true),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            TextButton.icon(onPressed: () => info('راهنمای بازی',
              'برای شروع ۳ بلیت مصرف می‌شود. یک چمدان نگه دارید و بقیه را باز کنید. در مراحل مختلف بانکدار پیشنهاد می‌دهد. همه امتیازها آزمایشی هستند.'),
              icon: const Icon(Icons.help_outline), label: const Text('راهنما')),
            TextButton.icon(onPressed: active ? null : reset,
              icon: const Icon(Icons.restart_alt), label: const Text('شروع مجدد')),
            TextButton.icon(onPressed: () => info('جوایز',
              'در این نسخه آفلاین هیچ جایزه واقعی، رتبه‌بندی آنلاین یا امکان خرید بلیت وجود ندارد.'),
              icon: const Icon(Icons.card_giftcard), label: const Text('جوایز')),
          ]),
          const SizedBox(height: 12),
          const Text('OFFLINE PREVIEW · NO REAL REWARDS', textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: Color(0xFFBCA879))),
          const SizedBox(height: 18),
        ]),
      )));
    })),
  );
}
