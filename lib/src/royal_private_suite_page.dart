import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Self-contained interactive PRIVATE SUITE preview.
/// No purchases, real-money balance, multiplayer or real invitations.
class RoyalPrivateSuitePage extends StatefulWidget {
  const RoyalPrivateSuitePage({super.key});

  @override
  State<RoyalPrivateSuitePage> createState() => _RoyalPrivateSuitePageState();
}

class _SuiteTheme {
  const _SuiteTheme(this.name, this.fa, this.wall, this.dark, this.accent);
  final String name;
  final String fa;
  final Color wall;
  final Color dark;
  final Color accent;
}

const _themes = <_SuiteTheme>[
  _SuiteTheme('JARDIN', 'ژاردن', Color(0xFF254735), Color(0xFF0D2418), Color(0xFFC5B681)),
  _SuiteTheme('LUMIÈRE', 'لومیر', Color(0xFF62786E), Color(0xFF243A37), Color(0xFFF3E2B4)),
  _SuiteTheme('DORÉ', 'دوره', Color(0xFF615039), Color(0xFF281B12), Color(0xFFEBC485)),
  _SuiteTheme('ÂME DU POÈTE', 'روح شاعر', Color(0xFF4C293C), Color(0xFF211321), Color(0xFFE2B6BD)),
  _SuiteTheme('ROYAL', 'رویال', Color(0xFF35405B), Color(0xFF151C31), Color(0xFFDEBE79)),
  _SuiteTheme('PRIVÉ', 'پریوه', Color(0xFF4E514A), Color(0xFF222822), Color(0xFFD3C4A1)),
  _SuiteTheme('NOIR', 'نوآر', Color(0xFF27282C), Color(0xFF090B0D), Color(0xFFC4A370)),
];

class _RoyalPrivateSuitePageState extends State<RoyalPrivateSuitePage> {
  static const _gold = Color(0xFFDFBF80);
  static const _cream = Color(0xFFF3EBDC);
  static const _keyStyle = 'royal_one_suite_style_v1';
  static const _keyAvatar = 'royal_one_suite_avatar_v1';
  static const _keyChair = 'royal_one_suite_chair_v1';
  static const _keyArt = 'royal_one_suite_art_v1';
  static const _keyLight = 'royal_one_suite_light_v1';
  static const _keyX = 'royal_one_suite_x_v1';
  static const _keyY = 'royal_one_suite_y_v1';

