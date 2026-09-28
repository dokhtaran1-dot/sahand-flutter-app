import 'package:flutter/material.dart';

class RoyalExplorePage extends StatelessWidget {
  const RoyalExplorePage({super.key});
  static const gold = Color(0xFFE4C17C);
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF100E0B),
    appBar: AppBar(title: const Text('EXPLORE'),
      foregroundColor: gold, backgroundColor: Colors.transparent),
    body: SafeArea(child: ListView(padding: const EdgeInsets.all(22),
      children: [
        const Icon(Icons.explore_outlined, size: 80, color: gold),
        const SizedBox(height: 12),
        const Text('کشف دنیای رویال', textAlign: TextAlign.center,
          style: TextStyle(fontSize: 28, color: gold)),
        const SizedBox(height: 30),
        ...[
          ('آموزش‌ها', Icons.school_outlined),
          ('تعرفه‌ها و مبالغ', Icons.payments_outlined),
          ('معرفی مجموعه‌ها', Icons.apartment_outlined),
          ('خدمات و امکانات', Icons.room_service_outlined),
          ('اخبار و رویدادها', Icons.campaign_outlined),
          ('ارتباط با ما', Icons.phone_outlined),
          ('پروفایل شخصی', Icons.person_outline),
        ].map((item) => Card(
          color: const Color(0xFF20190F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: gold, width: .6)),
          child: ListTile(leading: Icon(item.$2, color: gold),
            title: Text(item.$1, textAlign: TextAlign.right),
            onTap: () => showModalBottomSheet(context: context,
              builder: (_) => SafeArea(child: Padding(
                padding: const EdgeInsets.all(30),
                child: Text(item.$1, textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24)))))))),
      ])),
  );
}
