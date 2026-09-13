import 'package:flutter/material.dart';

import 'reservation_page.dart';
import 'salon_detail_page.dart';

class RoyalVillageEntryPage extends StatefulWidget {
  const RoyalVillageEntryPage({super.key});

  @override
  State<RoyalVillageEntryPage> createState() => _RoyalVillageEntryPageState();
}

class _RoyalVillageEntryPageState extends State<RoyalVillageEntryPage> {
  static const bg = Color(0xFF00120E);
  static const panel = Color(0xFF06241C);
  static const emerald = Color(0xFF0E5A43);
  static const gold = Color(0xFFD6AF58);
  static const gold2 = Color(0xFFF5D98E);

  int guests = 2;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final requestController = TextEditingController();

  final salons = const [
    _Salon('Salon Jardin', 'ظرفیت 12 تا 24 نفر', 'assets/image/salon_jardin.png'),
    _Salon('Salon Lumière', 'ظرفیت 12 تا 24 نفر', 'assets/image/salon_lumiere.png'),
    _Salon('Salon Doré', 'ظرفیت 12 تا 24 نفر', 'assets/image/salon_dore.png'),
    _Salon('Salon Âme du Poète', 'ظرفیت 12 تا 24 نفر', 'assets/image/salon_ame_du_poete.png'),
    _Salon('Salon Royal', 'ظرفیت 14 تا 18 نفر', 'assets/image/salon_royal.png'),
    _Salon('Salon Privé', 'ظرفیت 8 تا 12 نفر', 'assets/image/salon_prive.png'),
    _Salon('Salon Noir', 'ظرفیت 12 تا 20 نفر', 'assets/image/salon_noir.png'),
    _Salon('RV Lounge\nImpérial Classique', 'ظرفیت 4 تا 18 نفر', 'assets/image/rv_lounge_imperial_classique.png'),
  ];

  @override
  void dispose() {
    requestController.dispose();
    super.dispose();
  }

