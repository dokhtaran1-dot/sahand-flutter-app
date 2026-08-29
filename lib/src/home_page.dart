import 'package:flutter/material.dart';
import 'ettehad_page.dart';
import 'consulting_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const bg = Color(0xFF050607);
  static const card = Color(0xFF0D1013);
  static const gold = Color(0xFFD6B15E);
  static const gold2 = Color(0xFFFFD77A);

  void _comingSoon(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF17191C),
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
          elevation: 0,
          centerTitle: true,
          title: const Column(
            children: [
              Text(
                'شروع احیا',
                style: TextStyle(
                  color: gold2,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              Text(
                'SAHAND CONSORTIUM',
                style: TextStyle(
                  color: gold,
                  fontSize: 11,
                  letterSpacing: 1.6,
                ),
              ),
            ],
          ),
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 30),
          child: Column(
            children: [

              // مدیران
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _Person(
                    icon: Icons.workspace_premium,
                    name: 'حامد',
                    role: 'مدیریت',
                  ),
                  _Person(
                    icon: Icons.restaurant_menu,
                    name: 'دکتر سلمان‌زاده',
                    role: 'Royal Village',
                  ),
                  _Person(
                    icon: Icons.architecture,
                    name: 'دکتر اتحاد',
                    role: 'Ettehad',
                  ),
                  _Person(
                    icon: Icons.campaign,
                    name: 'الهه عبادی',
                    role: 'Advertising',
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // ROYAL CLUB
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF2B2110),
                      Color(0xFF0B0C0E),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: gold),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.workspace_premium,
                      size: 50,
                      color: gold2,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'ROYAL CLUB',
                      style: TextStyle(
                        color: gold2,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      '۳۰٪ امتیاز ویژه اعضا',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'رزرو اختصاصی  •  خدمات VIP  •  تخفیف فروشگاه‌ها  •  پیشنهادهای ویژه',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFD8D8D8),
                        height: 1.7,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            _comingSoon(context, 'کارت عضویت Royal Club'),
                        icon: const Icon(Icons.qr_code, color: gold2),
                        label: const Text(
                          'کارت عضویت من',
                          style: TextStyle(color: gold2),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: gold),
                          padding: const EdgeInsets.all(15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ROYAL VILLAGE
              _ServiceCard(
                icon: Icons.restaurant,
                title: 'ROYAL VILLAGE',
                subtitle: 'رستوران • رزرو • مراسم',
                items: const [
                  'رزرو اتاق‌های RV',
                  'رزرو VIP RV',
                  '۱۰ مدل دیزاین تولد برای هر اتاق',
                  '۱۰ مدل کیک مخصوص هر اتاق',
                  'انتخاب تاریخ و ساعت',
                  'سفارش مراسم و سورپرایز',
                ],
                button: 'رزرو و مشاهده',
                onTap: () => _comingSoon(context, 'Royal Village'),
              ),

              const SizedBox(height: 14),

              // ROYAL MALL
              _ServiceCard(
                icon: Icons.storefront,
                title: 'ROYAL MALL',
                subtitle: 'باشگاه خرید اعضا',
                badge: '۳۰٪ تخفیف',
                items: const [
                  'معرفی فروشگاه‌ها',
                  'دسته‌بندی مغازه‌ها',
                  'پیشنهادهای ویژه',
                  'تخفیف اعضای اپ',
                  'خدمات و رویدادهای پاساژ',
                ],
                button: 'مشاهده فروشگاه‌ها',
                onTap: () => _comingSoon(context, 'Royal Mall'),
              ),

              const SizedBox(height: 14),

              // HARMONIA
              _ServiceCard(
                icon: Icons.campaign_outlined,
                title: 'HARMONIA ADVERTISING',
                subtitle: 'مدیریت تبلیغات: الهه عبادی',
                items: const [
                  'رزرو لایت‌باکس تبلیغاتی',
                  'انتخاب محل تبلیغ',
                  'انتخاب مدت نمایش',
                  'بارگذاری طرح تبلیغ',
                  'سفارش طراحی اختصاصی',
                ],
                button: 'ثبت سفارش تبلیغ',
                onTap: () => _comingSoon(context, 'Harmonia Advertising'),
              ),

              const SizedBox(height: 14),

              // ETTEHAD
              _ServiceCard(
                icon: Icons.apartment,
                title: 'ETTEHAD SAZEH ROYAL',
                subtitle: 'دکتر مسعود اتحاد',
                items: const [
                  'پروژه‌های ساختمانی',
                  'طراحی و بازسازی',
                  'طراحی داخلی و نما',
                  'مدیریت پروژه',
                  'درخواست مشاوره',
                ],
                button: 'مشاهده پروژه‌ها',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EttehadPage(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 14),

              // SALMANZADEH
              _ServiceCard(
                icon: Icons.school_outlined,
                title: 'SALMANZADEH',
                subtitle: 'دکتر ناصر سلمان‌زاده',
                items: const [
                  'معرفی و رزومه',
                  'دوره‌های آموزشی',
                  'مدیریت Royal Village',
                  'برنامه‌های تخصصی',
                  'رزرو جلسه و دوره',
                ],
                button: 'مشاهده و رزرو',
                onTap: () => _comingSoon(context, 'Salmanzadeh'),
              ),

              const SizedBox(height: 14),

              // CONSULTING
              _ServiceCard(
                icon: Icons.psychology_alt_outlined,
                title: 'مدیریت و مشاوره',
                subtitle: 'از فروپاشی تا احیا',
                items: const [
                  'فلسفه مدیریت مرگ',
                  'پکیج‌های مشاوره',
                  'درخواست جلسه خصوصی',
                  'آموزش و سخنرانی',
                  'طراحی مسیر بازگشت و رشد',
                ],
                button: 'مشاهده پکیج‌ها',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ConsultingPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFF090B0D),
          selectedItemColor: gold2,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          currentIndex: 0,
          onTap: (index) {
            if (index != 0) {
              _comingSoon(context, [
                '',
                'رزروها',
                'تخفیف‌ها',
                'سفارش‌ها',
                'پروفایل',
              ][index]);
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'خانه',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              label: 'رزرو',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_offer_outlined),
              label: 'تخفیف‌ها',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              label: 'سفارش‌ها',
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

class _Person extends StatelessWidget {
  final IconData icon;
  final String name;
  final String role;

  const _Person({
    required this.icon,
    required this.name,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 78,
      child: Column(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: HomePage.gold,
                width: 1.5,
              ),
              color: const Color(0xFF111418),
            ),
            child: Icon(
              icon,
              color: HomePage.gold2,
              size: 29,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            role,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: HomePage.gold,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<String> items;
  final String button;
  final VoidCallback onTap;
  final String? badge;

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.items,
    required this.button,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: HomePage.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: HomePage.gold.withOpacity(.65),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF2A2111),
                child: Icon(icon, color: HomePage.gold2),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: HomePage.gold2,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6E4D12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    badge!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 15),

          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.circle,
                    size: 5,
                    color: HomePage.gold,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        color: Color(0xFFE5E5E5),
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF765218),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(button),
            ),
          ),
        ],
      ),
    );
  }
}