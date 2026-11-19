import 'package:flutter/material.dart';

/// Interactive Imperial Lounge booking presentation based on the approved
/// emerald-and-gold reference. The owning SalonDetailPage retains all state,
/// catalogs, selections and reservation submission.
class ImperialLuxuryBookingView extends StatelessWidget {
  const ImperialLuxuryBookingView({
    super.key, required this.salonName,
    required this.date, required this.time,
    required this.designCount, required this.cakeCount,
    required this.designNumber, required this.cakeNumber,
    required this.music, required this.onDate, required this.onTime,
    required this.onDesigns, required this.onCakes, required this.onMusic,
    required this.onCatalogue, required this.onReserve,
  });

  final String salonName;
  final DateTime? date;
  final TimeOfDay? time;
  final int designCount;
  final int cakeCount;
  final int? designNumber;
  final int? cakeNumber;
  final String? music;
  final VoidCallback onDate, onTime, onDesigns, onCakes;
  final VoidCallback? onCatalogue;
  final VoidCallback onMusic, onReserve;

  static const gold = Color(0xFFE0C084);
  static const goldLight = Color(0xFFF3D79F);
  static const black = Color(0xFF030907);

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
      key: const ValueKey('imperial-luxury-booking'),
      backgroundColor: black,
      appBar: AppBar(
        backgroundColor: black, foregroundColor: gold,
        centerTitle: true, elevation: 0,
        title: Text(salonName, textDirection: TextDirection.ltr,
          style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: gold)),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFF082216), Color(0xFF030806),
                   Color(0xFF0B291A)])),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(15, 4, 15, 34),
          children: [
            const Center(child: Text('RV', textDirection: TextDirection.ltr,
              style: TextStyle(color: goldLight, fontSize: 52,
                fontWeight: FontWeight.w300, letterSpacing: 6))),
            const SizedBox(height: 2),
            const Center(child: Text('L’EXPÉRIENCE IMPÉRIALE',
              textDirection: TextDirection.ltr,
              style: TextStyle(color: gold, fontSize: 10,
                letterSpacing: 2.5))),
            const SizedBox(height: 18),
            Row(children: [
              Expanded(child: _LuxuryChoice(
                key: const ValueKey('imperial-date'),
                icon: Icons.calendar_month_outlined, title: 'تاریخ',
                value: date == null ? 'انتخاب تاریخ'
                  : date!.year.toString() + '/' +
                    date!.month.toString() + '/' + date!.day.toString(),
                onTap: onDate)),
              const SizedBox(width: 10),
              Expanded(child: _LuxuryChoice(
                key: const ValueKey('imperial-time'),
                icon: Icons.access_time_rounded, title: 'ساعت',
                value: time == null ? 'انتخاب ساعت' : time!.format(context),
                onTap: onTime)),
            ]),
            const SizedBox(height: 15),
            _LuxuryService(
              key: const ValueKey('imperial-designs'),
              icon: Icons.celebration_outlined,
              photo: 'assets/image/salon_gallery/imperial/design_01.webp',
              title: '$designCount دیزاین تولد اختصاصی',
              subtitle: designNumber == null
                ? 'انتخاب تم و دیزاین مخصوص این سالن'
                : 'دیزاین $designNumber انتخاب شده',
              button: 'مشاهده دیزاین‌ها', onTap: onDesigns),
            const SizedBox(height: 14),
            _LuxuryService(
              key: const ValueKey('imperial-cakes'),
              icon: Icons.cake_outlined,
              photo: 'assets/image/salon_gallery/imperial/cake_01.webp',
              title: '$cakeCount مدل کیک اختصاصی',
              subtitle: cakeNumber == null
                ? 'انتخاب کیک متناسب با سالن و مراسم'
                : 'کیک $cakeNumber انتخاب شده',
              button: 'مشاهده کیک‌ها', onTap: onCakes),
            const SizedBox(height: 14),
            _LuxuryService(
              key: const ValueKey('imperial-music'),
              icon: Icons.headphones_rounded,
              title: '۳ موسیقی اختصاصی',
              subtitle: music ?? 'انتخاب موسیقی مخصوص این سالن',
              button: 'انتخاب موسیقی', onTap: onMusic),
            const SizedBox(height: 14),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(colors: [
                  Color(0xFF123A27), Color(0xFF06130E)]),
                border: Border.all(color: gold)),
              padding: const EdgeInsets.all(19),
              child: const Row(children: [
                Icon(Icons.workspace_premium_outlined,
                  color: goldLight, size: 29),
                SizedBox(width: 11),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('VIP EXPERIENCE', textDirection: TextDirection.ltr,
                      style: TextStyle(color: goldLight,
                        fontSize: 17, fontWeight: FontWeight.w700)),
                    SizedBox(height: 5),
                    Text('دیزاین اختصاصی، کیک ویژه و موسیقی منتخب',
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                )),
              ]),
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              key: const ValueKey('imperial-catalogue'),
              onPressed: onCatalogue,
              icon: const Icon(Icons.collections_bookmark_outlined),
              label: const Text('مشاهده عکس و کاتالوگ اصلی سالن'),
              style: OutlinedButton.styleFrom(
                foregroundColor: goldLight,
                side: const BorderSide(color: gold),
                padding: const EdgeInsets.all(15))),
            const SizedBox(height: 15),
            SizedBox(height: 56, child: FilledButton(
              key: const ValueKey('imperial-continue-reservation'),
              onPressed: onReserve,
              style: FilledButton.styleFrom(
                backgroundColor: gold, foregroundColor: black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16))),
              child: const Text('ادامه و ثبت درخواست رزرو',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            )),
            const SizedBox(height: 11),
            const Text('ثبت درخواست به معنی تأیید نهایی رزرو نیست.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 11)),
          ],
        ),
      ),
    ),
  );
}