  int theme = 0;
  int avatar = 0;
  int chair = 0;
  int painting = 0;
  int light = 0;
  double avatarX = .49;
  double avatarY = .79;
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    _restore();
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      theme = (prefs.getInt(_keyStyle) ?? 0).clamp(0, 6).toInt();
      avatar = (prefs.getInt(_keyAvatar) ?? 0).clamp(0, 3).toInt();
      chair = (prefs.getInt(_keyChair) ?? 0).clamp(0, 2).toInt();
      painting = (prefs.getInt(_keyArt) ?? 0).clamp(0, 2).toInt();
      light = (prefs.getInt(_keyLight) ?? 0).clamp(0, 2).toInt();
      avatarX = (prefs.getDouble(_keyX) ?? .49).clamp(.16, .84).toDouble();
      avatarY = (prefs.getDouble(_keyY) ?? .79).clamp(.64, .88).toDouble();
      loaded = true;
    });
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setInt(_keyStyle, theme),
      prefs.setInt(_keyAvatar, avatar),
      prefs.setInt(_keyChair, chair),
      prefs.setInt(_keyArt, painting),
      prefs.setInt(_keyLight, light),
      prefs.setDouble(_keyX, avatarX),
      prefs.setDouble(_keyY, avatarY),
    ]);
  }

  void _change(void Function() fn) {
    setState(fn);
    _save();
  }

  void _showComingSoon(String title) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF14231A),
        title: Text(title, style: const TextStyle(color: _gold),
            textDirection: TextDirection.rtl),
        content: const Text(
          'این یک نسخهٔ قابل آزمایش از اتاق خصوصی است. دعوت آنلاین، '
          'فروش وسایل، هدیه‌دادن و جشن چندنفره هنوز فعال نیستند؛ '
          'هیچ پولی دریافت نمی‌شود.',
          style: TextStyle(color: _cream, height: 1.9),
          textDirection: TextDirection.rtl,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx),
              child: const Text('متوجه شدم', style: TextStyle(color: _gold))),
        ],
      ),
    );
  }

  Widget _choice(String text, bool selected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 7),
      child: ChoiceChip(
        selected: selected,
        label: Text(text, style: TextStyle(
          fontSize: 11, color: selected ? const Color(0xFF15140C) : _cream,
          fontWeight: FontWeight.w700,
        )),
        selectedColor: _gold,
        backgroundColor: const Color(0xFF142119),
        side: BorderSide(color: selected ? _gold : const Color(0x997D6845)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        onSelected: (_) => onTap(),
      ),
    );
  }

  Widget _selector(String heading, List<String> names, int value,
      ValueChanged<int> onChange) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
        child: Text(heading, textDirection: TextDirection.rtl,
          style: const TextStyle(color: _gold, fontWeight: FontWeight.bold, fontSize: 14)),
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          for (int i = 0; i < names.length; i++)
            _choice(names[i], value == i, () => onChange(i)),
        ]),
      ),
      const SizedBox(height: 13),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final chosen = _themes[theme];
    return Scaffold(
      backgroundColor: const Color(0xFF060C08),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1B12),
        foregroundColor: _gold,
        centerTitle: true,
        title: const Text('ROYAL PRIVATE SUITE',
          style: TextStyle(letterSpacing: 1.3, fontSize: 15, color: _gold)),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(13, 13, 13, 30),
              children: [
                Row(children: [
                  const Icon(Icons.diamond_outlined, color: _gold, size: 18),
                  const SizedBox(width: 8),
                  const Expanded(child: Text('MY SUITE  ·  PREVIEW',
                    style: TextStyle(color: _cream, fontSize: 11, letterSpacing: 2))),
                  Text(chosen.name, style: const TextStyle(
                    color: _gold, fontWeight: FontWeight.bold, fontSize: 12)),
                ]),
                const SizedBox(height: 11),
                LayoutBuilder(builder: (context, bounds) {
                  final w = bounds.maxWidth;
                  final h = w > 550 ? 460.0 : (w * 1.07).clamp(340.0, 480.0).toDouble();
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: _gold.withOpacity(.80), width: 1.4),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(
                        color: chosen.accent.withOpacity(.12), blurRadius: 22,
                      )],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: SizedBox(
                      width: w, height: h,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTapDown: (d) {
                          final x = (d.localPosition.dx / w).clamp(.17, .83).toDouble();
                          final y = (d.localPosition.dy / h).clamp(.63, .86).toDouble();
                          _change(() { avatarX = x; avatarY = y; });
                        },
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CustomPaint(painter: _SuitePainter(
                              style: chosen, chair: chair,
                              painting: painting, light: light,
                            )),
                            Positioned(
                              left: 12, top: 11,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: const Color(0xC907130C),
                                  border: Border.all(color: _gold.withOpacity(.45)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  child: Text('SUITE 001 · PRIVATE',
                                    style: TextStyle(color: _gold, fontSize: 10, letterSpacing: .9)),
                                ),
                              ),
                            ),
                            AnimatedPositioned(
                              left: w * avatarX - 26,
                              top: h * avatarY - 96,
                              duration: const Duration(milliseconds: 850),
                              curve: Curves.easeInOutCubic,
                              child: IgnorePointer(
                                child: SizedBox(width: 52, height: 97,
                                  child: CustomPaint(painter: _AvatarPainter(
                                    color: const [
                                      Color(0xFF1C2D27), Color(0xFF7F293C),
                                      Color(0xFF1C2C55), Color(0xFFDFD2BD)
                                    ][avatar],
                                  )),
                                ),
                              ),
                            ),
                            const Positioned(
                              left: 8, right: 8, bottom: 10,
                              child: Text('برای حرکت کاراکتر، کف اتاق را لمس کنید',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Color(0xFFD9D2C3),
                                  fontSize: 11, shadows: [
                                    Shadow(color: Colors.black, blurRadius: 8),
                                  ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 11),
                const Text(
                  'نسخهٔ تعاملی اولیه با نمای پرسپکتیو؛ سه‌بعدی آزاد و چندنفره نیست.',
                  textDirection: TextDirection.rtl, textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, color: Color(0xFFB6C1B2)),
                ),
                const SizedBox(height: 20),
                _selector('سبک اتاق (۷ انتخاب)', [
                  for (final t in _themes) t.name,
                ], theme, (i) => _change(() => theme = i)),
                _selector('شخصیت شما', const [
                  'CLASSIC', 'RUBY', 'SAPPHIRE', 'IVORY',
                ], avatar, (i) => _change(() => avatar = i)),
                _selector('مبلمان اتاق', const [
                  'صندلی ساده', 'مبل کلاسیک', 'مبل امپریال',
                ], chair, (i) => _change(() => chair = i)),
                _selector('تابلوی دیوار', const [
                  'طبیعت', 'هنر انتزاعی', 'گالری طلایی',
                ], painting, (i) => _change(() => painting = i)),
                _selector('لوستر', const [
                  'کلاسیک', 'کریستال', 'مدرن',
                ], light, (i) => _change(() => light = i)),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(colors: [
                      Color(0xFF192B1F), Color(0xFF111D16),
                    ]),
                    border: Border.all(color: const Color(0xAA806A48)),
                  ),
                  child: Column(children: [
                    const Row(children: [
                      Icon(Icons.check_circle_outline, color: _gold, size: 19),
                      SizedBox(width: 8),
                      Expanded(child: Text('تغییرات روی همین دستگاه ذخیره می‌شوند',
                        style: TextStyle(color: _cream, fontSize: 12))),
                    ]),
                    const SizedBox(height: 12),
                    Row(children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showComingSoon('دعوت دوستان'),
                          icon: const Icon(Icons.people_outline, size: 18),
                          label: const Text('دعوت مهمان'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _gold,
                            side: const BorderSide(color: _gold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showComingSoon('Royal Moments'),
                          icon: const Icon(Icons.cake_outlined, size: 18),
                          label: const Text('جشن تولد'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _gold,
                            side: const BorderSide(color: _gold),
                          ),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 5),
                    const Text('فروشگاه، هدیه و پرداخت واقعی در این پیش‌نمایش غیرفعال‌اند.',
                      textDirection: TextDirection.rtl, textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFFB8BFB2), fontSize: 11)),
                  ]),
                ),
                if (!loaded)
                  const Center(child: Padding(
                    padding: EdgeInsets.all(8),
                    child: LinearProgressIndicator(color: _gold),
                  )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SuitePainter extends CustomPainter {
  const _SuitePainter({required this.style, required this.chair,
    required this.painting, required this.light});
  final _SuiteTheme style;
  final int chair, painting, light;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 400, size.height / 430);
    final wall = Paint()..color = style.wall;
    final shadow = Paint()..color = style.dark;
    final gold = Paint()..color = style.accent;

    void poly(List<Offset> pts, Paint p) {
      canvas.drawPath(Path()..addPolygon(pts, true), p);
    }
    void rect(double x, double y, double w, double h, Paint p) =>
        canvas.drawRect(Rect.fromLTWH(x,y,w,h), p);
    void line(Offset a, Offset b, Paint p) =>
        canvas.drawLine(a,b,p);

    // Architectural room, one-point perspective.
    rect(0, 0, 400, 430, shadow);
    poly([const Offset(0,0), const Offset(76,59), const Offset(76,259),
          const Offset(0,355)], Paint()..color = Color.lerp(style.wall, Colors.black, .38)!);
    poly([const Offset(400,0), const Offset(323,59), const Offset(323,259),
          const Offset(400,355)], Paint()..color = Color.lerp(style.wall, Colors.black, .28)!);
    poly([const Offset(76,59), const Offset(323,59), const Offset(323,259),
          const Offset(76,259)], wall);
    poly([const Offset(0,0), const Offset(400,0), const Offset(323,59),
          const Offset(76,59)], Paint()..color = const Color(0xFF111B14));
    poly([const Offset(0,355), const Offset(76,259), const Offset(323,259),
          const Offset(400,355), const Offset(400,430), const Offset(0,430)],
        Paint()..color = const Color(0xFF513728));

    // Floor with perspective parquet rays.
    final floorLine = Paint()..color = const Color(0x446F5B43)..strokeWidth = 1;
    for (int i=0; i<=9; i++) {
      line(const Offset(200,255), Offset(i*50-25,430), floorLine);
    }
    for (final y in [286.0,326.0,372.0,416.0]) {
      line(Offset(0,y), Offset(400,y), floorLine);
    }

    // Moldings and elegant wall panels.
    final trim = Paint()..color = style.accent.withOpacity(.75)
      ..style=PaintingStyle.stroke..strokeWidth=2;
    canvas.drawRect(const Rect.fromLTWH(88,72,224,173), trim);
    canvas.drawRect(const Rect.fromLTWH(98,82,204,153), trim);
    line(const Offset(76,249), const Offset(323,249), trim);
    line(const Offset(8,337), const Offset(76,257), trim);
    line(const Offset(323,257), const Offset(392,337), trim);

    // Frame artwork.
    rect(146,110,109,99,gold);
    rect(152,116,97,87,shadow);
    final artRect=Rect.fromLTWH(159,123,83,73);
    if (painting == 0) {
      rect(159,123,83,73, Paint()..color=const Color(0xFF385C54));
      poly([const Offset(159,191), const Offset(184,152),
        const Offset(207,173), const Offset(226,144), const Offset(242,191)],
        Paint()..color=const Color(0xFFB4AE90));
      canvas.drawCircle(const Offset(219,143),10,Paint()..color=const Color(0xFFE8D1A0));
    } else if (painting == 1) {
      rect(159,123,83,73, Paint()..color=const Color(0xFF411B2B));
      canvas.drawCircle(const Offset(201,159),25,Paint()..color=const Color(0xFFCA9B6F));
      poly([const Offset(159,190),const Offset(211,127),const Offset(242,169),
        const Offset(242,196)], Paint()..color=const Color(0xAA101D24));
    } else {
      rect(159,123,83,73, Paint()..color=const Color(0xFF151917));
      canvas.drawOval(Rect.fromCenter(center:const Offset(202,159),
        width:55,height:67),Paint()..color=const Color(0xFFBEA06E));
      canvas.drawOval(Rect.fromCenter(center:const Offset(202,159),
        width:35,height:49),Paint()..color=const Color(0xFF263F34));
    }
    canvas.drawRect(artRect,Paint()..color=Colors.transparent);
    // Two floor lamps.
    for(final x in [110.0,291.0]) {
      line(Offset(x,216), Offset(x,303), Paint()..color=style.accent..strokeWidth=3);
      poly([Offset(x-11,215),Offset(x+11,215),Offset(x+15,237),Offset(x-15,237)],
        Paint()..color=const Color(0xFFDECCA4));
      canvas.drawOval(Rect.fromCenter(center:Offset(x,304),width:29,height:8),gold);
    }

    // Ceiling chandelier.
    line(const Offset(200,0), const Offset(200,54),
      Paint()..color=style.accent..strokeWidth=3);
    final cy=light==2?61.0:75.0;
    canvas.drawOval(Rect.fromCenter(center:Offset(200,cy),
      width:light==2?105:87,height:22),gold);
    canvas.drawOval(Rect.fromCenter(center:Offset(200,cy+10),
      width:light==2?78:58,height:13),shadow);
    if (light != 2) {
      for (var i=-3; i<=3; i++) {
        final x=200.0+i*12;
        line(Offset(x,cy+4),Offset(x,cy+25+(i.isEven?12:0)),
          Paint()..color=style.accent..strokeWidth=2);
        canvas.drawCircle(Offset(x,cy+30+(i.isEven?12:0)),
          light==1?6:4,Paint()..color=const Color(0xFFE9E2CB));
      }
    }

    // Furniture silhouettes.
    final upholstery = chair==0?const Color(0xFF5A4738):
      chair==1?const Color(0xFF214032):const Color(0xFF731F2D);
    final seat = Paint()..color=upholstery;
    final furnitureTrim = Paint()..color=style.accent
      ..style=PaintingStyle.stroke..strokeWidth=3;
    if(chair==0) {
      canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(245,258,53,54),
        const Radius.circular(13)),seat);
      canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(245,258,53,54),
        const Radius.circular(13)),furnitureTrim);
      rect(254,303,5,30,shadow);rect(288,303,5,30,shadow);
    } else {
      canvas.drawRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(chair==1?233:221,250,chair==1?80:104,63),
        const Radius.circular(18)), seat);
      canvas.drawRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(chair==1?233:221,250,chair==1?80:104,63),
        const Radius.circular(18)), furnitureTrim);
      canvas.drawOval(Rect.fromLTWH(229,291,98,22),seat);
      for (final x in [244.0, 304.0]){
        rect(x,309,6,27,shadow);
      }
    }
    // Side table and ceramic vase.
    canvas.drawOval(const Rect.fromLTWH(72,294,74,23),
      Paint()..color=const Color(0xFFB09264));
    for (final x in [85.0,129.0]){
      rect(x,307,6,37,shadow);
    }
    canvas.drawOval(const Rect.fromLTWH(92,270,22,33),
      Paint()..color=const Color(0xFFE1D5BC));
    poly([const Offset(104,274),const Offset(99,251),const Offset(97,239)],
      Paint()..color=const Color(0xFF4E6842)..style=PaintingStyle.stroke..strokeWidth=4);

    // Soft vignette.
    final vignette=Paint()..shader=RadialGradient(colors: [
      Colors.transparent,Colors.black.withOpacity(.49),
    ],stops:const [.45,1]).createShader(const Rect.fromLTWH(0,0,400,430));
    rect(0,0,400,430,vignette);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SuitePainter old) =>
      old.style != style || old.chair != chair ||
      old.painting != painting || old.light != light;
}

