import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
        'Salon Royal', 'RV Lounge Impérial Classique', 'Salon Lumière',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // RV is a full-screen poster on phones: no black remainder.
          // We deliberately fill the viewport while keeping the original
          // bitmap at high filtering quality. Hotspots use the same x/y
          // factors, so every salon/footer button stays aligned.
          final sx = constraints.maxWidth / _designWidth;
          final sy = constraints.maxHeight / _designHeight;

          return SizedBox.expand(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  _art,
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                  isAntiAlias: true,
                  gaplessPlayback: true,
                ),
                Stack(
                  children: [
                    // Back
                    Positioned(
                      left: 0,
                      top: 0,
                      width: 120,
                      height: 130,
                      child: _TapZone(
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ),

                    // Location / Tabriz
                    Positioned(
                      left: 850,
                      top: 0,
                      width: 145,
                      height: 120,
                      child: _TapZone(
                        onTap: () => _info(
                          context,
                          'Royal Village • Tabriz',
                          'رویال ویلیج، تبریز\nبرای رزرو سالن و تجربه اختصاصی از بخش رزرو استفاده کنید.',
                        ),
                      ),
                    ),

                    // Top menu
                    Positioned(
                      left: 995,
                      top: 0,
                      width: 149,
                      height: 125,
                      child: _TapZone(onTap: () => _openGallery(context)),
                    ),

                    // Top row salons
                    Positioned(
                      left: 22,
                      top: 520,
                      width: 270,
                      height: 220,
                      child: _TapZone(
                        onTap: () => _openSalon(
                          context,
                          'RV Lounge Impérial Classique',
                        ),
                      ),
                    ),
                    Positioned(
                      left: 296,
                      top: 520,
                      width: 255,
                      height: 220,
                      child: _TapZone(
                        onTap: () => _openSalon(context, 'Salon Jardin'),
                      ),
                    ),
                    Positioned(
                      left: 554,
                      top: 520,
                      width: 255,
                      height: 220,
                      child: _TapZone(
                        onTap: () => _openSalon(context, 'Salon Lumière'),
                      ),
                    ),
                    Positioned(
                      left: 812,
                      top: 520,
                      width: 310,
                      height: 220,
                      child: _TapZone(
                        onTap: () => _openSalon(context, 'Salon Doré'),
                      ),
                    ),

                    // Grand Salon
                    Positioned(
                      left: 22,
                      top: 744,
                      width: 1100,
                      height: 248,
                      child: _TapZone(
                        onTap: () => _openSalon(context, 'Grand Salon'),
                      ),
                    ),

                    // Bottom row salons
                    Positioned(
                      left: 22,
                      top: 995,
                      width: 270,
                      height: 220,
                      child: _TapZone(
                        onTap: () => _openSalon(context, 'Salon Royal'),
                      ),
                    ),
                    Positioned(
                      left: 296,
                      top: 995,
                      width: 255,
                      height: 220,
                      child: _TapZone(
                        onTap: () => _openSalon(context, 'Salon Privé'),
                      ),
                    ),
                    Positioned(
                      left: 554,
                      top: 995,
                      width: 255,
                      height: 220,
                      child: _TapZone(
                        onTap: () => _openSalon(context, 'Salon Noir'),
                      ),
                    ),
                    Positioned(
                      left: 812,
                      top: 995,
                      width: 310,
                      height: 220,
                      child: _TapZone(
                        onTap: () => _openSalon(context, 'Salon Âme du Poète'),
                      ),
                    ),

                    // The approved poster remains an unchanged bitmap.
                    // These transparent hit regions match its footer icons:
                    // app mock-up / Bazaar / Google Play / App Store /
                    // WhatsApp / Instagram.
                    Positioned(
                      left: 10,
                      top: 1340,
                      width: 323,
                      height: 161,
                      child: _TapZone(
                        onTap: () => _openStoreChooser(context),
                      ),
                    ),
                    Positioned(
                      left: 347,
                      top: 1355,
                      width: 146,
                      height: 138,
                      child: _TapZone(
                        onTap: () => _openLink(
                          context, _bazaarSearch,
                          title: 'جستجو در کافه بازار',
                        ),
                      ),
                    ),
                    Positioned(
                      left: 497,
                      top: 1355,
                      width: 150,
                      height: 138,
                      child: _TapZone(
                        onTap: () => _openLink(
                          context, _playSearch,
                          title: 'جستجو در Google Play',
                        ),
                      ),
                    ),
                    Positioned(
                      left: 650,
                      top: 1355,
                      width: 146,
                      height: 138,
                      child: _TapZone(
                        onTap: () => _openLink(
                          context, _appStoreSearch,
                          title: 'جستجو در App Store',
                        ),
                      ),
                    ),
                    Positioned(
                      left: 812,
                      top: 1350,
                      width: 148,
                      height: 145,
                      child: _TapZone(
                        onTap: () => _openWhatsApp(context),
                      ),
                    ),
                    Positioned(
                      left: 967,
                      top: 1350,
                      width: 166,
                      height: 145,
                      child: _TapZone(
                        onTap: () => _openLink(
                          context, _instagram,
                          title: 'Instagram • the_royalmall',
                        ),
                      ),
                    ),




                  ].map((widget) {
                    if (widget is Positioned) {
                      return Positioned(
                        left: widget.left == null ? null : widget.left! * sx,
                        top: widget.top == null ? null : widget.top! * sy,
                        right: widget.right == null ? null : widget.right! * sx,
                        bottom: widget.bottom == null ? null : widget.bottom! * sy,
                        width: widget.width == null ? null : widget.width! * sx,
                        height: widget.height == null ? null : widget.height! * sy,
                        child: widget.child,
                      );
                    }
                    return widget;
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

}

class _TapZone extends StatelessWidget {
  final VoidCallback onTap;
  const _TapZone({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
    );
  }
}
