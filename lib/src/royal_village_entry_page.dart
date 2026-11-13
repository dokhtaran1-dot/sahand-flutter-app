import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'photo_orbit.dart';
import 'reservation_page.dart';
import 'royal_club_game_page.dart';
import 'rv_gallery_page.dart';
import 'salon_detail_page.dart';
import 'rv_booking_poster_page.dart';

class RoyalVillageEntryPage extends StatelessWidget {
  const RoyalVillageEntryPage({super.key});

  static const String _art = 'assets/image/Rv_page2.png';
  static const double _designWidth = 1144;
  static const double _designHeight = 1536;
  static const Color _gold = Color(0xFFD6B15E);

  void _openSalon(BuildContext context, String name) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const {
        'Salon Doré', 'Salon Jardin', 'Salon Noir', 'Salon Âme du Poète',
        'Salon Royal', 'Salon Privé', 'RV Lounge Impérial Classique', 'Salon Lumière', 'Grand Salon',
      }.contains(name)
        ? RvBookingPosterPage(salonName: name)
        : SalonDetailPage(salonName: name)),
    );
  }

  void _openGallery(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RvGalleryPage()),
    );
  }

  void _openReservation(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ReservationPage(salonName: 'Royal Village'),
      ),
    );
  }

  void _openRoyalClub(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RoyalClubGamePage()),
    );
  }

  void _info(BuildContext context, String title, String body) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF03110D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        side: BorderSide(color: _gold),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 28),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: _gold,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  body,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.8,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // These are store searches, not claims that an official app listing
  // is already published. Replace them with verified product URLs when live.
  static const String _bazaarSearch =
      'https://cafebazaar.ir/search?q=ROYAL%20ONE';
  static const String _playSearch =
      'https://play.google.com/store/search?q=ROYAL%20ONE&c=apps';
  static const String _appStoreSearch =
      'https://apps.apple.com/us/search?term=ROYAL%20ONE';
  static const String _instagram =
      'https://www.instagram.com/the_royalmall/';

  // Previously supplied Royal Village contact number. Confirm with the
  // business before publishing externally.
  static const String _whatsAppNumber = '989145353530';

  Future<void> _openLink(
    BuildContext context,
    String link, {
    required String title,
  }) async {
    final uri = Uri.parse(link);
    try {
      if (await launchUrl(uri, mode: LaunchMode.externalApplication)) return;
      if (await launchUrl(uri, mode: LaunchMode.platformDefault)) return;
    } catch (_) {
      // Show a usable fallback instead of silently ignoring the tap.
    }
    if (!context.mounted) return;
    _info(context, title, 'باز کردن لینک ممکن نشد.\\n$link');
  }

  Future<void> _openWhatsApp(BuildContext context) async {
    final message = Uri.encodeComponent(
      'سلام، برای رزرو سالن‌های رویال ویلیج راهنمایی می‌خواهم.',
    );
    await _openLink(
      context,
      'https://wa.me/$_whatsAppNumber?text=$message',
      title: 'ارتباط با رویال ویلیج در واتساپ',
    );
  }

  void _openStoreChooser(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF07150F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        side: BorderSide(color: _gold),
      ),
      builder: (sheetContext) => SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 17, 18, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('ROYAL ONE',
                    style: TextStyle(color: _gold,
                        fontSize: 24, fontWeight: FontWeight.w900)),
                const SizedBox(height: 5),
                const Text(
                  'انتخاب فروشگاه برای جستجوی اپلیکیشن؛ '
                  'این لینک‌ها تأیید انتشار اپ نیستند.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, height: 1.5),
                ),
                const SizedBox(height: 15),
                ListTile(
                  leading: const Icon(Icons.storefront_rounded,
                      color: _gold),
                  title: const Text('کافه بازار',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _openLink(context, _bazaarSearch,
                        title: 'جستجو در کافه بازار');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.shop_rounded,
                      color: _gold),
                  title: const Text('Google Play',
                      textDirection: TextDirection.ltr,
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _openLink(context, _playSearch,
                        title: 'جستجو در Google Play');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.phone_iphone_rounded,
                      color: _gold),
                  title: const Text('App Store',
                      textDirection: TextDirection.ltr,
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _openLink(context, _appStoreSearch,
                        title: 'جستجو در App Store');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static const _salons = ['Salon Lumière', 'Salon Noir', 'Salon Jardin', 'Salon Privé', 'RV Lounge Impérial Classique', 'Salon Doré', 'Salon Âme du Poète', 'Salon Royal'];
  static const _photos = ['Salon_lumiere.png', 'Salon_noir.png', 'salon_jardin.png', 'Salon_prive.png', 'rv_lounge_imperial_classique.png', 'salon_dore.png', 'salon_ame_du_poete.png', 'Salon_royal.png'];

  void _showFullPhoto(BuildContext context, String title, String asset) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => Scaffold(
      backgroundColor: const Color(0xFF03120E),
      appBar: AppBar(backgroundColor: const Color(0xFF03120E), foregroundColor: _gold, title: Text(title)),
      body: Center(child: InteractiveViewer(
        minScale: 1, maxScale: 5,
        child: Image.asset(asset, fit: BoxFit.contain, filterQuality: FilterQuality.high),
      )),
      bottomNavigationBar: SafeArea(child: Padding(
        padding: const EdgeInsets.all(14),
        child: FilledButton(
          style: FilledButton.styleFrom(backgroundColor: _gold, foregroundColor: const Color(0xFF061710)),
          onPressed: () => _openSalon(context, title),
          child: const Text('مشاهده جزئیات و رزرو سالن'),
        ),
      )),
    )));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF061710),
    appBar: AppBar(backgroundColor: const Color(0xFF061710), foregroundColor: _gold,
      title: const Text('LE ROYAL VILLAGE CAFÉ', style: TextStyle(fontFamily: 'serif', fontSize: 17)),
      actions: [IconButton(tooltip: 'گالری', icon: const Icon(Icons.photo_library_outlined), onPressed: () => _openGallery(context))]),
    body: ListView(children: [
      AspectRatio(aspectRatio: 1.65, child: Stack(fit: StackFit.expand, children: [
        Image.asset('assets/image/Grand_Salon_Original.png', fit: BoxFit.cover, alignment: Alignment.topCenter),
        const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Color(0xFF061710)]))),
        const Positioned(left: 20, right: 20, bottom: 16, child: Column(children: [
          Text('RV', style: TextStyle(fontFamily: 'serif', fontSize: 50, color: _gold)),
          Text('رویال ویلاژ کافه', textDirection: TextDirection.rtl, style: TextStyle(fontSize: 25, color: Colors.white)),
          Text('کافه و رستوران · سالن‌های اختصاصی', textDirection: TextDirection.rtl, style: TextStyle(fontSize: 14, color: Color(0xFFF4DFAF))),
        ])),
      ])),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), child: Row(children: [
        Expanded(child: FilledButton.icon(style: FilledButton.styleFrom(backgroundColor: _gold, foregroundColor: const Color(0xFF061710)), onPressed: () => _openReservation(context), icon: const Icon(Icons.calendar_month), label: const Text('رزرو میز و سالن'))),
        const SizedBox(width: 12),
        OutlinedButton(onPressed: () => _openWhatsApp(context), child: const Text('ارتباط')),
      ])),
      const Padding(padding: EdgeInsets.only(top: 26), child: Text('OUR PRIVATE SALONS', textAlign: TextAlign.center, style: TextStyle(color: _gold, letterSpacing: 3, fontSize: 17))),
      PhotoOrbit(images: _photos.map((p) => 'assets/image/$p').toList(), labels: _salons, onSelected: (i) => _openSalon(context, _salons[i])),
      const Padding(padding: EdgeInsets.only(top: 18), child: Text('THE ROYAL SALON COLLECTION', textAlign: TextAlign.center, style: TextStyle(color: _gold, letterSpacing: 2, fontSize: 15))),
      Padding(padding: const EdgeInsets.all(20), child: LayoutBuilder(builder: (context, constraints) => Wrap(spacing: 12, runSpacing: 16, children: [
        for (var i = 0; i < _salons.length; i++) SizedBox(width: (constraints.maxWidth - 12) / 2, child: _SalonCard(name: _salons[i], image: 'assets/image/${_photos[i]}', onTap: () => _showFullPhoto(context, _salons[i], 'assets/image/${_photos[i]}'))),
        SizedBox(width: constraints.maxWidth, child: _SalonCard(name: 'Grand Salon', image: 'assets/image/Grand_Salon_Original.png', onTap: () => _showFullPhoto(context, 'Grand Salon', 'assets/image/Grand_Salon_Original.png'))),
      ]))),
      Padding(padding: const EdgeInsets.all(20), child: OutlinedButton.icon(onPressed: () => _openGallery(context), icon: const Icon(Icons.photo_library_outlined), label: const Text('مشاهدهٔ گالری'))),
      const Padding(padding: EdgeInsets.only(bottom: 32), child: Text('POWERED BY SAHAND CONSORTIUM', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, letterSpacing: 2, color: _gold))),
    ]),
  );
}

class _SalonCard extends StatelessWidget {
  final String name, image;
  final VoidCallback onTap;
  const _SalonCard({required this.name, required this.image, required this.onTap});
  @override
  Widget build(BuildContext context) => Semantics(button: true, label: name, child: Material(
    color: const Color(0xFF10291D), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Color(0xFF806B40))), clipBehavior: Clip.antiAlias,
    child: InkWell(onTap: onTap, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      AspectRatio(aspectRatio: .95, child: Image.asset(image, fit: BoxFit.cover, filterQuality: FilterQuality.high, alignment: Alignment.center)),
      Padding(padding: const EdgeInsets.all(12), child: Text(name, style: const TextStyle(color: Color(0xFFE7C77D), fontFamily: 'serif', fontSize: 16))),
      const Padding(padding: EdgeInsets.fromLTRB(12, 0, 12, 14), child: Row(children: [Expanded(child: Text('بزرگ‌نمایی تصویر', textDirection: TextDirection.rtl, style: TextStyle(fontSize: 12))), Icon(Icons.arrow_forward, size: 18, color: Color(0xFFE7C77D))])),
    ])),
  ));
}
