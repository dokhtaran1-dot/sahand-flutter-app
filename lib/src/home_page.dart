import 'package:flutter/material.dart';
import 'royal_village_page.dart';
import 'ettehad_page.dart';
import 'consulting_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const Color bg = Color(0xFF050607);
  static const Color card = Color(0xFF0C0E10);
  static const Color gold = Color(0xFFD6B15E);
  static const Color gold2 = Color(0xFFFFD77A);

  void _comingSoon(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF17191C),
        content: Text(
          '$title در حال تکمیل است',
          textDirection: TextDirection.rtl,
          style: const TextStyle(color: Colors.white),
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
          elevation: 0,
          centerTitle: true,
          toolbarHeight: 78,
          title: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'SAHAND CONSORTIUM',
                style: TextStyle(
                  color: gold2,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'POWER IN UNITY',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 9,
                  letterSpacing: 3,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () => _comingSoon(context, 'اعلان‌ها'),
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: gold2,
              ),
            ),
          ],
        ),

        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 30),
            child: Column(
              children: [

                // HERO
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 25,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF211706),
                        Color(0xFF080909),
                        Color(0xFF11100C),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: gold,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: gold2,
                            width: 1.5,
                          ),
                          color: const Color(0xFF151109),
                        ),
                        child: const Icon(
                          Icons.diamond_outlined,
                          color: gold2,
                          size: 38,
                        ),
                      ),

                      const SizedBox(height: 15),

                      const Text(
                        'SAHAND CONSORTIUM',
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          color: gold2,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),

                      const SizedBox(height: 9),

                      const Text(
                        'قدرت در اتحاد  |  استراتژی در مدیریت',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          height: 1.7,
                        ),
                      ),

                      const SizedBox(height: 3),

                      const Text(
                        'Strategy • Management • Lifestyle',
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'مجموعه‌های ویژه',
                    style: TextStyle(
                      color: gold2,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // 2 CARDS
                Row(
                  children: [
                    Expanded(
                      child: _MainCard(
                        icon: Icons.apartment_rounded,
                        title: 'ROYAL MALL',
                        subtitle: 'پاساژ و خدمات تجاری',
                        onTap: () =>
                            _comingSoon(context, 'Royal Mall'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _MainCard(
                        icon: Icons.restaurant_menu_rounded,
                        title: 'ROYAL VILLAGE',
                        subtitle: 'رستوران • رزرو • مراسم',
                        featured: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const RoyalVillagePage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: _MainCard(
                        icon: Icons.campaign_outlined,
                        title: 'ROYAL HARMONIA',
                        subtitle: 'تبلیغات و برندینگ',
                        onTap: () =>
                            _comingSoon(context, 'Royal Harmonia'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _MainCard(
                        icon: Icons.architecture_rounded,
                        title: 'ROYAL SAZEH',
                        subtitle: 'ساخت و پروژه‌ها',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const EttehadPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ROYAL VILLAGE PREMIUM CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: card,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: gold.withOpacity(.75),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Color(0xFF2A2111),
                            child: Icon(
                              Icons.restaurant,
                              color: gold2,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ROYAL VILLAGE',
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                    color: gold2,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  'رزرو اختصاصی مراسم و سالن‌ها',
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      const _FeatureLine(
                        text: 'رزرو ۸ سالن اختصاصی Royal Village',
                      ),
                      const _FeatureLine(
                        text: 'رزرو فضای VIP',
                      ),
                      const _FeatureLine(
                        text: 'انتخاب تاریخ و ساعت مراسم',
                      ),
                      const _FeatureLine(
                        text: 'انتخاب دیزاین مخصوص هر سالن',
                      ),
                      const _FeatureLine(
                        text: 'انتخاب کیک اختصاصی',
                      ),
                      const _FeatureLine(
                        text: 'سفارش مراسم و سورپرایز',
                      ),

                      const SizedBox(height: 15),

                      SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const RoyalVillagePage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF8B641C),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(16),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Text(
                                'ورود به ROYAL VILLAGE',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(width: 9),
                              Icon(Icons.arrow_back_rounded),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // MANAGEMENT
                InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ConsultingPage(),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A0C0D),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: Colors.white12,
                      ),
                    ),
                    child: const Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Color(0xFF211B0D),
                          child: Icon(
                            Icons.auto_graph_rounded,
                            color: gold2,
                          ),
                        ),
                        SizedBox(width: 13),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                'STRATEGY & MANAGEMENT',
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'مدیریت، مشاوره و توسعه',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_left_rounded,
                          color: gold,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFF070809),
          selectedItemColor: gold2,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          currentIndex: 0,
          onTap: (index) {
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RoyalVillagePage(),
                ),
              );
            } else if (index == 2) {
              _comingSoon(context, 'پیشنهادهای ویژه');
            } else if (index == 3) {
              _comingSoon(context, 'پروفایل');
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'خانه',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              label: 'رزرو',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_offer_outlined),
              label: 'ویژه',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'پروفایل',
            ),
          ],
        ),
      ),
    );
  }
}

class _MainCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool featured;

  const _MainCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.featured = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        height: 185,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: featured
                ? const [
                    Color(0xFF162017),
                    Color(0xFF090D0A),
                  ]
                : const [
                    Color(0xFF121416),
                    Color(0xFF080909),
                  ],
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: featured
                ? HomePage.gold2
                : HomePage.gold.withOpacity(.55),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: featured
                    ? const Color(0xFF27311E)
                    : const Color(0xFF1A1812),
                border: Border.all(
                  color: HomePage.gold.withOpacity(.65),
                ),
              ),
              child: Icon(
                icon,
                size: 29,
                color: HomePage.gold2,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: HomePage.gold2,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 11,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureLine extends StatelessWidget {
  final String text;

  const _FeatureLine({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const Icon(
            Icons.diamond,
            size: 8,
            color: HomePage.gold,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFFE7E7E7),
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}