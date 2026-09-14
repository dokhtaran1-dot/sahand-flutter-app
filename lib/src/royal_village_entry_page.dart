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
  static const emerald = Color(0xFF0B4E3A);
  static const gold = Color(0xFFD6AF58);
  static const gold2 = Color(0xFFF5D98E);

  int guests = 2;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final requestController = TextEditingController();

  final List<_Salon> topSalons = const [
    _Salon(
      'RV Lounge\nImpérial Classique',
      'ظرفیت 1 تا 20 نفر',
      'assets/image/rv_lounge_imperial_classique.png',
      locked: true,
    ),
    _Salon(
      'Salon Jardin',
      'ظرفیت 1 تا 20 نفر',
      'assets/image/salon_jardin.png',
    ),
    _Salon(
      'Salon Lumière',
      'ظرفیت 1 تا 20 نفر',
      'assets/image/salon_lumiere.png',
    ),
    _Salon(
      'Salon Doré',
      'ظرفیت 1 تا 20 نفر',
      'assets/image/salon_dore.png',
    ),
  ];

  final List<_Salon> bottomSalons = const [
    _Salon(
      'Salon Royal',
      'ظرفیت 1 تا 20 نفر',
      'assets/image/salon_royal.png',
    ),
    _Salon(
      'Salon Privé',
      'ظرفیت 1 تا 20 نفر',
      'assets/image/salon_prive.png',
    ),
    _Salon(
      'Salon Noir',
      'ظرفیت 1 تا 20 نفر',
      'assets/image/salon_noir.png',
    ),
    _Salon(
      'Salon Âme du Poète',
      'ظرفیت 1 تا 20 نفر',
      'assets/image/salon_ame_du_poete.png',
    ),
  ];

  @override
  void dispose() {
    requestController.dispose();
    super.dispose();
  }

  void _openSalon(_Salon salon) {
    if (salon.locked) {
      _clubLocked();
      return;
    }
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

  void _clubLocked() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF071A15),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: gold),
          ),
          content: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_rounded, color: gold2, size: 19),
              SizedBox(width: 8),
              Text(
                'RV Lounge فقط برای اعضای Royal Club',
                textDirection: TextDirection.rtl,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ],
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
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.8),
                    radius: 1.25,
                    colors: [emerald.withOpacity(.35), bg],
                  ),
                ),
              ),
            ),
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: _header()),
                SliverToBoxAdapter(child: _salonGrid(topSalons)),
                SliverToBoxAdapter(child: _grandSalon()),
                SliverToBoxAdapter(child: _salonGrid(bottomSalons)),
                SliverToBoxAdapter(child: _experienceSection()),
                SliverToBoxAdapter(child: _bookingForm()),
                const SliverToBoxAdapter(child: SizedBox(height: 92)),
              ],
            ),
            Positioned(left: 0, right: 0, bottom: 0, child: _bottomNav()),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return SizedBox(
      height: 285,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/image/royal_village.png',
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x44000000), Color(0x6600120E), bg],
              ),
            ),
          ),
          Positioned(
            top: 12,
            left: 14,
            child: _circleButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => Navigator.maybePop(context),
            ),
          ),
          Positioned(
            top: 12,
            right: 14,
            child: _circleButton(
              icon: Icons.menu_rounded,
              onTap: () => _soon('منو'),
            ),
          ),
          const Align(
            alignment: Alignment(0, -.15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'RV',
                  style: TextStyle(
                    color: gold2,
                    fontSize: 72,
                    height: .9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                    shadows: [Shadow(color: Colors.black87, blurRadius: 22)],
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  'LE ROYAL VILLAGE CAFÉ',
                  style: TextStyle(
                    color: gold2,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.6,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'RESTAURANT & LOUNGE • TABRIZ',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 9,
                    letterSpacing: 1.8,
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 12,
            child: Text(
              'Royal Moments',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 31,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                shadows: [Shadow(color: Colors.black, blurRadius: 12)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(99),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xCC001712),
          border: Border.all(color: gold.withOpacity(.8)),
        ),
        child: Icon(icon, color: gold2, size: 20),
      ),
    );
  }

  Widget _salonGrid(List<_Salon> salons) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
      child: LayoutBuilder(
        builder: (context, c) {
          const gap = 7.0;
          final width = (c.maxWidth - gap * 3) / 4;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(salons.length, (i) {
              return Padding(
                padding: EdgeInsets.only(right: i == salons.length - 1 ? 0 : gap),
                child: SizedBox(width: width, child: _salonCard(salons[i])),
              );
            }),
          );
        },
      ),
    );
  }

  Widget _salonCard(_Salon salon) {
    return InkWell(
      onTap: () => _openSalon(salon),
      borderRadius: BorderRadius.circular(13),
      child: Container(
        height: 190,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFF071A15),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: gold.withOpacity(.82), width: 1.1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.35),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              salon.image,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xF0000C09)],
                  stops: [.35, 1],
                ),
              ),
            ),
            if (salon.locked)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(.72),
                    border: Border.all(color: gold2),
                  ),
                  child: const Icon(Icons.lock_rounded, color: gold2, size: 16),
                ),
              ),
            Positioned(
              left: 6,
              right: 6,
              bottom: 8,
              child: Column(
                children: [
                  Text(
                    salon.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: gold2,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                      shadows: [Shadow(color: Colors.black, blurRadius: 8)],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    salon.locked ? 'فقط اعضای Royal Club' : salon.capacity,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _grandSalon() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
      child: InkWell(
        onTap: () => _reserve('Grand Salon'),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: 215,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: gold2, width: 1.3),
            boxShadow: [
              BoxShadow(
                color: gold.withOpacity(.18),
                blurRadius: 18,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/image/royal_village.png',
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x22000000), Color(0xEE00120E)],
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'GRAND SALON',
                      style: TextStyle(
                        color: gold2,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        shadows: [Shadow(color: Colors.black, blurRadius: 12)],
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'سالن اصلی رستوران',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'ظرفیت 250 نفر • رزرو میز',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(color: gold2, fontSize: 13, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _experienceSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: _sectionCard(
                  title: 'موسیقی زنده',
                  child: Row(
                    children: [
                      Expanded(child: _miniAction(Icons.music_note_rounded, 'گیتار')),
                      const SizedBox(width: 6),
                      Expanded(child: _miniAction(Icons.music_note_rounded, 'ویولن')),
                      const SizedBox(width: 6),
                      Expanded(child: _miniAction(Icons.library_music_rounded, 'گیتار + ویولن')),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: _sectionCard(
                  title: 'سورپرایز ناگهانی',
                  child: InkWell(
                    onTap: () => _soon('سورپرایز ناگهانی'),
                    child: Container(
                      height: 105,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        image: const DecorationImage(
                          image: AssetImage('assets/image/royal_village.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          color: Colors.black54,
                          child: const Text(
                            'تا 10 نفر ورود هماهنگ',
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _sectionCard(
            title: 'افزودنی‌های محبوب',
            child: Row(
              children: [
                Expanded(child: _miniAction(Icons.cake_outlined, 'کیک اختصاصی')),
                const SizedBox(width: 6),
                Expanded(child: _miniAction(Icons.local_florist_outlined, 'گل‌آرایی میز')),
                const SizedBox(width: 6),
                Expanded(child: _miniAction(Icons.light_mode_outlined, 'شمع و دکور')),
                const SizedBox(width: 6),
                Expanded(child: _miniAction(Icons.photo_camera_outlined, 'فیلمبرداری')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: panel.withOpacity(.92),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: gold.withOpacity(.42)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: const TextStyle(color: gold2, fontSize: 15, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _miniAction(IconData icon, String text) {
    return InkWell(
      onTap: () => _soon(text),
      child: Container(
        height: 82,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF041812),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: gold.withOpacity(.42)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: gold2, size: 24),
            const SizedBox(height: 7),
            Text(
              text,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bookingForm() {
    final dateText = selectedDate == null
        ? 'تاریخ'
        : '${selectedDate!.year}/${selectedDate!.month}/${selectedDate!.day}';
    final timeText = selectedTime == null ? 'ساعت' : selectedTime!.format(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 18),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF041812),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: gold.withOpacity(.55)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _bookingButton(
                    icon: Icons.calendar_month_outlined,
                    label: dateText,
                    onTap: _pickDate,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _bookingButton(
                    icon: Icons.schedule_outlined,
                    label: timeText,
                    onTap: _pickTime,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: gold.withOpacity(.5)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: guests > 1 ? () => setState(() => guests--) : null,
                          icon: const Icon(Icons.remove, color: gold2, size: 18),
                        ),
                        Text('$guests', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: guests < 250 ? () => setState(() => guests++) : null,
                          icon: const Icon(Icons.add, color: gold2, size: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 9),
            TextField(
              controller: requestController,
              textDirection: TextDirection.rtl,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'درخواست خاص (اختیاری)',
                hintTextDirection: TextDirection.rtl,
                hintStyle: const TextStyle(color: Colors.white54, fontSize: 12),
                filled: true,
                fillColor: const Color(0xFF071F18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: gold.withOpacity(.45)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: gold.withOpacity(.45)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => _reserve('Royal Village'),
                icon: const Icon(Icons.calendar_month_rounded),
                label: const Text(
                  'رزرو میزم الآن',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: gold,
                  foregroundColor: const Color(0xFF06110D),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bookingButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: gold.withOpacity(.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: gold2, size: 18),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                textDirection: TextDirection.rtl,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomNav() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xF2061511),
        border: Border(top: BorderSide(color: gold.withOpacity(.55))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home_outlined, 'خانه', () => Navigator.maybePop(context)),
          _navItem(Icons.restaurant_outlined, 'رستوران', () {}),
          _navItem(Icons.calendar_month_outlined, 'رزرو', () => _reserve()),
          _navItem(Icons.music_note_outlined, 'موسیقی زنده', () => _soon('موسیقی زنده')),
          _navItem(Icons.card_giftcard_outlined, 'سورپرایز', () => _soon('سورپرایز')),
          _navItem(Icons.workspace_premium_outlined, 'Royal Club', () => _soon('Royal Club')),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 54,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: gold2, size: 20),
            const SizedBox(height: 3),
            Text(
              label,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 8.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _Salon {
  final String name;
  final String capacity;
  final String image;
  final bool locked;

  const _Salon(
    this.name,
    this.capacity,
    this.image, {
    this.locked = false,
  });
}