  void _openSalon(_Salon salon) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SalonDetailPage(
          salonName: salon.name.replaceAll('\n', ' '),
        ),
      ),
    );
  }

  void _reserve([String? salonName]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReservationPage(
          salonName: salonName ?? 'Royal Village',
        ),
      ),
    );
  }

  void _soon(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF061B15),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: gold),
          ),
          content: Text(
            '$text در حال تکمیل است',
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
        ),
      );
  }

  Future<void> _pickDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (result != null) setState(() => selectedDate = result);
  }

  Future<void> _pickTime() async {
    final result = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 20, minute: 0),
    );
    if (result != null) setState(() => selectedTime = result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0, -0.65),
                      radius: 1.15,
                      colors: [emerald.withOpacity(.18), bg],
                    ),
                  ),
                ),
              ),
            ),
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: _hero()),
                SliverToBoxAdapter(child: _salonsSection()),
                SliverToBoxAdapter(child: _experienceSection()),
                SliverToBoxAdapter(child: _bookingForm()),
                const SliverToBoxAdapter(child: SizedBox(height: 110)),
              ],
            ),
            Positioned(left: 0, right: 0, bottom: 0, child: _bottomNav()),
          ],
        ),
      ),
    );
  }

  Widget _hero() {
    return SizedBox(
      height: 360,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/image/royal_village.png', fit: BoxFit.cover, filterQuality: FilterQuality.high),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black26, Colors.transparent, Color(0xEE00120E)],
              ),
            ),
          ),
          Positioned(top: 10, left: 12, child: _sideMenu(leftSide: true)),
          Positioned(top: 10, right: 12, child: _sideMenu(leftSide: false)),
          Positioned(
            left: 90,
            top: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('RV', style: TextStyle(color: gold2, fontSize: 58, height: .9, fontWeight: FontWeight.w800, shadows: [Shadow(color: Colors.black, blurRadius: 18)])),
                SizedBox(height: 6),
                Text('Le Royal Village Café', style: TextStyle(color: gold2, fontSize: 18, fontWeight: FontWeight.w700)),
                Text('RESTAURANT & LOUNGE  •  TABRIZ', style: TextStyle(color: Colors.white70, fontSize: 9, letterSpacing: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sideMenu({required bool leftSide}) {
    final items = leftSide
        ? const [
            _MenuItem(Icons.home_outlined, 'خانه'),
            _MenuItem(Icons.restaurant_outlined, 'رستوران'),
            _MenuItem(Icons.calendar_month_outlined, 'رزرو'),
            _MenuItem(Icons.music_note_outlined, 'موسیقی زنده'),
            _MenuItem(Icons.card_giftcard_outlined, 'سورپرایز'),
            _MenuItem(Icons.workspace_premium_outlined, 'Royal Club'),
            _MenuItem(Icons.more_horiz, 'بیشتر'),
          ]
        : const [
            _MenuItem(Icons.cake_outlined, 'تولد'),
            _MenuItem(Icons.favorite_border, 'سالگرد'),
            _MenuItem(Icons.diamond_outlined, 'خواستگاری'),
            _MenuItem(Icons.groups_outlined, 'سورپرایز\n10 نفره'),
            _MenuItem(Icons.business_center_outlined, 'جلسه کاری'),
            _MenuItem(Icons.group_outlined, 'مهمانی خصوصی'),
          ];

    return Container(
      width: 70,
      decoration: BoxDecoration(
        color: const Color(0xDA001913),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: gold.withOpacity(.45)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final selected = leftSide && index == 1;
          return InkWell(
            onTap: () => _soon(item.label.replaceAll('\n', ' ')),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: selected ? emerald.withOpacity(.75) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border(bottom: BorderSide(color: gold.withOpacity(.16))),
              ),
              child: Column(
                children: [
                  Icon(item.icon, color: gold2, size: 21),
                  const SizedBox(height: 4),
                  Text(item.label, textAlign: TextAlign.center, textDirection: TextDirection.rtl, style: const TextStyle(color: Colors.white, fontSize: 9, height: 1.25)),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _salonsSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
      decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF083B2E), Color(0xFF001A14)])),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('رزرو سالن‌ها', textDirection: TextDirection.rtl, style: TextStyle(color: gold2, fontSize: 27, fontWeight: FontWeight.w800)),
              Text('۸ سالن منحصر‌به‌فرد', textDirection: TextDirection.rtl, style: TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 205,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: salons.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) => _salonCard(salons[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _salonCard(_Salon salon) {
    return InkWell(
      onTap: () => _openSalon(salon),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 132,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: const Color(0xFF071A15), borderRadius: BorderRadius.circular(14), border: Border.all(color: gold.withOpacity(.65))),
        child: Column(
          children: [
            Expanded(child: Image.asset(salon.image, width: double.infinity, fit: BoxFit.cover, filterQuality: FilterQuality.high)),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 7, 5, 8),
              child: Column(
                children: [
                  Text(salon.name, maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600, height: 1.15)),
                  const SizedBox(height: 3),
                  Text(salon.capacity, textDirection: TextDirection.rtl, textAlign: TextAlign.center, style: const TextStyle(color: gold2, fontSize: 9)),
                  const SizedBox(height: 6),
                  Container(width: 28, height: 28, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF00120E), border: Border.all(color: gold)), child: const Icon(Icons.arrow_forward, color: gold2, size: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _experienceSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: _sectionCard(
                  title: 'موسیقی زنده',
                  child: Row(
                    children: [
                      Expanded(child: _featureTile(Icons.music_note, 'گیتار', 'اجرای خصوصی')),
                      const SizedBox(width: 7),
                      Expanded(child: _featureTile(Icons.music_note, 'ویولن', 'اجرای خصوصی')),
                      const SizedBox(width: 7),
                      Expanded(child: _featureTile(Icons.library_music_outlined, 'گیتار + ویولن', 'دونفره')),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: _sectionCard(
                  title: 'سورپرایز ناگهانی',
                  child: InkWell(
                    onTap: () => _soon('سورپرایز ناگهانی'),
                    child: Container(
                      height: 145,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), image: const DecorationImage(image: AssetImage('assets/image/royal_village.png'), fit: BoxFit.cover)),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(width: double.infinity, padding: const EdgeInsets.all(9), color: Colors.black54, child: const Text('تا ۱۰ نفر ورود هماهنگ', textAlign: TextAlign.center, textDirection: TextDirection.rtl, style: TextStyle(color: Colors.white, fontSize: 11))),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _sectionCard(
            title: 'افزودنی‌های محبوب',
            child: Row(
              children: [
                Expanded(child: _addon(Icons.cake_outlined, 'کیک اختصاصی')),
                const SizedBox(width: 7),
                Expanded(child: _addon(Icons.local_florist_outlined, 'گل‌آرایی میز')),
                const SizedBox(width: 7),
                Expanded(child: _addon(Icons.light_mode_outlined, 'شمع و دکور')),
                const SizedBox(width: 7),
                Expanded(child: _addon(Icons.photo_camera_outlined, 'فیلمبرداری حرفه‌ای')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(color: panel.withOpacity(.85), borderRadius: BorderRadius.circular(15), border: Border.all(color: emerald.withOpacity(.8))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, textDirection: TextDirection.rtl, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 9),
          child,
        ],
      ),
    );
  }

  Widget _featureTile(IconData icon, String title, String subtitle) {
    return InkWell(
      onTap: () => _soon(title),
      child: Container(
        height: 145,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: const Color(0xFF061A15), borderRadius: BorderRadius.circular(12), border: Border.all(color: gold.withOpacity(.45))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: gold2, size: 34),
            const SizedBox(height: 9),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11)),
            const SizedBox(height: 4),
            Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white60, fontSize: 9)),
            const Spacer(),
            const Icon(Icons.arrow_circle_right_outlined, color: gold2, size: 23),
          ],
        ),
      ),
    );
  }

  Widget _addon(IconData icon, String title) {
    return InkWell(
      onTap: () => _soon(title),
      child: Container(
        height: 95,
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(color: const Color(0xFF061A15), borderRadius: BorderRadius.circular(12), border: Border.all(color: gold.withOpacity(.45))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: gold2, size: 28),
            const SizedBox(height: 7),
            Text(title, textAlign: TextAlign.center, textDirection: TextDirection.rtl, style: const TextStyle(color: Colors.white, fontSize: 10, height: 1.2)),
          ],
        ),
      ),
    );
  }

  Widget _bookingForm() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _sectionCard(
                  title: 'انتخاب تاریخ و ساعت',
                  child: Row(
                    children: [
                      Expanded(child: _formButton(icon: Icons.calendar_month_outlined, text: selectedDate == null ? 'انتخاب کنید' : '${selectedDate!.year}/${selectedDate!.month}/${selectedDate!.day}', onTap: _pickDate)),
                      const SizedBox(width: 6),
                      Expanded(child: _formButton(icon: Icons.schedule, text: selectedTime == null ? 'ساعت' : selectedTime!.format(context), onTap: _pickTime)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _sectionCard(
                  title: 'تعداد مهمان',
                  child: Container(
                    height: 54,
                    decoration: BoxDecoration(color: const Color(0xFF08281F), borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(onPressed: () => setState(() => guests = guests > 1 ? guests - 1 : 1), icon: const Icon(Icons.remove, color: gold2)),
                        Text('$guests', style: const TextStyle(color: Colors.white, fontSize: 18)),
                        IconButton(onPressed: () => setState(() => guests++), icon: const Icon(Icons.add, color: gold2)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _sectionCard(
            title: 'درخواست خاص',
            child: TextField(
              controller: requestController,
              minLines: 2,
              maxLines: 4,
              textDirection: TextDirection.rtl,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'متن درخواست شما (اختیاری)',
                hintTextDirection: TextDirection.rtl,
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: const Color(0xFF08281F),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Tabriz', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)), Text('Le Royal Village Café', style: TextStyle(color: Colors.white60, fontSize: 11))])),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 62,
                  child: ElevatedButton(
                    onPressed: () => _reserve(),
                    style: ElevatedButton.styleFrom(backgroundColor: gold2, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)), elevation: 8, shadowColor: gold.withOpacity(.35)),
                    child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.calendar_month), SizedBox(width: 10), Text('رزرو میز الآن', textDirection: TextDirection.rtl, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)), SizedBox(width: 10), Icon(Icons.arrow_forward)]),
                  ),
                ),
              ),
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text('0914 53 53 53 0', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)), Text('پشتیبانی و مشاوره', textDirection: TextDirection.rtl, style: TextStyle(color: Colors.white60, fontSize: 10))])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _formButton({required IconData icon, required String text, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(color: const Color(0xFF08281F), borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Icon(icon, color: gold2, size: 22),
            const SizedBox(width: 7),
            Expanded(child: Text(text, textAlign: TextAlign.center, textDirection: TextDirection.rtl, style: const TextStyle(color: Colors.white, fontSize: 11))),
          ],
        ),
      ),
    );
  }

  Widget _bottomNav() {
    final items = const [
      _MenuItem(Icons.home_outlined, 'خانه'),
      _MenuItem(Icons.restaurant_outlined, 'رستوران'),
      _MenuItem(Icons.calendar_month_outlined, 'رزرو'),
      _MenuItem(Icons.music_note_outlined, 'موسیقی'),
      _MenuItem(Icons.card_giftcard_outlined, 'سورپرایز'),
      _MenuItem(Icons.workspace_premium_outlined, 'Royal Club'),
      _MenuItem(Icons.more_horiz, 'بیشتر'),
    ];
    return Container(
      height: 82,
      decoration: BoxDecoration(color: const Color(0xF5000D0A), border: Border(top: BorderSide(color: gold.withOpacity(.35)))),
      child: Row(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final selected = index == 1;
          return Expanded(
            child: InkWell(
              onTap: () {
                if (index == 0) Navigator.pop(context);
                if (index == 2) _reserve();
                if (index > 2) _soon(item.label);
              },
              child: Container(
                decoration: BoxDecoration(color: selected ? emerald.withOpacity(.45) : Colors.transparent, borderRadius: selected ? BorderRadius.circular(14) : null),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item.icon, color: selected ? gold2 : Colors.white54, size: 23),
                    const SizedBox(height: 4),
                    Text(item.label, textAlign: TextAlign.center, textDirection: TextDirection.rtl, style: TextStyle(color: selected ? gold2 : Colors.white60, fontSize: 9)),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _Salon {
  final String name;
  final String capacity;
  final String image;
  const _Salon(this.name, this.capacity, this.image);
}

class _MenuItem {
  final IconData icon;
  final String label;
  const _MenuItem(this.icon, this.label);
}
