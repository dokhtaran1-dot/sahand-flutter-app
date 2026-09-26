import 'package:flutter/material.dart';

class RoyalSignaturePage extends StatelessWidget {
  const RoyalSignaturePage({super.key});
  static const gold = Color(0xFFEAC878);
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF1B0808),
    appBar: AppBar(backgroundColor: Colors.transparent,
      foregroundColor: gold, title: const Text('ROYAL SIGNATURE')),
    body: SafeArea(child: ListView(padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 20),
        const Center(child: Text('RS', style: TextStyle(fontFamily: 'serif',
          fontSize: 108, color: gold, fontWeight: FontWeight.bold))),
        const Center(child: Text('رویال سیگنیچر', style: TextStyle(
          fontSize: 30, color: gold))),
        const Center(child: Text('EXCLUSIVE ITEMS · LUXURY COLLECTION',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, letterSpacing: 2))),
        const SizedBox(height: 30),
        ...[
          ('ساعت‌های خاص', Icons.watch_outlined),
          ('جواهرات', Icons.diamond_outlined),
          ('آثار هنری', Icons.palette_outlined),
          ('کلکسیون‌های لوکس', Icons.auto_awesome_outlined),
        ].map((item) => Padding(padding: const EdgeInsets.only(bottom: 14),
          child: Container(padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [
                Color(0xFF4D0D0D), Color(0xFF210808)]),
              border: Border.all(color: gold),
              borderRadius: BorderRadius.circular(18)),
            child: Row(children: [
              Icon(item.$2, color: gold, size: 34),
              const Spacer(),
              Text(item.$1, style: const TextStyle(
                color: Colors.white, fontSize: 22)),
            ])))),
        const SizedBox(height: 12),
        const Text('کالاها و قیمت‌ها پس از ثبت و تأیید در این بخش نمایش داده می‌شوند.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white60)),
      ])),
  );
}
