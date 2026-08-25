import 'package:flutter/material.dart';

class EttehadPage extends StatelessWidget {
  const EttehadPage({super.key});

  static const gold = Color(0xFFD6B15E);
  static const dark = Color(0xFF05070A);

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
        backgroundColor: dark,
        appBar: AppBar(
        backgroundColor: dark,
        foregroundColor: gold,
        elevation: 0,
        title: const Text(
        'اتحاد سازه رویال',
        style: TextStyle(
        color: gold,
        fontWeight: FontWeight.bold,
    ),
    ),
    ),
    body: SingleChildScrollView(
    padding: const EdgeInsets.all(18),
    child: Column(
    children: [
    const SizedBox(height: 10),

    Image.asset(
    'assets/image/ettehad_logo.png',
    height: 180,
    fit: BoxFit.contain,
    errorBuilder: (_, __, ___) => const Icon(
    Icons.apartment_rounded,
    color: gold,
    size: 110,
    ),
    ),

    const SizedBox(height: 16),

    const Text(
    'ETTEHAD SAZEH ROYAL',
    textDirection: TextDirection.ltr,
    style: TextStyle(
    color: gold,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    letterSpacing: 2,
    ),
    ),

    const SizedBox(height: 8),

    const Text(
    'طراحی، مشاوره، مدیریت و اجرای پروژه‌های ساختمانی خاص',
    textAlign: TextAlign.center,
    style: TextStyle(
    color: Colors.white70,
    fontSize: 15,
    height: 1.8,
    ),
    ),

    const SizedBox(height: 28),

    _card(
    icon: Icons.engineering_rounded,
    title: 'دکتر مسعود نژاد اتحاد',
    subtitle: 'مشاور ارشد ساخت‌وساز و مدیریت پروژه',
    ),

    const SizedBox(height: 20),

    const Align(
    alignment: Alignment.centerRight,
    child: Text(
    'خدمات تخصصی',
    style: TextStyle(
    color: gold,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    ),
    ),
    ),

    const SizedBox(height: 14),

    _service('طراحی و بازطراحی پروژه‌ها'),
    _service('ساخت و اجرای پروژه‌های ساختمانی'),
    _service('بازسازی و احیای ساختمان'),
    _service('طراحی داخلی و طراحی نما'),
    _service('مدیریت و نظارت پروژه'),
    _service('مشاوره تخصصی ساخت‌وساز'),

    const SizedBox(height: 24),

    _card(
    icon: Icons.photo_library_rounded,
    title: 'پروژه‌ها و طراحی‌ها',
    subtitle:
    'نمونه پروژه‌های اجراشده، طراحی‌ها و تصاویر قبل و بعد',
    ),

    const SizedBox(height: 22),

    SizedBox(
    width: double.infinity,
    height: 58,
    child: ElevatedButton.icon(
    onPressed: () {},
    icon: const Icon(Icons.apartment_rounded),
    label: const Text(
    'مشاهده پروژه‌ها',
    style: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    ),
    ),
    style: ElevatedButton.styleFrom(
    backgroundColor: gold,
    foregroundColor: Colors.black,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(18),
    ),
    ),
    ),
    ),

    const SizedBox(height: 12),

      SizedBox(
        width: double.infinity,
        height: 58,
        child: OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.handshake_rounded),
          label: const Text(
            'درخواست مشاوره',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: gold,
            side: const BorderSide(color: gold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),

      const SizedBox(height: 30),
    ],
    ),
    ),
        ),
    );
  }

  static Widget _service(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          const Icon(
            Icons.diamond_outlined,
            color: gold,
            size: 19,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _card({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0C1117),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: gold),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: gold,
            size: 38,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: gold,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}