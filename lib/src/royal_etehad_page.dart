import 'package:flutter/material.dart';

class RoyalEtehadPage extends StatelessWidget {
  const RoyalEtehadPage({super.key});
  @override
  Widget build(BuildContext context) => const _DivisionPage(
    title: 'RE', subtitle: 'اتحاد سازه رویال',
    english: 'ETEHAD SAZEH ROYAL',
    description: 'ساخت‌وساز، پروژه‌ها و خدمات تجاری',
    accent: Color(0xFF379BFF),
    items: ['پروژه‌های ساختمانی', 'معرفی مجموعه', 'خدمات تجاری', 'ارتباط با ما'],
  );
}

class _DivisionPage extends StatelessWidget {
  final String title, subtitle, english, description;
  final Color accent;
  final List<String> items;
  const _DivisionPage({required this.title, required this.subtitle,
    required this.english, required this.description, required this.accent,
    required this.items});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF060B17),
    appBar: AppBar(backgroundColor: Colors.transparent,
      foregroundColor: accent, title: Text(english)),
    body: SafeArea(child: ListView(padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 28),
        Center(child: Text(title, style: TextStyle(color: accent,
          fontSize: 96, fontFamily: 'serif', fontWeight: FontWeight.bold))),
        Center(child: Text(subtitle, style: const TextStyle(
          color: Color(0xFFE8C77B), fontSize: 27))),
        const SizedBox(height: 12),
        Center(child: Text(description, textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70, fontSize: 17))),
        const SizedBox(height: 42),
        ...items.map((item) => Card(color: const Color(0xFF101C30),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: accent.withOpacity(.55))),
          child: ListTile(title: Text(item, textAlign: TextAlign.right),
            trailing: Icon(Icons.arrow_back_ios_new, color: accent),
            onTap: () => showModalBottomSheet(context: context,
              builder: (_) => Padding(padding: const EdgeInsets.all(28),
                child: Text(item, textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22))))))),
      ])),
  );
}
