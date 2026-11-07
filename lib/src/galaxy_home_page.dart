import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'ettehad_page.dart';
import 'royal_club_game_page.dart';
import 'royal_harmonia_page.dart';
import 'royal_mall_page.dart';
import 'royal_signature_page.dart';
import 'royal_village_page.dart';

/// Six independently tappable gateways; photos revolve inside the fixed
/// spherical silhouettes, while all labels and controls remain readable.
class GalaxyHomePage extends StatefulWidget {
  const GalaxyHomePage({super.key});
  @override
  State<GalaxyHomePage> createState() => _GalaxyHomePageState();
}
class _GalaxyHomePageState extends State<GalaxyHomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _turn;
  @override
  void initState() {
    super.initState();
    _turn = AnimationController(
      vsync: this, duration: const Duration(seconds: 20))..repeat();
  }
  @override
  void dispose() { _turn.dispose(); super.dispose(); }
  void _open(Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }
  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.sizeOf(context);
    final d = math.min((sz.width - 48) / 3, 128.0);
    const gold = Color(0xFFE7C88E);
    return Scaffold(
      backgroundColor: const Color(0xFF03100B),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -.3), radius: 1.45,
            colors: [Color(0xFF17372C), Color(0xFF071B14), Color(0xFF020807)])),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: math.max(sz.height - 50, 550.0)),
              child: Column(children: [
                const SizedBox(height: 16),
                const Text('SC', style: TextStyle(
                  color: gold, fontSize: 37, fontWeight: FontWeight.w300)),
                const Text('SAHAND CONSORTIUM', style: TextStyle(
                  color: gold, fontSize: 11, letterSpacing: 3)),
                const SizedBox(height: 3),
                const Text('SINCE 1351', style: TextStyle(
                  color: Color(0xFFDBD0B7), fontSize: 9, letterSpacing: 2)),
                const SizedBox(height: 13),
                const Text('ROYAL ONE', style: TextStyle(
                  color: gold, fontSize: 29, fontWeight: FontWeight.bold,
                  letterSpacing: 3.6)),
                const Text('یک ورود، یک دنیای کامل رویال', style: TextStyle(
                  color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 21),
                _row(d, [
                  _OrbInfo('assets/image/mne_06_royal_mall.jpg',
                    'RM', 'ROYAL MALL', 'مرکز خرید', 0,
                    () => _open(const RoyalMallPage())),
                  _OrbInfo('assets/image/RC_Approved.jpg',
                    'RC', 'ROYAL CLUB', 'باشگاه اختصاصی', .333,
                    () => _open(const RoyalClubGamePage())),
                  _OrbInfo('assets/image/Grand_Salon_Original.png',
                    'RV', 'ROYAL VILLAGE', 'رستوران و کافه', .667,
                    () => _open(const RoyalVillagePage())),
                ]),
                const SizedBox(height: 19),
                Container(
                  width: sz.width * .66, height: 1,
                  color: gold.withOpacity(.45),
                ),
                const SizedBox(height: 20),
                _row(d, [
                  _OrbInfo('assets/image/monogram_re.webp',
                    'RE', 'ROYAL ETTEHAD', 'ساخت و ساز', .16,
                    () => _open(const EttehadPage())),
                  _OrbInfo('assets/image/monogram_rs.webp',
                    'RS', 'ROYAL SIGNATURE', 'هنر و محصولات خاص', .5,
                    () => _open(const RoyalSignaturePage())),
                  _OrbInfo('assets/image/monogram_rh.webp',
                    'RH', 'ROYAL HARMONIA', 'تجهیزات و فناوری', .83,
                    () => _open(const RoyalHarmoniaPage())),
                ]),
                const SizedBox(height: 25),
                const Icon(Icons.public_rounded, color: gold, size: 25),
                const SizedBox(height: 7),
                const Text('ONE ENTRANCE. A WHOLE ROYAL WORLD.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFFE9D7B5),
                    letterSpacing: 1.15, fontSize: 10)),
                const SizedBox(height: 17),
              ]),
            ),
          ),
        ),
      ),
    );
  }
  Widget _row(double d, List<_OrbInfo> orbs) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (final orb in orbs) Expanded(
        child: _OrbTile(diameter: d, animation: _turn, info: orb)),
    ],
  );
}
class _OrbInfo {
  const _OrbInfo(this.photo, this.initials, this.title,
      this.caption, this.phase, this.onTap);
  final String photo, initials, title, caption;
  final double phase;
  final VoidCallback onTap;
}
class _OrbTile extends StatelessWidget {
  const _OrbTile({required this.diameter, required this.animation,
    required this.info});
  final double diameter;
  final Animation<double> animation;
  final _OrbInfo info;

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFE7C88E);
    return Semantics(
      label: 'ورود به ' + info.title,
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: info.onTap,
          borderRadius: BorderRadius.circular(18),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(
              height: diameter + 9, width: diameter,
              child: Center(
                child: RepaintBoundary(
                  child: AnimatedBuilder(
                    animation: animation,
                    builder: (context, _) {
                      final t = (animation.value + info.phase) % 1;
                      return Transform.translate(
                        offset: Offset(0, 3 * math.sin(t * math.pi * 2)),
                        child: _SpinningPhotoSphere(
                          diameter: diameter, photo: info.photo, t: t),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(info.initials, style: const TextStyle(color: gold,
              fontSize: 26, fontWeight: FontWeight.w800, height: 1)),
            const SizedBox(height: 6),
            Text(info.title, maxLines: 1, overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center, style: const TextStyle(
                color: gold, fontSize: 10, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(info.caption, maxLines: 2, textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFE7DDC6), fontSize: 11, height: 1.25)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF221B0E),
                border: Border.all(color: gold),
                borderRadius: BorderRadius.circular(22)),
              child: const Text('ورود', style: TextStyle(
                color: gold, fontSize: 11, fontWeight: FontWeight.w600)),
            ),
          ]),
        ),
      ),
    );
  }
}
/// The two tiles loop without a sudden reset. Gold light, shadow and a
/// stable circular outline simulate a lit three-dimensional globe.
class _SpinningPhotoSphere extends StatelessWidget {
  const _SpinningPhotoSphere({
    required this.diameter, required this.photo, required this.t});
  final double diameter;
  final String photo;
  final double t;
  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFFFD89E);
    return SizedBox(
      width: diameter, height: diameter,
      child: Stack(children: [
        Positioned.fill(child: DecoratedBox(
          decoration: BoxDecoration(shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: gold.withOpacity(.40),
              blurRadius: 20, spreadRadius: 1)]))),
        ClipOval(child: SizedBox(
          width: diameter, height: diameter,
          child: Stack(children: [
            Positioned(
              left: -2 * diameter * t, top: 0,
              width: 4 * diameter, height: diameter,
              child: Row(children: [
                Image.asset(photo, width: 2 * diameter, height: diameter,
                  fit: BoxFit.cover, filterQuality: FilterQuality.medium),
                Image.asset(photo, width: 2 * diameter, height: diameter,
                  fit: BoxFit.cover, filterQuality: FilterQuality.medium),
              ]),
            ),
            const Positioned.fill(child: DecoratedBox(
              decoration: BoxDecoration(gradient: RadialGradient(
                center: Alignment(-.45, -.55), radius: 1.05,
                colors: [Color(0x30FFFFFF), Color(0x09000000),
                  Color(0x66000000), Color(0xBC000000)],
                stops: [0, .40, .77, 1])))),
          ]),
        )),
        Positioned.fill(child: IgnorePointer(child: DecoratedBox(
          decoration: BoxDecoration(shape: BoxShape.circle,
            border: Border.fromBorderSide(
              BorderSide(color: gold, width: 2.2)))))),
        Positioned(top: diameter * .08, left: diameter * .16,
          child: Container(
            width: diameter * .19, height: diameter * .05,
            decoration: BoxDecoration(
              color: const Color(0x88FFFDF4),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Color(0x99FFF2CD), blurRadius: 9)],
            ),
          ),
        ),
      ]),
    );
  }
}