class _AvatarPainter extends CustomPainter {
  const _AvatarPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width/52,size.height/97);
    canvas.drawOval(const Rect.fromLTWH(8,89,38,8),
      Paint()..color=const Color(0x88000000));
    final outline=Paint()..color=const Color(0xFFC7A576)
      ..style=PaintingStyle.stroke..strokeWidth=2;
    final coat=Paint()..color=color;
    // Shoes and legs.
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(13,72,11,21),
      const Radius.circular(3)),Paint()..color=const Color(0xFF181A1A));
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(29,72,11,21),
      const Radius.circular(3)),Paint()..color=const Color(0xFF181A1A));
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(8,30,37,49),
      const Radius.circular(9)),coat);
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(8,30,37,49),
      const Radius.circular(9)),outline);
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(2,35,9,34),
      const Radius.circular(4)),coat);
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(42,35,9,34),
      const Radius.circular(4)),coat);
    canvas.drawOval(const Rect.fromLTWH(13,6,28,30),
      Paint()..color=const Color(0xFFDAB696));
    canvas.drawArc(const Rect.fromLTWH(11,2,30,21),
      math.pi, math.pi, true, Paint()..color=const Color(0xFF211B19));
    canvas.drawLine(const Offset(26,31),const Offset(26,68),
      Paint()..color=const Color(0xFFD9C4A2)..strokeWidth=2);
    canvas.restore();
  }
  @override
  bool shouldRepaint(covariant _AvatarPainter old) => old.color != color;
}
