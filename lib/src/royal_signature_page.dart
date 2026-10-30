import 'package:flutter/material.dart';

/// RS artist edition: original proposed designs, not fabricated inventory.
class RoyalSignaturePage extends StatelessWidget {
  const RoyalSignaturePage({super.key});

  static const Color _black = Color(0xFF090D0A);
  static const Color _emerald = Color(0xFF163426);
  static const Color _gold = Color(0xFFDFC189);
  static const Color _cream = Color(0xFFF3EBDD);
  static const Color _muted = Color(0xFFA8B5A8);

  static const List<_ArtConcept> _concepts = [
    _ArtConcept(1, 'دهکدهٔ آلپی نیمه‌شب', 'Midnight Alpine Village'),
    _ArtConcept(2, 'ارگ بونسای زمردین', 'Emerald Bonsai Citadel'),
    _ArtConcept(3, 'جزیرهٔ ساعت‌ساز', 'The Clockmaker’s Isle'),
    _ArtConcept(4, 'حریم رز سیاه', 'Black Rose Sanctuary'),
    _ArtConcept(5, 'آبشار مارپیچ', 'The Spiral Cascade'),
    _ArtConcept(6, 'شطرنجِ جاذبه', 'Chess of Gravity'),
    _ArtConcept(7, 'کتابخانهٔ نورانی', 'The Luminous Library'),
    _ArtConcept(8, 'الههٔ عاجی', 'Ivory Muse'),
    _ArtConcept(9, 'ققنوسِ آبسیدین', 'Obsidian Phoenix'),
    _ArtConcept(10, 'ریشه‌های بی‌انتها', 'Infinite Roots'),
  ];

  static const _note =
      'این تصاویر ایده‌های مفهومی پیشنهادی برای بررسی و ساخت احتمالی هستند؛ '
      'آثار ساخته‌شده یا تأییدشدهٔ استاد جعفر درگاهی محسوب نمی‌شوند.';

