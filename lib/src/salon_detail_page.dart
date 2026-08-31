import 'package:flutter/material.dart';

class SalonDetailPage extends StatelessWidget {
  final String salonName;

  const SalonDetailPage({
    super.key,
    required this.salonName,
  });

  static const bg = Color(0xFF050807);
  static const panel = Color(0xFF0C1210);
  static const gold = Color(0xFFD6B15E);
  static const emerald = Color(0xFF0B3A2A);

  void _soon(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF132019),
        content: Text(
          '$title در حال تکمیل است',
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: bg,
          foregroundColor: gold,
          centerTitle: true,
          title: Text(
            salonName,
            style: const TextStyle(
              color: gold,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(14),
          children: [
            Container(
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: gold),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF123C2C),
                    Color(0xFF10130F),
                  ],
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.meeting_room_outlined,
                  color: gold,
                  size: 72,
                ),
              ),
            ),

            const SizedBox(height: 18),

            Text(
              salonName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: gold,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'فضای اختصاصی برای لحظه‌های خاص',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 22),

            _ActionCard(
              icon: Icons.calendar_month_outlined,
              title: 'رزرو Salon',
              subtitle: 'انتخاب تاریخ، ساعت و نوع مراسم',
              button: 'رزرو',
              onTap: () => _soon(context, 'رزرو $salonName'),
            ),

            const SizedBox(height: 12),

            _ActionCard(
              icon: Icons.celebration_outlined,
              title: '۱۰ مدل دیزاین تولد',
              subtitle: 'دیزاین اختصاصی متناسب با همین Salon',
              button: 'مشاهده دیزاین‌ها',
              onTap: () => _soon(context, 'دیزاین‌های $salonName'),
            ),

            const SizedBox(height: 12),

            _ActionCard(
              icon: Icons.cake_outlined,
              title: '۱۰ مدل کیک اختصاصی',
              subtitle: 'انتخاب کیک متناسب با دیزاین و مراسم',
              button: 'مشاهده کیک‌ها',
              onTap: () => _soon(context, 'کیک‌های $salonName'),
            ),

            const SizedBox(height: 12),

            _ActionCard(
              icon: Icons.workspace_premium_outlined,
              title: 'VIP Experience',
              subtitle: 'خدمات اختصاصی، پذیرایی ویژه و سورپرایز',
              button: 'درخواست VIP',
              onTap: () => _soon(context, 'VIP $salonName'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String button;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.button,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: SalonDetailPage.panel,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: SalonDetailPage.gold,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: SalonDetailPage.gold,
                size: 30,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: SalonDetailPage.gold,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: SalonDetailPage.emerald,
                foregroundColor: SalonDetailPage.gold,
              ),
              child: Text(button),
            ),
          ),
        ],
      ),
    );
  }
}