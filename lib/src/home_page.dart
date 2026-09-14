import 'package:flutter/material.dart';

import 'royal_village_page.dart';
import 'royal_club_game_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const gold = Color(0xFFF0C86A);
  static const paleGold = Color(0xFFFFE9A8);

  void _comingSoon(BuildContext context, String title) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF090909),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: gold),
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
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;
            final tiny = w < 390;
            final pad = (w * .018).clamp(5.0, 13.0);
            final gap = (w * .012).clamp(4.0, 9.0);
            final headerH = (h * .195).clamp(160.0, 270.0);
            final moreH = (h * .16).clamp(120.0, 210.0);
            final cardsH = h - headerH - moreH;

            return DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF070403), Color(0xFF020202), Color(0xFF090503)],
                ),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const CustomPaint(painter: _MarblePainter()),
                  Column(
                    children: [
                      SizedBox(
                        height: headerH,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: RadialGradient(
                                    center: Alignment(0, -0.25),
                                    radius: .85,
                                    colors: [Color(0x332E76FF), Colors.transparent],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 18,
                              top: 28,
                              child: IconButton(
                                onPressed: () => _comingSoon(context, 'Menu'),
                                icon: const Icon(Icons.menu_rounded, color: paleGold, size: 38),
                              ),
                            ),
                            Positioned(
                              right: 18,
                              top: 28,
                              child: IconButton(
                                onPressed: () => _comingSoon(context, 'Notifications'),
                                icon: const Icon(Icons.notifications_none_rounded, color: paleGold, size: 34),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 34),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _RoyalOneLogo(compact: tiny),
                                    const SizedBox(height: 7),
                                    Text(
                                      'ROYAL 1',
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                        color: paleGold,
                                        fontSize: tiny ? 26 : 34,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 2.2,
                                        shadows: const [Shadow(color: Color(0xFFFFB325), blurRadius: 12)],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              left: w * .18,
                              right: w * .18,
                              bottom: 0,
                              child: Container(
                                height: 1,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.transparent, gold, Colors.transparent],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: cardsH,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(pad, 2, pad, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: _RoyalPanel(
                                  code: 'RM',
                                  title: 'ROYAL MALL',
                                  city: 'TABRIZ',
                                  faTitle: 'رویال مال',
                                  faTag: 'خرید فراتر از انتظار',
                                  discount: '35%',
                                  accent: const Color(0xFF1676FF),
                                  icon: Icons.shopping_bag_outlined,
                                  image: 'assets/image/Welcome.png',
                                  onTap: () => _comingSoon(context, 'Royal Mall'),
                                ),
                              ),
                              SizedBox(width: gap),
                              Expanded(
                                child: Transform.translate(
                                  offset: const Offset(0, -10),
                                  child: _RoyalPanel(
                                    code: 'RC',
                                    title: 'ROYAL CLUB',
                                    city: '',
                                    faTitle: 'رویال کلاب',
                                    faTag: 'ورود متفاوت',
                                    topFa: 'یک‌بار وارد شو؛\nبعدش معمولی دیگه به چشمت نمیاد.',
                                    topEn: "ONCE YOU ENTER,\nORDINARY WON'T BE ENOUGH.",
                                    accent: const Color(0xFFFF223B),
                                    icon: Icons.local_bar_outlined,
                                    image: 'assets/image/Salons.png',
                                    center: true,
                                    onTap: () => _openRoyalClub(context),
                                  ),
                                ),
                              ),
                              SizedBox(width: gap),
                              Expanded(
                                child: _RoyalPanel(
                                  code: 'RV',
                                  title: 'ROYAL VILLAGE',
                                  city: 'CAFÉ & RESTAURANT',
                                  faTitle: 'رویال ویلیج',
                                  faTag: 'طعم لحظات خاص',
                                  discount: '45%',
                                  accent: const Color(0xFF21D668),
                                  icon: Icons.restaurant_rounded,
                                  image: 'assets/image/royal_village.png',
                                  onTap: () => _openRoyalVillage(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: moreH,
                        child: Center(
                          child: InkWell(
                            onTap: () => _comingSoon(context, 'More'),
                            borderRadius: BorderRadius.circular(32),
                            child: Container(
                              width: (w * .34).clamp(130.0, 230.0),
                              height: 58,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32),
                                color: const Color(0xB3070707),
                                border: Border.all(color: paleGold, width: 1.2),
                                boxShadow: const [
                                  BoxShadow(color: Color(0x33E7A72E), blurRadius: 24, spreadRadius: 1),
                                ],
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('More', style: TextStyle(color: Colors.white, fontSize: 18)),
                                  Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 18),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RoyalOneLogo extends StatelessWidget {
  final bool compact;
  const _RoyalOneLogo({required this.compact});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: compact ? 55 : 72,
      width: compact ? 92 : 118,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            'R',
            style: TextStyle(
              color: HomePage.paleGold,
              fontFamily: 'serif',
              fontSize: compact ? 58 : 74,
              fontWeight: FontWeight.w600,
              height: 1,
              shadows: const [Shadow(color: Color(0xFFFFB325), blurRadius: 14)],
            ),
          ),
          Positioned(
            left: compact ? 13 : 16,
            bottom: 4,
            child: Text(
              '1',
              style: TextStyle(
                color: const Color(0xFF9EE8FF),
                fontSize: compact ? 52 : 66,
                fontWeight: FontWeight.w800,
                height: 1,
                shadows: const [
                  Shadow(color: Color(0xFF00B8FF), blurRadius: 11),
                  Shadow(color: Colors.white, blurRadius: 3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoyalPanel extends StatelessWidget {
  final String code;
  final String title;
  final String city;
  final String faTitle;
  final String faTag;
  final String? discount;
  final String? topFa;
  final String? topEn;
  final Color accent;
  final IconData icon;
  final String image;
  final bool center;
  final VoidCallback onTap;

  const _RoyalPanel({
    required this.code,
    required this.title,
    required this.city,
    required this.faTitle,
    required this.faTag,
    required this.accent,
    required this.icon,
    required this.image,
    required this.onTap,
    this.discount,
    this.topFa,
    this.topEn,
    this.center = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final narrow = c.maxWidth < 125;
        final codeSize = narrow ? 39.0 : 50.0;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: HomePage.paleGold, width: 1.5),
                boxShadow: [
                  BoxShadow(color: accent.withOpacity(.28), blurRadius: 18, spreadRadius: 1),
                  const BoxShadow(color: Colors.black87, blurRadius: 12, offset: Offset(0, 6)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      image,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (_, __, ___) => const ColoredBox(color: Color(0xFF080808)),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(.42),
                            Colors.black.withOpacity(.60),
                            Colors.black.withOpacity(.78),
                            const Color(0xFF020202),
                          ],
                          stops: const [0, .38, .68, 1],
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: center ? const Alignment(0, -.42) : const Alignment(0, .8),
                            radius: .9,
                            colors: [accent.withOpacity(center ? .24 : .13), Colors.transparent],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(narrow ? 5 : 7, 12, narrow ? 5 : 7, 10),
                      child: Column(
                        children: [
                          if (center) ...[
                            Text(
                              topFa ?? '',
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              maxLines: 2,
                              style: TextStyle(
                                color: HomePage.paleGold,
                                fontSize: narrow ? 9.5 : 11.5,
                                height: 1.35,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              topEn ?? '',
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: narrow ? 6.6 : 8.3,
                                height: 1.25,
                                letterSpacing: .45,
                              ),
                            ),
                          ] else
                            SizedBox(height: narrow ? 16 : 24),
                          SizedBox(height: center ? 8 : 0),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              code,
                              style: TextStyle(
                                color: HomePage.paleGold,
                                fontFamily: 'serif',
                                fontSize: codeSize,
                                fontWeight: FontWeight.w700,
                                height: 1,
                                shadows: const [
                                  Shadow(color: Color(0xFFFFAB2B), blurRadius: 9),
                                  Shadow(color: Colors.black, blurRadius: 3, offset: Offset(0, 2)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 3),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              title,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'serif',
                                fontSize: narrow ? 13 : 17,
                                fontWeight: FontWeight.w700,
                                letterSpacing: .2,
                              ),
                            ),
                          ),
                          if (city.isNotEmpty) ...[
                            const SizedBox(height: 3),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                city,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: narrow ? 7.5 : 9.5,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ],
                          const Spacer(),
                          Icon(icon, color: HomePage.paleGold, size: narrow ? 28 : 35),
                          const SizedBox(height: 8),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              faTitle,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                color: HomePage.paleGold,
                                fontSize: narrow ? 15 : 19,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(height: 3),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              faTag,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: narrow ? 10 : 12.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (discount != null) ...[
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: narrow ? 7 : 10),
                              decoration: BoxDecoration(
                                color: accent.withOpacity(.15),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: accent, width: 1.4),
                                boxShadow: [BoxShadow(color: accent.withOpacity(.35), blurRadius: 12)],
                              ),
                              child: Column(
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      discount!,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: narrow ? 27 : 37,
                                        fontWeight: FontWeight.w900,
                                        height: 1,
                                      ),
                                    ),
                                  ),
                                  const Text('OFF', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 9),
                          ] else
                            SizedBox(height: narrow ? 52 : 72),
                          Container(
                            height: narrow ? 46 : 54,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: accent.withOpacity(.22),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: accent, width: 1.5),
                              boxShadow: [BoxShadow(color: accent.withOpacity(.52), blurRadius: 13)],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'ورود',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: narrow ? 15 : 19,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(width: narrow ? 3 : 8),
                                Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: narrow ? 14 : 18),
                              ],
                            ),
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
      },
    );
  }
}

class _MarblePainter extends CustomPainter {
  const _MarblePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = const Color(0xFFB07028).withOpacity(.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = .8;
    for (var i = 0; i < 8; i++) {
      final y = size.height * (.10 + i * .12);
      final path = Path()
        ..moveTo(-30, y)
        ..cubicTo(size.width * .22, y - 45, size.width * .42, y + 45, size.width * .62, y - 5)
        ..cubicTo(size.width * .78, y - 38, size.width * .92, y + 28, size.width + 30, y - 12);
      canvas.drawPath(path, p);
    }
    final glow = Paint()
      ..shader = RadialGradient(
        colors: [const Color(0xFFFFA62B).withOpacity(.14), Colors.transparent],
      ).createShader(Rect.fromCircle(center: Offset(size.width / 2, size.height * .88), radius: size.width * .55));
    canvas.drawRect(Offset.zero & size, glow);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
