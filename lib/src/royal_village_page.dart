import 'package:flutter/material.dart';

import 'reservation_page.dart';
import 'rv_gallery_page.dart';
import 'salon_detail_page.dart';

class RoyalVillagePage extends StatelessWidget {
  const RoyalVillagePage({super.key});

  static const double _designWidth = 1144;
  static const double _designHeight = 1536;

  void _openSalon(BuildContext context, String name) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SalonDetailPage(salonName: name)),
    );
  }

  void _reserve(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ReservationPage(salonName: 'Royal Village'),
      ),
    );
  }

  void _openGallery(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RvGalleryPage()),
    );
  }

  void _soon(BuildContext context, String title) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF051511),
          content: Text(
            '$title در حال تکمیل است',
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final scale = constraints.maxWidth / _designWidth;
            final pageHeight = _designHeight * scale;

            Widget zone({
              required double left,
              required double top,
              required double width,
              required double height,
              required VoidCallback onTap,
            }) {
              return Positioned(
                left: left * scale,
                top: top * scale,
                width: width * scale,
                height: height * scale,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onTap,
                  child: const SizedBox.expand(),
                ),
              );
            }

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: SizedBox(
                width: constraints.maxWidth,
                height: pageHeight,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/image/Rv_page2.png',
                      fit: BoxFit.fill,
                      filterQuality: FilterQuality.high,
                      gaplessPlayback: true,
                    ),

                    // Top-right menu -> complete RV media gallery.
                    zone(
                      left: 972,
                      top: 0,
                      width: 172,
                      height: 125,
                      onTap: () => _openGallery(context),
                    ),

                    // Salon cards.
                    zone(
                      left: 20,
                      top: 520,
                      width: 275,
                      height: 225,
                      onTap: () => _openSalon(
                        context,
                        'RV Lounge Impérial Classique',
                      ),
                    ),
                    zone(
                      left: 295,
                      top: 520,
                      width: 255,
                      height: 225,
                      onTap: () => _openSalon(context, 'Salon Jardin'),
                    ),
                    zone(
                      left: 550,
                      top: 520,
                      width: 255,
                      height: 225,
                      onTap: () => _openSalon(context, 'Salon Lumière'),
                    ),
                    zone(
                      left: 805,
                      top: 520,
                      width: 319,
                      height: 225,
                      onTap: () => _openSalon(context, 'Salon Doré'),
                    ),
                    zone(
                      left: 20,
                      top: 745,
                      width: 1104,
                      height: 245,
                      onTap: () => _openSalon(context, 'Grand Salon'),
                    ),
                    zone(
                      left: 20,
                      top: 990,
                      width: 275,
                      height: 225,
                      onTap: () => _openSalon(context, 'Salon Royal'),
                    ),
                    zone(
                      left: 295,
                      top: 990,
                      width: 255,
                      height: 225,
                      onTap: () => _openSalon(context, 'Salon Privé'),
                    ),
                    zone(
                      left: 550,
                      top: 990,
                      width: 255,
                      height: 225,
                      onTap: () => _openSalon(context, 'Salon Noir'),
                    ),
                    zone(
                      left: 805,
                      top: 990,
                      width: 319,
                      height: 225,
                      onTap: () => _openSalon(context, 'Salon Âme du Poète'),
                    ),

                    // Bottom navigation on the artwork.
                    zone(
                      left: 0,
                      top: 1225,
                      width: 185,
                      height: 311,
                      onTap: () => Navigator.of(context).maybePop(),
                    ),
                    zone(
                      left: 360,
                      top: 1225,
                      width: 195,
                      height: 311,
                      onTap: () => _reserve(context),
                    ),
                    zone(
                      left: 555,
                      top: 1225,
                      width: 195,
                      height: 311,
                      onTap: () => _soon(context, 'موسیقی زنده'),
                    ),
                    zone(
                      left: 750,
                      top: 1225,
                      width: 190,
                      height: 311,
                      onTap: () => _soon(context, 'سوپرایزها'),
                    ),
                    zone(
                      left: 940,
                      top: 1225,
                      width: 204,
                      height: 311,
                      onTap: () => _soon(context, 'Royal Club'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
