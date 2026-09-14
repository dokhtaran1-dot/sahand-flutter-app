import 'package:flutter/material.dart';

import 'royal_village_page.dart';
import 'royal_club_game_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _comingSoon(BuildContext context, String title) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF090909),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Color(0xFFE8C36A)),
          ),
          content: Text(
            '$title در حال تکمیل است',
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
  }

  void _openRoyalVillage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RoyalVillagePage()),
    );
  }

  void _openRoyalClub(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RoyalClubGamePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;

          Rect zone(double l, double t, double r, double b) =>
              Rect.fromLTRB(l * w, t * h, r * w, b * h);

          final rm = zone(0.015, 0.20, 0.315, 0.76);
          final rc = zone(0.325, 0.20, 0.665, 0.76);
          final rv = zone(0.675, 0.20, 0.985, 0.76);
          final deal = zone(0.02, 0.765, 0.98, 0.895);
          final more = zone(0.34, 0.905, 0.66, 0.985);
          final menu = zone(0.00, 0.00, 0.14, 0.12);
          final bell = zone(0.86, 0.00, 1.00, 0.12);

          return Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/image/Welcome.png',
                fit: BoxFit.fill,
                filterQuality: FilterQuality.high,
                gaplessPlayback: true,
                errorBuilder: (_, __, ___) => const ColoredBox(
                  color: Colors.black,
                  child: Center(
                    child: Text(
                      'ROYAL 1',
                      style: TextStyle(
                        color: Color(0xFFE8C36A),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                ),
              ),

              Positioned.fromRect(
                rect: deal,
                child: GestureDetector(
                  onTap: () => _comingSoon(context, 'Royal Deal'),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: w * .008, vertical: h * .006),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: const Color(0xFFE8C36A), width: 1.4),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF080808), Color(0xFF21080B), Color(0xFF080808)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      boxShadow: const [
                        BoxShadow(color: Color(0x66E8A74A), blurRadius: 16, spreadRadius: 1),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Text('👑  ROYAL DEAL', style: TextStyle(color: Color(0xFFFFD979), fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: 1)),
                                SizedBox(height: 3),
                                Text('بازی روزانه', textDirection: TextDirection.rtl, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                SizedBox(height: 3),
                                Text('۲۰ جعبه • R1 Ticket • جوایز رویال', textDirection: TextDirection.rtl, textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: const Color(0xFFFFD979)),
                                gradient: const LinearGradient(colors: [Color(0xFF9E0B19), Color(0xFF450207)]),
                                boxShadow: const [BoxShadow(color: Color(0x99FF1B35), blurRadius: 12)],
                              ),
                              alignment: Alignment.center,
                              child: const Text('بازی کن  ›', textDirection: TextDirection.rtl, style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Positioned.fromRect(rect: rm, child: _TapZone(onTap: () => _comingSoon(context, 'Royal Mall'))),
              Positioned.fromRect(rect: rc, child: _TapZone(onTap: () => _openRoyalClub(context))),
              Positioned.fromRect(rect: rv, child: _TapZone(onTap: () => _openRoyalVillage(context))),
              Positioned.fromRect(rect: more, child: _TapZone(onTap: () => _comingSoon(context, 'More'))),
              Positioned.fromRect(rect: menu, child: _TapZone(onTap: () => _comingSoon(context, 'Menu'))),
              Positioned.fromRect(rect: bell, child: _TapZone(onTap: () => _comingSoon(context, 'Notifications'))),
            ],
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
