import 'package:flutter/material.dart';
import 'royal_village_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const Color bg = Color(0xFF030506);
  static const Color gold = Color(0xFFD9B45B);
  static const Color goldLight = Color(0xFFFFE3A0);

  void _comingSoon(BuildContext context, String title) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF0A0C0D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: gold),
          ),
          content: Text(
            '$title در حال تکمیل است',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth > 720
                ? 720.0
                : constraints.maxWidth;

            return Center(
              child: SizedBox(
                width: maxWidth,
                height: constraints.maxHeight,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment(0, -0.15),
                            radius: 1.15,
                            colors: [
                              Color(0xFF16120E),
                              Color(0xFF070809),
                              Color(0xFF020303),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -110,
                      left: -80,
                      child: _glow(260, const Color(0xFF1D4F8E)),
                    ),
                    Positioned(
                      top: 210,
                      right: -110,
                      child: _glow(300, const Color(0xFF0D5F3A)),
                    ),
                    Positioned(
                      bottom: -100,
                      left: 20,
                      child: _glow(300, const Color(0xFF8A1824)),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          const Text(
                            'ROYAL 1',
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              color: goldLight,
                              fontSize: 34,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 3.5,
                            ),
                          ),
                          const SizedBox(height: 9),
                          const Text(
                            'WELCOME TO ROYAL FAMILY',
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              letterSpacing: 2.1,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: 86,
                            height: 1,
                            color: gold.withOpacity(.75),
                          ),
                          const Spacer(),
                          _RoyalEntryCard(
                            shortName: 'RM',
                            title: 'ROYAL MALL',
                            persianTitle: 'رویال مال',
                            enterText: 'ورود به رویال مال',
                            accent: const Color(0xFF165FA7),
                            icon: Icons.apartment_rounded,
                            onTap: () => _comingSoon(context, 'Royal Mall'),
                          ),
                          const SizedBox(height: 18),
                          _RoyalEntryCard(
                            shortName: 'RV',
                            title: 'ROYAL VILLAGE',
                            persianTitle: 'رویال ویلیج',
                            enterText: 'ورود به رویال ویلیج',
                            accent: const Color(0xFF08764F),
                            icon: Icons.restaurant_rounded,
                            onTap: () => _openRoyalVillage(context),
                          ),
                          const SizedBox(height: 18),
                          _RoyalEntryCard(
                            shortName: 'RC',
                            title: 'ROYAL CLUB',
                            persianTitle: 'رویال کلاب',
                            enterText: 'ورود به رویال کلاب',
                            accent: const Color(0xFFA31324),
                            icon: Icons.workspace_premium_rounded,
                            onTap: () => _comingSoon(context, 'Royal Club'),
                          ),
                          const Spacer(),
                          const Text(
                            'یک ورود، یک دنیای کامل',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              color: goldLight,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
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

  Widget _glow(double size, Color color) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(.14),
              blurRadius: 90,
              spreadRadius: 26,
            ),
          ],
        ),
      ),
    );
  }
}

class _RoyalEntryCard extends StatelessWidget {
  final String shortName;
  final String title;
  final String persianTitle;
  final String enterText;
  final Color accent;
  final IconData icon;
  final VoidCallback onTap;

  const _RoyalEntryCard({
    required this.shortName,
    required this.title,
    required this.persianTitle,
    required this.enterText,
    required this.accent,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Ink(
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                accent.withOpacity(.84),
                accent.withOpacity(.32),
                const Color(0xFF080A0B),
              ],
            ),
            border: Border.all(
              color: HomePage.gold.withOpacity(.86),
              width: 1.15,
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(.24),
                blurRadius: 30,
                spreadRadius: 1,
              ),
              const BoxShadow(
                color: Colors.black54,
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 78,
                  height: 78,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(.30),
                    border: Border.all(
                      color: HomePage.gold.withOpacity(.82),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    shortName,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(
                      color: HomePage.goldLight,
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(width: 17),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        textDirection: TextDirection.ltr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        persianTitle,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 13),
                      Row(
                        children: [
                          Text(
                            enterText,
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(
                              color: HomePage.goldLight,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: HomePage.goldLight,
                            size: 19,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  icon,
                  color: HomePage.goldLight.withOpacity(.95),
                  size: 32,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
