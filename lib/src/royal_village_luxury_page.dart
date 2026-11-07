import 'package:flutter/material.dart';

import 'reservation_page.dart';
import 'rv_gallery_page.dart';
import 'rv_booking_poster_page.dart';

/// Responsive, image-led Royal Village home. No poster stretching or
/// screenshot-scaled tap areas; all controls are native Flutter widgets.
class RoyalVillageLuxuryPage extends StatelessWidget {
  const RoyalVillageLuxuryPage({super.key});

  static const Color gold = Color(0xFFD5B679);
  static const Color ink = Color(0xFF050A08);
  static const Color emerald = Color(0xFF102B22);

  static const List<_Salon> salons = [
    _Salon('Lumière', 'نور و ظرافت', 'assets/image/Salon_lumiere.png', 'Salon Lumière'),
    _Salon('Noir', 'شکوه شب', 'assets/image/Salon_noir.png', 'Salon Noir'),
    _Salon('Jardin', 'باغ اختصاصی', 'assets/image/salon_jardin.png', 'Salon Jardin'),
    _Salon('Privé', 'خلوت خصوصی', 'assets/image/Salon_prive.png', 'Salon Privé'),
    _Salon('RV Lounge', 'Impérial Classique', 'assets/image/rv_lounge_imperial_classique.png', 'RV Lounge Impérial Classique'),
    _Salon('Doré', 'تلالؤ طلایی', 'assets/image/salon_dore.png', 'Salon Doré'),
    _Salon('Âme du Poète', 'روح شاعر', 'assets/image/salon_ame_du_poete.png', 'Salon Âme du Poète'),
    _Salon('Royal', 'تجربه سلطنتی', 'assets/image/Salon_royal.png', 'Salon Royal'),
  ];

  void _go(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final roomAspect = width < 370 ? .82 : .91;
    return Scaffold(
      backgroundColor: ink,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                SizedBox(
                  height: 370,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/image/Grand_Salon_Original.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    filterQuality: FilterQuality.high,
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(.62),
                          Colors.transparent,
                          ink.withOpacity(.97),
                        ],
                        stops: const [0, .37, 1],
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(17, 12, 17, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: gold),
                          tooltip: 'بازگشت',
                        ),
                        const Text('SAHAND CONSORTIUM', style: TextStyle(
                          color: gold, fontSize: 11, letterSpacing: 2.3,
                          fontWeight: FontWeight.w600,
                        )),
                        IconButton(
                          onPressed: () => _go(context, const RvGalleryPage()),
                          icon: const Icon(Icons.photo_library_outlined, color: gold),
                          tooltip: 'گالری تصاویر',
                        ),
                      ],
                    ),
                  ),
                ),
                const Positioned(
                  left: 16, right: 16, bottom: 29,
                  child: Column(
                    children: [
                      Text('LE ROYAL VILLAGE CAFÉ', textAlign: TextAlign.center,
                        style: TextStyle(color: gold, fontSize: 23,
                          letterSpacing: 2.1, fontWeight: FontWeight.w700)),
                      SizedBox(height: 9),
                      Text('رویال ویلاژ کافه',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 22,
                          fontWeight: FontWeight.w600)),
                      SizedBox(height: 8),
                      Text('TABRIZ  ·  PRIVATE SALONS  ·  ART DE VIVRE',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFFEEE1CE), fontSize: 10,
                          letterSpacing: 1.15)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                children: [
                  Container(height: 1, width: 80, color: gold),
                  const SizedBox(height: 15),
                  const Text('HUIT SALONS · ONE EXCEPTIONAL EXPERIENCE',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: gold, letterSpacing: 1.2, fontSize: 10)),
                  const SizedBox(height: 8),
                  const Text('هشت فضای اختصاصی، هشت تجربه متفاوت',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFFE9E0D5), fontSize: 14)),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final salon = salons[i];
                  return _SalonCard(
                    salon: salon,
                    onTap: () => _go(context,
                      RvBookingPosterPage(salonName: salon.bookingName)),
                  );
                },
                childCount: salons.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 13,
                mainAxisSpacing: 15,
                childAspectRatio: roomAspect,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 30, 18, 50),
              child: Column(
                children: [
                  const Text('L\'ART DE RECEVOIR',
                    style: TextStyle(color: gold, letterSpacing: 3, fontSize: 16)),
                  const SizedBox(height: 9),
                  const Text('برای تجربه‌ای متفاوت، سالن دلخواه خود را رزرو کنید.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 19),
                  SizedBox(
                    width: double.infinity,
                    height: 53,
                    child: FilledButton.icon(
                      onPressed: () => _go(context,
                        const ReservationPage(salonName: 'Royal Village')),
                      icon: const Icon(Icons.event_available_outlined, color: ink),
                      label: const Text('رزرو اختصاصی رویال ویلاژ',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                      style: FilledButton.styleFrom(
                        backgroundColor: gold,
                        foregroundColor: ink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text('POWERED BY SAHAND CONSORTIUM',
                    style: TextStyle(color: Color(0xFF9E8B67),
                      fontSize: 10, letterSpacing: 2)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Salon {
  const _Salon(this.title, this.subtitle, this.image, this.bookingName);
  final String title;
  final String subtitle;
  final String image;
  final String bookingName;
}

class _SalonCard extends StatelessWidget {
  const _SalonCard({required this.salon, required this.onTap});
  final _Salon salon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: RoyalVillageLuxuryPage.emerald,
      borderRadius: BorderRadius.circular(17),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(salon.image, fit: BoxFit.cover,
              filterQuality: FilterQuality.high),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(.04),
                    Colors.transparent, Colors.black.withOpacity(.9)],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 11, right: 11, bottom: 13,
              child: Column(
                children: [
                  Text(salon.title, textAlign: TextAlign.center,
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Color(0xFFEFD7A2),
                      fontWeight: FontWeight.w800, fontSize: 17)),
                  const SizedBox(height: 4),
                  Text(salon.subtitle, textAlign: TextAlign.center,
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white,
                      fontSize: 11)),
                ],
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    border: Border.all(
                      color: const Color(0xFFCAAC72).withOpacity(.8),
                      width: 1.15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