  void _openArtwork(BuildContext context, _ArtConcept concept) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _ArtworkViewer(
          concept: concept,
          gold: _gold,
          cream: _cream,
          note: _note,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 700 ? 3 : 2;
    return Scaffold(
      backgroundColor: _black,
      appBar: AppBar(
        backgroundColor: _black,
        foregroundColor: _gold,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'ROYAL SIGNATURE',
          style: TextStyle(
            fontSize: 15,
            letterSpacing: 2.4,
            fontWeight: FontWeight.w600,
            color: _gold,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 34),
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(17, 22, 17, 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [_emerald, _black],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0x66775E35)),
              ),
              child: Column(
                children: [
                  const SizedBox(width: 68, height: 68, child: _JDMonogram()),
                  const SizedBox(height: 9),
                  const Text(
                    'JAFAR DARGAHI',
                    style: TextStyle(
                      color: _cream,
                      fontFamily: 'serif',
                      letterSpacing: 3,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'JD · SIGNATURE ART COLLECTION',
                    style: TextStyle(
                      color: _gold,
                      letterSpacing: 2,
                      fontSize: 9,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'ده جهان تازه، یک امضای ماندگار',
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: _cream,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'مجموعه‌ای از ۱۰ طرح اختصاصی الهام‌گرفته از جزیره‌های معلق، '
                    'مجسمه‌های کلاسیک و فرم‌های فراسوی جاذبه.',
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: _muted,
                      fontSize: 12,
                      height: 1.9,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 23),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 1.68,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(_concepts.first.asset, fit: BoxFit.cover),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Color(0xE908100A),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 16,
                      bottom: 14,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'JD / EDITION 01',
                            style: TextStyle(
                              fontSize: 10,
                              letterSpacing: 2,
                              color: _gold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            _concepts.first.titleFa,
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(
                              fontSize: 17,
                              color: _cream,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'JD / 10 EXCLUSIVE CONCEPTS',
                  style: TextStyle(
                    fontSize: 9,
                    color: _gold,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  'طرح‌های امضایی',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: _cream,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _concepts.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 11,
                mainAxisSpacing: 13,
                childAspectRatio: .69,
              ),
              itemBuilder: (context, index) {
                final concept = _concepts[index];
                return Material(
                  color: const Color(0xFF111A14),
                  borderRadius: BorderRadius.circular(14),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => _openArtwork(context, concept),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0x668F734A)),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(
                                  concept.asset,
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.high,
                                ),
                                Positioned(
                                  top: 6,
                                  right: 7,
                                  child: Container(
                                    width: 39,
                                    height: 39,
                                    padding: const EdgeInsets.all(4),
                                    color: const Color(0xCC071009),
                                    child: const _JDMonogram(),
                                  ),
                                ),
                                Positioned(
                                  left: 9,
                                  bottom: 8,
                                  child: Text(
                                    'JD · ${concept.number.toString().padLeft(2, '0')}',
                                    style: const TextStyle(
                                      color: _cream,
                                      fontSize: 10,
                                      letterSpacing: 1.1,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 8,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(7, 9, 9, 9),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  concept.titleFa,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textDirection: TextDirection.rtl,
                                  style: const TextStyle(
                                    color: _cream,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  concept.titleEn,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    color: _gold,
                                    fontFamily: 'serif',
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF111912),
                border: Border.all(color: const Color(0x446F815E)),
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Text(
                _note,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: _muted,
                  fontSize: 11,
                  height: 1.85,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArtConcept {
  final int number;
  final String titleFa;
  final String titleEn;

  const _ArtConcept(this.number, this.titleFa, this.titleEn);

  String get asset =>
      'assets/image/jd_signature/jd-concept-${number.toString().padLeft(2, '0')}.webp';
}

class _ArtworkViewer extends StatelessWidget {
  final _ArtConcept concept;
  final Color gold;
  final Color cream;
  final String note;

  const _ArtworkViewer({
    required this.concept,
    required this.gold,
    required this.cream,
    required this.note,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF050906),
    appBar: AppBar(
      backgroundColor: const Color(0xFF050906),
      foregroundColor: gold,
      centerTitle: true,
      title: Text('JD · ${concept.number.toString().padLeft(2, '0')}'),
    ),
    body: SafeArea(
      child: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 5,
              child: Center(
                child: Hero(
                  tag: 'jd-art-${concept.number}',
                  child: Image.asset(concept.asset, fit: BoxFit.contain),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
            child: Column(
              children: [
                Text(
                  concept.titleFa,
                  style: TextStyle(color: cream, fontSize: 20),
                ),
                const SizedBox(height: 3),
                Text(
                  concept.titleEn,
                  style: TextStyle(
                    fontFamily: 'serif',
                    color: gold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 13),
                Text(
                  note,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFA7B4A8),
                    fontSize: 10,
                    height: 1.7,
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

/// Native Flutter painter for the original JD monogram, no SVG dependency.
class _JDMonogram extends StatelessWidget {
  const _JDMonogram();

  @override
  Widget build(BuildContext context) => const CustomPaint(
    painter: _JDMonogramPainter(),
    child: SizedBox.expand(),
  );
}

class _JDMonogramPainter extends CustomPainter {
  const _JDMonogramPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 512, size.height / 512);
    final stroke = Paint()
      ..color = const Color(0xFFD6B779)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 22
      ..strokeJoin = StrokeJoin.round;

    final j = Path()
      ..moveTo(65, 93)
      ..lineTo(228, 93)
      ..moveTo(163, 93)
      ..lineTo(163, 306)
      ..cubicTo(163, 349, 144, 370, 108, 370)
      ..cubicTo(76, 370, 58, 352, 55, 323);
    canvas.drawPath(j, stroke);
    final d = Path()
      ..moveTo(224, 93)
      ..lineTo(224, 362)
      ..moveTo(224, 93)
      ..lineTo(291, 93)
      ..cubicTo(385, 93, 436, 141, 436, 226)
      ..cubicTo(436, 311, 385, 362, 291, 362)
      ..lineTo(224, 362);
    canvas.drawPath(d, stroke);
    final rock = Path()
      ..moveTo(185, 401)
      ..cubicTo(215, 392, 235, 398, 253, 390)
      ..cubicTo(282, 382, 302, 395, 327, 390)
      ..cubicTo(349, 386, 367, 395, 388, 401)
      ..lineTo(373, 407)
      ..lineTo(360, 413)
      ..lineTo(351, 430)
      ..lineTo(333, 420)
      ..lineTo(315, 443)
      ..lineTo(295, 428)
      ..lineTo(274, 453)
      ..lineTo(255, 432)
      ..lineTo(238, 440)
      ..lineTo(225, 421)
      ..lineTo(201, 423)
      ..close();
    canvas.drawPath(rock, Paint()..color = const Color(0xFFD6B779));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
