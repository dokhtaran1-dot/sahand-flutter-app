import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class RoyalMallPage extends StatefulWidget {
  const RoyalMallPage({super.key});

  @override
  State<RoyalMallPage> createState() => _RoyalMallPageState();
}

class _RoyalMallPageState extends State<RoyalMallPage> {
  static const _gold = Color(0xFFE6BE68);
  static const _videoAsset = 'assets/videos/rm_intro.mp4';

  VideoPlayerController? _controller;
  bool _videoReady = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    final controller = VideoPlayerController.asset(_videoAsset);
    try {
      await controller.initialize();
      await controller.setLooping(true);
      await controller.setVolume(0);
      await controller.play();
      if (!mounted) {
        controller.dispose();
        return;
      }
      setState(() {
        _controller = controller;
        _videoReady = true;
      });
    } catch (_) {
      await controller.dispose();
      if (mounted) setState(() => _videoReady = false);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final features = const [
      (Icons.shopping_bag_outlined, 'فروشگاه‌ها'),
      (Icons.restaurant_outlined, 'رستوران و کافه'),
      (Icons.diamond_outlined, 'برندهای لوکس'),
      (Icons.local_parking_outlined, 'پارکینگ'),
      (Icons.event_outlined, 'رویدادها'),
      (Icons.location_on_outlined, 'نقشه و مسیرها'),
      (Icons.local_offer_outlined, 'تخفیف‌ها'),
      (Icons.info_outline, 'درباره ما'),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF100B06), Colors.black],
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _gold),
                    ),
                    const Spacer(),
                    const Column(
                      children: [
                        Text(
                          'SC',
                          style: TextStyle(
                            color: _gold,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                        Text(
                          'SAHAND CONSORTIUM',
                          style: TextStyle(
                            color: _gold,
                            fontSize: 9,
                            letterSpacing: 1.4,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const SizedBox(
                      width: 48,
                      child: Icon(Icons.notifications_none_rounded, color: _gold, size: 29),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 120),
                  child: Column(
                    children: [
                      _HeroVideo(
                        controller: _controller,
                        ready: _videoReady,
                        gold: _gold,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'بیش از یک مرکز خرید',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: _gold,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'MORE THAN A MALL',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          letterSpacing: 4,
                        ),
                      ),
                      const SizedBox(height: 22),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: features.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.65,
                        ),
                        itemBuilder: (context, i) {
                          return _FeatureTile(
                            icon: features[i].$1,
                            title: features[i].$2,
                            gold: _gold,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            color: const Color(0xFF080706),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: _gold.withOpacity(.65)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavIcon(Icons.home_rounded, 'خانه'),
              _NavIcon(Icons.workspace_premium_outlined, 'Royal Club'),
              _NavIcon(Icons.favorite_border_rounded, 'علاقه‌مندی'),
              _NavIcon(Icons.grid_view_rounded, 'بیشتر'),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroVideo extends StatelessWidget {
  final VideoPlayerController? controller;
  final bool ready;
  final Color gold;

  const _HeroVideo({
    required this.controller,
    required this.ready,
    required this.gold,
  });

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height * .43;
    return Container(
      height: h.clamp(300.0, 520.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF070707),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: gold.withOpacity(.75)),
        boxShadow: [
          BoxShadow(color: gold.withOpacity(.12), blurRadius: 26),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: ready && controller != null
          ? FittedBox(
              fit: BoxFit.cover,
              clipBehavior: Clip.hardEdge,
              child: SizedBox(
                width: controller!.value.size.width,
                height: controller!.value.size.height,
                child: VideoPlayer(controller!),
              ),
            )
          : Stack(
              fit: StackFit.expand,
              children: [
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(0, -.25),
                      radius: 1.1,
                      colors: [Color(0xFF33210D), Color(0xFF070707)],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_circle_outline_rounded, color: gold, size: 72),
                    const SizedBox(height: 14),
                    const Text(
                      'ROYAL MALL',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'ویدیو را با نام rm_intro.mp4 آپلود کنید',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(color: Colors.white60, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color gold;

  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.gold,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0D0B08),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: gold.withOpacity(.48)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: gold, size: 31),
            const SizedBox(height: 9),
            Text(
              title,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const _NavIcon(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 2),
        Icon(icon, color: _RoyalMallPageState._gold, size: 25),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: _RoyalMallPageState._gold,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