class _LuxuryChoice extends StatelessWidget {
  const _LuxuryChoice({super.key, required this.icon,
    required this.title, required this.value, required this.onTap});
  final IconData icon;
  final String title, value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        constraints: const BoxConstraints(minHeight: 124),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [
            Color(0xFF12412A), Color(0xFF06130E)]),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: ImperialLuxuryBookingView.gold)),
        padding: const EdgeInsets.all(12),
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 31, color: ImperialLuxuryBookingView.goldLight),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: Colors.white,
              fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 6),
            Text(value, textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis, maxLines: 1,
              style: const TextStyle(color: Colors.white60, fontSize: 12)),
          ]),
      ),
    ),
  );
}

class _LuxuryService extends StatelessWidget {
  const _LuxuryService({super.key, required this.title,
    required this.subtitle, required this.button, required this.icon,
    required this.onTap, this.photo});
  final String title, subtitle, button;
  final IconData icon;
  final String? photo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Container(
    height: 186,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topRight, end: Alignment.bottomLeft,
        colors: [Color(0xFF0A2C1D), Color(0xFF040A07)]),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: ImperialLuxuryBookingView.gold, width: 1.1),
    ),
    child: Stack(children: [
      if (photo != null)
        Positioned(left: 0, top: 0, bottom: 0, width: 120,
          child: Image.asset(photo!, fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const ColoredBox(
              color: Color(0xFF0A291B),
              child: Icon(Icons.auto_awesome,
                color: ImperialLuxuryBookingView.gold, size: 39)))),
      if (photo != null)
        Positioned(left: 87, top: 0, bottom: 0, width: 65,
          child: DecoratedBox(decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              const Color(0x000A2016), const Color(0xFF082116)])))),
      if (photo == null)
        const Positioned(left: 18, top: 23,
          child: Icon(Icons.headphones_rounded, size: 64,
            color: Color(0xFFB79551))),
      Padding(
        padding: const EdgeInsets.fromLTRB(15, 17, 15, 14),
        child: Column(children: [
          Row(children: [
            Icon(icon, size: 29, color: ImperialLuxuryBookingView.goldLight),
            const SizedBox(width: 8),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: ImperialLuxuryBookingView.goldLight,
                    fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(subtitle, maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70,
                    fontSize: 11)),
              ],
            )),
          ]),
          const Spacer(),
          Align(alignment: Alignment.centerRight,
            child: SizedBox(
              width: 198, height: 48,
              child: OutlinedButton(
                onPressed: onTap,
                style: OutlinedButton.styleFrom(
                  foregroundColor: ImperialLuxuryBookingView.goldLight,
                  backgroundColor: const Color(0xD903120C),
                  side: const BorderSide(
                    color: ImperialLuxuryBookingView.gold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25))),
                child: Text(button, maxLines: 1,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ]),
      ),
    ]),
  );
}
