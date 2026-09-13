import 'package:flutter/material.dart';
import 'royal_village_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const Color bg = Color(0xFF020304);
  static const Color gold = Color(0xFFD8B15A);
  static const Color goldLight = Color(0xFFFFE4A3);

  void _comingSoon(BuildContext context, String title) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF0A0B0C),
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
      MaterialPageRoute(builder: (_) => const RoyalVillagePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth > 760
                ? 760.0
                : constraints.maxWidth;
            final height = constraints.maxHeight;
            final compact = width < 500;
            final sidePadding = compact ? 10.0 : 16.0;
            final gap = compact ? 7.0 : 10.0;
            final usable = width - (sidePadding * 2) - (gap * 2);
            final cardWidth = usable / 3;
            final baseCardHeight = compact
                ? (height * .47).clamp(330.0, 430.0)
                : (height * .50).clamp(360.0, 470.0);

            return Center(
              child: SizedBox(
                width: width,
                height: height,
                child: Stack(
                  children: [
                    const Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF040506),
                              Color(0xFF070807),
                              Color(0xFF020303),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -120,
                      left: -80,
                      child: _Glow(
                        size: 280,
                        color: const Color(0xFF165FA7),
                      ),
                    ),
                    Positioned(
                      top: 180,
                      right: -90,
                      child: _Glow(
                        size: 290,
                        color: const Color(0xFF08764F),
                      ),
                    ),
                    Positioned(
                      bottom: -100,
                      left: width * .28,
                      child: _Glow(
                        size: 300,
                        color: const Color(0xFFA31324),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        sidePadding,
                        compact ? 10 : 16,
                        sidePadding,
                        compact ? 12 : 18,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 4),
                          const Text(
                            'ROYAL 1',
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              color: goldLight,
                              fontSize: 34,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 3.8,
                            ),
                          ),
                          const SizedBox(height: 7),
                          const Text(
                            'WELCOME TO ROYAL FAMILY',
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              letterSpacing: 2.2,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: 82,
                            height: 1,
                            color: gold.withOpacity(.75),
                          ),
                          SizedBox(height: compact ? 36 : 48),

                          // Approved page: three large entries side-by-side.
                          SizedBox(
                            height: baseCardHeight + 28,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: cardWidth,
                                  height: baseCardHeight,
                                  child: _RoyalPanel(
                                    shortName: 'RM',
                                    title: 'ROYAL\nMALL',
                                    persianTitle: 'رویال مال',
                                    accent: const Color(0xFF165FA7),
                                    discount: '35%',
                                    actionText: 'مشاهده',
                                    subtitle: 'پیشنهادهای ویژه رویال مال',
                                    onTap: () =>
                                        _comingSoon(context, 'Royal Mall'),
                                  ),
                                ),
                                SizedBox(width: gap),
                                SizedBox(
                                  width: cardWidth,
                                  height: baseCardHeight + 28,
                                  child: _RoyalPanel(
                                    shortName: 'RC',
                                    title: 'ROYAL\nCLUB',
                                    persianTitle: 'رویال کلاب',
                                    accent: const Color(0xFFA31324),
                                    actionText: 'ورود',
                                    subtitle:
                                        'یک‌بار وارد شو؛ بعدش معمولی دیگه به چشمت نمیاد.',
                                    isClub: true,
                                    onTap: () =>
                                        _comingSoon(context, 'Royal Club'),
                                  ),
                                ),
                                SizedBox(width: gap),
                                SizedBox(
                                  width: cardWidth,
                                  height: baseCardHeight,
                                  child: _RoyalPanel(
                                    shortName: 'RV',
                                    title: 'ROYAL\nVILLAGE',
                                    persianTitle: 'رویال ویلیج',
                                    accent: const Color(0xFF08764F),
                                    discount: '45%',
                                    actionText: 'مشاهده',
                                    subtitle: 'تجربه خاص کافه و رستوران',
                                    onTap: () => _openRoyalVillage(context),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Spacer(),
                          InkWell(
                            onTap: () => _comingSoon(context, 'More'),
                            borderRadius: BorderRadius.circular(28),
                            child: Container(
                              height: 48,
                              width: compact ? 148 : 172,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.025),
                                borderRadius: BorderRadius.circular(28),
                                border: Border.all(
                                  color: gold.withOpacity(.75),
                                ),
                              ),
                              child: const Text(
                                'MORE',
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                  color: goldLight,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 3,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
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
}

class _RoyalPanel extends StatelessWidget {
  final String shortName;
  final String title;
  final String persianTitle;
  final String subtitle;
  final String actionText;
  final String? discount;
  final Color accent;
  final bool isClub;
  final VoidCallback onTap;

  const _RoyalPanel({
    required this.shortName,
    required this.title,
    required this.persianTitle,
    required this.subtitle,
    required this.actionText,
    required this.accent,
    required this.onTap,
    this.discount,
    this.isClub = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                accent.withOpacity(isClub ? .96 : .90),
                accent.withOpacity(.46),
                const Color(0xFF060809),
              ],
            ),
            border: Border.all(
              color: HomePage.gold.withOpacity(isClub ? 1 : .82),
              width: isClub ? 1.6 : 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(isClub ? .42 : .24),
                blurRadius: isClub ? 34 : 24,
                spreadRadius: isClub ? 2 : 0,
              ),
              const BoxShadow(
                color: Colors.black54,
                blurRadius: 16,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 14, 10, 12),
            child: Column(
              children: [
                if (isClub)
                  const Icon(
                    Icons.workspace_premium_rounded,
                    color: HomePage.goldLight,
                    size: 27,
                  )
                else
                  const SizedBox(height: 27),
                const SizedBox(height: 8),
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(.26),
                    border: Border.all(
                      color: HomePage.gold.withOpacity(.9),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    shortName,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(
                      color: HomePage.goldLight,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 13),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: shortName == 'RV' ? 15 : 17,
                    height: 1.08,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .9,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  persianTitle,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                if (discount != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    discount!,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(
                      color: HomePage.goldLight,
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  const Text(
                    'OFF',
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      letterSpacing: 2.5,
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 14),
                  Container(
                    width: 40,
                    height: 1,
                    color: HomePage.gold.withOpacity(.75),
                  ),
                  const SizedBox(height: 12),
                ],
                const Spacer(),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  maxLines: isClub ? 4 : 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(.83),
                    fontSize: isClub ? 10.5 : 10,
                    height: 1.45,
                    fontWeight: isClub ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 13),
                Container(
                  height: 39,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black.withOpacity(.30),
                    border: Border.all(
                      color: HomePage.gold.withOpacity(.85),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        actionText,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          color: HomePage.goldLight,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: HomePage.goldLight,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  final double size;
  final Color color;

  const _Glow({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(.15),
              blurRadius: 100,
              spreadRadius: 36,
            ),
          ],
        ),
      ),
    );
  }
}
