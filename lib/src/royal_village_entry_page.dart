import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'reservation_page.dart';
import 'royal_club_game_page.dart';
import 'rv_gallery_page.dart';
import 'salon_detail_page.dart';

class RoyalVillageEntryPage extends StatelessWidget {
  const RoyalVillageEntryPage({super.key});

  static const String _art = 'assets/image/Rv_page2.png';
  static const double _designWidth = 1144;
  static const double _designHeight = 1536;
  static const Color _gold = Color(0xFFD6B15E);

  void _openSalon(BuildContext context, String name) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SalonDetailPage(salonName: name)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          ImageFiltered(
            imageFilter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(.42),
                BlendMode.darken,
              ),
              child: Image.asset(
                _art,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
          Center(
            child: FittedBox(
              fit: BoxFit.contain,
              alignment: Alignment.center,
              child: SizedBox(
                width: _designWidth,
                height: _designHeight,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      _art,
                      width: _designWidth,
                      height: _designHeight,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                      gaplessPlayback: true,
                    ),

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

                    // Bottom navigation — Home
                    Positioned(
                      left: 0,
                      top: 1228,
                      width: 190,
                      height: 308,
                      child: _TapZone(
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ),

                    // Restaurants / salons
                    Positioned(
                      left: 190,
                      top: 1228,
                      width: 195,
                      height: 308,
                      child: _TapZone(onTap: () => _openGallery(context)),
                    ),

                    // Reservation
                    Positioned(
                      left: 385,
                      top: 1228,
                      width: 190,
                      height: 308,
                      child: _TapZone(onTap: () => _openReservation(context)),
                    ),

                    // Live music
                    Positioned(
                      left: 575,
                      top: 1228,
                      width: 190,
                      height: 308,
                      child: _TapZone(
                        onTap: () => _info(
                          context,
                          'موسیقی زنده',
                          'رزرو موسیقی زنده و اجرای اختصاصی برای مراسم و سالن‌های Royal Village.',
                        ),
                      ),
                    ),

                    // Surprises
                    Positioned(
                      left: 765,
                      top: 1228,
                      width: 190,
                      height: 308,
                      child: _TapZone(
                        onTap: () => _info(
                          context,
                          'سوپرایزها',
                          'سوپرایز تولد، کیک، گل‌آرایی، اجرای ویژه و خدمات اختصاصی Royal Village.',
                        ),
                      ),
                    ),

                    // Royal Club
                    Positioned(
                      left: 955,
                      top: 1228,
                      width: 189,
                      height: 308,
                      child: _TapZone(onTap: () => _openRoyalClub(context)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
