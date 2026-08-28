import 'package:flutter/material.dart';
import 'ettehad_page.dart';
import 'consulting_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const gold = Color(0xFFD6B15E);
  static const dark = Color(0xFF05080D);

  @override
  Widget build(BuildContext context) {
    final sections = [
      {
        'title': 'اتحاد سازه رویال',
        'subtitle': 'طراحی، ساخت و اجرای پروژه‌های خاص',
        'icon': Icons.apartment_rounded,
      },
      {
        'title': 'HARMONIA',
        'subtitle': 'تبلیغات، لایت‌باکس و طراحی محیطی',
        'icon': Icons.auto_awesome_rounded,
      },
      {
        'title': 'LE ROYAL VILLAGE CAFE',
        'subtitle': 'رزرو اتاق، زمان، کیک و خدمات اختصاصی',
        'icon': Icons.local_cafe_rounded,
      },
      {
        'title': 'مشاوره',
        'subtitle': 'فلسفه مدیریت مرگ؛ از فروپاشی تا احیا',
        'icon': Icons.psychology_alt_rounded,
      },
      {
        'title': 'آموزش',
        'subtitle': 'دوره‌ها و محتوای آموزشی',
        'icon': Icons.school_rounded,
      },
      {
        'title': 'ارتباط با ما',
        'subtitle': 'تماس و راه‌های ارتباطی',
        'icon': Icons.phone_in_talk_rounded,
      },
    ];

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
        backgroundColor: dark,
        body: SafeArea(
        child: Column(
        children: [
        const SizedBox(height: 25),
    const Text(
    'شروع احیا',
    style: TextStyle(
    color: gold,
    fontSize: 30,
    fontWeight: FontWeight.bold,
    ),
    ),
    const SizedBox(height: 20),

    Expanded(
    child: ListView.separated(
    padding: const EdgeInsets.all(18),
    itemCount: sections.length,
    separatorBuilder: (_, __) =>
    const SizedBox(height: 14),
    itemBuilder: (context, index) {
    final item = sections[index];

    return GestureDetector(
    onTap: () {
    if (index == 0) {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (_) => const EttehadPage(),
    ),
    );
    }

    if (index == 3) {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (_) => const ConsultingPage(),
    ),
    );
    }
    },
    child: Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
    color: const Color(0xFF0C1117),
    borderRadius: BorderRadius.circular(22),
    border: Border.all(color: gold),
    ),
    child: Row(
    children: [
    Icon(
    item['icon'] as IconData,
    color: gold,
    size: 32,
    ),
    const SizedBox(width: 16),

    Expanded(
    child: Column(
    crossAxisAlignment:
    CrossAxisAlignment.start,
    children: [
    Text(
    item['title'] as String,
    style: const TextStyle(
    color: gold,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    ),
    ),
      const SizedBox(height: 5),
      Text(
        item['subtitle'] as String,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 13,
        ),
      ),
    ],
    ),
    ),

      const Icon(
        Icons.arrow_back_ios_new_rounded,
        color: gold,
        size: 17,
      ),
    ],
    ),
    ),
    );
    },
    ),
    ),
        ],
        ),
        ),
        ),
    );
  }
}