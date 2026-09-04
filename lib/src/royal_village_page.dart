import 'dart:ui';
import 'package:flutter/material.dart';
import 'reservation_page.dart';
class RoyalVillagePage extends StatelessWidget {
  const RoyalVillagePage({super.key});

  static const bg = Color(0xFF020706);
  static const emerald = Color(0xFF063D30);
  static const emeraldLight = Color(0xFF0B7256);
  static const gold = Color(0xFFD5AD57);
  static const goldLight = Color(0xFFF0D58C);

  void _soon(BuildContext context, String title) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF0A1210),
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

  @override
  Widget build(BuildContext context) {
    final salons = [
      const SalonData(
        name: 'Salon Lumière',
        subtitle: 'Elegant, bright and refined',
        image: 'assets/image/salon_lumiere.png',
      ),
      const SalonData(
        name: 'Salon Noir',
        subtitle: 'Dramatic, intimate and unforgettable',
        image: 'assets/image/salon_noir.png',
      ),
      const SalonData(
        name: 'Salon Jardin',
        subtitle: 'A dreamy floral garden atmosphere',
        image: 'assets/image/salon_jardin.png',
      ),
      const SalonData(
        name: 'Salon Privé',
        subtitle: 'Private moments, elevated',
        image: 'assets/image/salon_prive.png',
      ),
      const SalonData(
        name: 'RV Lounge Impérial Classique',
        subtitle: 'The signature VIP experience',
        image: 'assets/image/rv_lounge_imperial_classique.png',
      ),
      const SalonData(
        name: 'Salon Doré',
        subtitle: 'Modern luxury in golden light',
        image: 'assets/image/salon_dore.png',
      ),
      const SalonData(
        name: 'Salon Âme du Poète',
        subtitle: 'Poetic, nostalgic and soulful',
        image: 'assets/image/salon_ame_du_poete.png',
      ),
      const SalonData(
        name: 'Salon Royal',
        subtitle: 'Classic royal ambience',
        image: 'assets/image/salon_royal.png',
      ),
    ];

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          Positioned(
            top: -160,
            right: -110,
            child: _glow(330, emeraldLight.withOpacity(.18)),
          ),
          Positioned(
            top: 430,
            left: -160,
            child: _glow(330, gold.withOpacity(.07)),
          ),

          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
                    child: Column(
                      children: [
                        _topBar(context),

                        const SizedBox(height: 24),

                        _hero(context),

                        const SizedBox(height: 18),

                        _vipCard(context),

                        const SizedBox(height: 30),

                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'THE COLLECTION',
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              color: gold,
                              fontSize: 12,
                              letterSpacing: 4,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const SizedBox(height: 7),

                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Royal Salons',
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              color: goldLight,
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                        const SizedBox(height: 5),

                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '۸ فضای اختصاصی برای تجربه‌ای متفاوت',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 13,
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),
                      ],
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList.separated(
                    itemCount: salons.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 22),
                    itemBuilder: (context, index) {
                      return _SalonCard(
                        number: index + 1,
                        data: salons[index],
                        onReserve: () => _soon(
                          context,
                          'رزرو ${salons[index].name}',
                        ),
                        onDesign: () => _soon(
                          context,
                          'دیزاین ${salons[index].name}',
                        ),
                        onCake: () => _soon(
                          context,
                          'کیک ${salons[index].name}',
                        ),
                      );
                    },
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Row(
      children: [
        _glassIcon(
          Icons.arrow_back_ios_new_rounded,
          () => Navigator.pop(context),
        ),

        const Expanded(
          child: Column(
            children: [
              Text(
                'ROYAL VILLAGE',
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  color: goldLight,
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'PRIVATE DINING • EVENTS • VIP',
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 8,
                  letterSpacing: 2.1,
                ),
              ),
            ],
          ),
        ),

        _glassIcon(
          Icons.notifications_none_rounded,
          () => _soon(context, 'اعلان‌ها'),
        ),
      ],
    );
  }

  Widget _hero(BuildContext context) {
    return Container(
      height: 285,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: gold.withOpacity(.85)),
        image: const DecorationImage(
          image: AssetImage(
            'assets/image/royal_village.png',
          ),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: emeraldLight.withOpacity(.15),
            blurRadius: 40,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(33),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(.12),
                Colors.black.withOpacity(.55),
                const Color(0xFF03130F).withOpacity(.95),
              ],
            ),
          ),
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'RV',
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  color: goldLight,
                  fontSize: 52,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 3,
                ),
              ),

              const Text(
                'ROYAL VILLAGE',
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'رزرو اختصاصی سالن، مراسم، دیزاین، کیک و خدمات VIP',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  _miniTag('8 SALONS'),
                  const SizedBox(width: 8),
                  _miniTag('VIP'),
                  const SizedBox(width: 8),
                  _miniTag('PRIVATE'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _vipCard(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 14,
          sigmaY: 14,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.035),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: gold.withOpacity(.65),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          goldLight,
                          Color(0xFF8A641F),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: gold.withOpacity(.2),
                          blurRadius: 18,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.workspace_premium_outlined,
                      color: Colors.black,
                      size: 34,
                    ),
                  ),

                  const SizedBox(width: 15),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ROYAL VIP',
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            color: goldLight,
                            fontSize: 23,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'تجربه اختصاصی رویال ویلاژ',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Icon(
                    Icons.diamond_outlined,
                    color: gold,
                    size: 27,
                  ),
                ],
              ),

              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () =>
                      _soon(context, 'رزرو VIP'),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: emerald,
                    foregroundColor: goldLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: const BorderSide(
                        color: gold,
                      ),
                    ),
                  ),
                  child: const Text(
                    'رزرو اختصاصی VIP',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _glassIcon(
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.035),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: gold.withOpacity(.5),
          ),
        ),
        child: Icon(
          icon,
          color: goldLight,
          size: 21,
        ),
      ),
    );
  }

  Widget _miniTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.35),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: gold.withOpacity(.5),
        ),
      ),
      child: Text(
        text,
        textDirection: TextDirection.ltr,
        style: const TextStyle(
          color: goldLight,
          fontSize: 9,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _glow(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

class _SalonCard extends StatelessWidget {
  final int number;
  final SalonData data;
  final VoidCallback onReserve;
  final VoidCallback onDesign;
  final VoidCallback onCake;

  const _SalonCard({
    required this.number,
    required this.data,
    required this.onReserve,
    required this.onDesign,
    required this.onCake,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        color: const Color(0xFF030907),
        border: Border.all(
          color: RoyalVillagePage.gold.withOpacity(.70),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.65),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
          BoxShadow(
            color: RoyalVillagePage.gold.withOpacity(.06),
            blurRadius: 22,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(33),
        child: Column(
          children: [

            // ===============================
            // FULL LUXURY IMAGE
            // ===============================
            AspectRatio(
              aspectRatio: 1.20,
              child: Stack(
                fit: StackFit.expand,
                children: [

                  Image.asset(
                    data.image,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                  ),

                  // DARK CINEMATIC GRADIENT
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0, .48, 1],
                        colors: [
                          Color(0x05000000),
                          Color(0x28000000),
                          Color(0xF5000000),
                        ],
                      ),
                    ),
                  ),

                  // GOLD TOP LINE
                  Positioned(
                    left: 20,
                    right: 20,
                    top: 18,
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            RoyalVillagePage.gold.withOpacity(.9),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // NUMBER
                  Positioned(
                    top: 30,
                    right: 24,
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xD9063D30),
                        border: Border.all(
                          color: RoyalVillagePage.gold,
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                RoyalVillagePage.gold.withOpacity(.14),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          number.toString().padLeft(2, '0'),
                          style: const TextStyle(
                            color: RoyalVillagePage.goldLight,
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // EXCLUSIVE LABEL
                  Positioned(
                    top: 34,
                    left: 23,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.48),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color:
                              RoyalVillagePage.gold.withOpacity(.55),
                        ),
                      ),
                      child: const Text(
                        'ROYAL COLLECTION',
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          color: RoyalVillagePage.goldLight,
                          fontSize: 9,
                          letterSpacing: 1.8,
                        ),
                      ),
                    ),
                  ),

                  // SALON TITLE
                  Positioned(
                    left: 22,
                    right: 22,
                    bottom: 25,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.name,
                          textDirection: TextDirection.ltr,
                          style: const TextStyle(
                            color: RoyalVillagePage.goldLight,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            letterSpacing: .2,
                            height: 1.1,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          data.subtitle,
                          textDirection: TextDirection.ltr,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            letterSpacing: .2,
                          ),
                        ),

                        const SizedBox(height: 13),

                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 1,
                              color: RoyalVillagePage.gold,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'ROYAL VILLAGE',
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 9,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ===============================
            // GLASS ACTION AREA
            // ===============================
            Container(
              padding: const EdgeInsets.fromLTRB(
                14,
                16,
                14,
                17,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF07130F),
                    Color(0xFF020706),
                  ],
                ),
              ),
              child: Row(
                children: [

                  Expanded(
                    child: _luxuryAction(
                      icon: Icons.calendar_month_outlined,
                      title: 'رزرو',
                      subtitle: 'BOOK',
                      onTap: onReserve,
                      featured: true,
                    ),
                  ),

                  const SizedBox(width: 9),

                  Expanded(
                    child: _luxuryAction(
                      icon: Icons.auto_awesome_outlined,
                      title: 'دیزاین',
                      subtitle: 'DESIGN',
                      onTap: onDesign,
                    ),
                  ),

                  const SizedBox(width: 9),

                  Expanded(
                    child: _luxuryAction(
                      icon: Icons.cake_outlined,
                      title: 'کیک',
                      subtitle: 'CAKE',
                      onTap: onCake,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _luxuryAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool featured = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        height: 92,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: featured
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF105B46),
                    Color(0xFF063D30),
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(.055),
                    Colors.white.withOpacity(.015),
                  ],
                ),
          border: Border.all(
            color: featured
                ? RoyalVillagePage.gold
                : RoyalVillagePage.gold.withOpacity(.48),
          ),
          boxShadow: featured
              ? [
                  BoxShadow(
                    color:
                        RoyalVillagePage.emeraldLight.withOpacity(.20),
                    blurRadius: 15,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              icon,
              size: 24,
              color: RoyalVillagePage.goldLight,
            ),

            const SizedBox(height: 7),

            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 3),

            Text(
              subtitle,
              textDirection: TextDirection.ltr,
              style: TextStyle(
                color: RoyalVillagePage.gold.withOpacity(.70),
                fontSize: 7,
                letterSpacing: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SalonData {
  final String name;
  final String subtitle;
  final String image;

  const SalonData({
    required this.name,
    required this.subtitle,
    required this.image,
  });
}
