import 'dart:async';

import 'package:flutter/material.dart';

class RoyalPrizeTv extends StatefulWidget {
  final VoidCallback? onOpenRewards;

  const RoyalPrizeTv({super.key, this.onOpenRewards});

  @override
  State<RoyalPrizeTv> createState() => _RoyalPrizeTvState();
}

class _RoyalPrizeTvState extends State<RoyalPrizeTv> {
  static const _gold = Color(0xFFE8C36A);
  static const _deepGold = Color(0xFF9A6A23);
  static const _burgundy = Color(0xFF5C0710);

  final PageController _controller = PageController();
  Timer? _timer;
  int _index = 0;

  static const List<_Prize> _prizes = [
    _Prize(
      'iPhone 18 Pro Max',
      'BURGUNDY',
      'https://www.fkaysmartphone.co.ke/web/image/625029-c40cb6ec/apple-iphone-18-pro-max-11.jpg',
    ),
    _Prize(
      'Galaxy Z Fold8',
      'GRAPHITE',
      'https://shop.samsung.com/ie/images/products/30619/39368/2000x2000/H8Mid512.webp',
    ),
    _Prize(
      'Galaxy Z Flip8',
      'LAVENDER',
      'https://t.vietgiaitri.com/2026/7/8/nhung-nang-cap-dang-chu-y-cua-samsung-galaxy-z-flip8-gia-tu-3199-trieu-tai-viet-nam-800x576-857-7739679.webp',
    ),
    _Prize(
      'Galaxy Z Flip7',
      'BLUE SHADOW',
      'https://ktstore.net/img/thumb/flip7_blue.png',
    ),
    _Prize(
      'PlayStation 5',
      'DISC EDITION',
      'https://gmedia.playstation.com/is/image/SIEPDC/ps5-slim-edition-left-image-block-01-en-24jun24?%24100px--t%24=',
    ),
    _Prize(
      'PS5 HD Camera',
      'OFFICIAL ACCESSORY',
      'https://gmedia.playstation.com/is/image/SIEPDC/hd-camera-video-block-ps5-01-en-14jul20?%24native%24=',
    ),
    _Prize(
      'DJI Avata 2',
      'GOGGLES 3 • RC MOTION 3',
      'https://se-cdn.djiits.com/tpc/uploads/spu_bundle/cover/7b0aaa43cc6ad0897614e18434d8e10d%40small.png',
    ),
    _Prize(
      'iPhone 17',
      'SAGE GREEN',
      'https://youget.pt/245640-large_default/apple-iphone-17-63-256gb-verde-salvia.jpg',
    ),
    _Prize(
      'iPhone 17 Pro Max',
      'COSMIC ORANGE',
      'https://www.mwave.com.au/images/400/apple-iphone-17-pro-max-256gb-cosmic-orange-ac89347.jpg',
    ),
    _Prize.discount(),
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_controller.hasClients) return;
      final next = (_index + 1) % _prizes.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _go(int delta) {
    final next = (_index + delta + _prizes.length) % _prizes.length;
    _controller.animateToPage(
      next,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: _gold, width: 2.5),
          gradient: const RadialGradient(
            center: Alignment(0, -.25),
            radius: 1.15,
            colors: [
              Color(0xFF33150D),
              Color(0xFF150708),
              Color(0xFF050505),
            ],
          ),
          boxShadow: const [
            BoxShadow(color: Color(0x668C5C18), blurRadius: 24),
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: PageView.builder(
                controller: _controller,
                itemCount: _prizes.length,
                onPageChanged: (value) => setState(() => _index = value),
                itemBuilder: (_, i) => _PrizeCard(
                  prize: _prizes[i],
                  onTap: widget.onOpenRewards,
                ),
              ),
            ),
            Positioned(
              left: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: _ArrowButton(
                  icon: Icons.chevron_left_rounded,
                  onTap: () => _go(-1),
                ),
              ),
            ),
            Positioned(
              right: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: _ArrowButton(
                  icon: Icons.chevron_right_rounded,
                  onTap: () => _go(1),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _prizes.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: i == _index ? 18 : 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: i == _index ? _gold : Colors.white38,
                      borderRadius: BorderRadius.circular(20),
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

class _PrizeCard extends StatelessWidget {
  final _Prize prize;
  final VoidCallback? onTap;

  const _PrizeCard({required this.prize, this.onTap});

  static const _gold = Color(0xFFE8C36A);

  @override
  Widget build(BuildContext context) {
    if (prize.isDiscount) {
      return InkWell(
        onTap: onTap,
        child: const _DiscountCard(),
      );
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(42, 14, 42, 26),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.card_giftcard_rounded, color: _gold, size: 19),
                SizedBox(width: 7),
                Text(
                  'ROYAL CLUB PRIZES',
                  style: TextStyle(
                    color: _gold,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Text(
              'جوایز ویژه',
              textDirection: TextDirection.rtl,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(4),
                alignment: Alignment.center,
                child: Image.network(
                  prize.imageUrl!,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  filterQuality: FilterQuality.high,
                  gaplessPlayback: true,
                  loadingBuilder: (context, child, loading) {
                    if (loading == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(
                        color: _gold,
                        strokeWidth: 2,
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(
                      Icons.card_giftcard_rounded,
                      color: _gold,
                      size: 74,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                prize.name,
                maxLines: 1,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .2,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              prize.subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _gold,
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class _DiscountCard extends StatelessWidget {
  const _DiscountCard();

  static const _gold = Color(0xFFE8C36A);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(46, 18, 46, 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.workspace_premium_rounded, color: _gold, size: 48),
          const SizedBox(height: 4),
          const Text(
            'ROYAL CLUB',
            style: TextStyle(
              color: _gold,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
          const Spacer(),
          ShaderMask(
            shaderCallback: (rect) => const LinearGradient(
              colors: [Color(0xFFFFF1AA), Color(0xFFD49A2A), Color(0xFFFFE58B)],
            ).createShader(rect),
            child: const Text(
              '80%',
              style: TextStyle(
                color: Colors.white,
                fontSize: 78,
                height: .92,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'تخفیف ویژه خرید',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'ROYAL MALL • SPECIAL REWARD',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _gold,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFF170B08),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _gold),
            ),
            child: const Text(
              'جایزه اختصاصی اعضای رویال کلاب',
              textDirection: TextDirection.rtl,
              style: TextStyle(color: Colors.white, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ArrowButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(.72),
      shape: const CircleBorder(
        side: BorderSide(color: Color(0xFFE8C36A), width: 1.2),
      ),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 34,
          height: 34,
          child: Icon(icon, color: const Color(0xFFE8C36A), size: 28),
        ),
      ),
    );
  }
}

class _Prize {
  final String name;
  final String subtitle;
  final String? imageUrl;
  final bool isDiscount;

  const _Prize(this.name, this.subtitle, this.imageUrl)
      : isDiscount = false;

  const _Prize.discount()
      : name = '80% ROYAL MALL',
        subtitle = 'SPECIAL SHOPPING REWARD',
        imageUrl = null,
        isDiscount = true;
}
