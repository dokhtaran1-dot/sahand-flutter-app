import 'package:flutter/material.dart';

import 'royal_village_page.dart';
import 'ettehad_page.dart';
import 'consulting_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const Color gold = Color(0xFFD7A83D);
  static const Color dark = Color(0xFF030609);

  void _comingSoon(BuildContext context, String title) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF111315),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(
              color: gold,
              width: .7,
            ),
          ),
          content: Text(
            '$title در حال تکمیل است',
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      );
  }

  void _openRoyalVillage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RoyalVillagePage(),
      ),
    );
  }

  void _openRoyalSazeh(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const EttehadPage(),
      ),
    );
  }

  void _openConsulting(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ConsultingPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dark,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // برای اینکه روی Fold و موبایل‌های مختلف خراب نشود
            final double pageWidth =
                constraints.maxWidth > 720 ? 720 : constraints.maxWidth;

            // تصویر اصلی 1024 × 1536 است
            final double pageHeight = pageWidth * 1.5;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Center(
                child: SizedBox(
                  width: pageWidth,
                  height: pageHeight,
                  child: Stack(
                    children: [

                      // =========================
                      // BACKGROUND DESIGN
                      // =========================
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/sc_home.png',
                          fit: BoxFit.fill,
                          filterQuality: FilterQuality.high,
                        ),
                      ),

                      // =========================
                      // NOTIFICATION
                      // =========================
                      _hotspot(
                        left: .855,
                        top: .020,
                        width: .120,
                        height: .095,
                        onTap: () =>
                            _comingSoon(context, 'اعلان‌ها'),
                      ),

                      // =========================
                      // ROYAL MALL
                      // =========================
                      _hotspot(
                        left: .025,
                        top: .162,
                        width: .225,
                        height: .355,
                        onTap: () =>
                            _comingSoon(context, 'Royal Mall'),
                      ),

                      // =========================
                      // ROYAL VILLAGE
                      // =========================
                      _hotspot(
                        left: .266,
                        top: .162,
                        width: .225,
                        height: .355,
                        onTap: () => _openRoyalVillage(context),
                      ),

                      // =========================
                      // ROYAL HARMONIA
                      // =========================
                      _hotspot(
                        left: .507,
                        top: .162,
                        width: .225,
                        height: .355,
                        onTap: () =>
                            _comingSoon(context, 'Royal Harmonia'),
                      ),

                      // =========================
                      // ROYAL SAZEH
                      // =========================
                      _hotspot(
                        left: .747,
                        top: .162,
                        width: .225,
                        height: .355,
                        onTap: () => _openRoyalSazeh(context),
                      ),

                      // =========================
                      // ROYAL CLUB
                      // =========================
                      _hotspot(
                        left: .028,
                        top: .527,
                        width: .944,
                        height: .173,
                        onTap: () =>
                            _comingSoon(context, 'Royal Club'),
                      ),

                      // =========================
                      // DISCOUNTS
                      // =========================
                      _hotspot(
                        left: .025,
                        top: .709,
                        width: .225,
                        height: .145,
                        onTap: () => _comingSoon(
                          context,
                          'تخفیف‌ها و پیشنهادها',
                        ),
                      ),

                      // =========================
                      // RESERVATION
                      // =========================
                      _hotspot(
                        left: .266,
                        top: .709,
                        width: .225,
                        height: .145,
                        onTap: () => _openRoyalVillage(context),
                      ),

                      // =========================
                      // ORDERS
                      // =========================
                      _hotspot(
                        left: .507,
                        top: .709,
                        width: .225,
                        height: .145,
                        onTap: () =>
                            _comingSoon(context, 'سفارش‌ها'),
                      ),

                      // =========================
                      // PROFILE
                      // =========================
                      _hotspot(
                        left: .747,
                        top: .709,
                        width: .225,
                        height: .145,
                        onTap: () =>
                            _comingSoon(context, 'پروفایل من'),
                      ),

                      // =========================
                      // BOTTOM NAV - HOME
                      // =========================
                      _hotspot(
                        left: .015,
                        top: .866,
                        width: .190,
                        height: .082,
                        onTap: () {
                          // همین صفحه هستیم
                        },
                      ),

                      // =========================
                      // BOTTOM NAV - SC NETWORK
                      // =========================
                      _hotspot(
                        left: .215,
                        top: .866,
                        width: .190,
                        height: .082,
                        onTap: () => _openConsulting(context),
                      ),

                      // =========================
                      // CENTER SC LOGO
                      // =========================
                      _hotspot(
                        left: .412,
                        top: .850,
                        width: .178,
                        height: .102,
                        onTap: () =>
                            _comingSoon(context, 'SC Network'),
                      ),

                      // =========================
                      // FAVORITES
                      // =========================
                      _hotspot(
                        left: .605,
                        top: .866,
                        width: .190,
                        height: .082,
                        onTap: () =>
                            _comingSoon(context, 'علاقه‌مندی‌ها'),
                      ),

                      // =========================
                      // MENU
                      // =========================
                      _hotspot(
                        left: .805,
                        top: .866,
                        width: .185,
                        height: .082,
                        onTap: () =>
                            _showLuxuryMenu(context),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _hotspot({
    required double left,
    required double top,
    required double width,
    required double height,
    required VoidCallback onTap,
  }) {
    return Positioned.fill(
      child: LayoutBuilder(
        builder: (context, box) {
          return Stack(
            children: [
              Positioned(
                left: box.maxWidth * left,
                top: box.maxHeight * top,
                width: box.maxWidth * width,
                height: box.maxHeight * height,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onTap,
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showLuxuryMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.fromLTRB(
            20,
            18,
            20,
            30,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF080B0E),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
            border: Border(
              top: BorderSide(
                color: gold,
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 55,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 22),
                  decoration: BoxDecoration(
                    color: gold,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                const Text(
                  'SAHAND CONSORTIUM',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    color: gold,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.8,
                  ),
                ),

                const SizedBox(height: 20),

                _menuItem(
                  icon: Icons.restaurant_rounded,
                  title: 'Royal Village',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _openRoyalVillage(context);
                  },
                ),

                _menuItem(
                  icon: Icons.apartment_rounded,
                  title: 'Royal Mall',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _comingSoon(context, 'Royal Mall');
                  },
                ),

                _menuItem(
                  icon: Icons.architecture_rounded,
                  title: 'Royal Sazeh',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _openRoyalSazeh(context);
                  },
                ),

                _menuItem(
                  icon: Icons.auto_graph_rounded,
                  title: 'Strategy & Management',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _openConsulting(context);
                  },
                ),

                _menuItem(
                  icon: Icons.person_outline_rounded,
                  title: 'پروفایل من',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _comingSoon(context, 'پروفایل من');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1114),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: gold.withOpacity(.35),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: gold,
        ),
        title: Text(
          title,
          textDirection: TextDirection.rtl,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_left_rounded,
          color: gold,
        ),
      ),
    );
  }
}