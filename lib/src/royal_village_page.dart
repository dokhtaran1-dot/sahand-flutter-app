import 'package:flutter/material.dart';
import 'salon_detail_page.dart';

class RoyalVillagePage extends StatelessWidget {
  const RoyalVillagePage({super.key});

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
final rooms = [
  'Salon Lumière',
  'Salon Noir',
  'Salon Jardin',
  'Salon Privé',
  'RV Lounge Impérial Classique',
  'Salon Doré',
  'Salon Âme du Poète',
  'Salon Royal',
];

final roomImages = [
  'assets/image/salon_lumiere.png',
  'assets/image/salon_noir.png',
  'assets/image/salon_jardin.png',
  'assets/image/salon_prive.png',
  'assets/image/rv_lounge_imperial_classique.png',
  'assets/image/salon_dore.png',
  'assets/image/salon_ame_du_poete.png',
  'assets/image/salon_de_lame.png',
];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: bg,
          foregroundColor: gold,
          centerTitle: true,
          title: const Column(
            children: [
              Text(
                'ROYAL VILLAGE',
                style: TextStyle(
                  color: gold,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                'رزرو • مراسم • تجربه VIP',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(14),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF123C2C),
                    Color(0xFF10130F),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: gold),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.restaurant_menu,
                    color: gold,
                    size: 48,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'RV • ROYAL VILLAGE',
                    style: TextStyle(
                      color: gold,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'اتاق اختصاصی، دیزاین تولد، کیک، مراسم خصوصی و خدمات VIP',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      height: 1.7,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            _ActionCard(
              icon: Icons.workspace_premium_outlined,
              title: 'VIP RV',
              subtitle: 'رزرو اختصاصی خدمات VIP رویال ویلیج',
              button: 'رزرو VIP',
              onTap: () => _soon(context, 'رزرو VIP RV'),
            ),

            const SizedBox(height: 18),

            const Text(
              'Salonهای اختصاصی Royal Village',
              style: TextStyle(
                color: gold,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            ...rooms.asMap().entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _RoomCard(              
                  number: entry.key + 1,
                  name: entry.value,
                  imagePath: roomImages[entry.key],
                  onReserve: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => SalonDetailPage(
        salonName: entry.value,
      ),
    ),
  );
},
                  onDesign: () =>
                      _soon(context, '۱۰ مدل دیزاین ${entry.value}'),
                  onCake: () =>
                      _soon(context, '۱۰ مدل کیک ${entry.value}'),
                ),
              ),
            ),

            const SizedBox(height: 10),

            _ActionCard(
              icon: Icons.cake_outlined,
              title: 'سفارش کیک اختصاصی',
              subtitle: 'انتخاب کیک متناسب با اتاق و مراسم',
              button: 'مشاهده کیک‌ها',
              onTap: () => _soon(context, 'کیک‌های Royal Village'),
            ),

            const SizedBox(height: 12),

            _ActionCard(
              icon: Icons.celebration_outlined,
              title: 'دیزاین تولد و مراسم',
              subtitle: 'برای هر اتاق ۱۰ مدل دیزاین اختصاصی',
              button: 'مشاهده دیزاین‌ها',
              onTap: () => _soon(context, 'دیزاین مراسم'),
            ),

            const SizedBox(height: 12),

            _ActionCard(
              icon: Icons.calendar_month_outlined,
              title: 'تاریخ و ساعت رزرو',
              subtitle: 'انتخاب روز، ساعت و نوع مراسم',
              button: 'انتخاب زمان',
              onTap: () => _soon(context, 'تقویم رزرو'),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  final int number;
  final String name;
  final String imagePath;
  final VoidCallback onReserve;
  final VoidCallback onDesign;
  final VoidCallback onCake;

  const _RoomCard({
    required this.number,
    required this.name,
    required this.imagePath,
    required this.onReserve,
    required this.onDesign,
    required this.onCake,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: RoyalVillagePage.panel,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: RoyalVillagePage.gold,
        ),
      ),
      child: Column(
        children: [
          ClipRRect(
  borderRadius: BorderRadius.circular(14),
  child: Image.asset(
    imagePath,
    width: double.infinity,
    height: 190,
    fit: BoxFit.cover,
  ),
),
const SizedBox(height: 14),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: RoyalVillagePage.emerald,
                child: Text(
                  '$number',
                  style: const TextStyle(
                    color: RoyalVillagePage.gold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    color: RoyalVillagePage.gold,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: RoyalVillagePage.gold,
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _SmallButton(
                  text: 'رزرو',
                  icon: Icons.calendar_month,
                  onTap: onReserve,
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: _SmallButton(
                  text: '۱۰ دیزاین',
                  icon: Icons.celebration,
                  onTap: onDesign,
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: _SmallButton(
                  text: '۱۰ کیک',
                  icon: Icons.cake,
                  onTap: onCake,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const _SmallButton({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 4,
        ),
        side: const BorderSide(
          color: RoyalVillagePage.gold,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: RoyalVillagePage.gold,
            size: 18,
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
        ],
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
        color: RoyalVillagePage.panel,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: RoyalVillagePage.gold,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: RoyalVillagePage.gold,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: RoyalVillagePage.gold,
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
                backgroundColor: RoyalVillagePage.emerald,
                foregroundColor: RoyalVillagePage.gold,
              ),
              child: Text(button),
            ),
          ),
        ],
      ),
    );
  }
}
