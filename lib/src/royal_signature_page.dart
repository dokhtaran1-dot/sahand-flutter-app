import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const Color _rsCream = Color(0xFFF3EBDD);
const Color _rsGold = Color(0xFFDFC189);

/// RS is a self-contained Royal One section; no external mini-site is opened.
/// Concept designs are labeled as concepts, not finished artist inventory.
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
      'این ده طرح امضایی بر اساس سفارش قابل ساخت هستند؛ جزئیات اجرا و زمان‌بندی '
      'با هنرمند هماهنگ می‌شود.';

  void _openGalleryPhoto(BuildContext context, _GalleryItem item) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => _GalleryPhotoViewer(item: item)),
    );
  }

  Future<void> _openWhatsApp() async {
    final uri = Uri.https('wa.me', '/989141159263');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

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
            _BeyondGravityFeature(
              artwork: 'https://jafar-dargahi-art-royalone.dokhtaran1.chatgpt.site/jafar-dargahi-floating-island.jpg',
              onOpen: () => _openGalleryPhoto(
                context,
                const _GalleryItem(
                  'https://jafar-dargahi-art-royalone.dokhtaran1.chatgpt.site/jafar-dargahi-floating-island.jpg',
                  'جزیرهٔ معلق',
                  'Floating Island',
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                '01 / SELECTED INSTALLATION',
                style: TextStyle(
                  fontSize: 9,
                  color: _gold,
                  letterSpacing: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'جایی میان زمین و خیال',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: _cream,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'اثر شاخص استاد جعفر درگاهی در رویال مال تبریز؛ جزیره‌ای معلق با خانه‌ای کوچک، خزه، گیاه و بافت سنگ.',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: TextStyle(color: _muted, fontSize: 13, height: 1.9),
            ),
            const SizedBox(height: 24),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'THE ART COLLECTION · 04',
                  style: TextStyle(
                    fontSize: 8,
                    color: _gold,
                    letterSpacing: 1.3,
                  ),
                ),
                Text(
                  'آثار و جزئیات',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 19,
                    color: _cream,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 13),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _gallery.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 11,
                childAspectRatio: .78,
              ),
              itemBuilder: (context, index) => _GalleryTile(
                item: _gallery[index],
                onTap: () => _openGalleryPhoto(context, _gallery[index]),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.fromLTRB(17, 16, 17, 17),
              decoration: BoxDecoration(
                color: const Color(0xFF101A13),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0x557B694A)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'BEYOND GRAVITY',
                    style: TextStyle(
                      fontSize: 9,
                      color: _gold,
                      letterSpacing: 2.1,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'سنگ، طبیعت و خیال',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: _cream,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'از خانه‌ای کوچک با الهام از یک دهکده در اسلواکی تا صخره‌ای پوشیده از طبیعت؛ این اثر، تضاد میان سنگینی و شناوری را به تصویری شاعرانه تبدیل می‌کند.',
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: TextStyle(color: _muted, fontSize: 12, height: 1.9),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _openWhatsApp,
                icon: const Icon(Icons.chat_bubble_outline_rounded),
                label: const Text(
                  'استعلام قیمت و سفارش از واتساپ',
                  textDirection: TextDirection.rtl,
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: _gold,
                  foregroundColor: _black,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 21),
            Container(
              padding: const EdgeInsets.fromLTRB(19, 18, 19, 18),
              decoration: BoxDecoration(
                color: const Color(0xFF101A13),
                borderRadius: BorderRadius.circular(17),
                border: Border.all(color: const Color(0x557B694A)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'THE ARTIST',
                    style: TextStyle(
                      fontSize: 10,
                      color: _gold,
                      letterSpacing: 2.8,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'استاد جعفر درگاهی',
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: _cream,
                    ),
                  ),
                  SizedBox(height: 9),
                  Text(
                    'عضو تیم هنری کنسرسیوم سهند و مجری آثار هنری برای مجموعهٔ رویال مال تبریز. '
                    'در آثار او، طبیعت، فرم و خیال در جهانِ جزیره‌های معلق به هم می‌رسند.',
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.9,
                      color: _muted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 27),
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

/// Native Royal One artist-edition centerpiece. The screen is Flutter UI;
/// its documentary photo is loaded from the mini-site's public image assets.
class _BeyondGravityFeature extends StatelessWidget {
  final String artwork;
  final VoidCallback onOpen;

  const _BeyondGravityFeature({
    required this.artwork,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    const cream = Color(0xFFF3EBDD);
    const gold = Color(0xFFDFC189);
    return LayoutBuilder(
      builder: (context, constraints) {
        final large = constraints.maxWidth >= 640;
        return Material(
          color: const Color(0xFF08120C),
          borderRadius: BorderRadius.circular(22),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onOpen,
            child: Container(
              height: large ? 440 : 510,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xAA95764C), width: 1),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(artwork, fit: BoxFit.cover, filterQuality: FilterQuality.high, errorBuilder: (_, __, ___) => const ColoredBox(color: Color(0xFF111A14), child: Center(child: Icon(Icons.image_not_supported_outlined, color: Color(0xFFDFC189), size: 38)))),
                  const _FloatingIslandAtmosphere(),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0, .24, .57, 1],
                        colors: [
                          Color(0x9208140C),
                          Color(0x2308140C),
                          Color(0x8A07110A),
                          Color(0xF507100A),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: large ? 29 : 20,
                      vertical: 22,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.diamond_outlined, color: gold, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'R1  /  ARTIST EDITION',
                              style: TextStyle(
                                color: gold,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.7,
                              ),
                            ),
                            Spacer(),
                            Icon(Icons.auto_awesome_outlined, color: gold, size: 19),
                          ],
                        ),
                        const Spacer(),
                        const Text(
                          'BEYOND GRAVITY.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: cream,
                            fontFamily: 'serif',
                            fontSize: 30,
                            letterSpacing: 2.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'هنر، فراتر از جاذبه',
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: cream,
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'JAFAR DARGAHI',
                          style: TextStyle(
                            color: gold,
                            fontSize: 13,
                            letterSpacing: 2.4,
                          ),
                        ),
                        const SizedBox(height: 7),
                        const Text(
                          'FLOATING ISLAND · ROYAL MALL, TABRIZ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFE3D1B0),
                            fontSize: 8,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD3AF71),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'مشاهدهٔ جزیره',
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  color: Color(0xFF121711),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(width: 12),
                              Icon(Icons.arrow_forward_ios, color: Color(0xFF121711), size: 13),
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
        );
      },
    );
  }
}

class _FloatingIslandAtmosphere extends StatelessWidget {
  const _FloatingIslandAtmosphere();

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => IgnorePointer(
          child: Stack(
            children: [
              Positioned(
                left: constraints.maxWidth * .445,
                top: constraints.maxHeight * .465,
                width: 38,
                height: 46,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x55E8AC53),
                        blurRadius: 22,
                        spreadRadius: 7,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: constraints.maxWidth * .355,
                top: constraints.maxHeight * .59,
                width: 92,
                height: 102,
                child: const CustomPaint(painter: _SteamPainter()),
              ),
            ],
          ),
        ),
      );
}

class _SteamPainter extends CustomPainter {
  const _SteamPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x32F5F3E9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    final paths = [
      Path()
        ..moveTo(size.width * .35, size.height)
        ..cubicTo(size.width * .16, size.height * .70, size.width * .62, size.height * .44, size.width * .45, 0),
      Path()
        ..moveTo(size.width * .60, size.height * .94)
        ..cubicTo(size.width * .82, size.height * .65, size.width * .35, size.height * .35, size.width * .72, size.height * .05),
    ];
    for (final path in paths) {
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SteamPainter oldDelegate) => false;
}

class _GalleryItem {
  final String asset;
  final String titleFa;
  final String titleEn;

  const _GalleryItem(this.asset, this.titleFa, this.titleEn);
}

const List<_GalleryItem> _gallery = [
  _GalleryItem('https://jafar-dargahi-art-royalone.dokhtaran1.chatgpt.site/gallery-room-luxury.png', 'نمای کامل چیدمان', 'The Installation in Space'),
  _GalleryItem('https://jafar-dargahi-art-royalone.dokhtaran1.chatgpt.site/gallery-cottage-luxury.png', 'دهکدهٔ خزه‌پوش', 'Moss-Covered Cottage'),
  _GalleryItem('https://jafar-dargahi-art-royalone.dokhtaran1.chatgpt.site/classical-bust-gallery.png', 'تندیس کلاسیک', 'Classical Bust'),
  _GalleryItem('https://jafar-dargahi-art-royalone.dokhtaran1.chatgpt.site/gallery-forest-luxury.png', 'جزیرهٔ درختی معلق', 'Floating Woodland'),
];

class _GalleryTile extends StatelessWidget {
  final _GalleryItem item;
  final VoidCallback onTap;

  const _GalleryTile({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) => Material(
        color: const Color(0xFF111A14),
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(item.asset, fit: BoxFit.cover, filterQuality: FilterQuality.high, errorBuilder: (_, __, ___) => const ColoredBox(color: Color(0xFF111A14), child: Center(child: Icon(Icons.image_not_supported_outlined, color: _rsGold, size: 30)))),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xE8050906)],
                    stops: [.43, 1],
                  ),
                ),
              ),
              Positioned(
                right: 11,
                left: 9,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      item.titleFa,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: _rsCream, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.titleEn,
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: _rsGold, fontSize: 9, fontFamily: 'serif'),
                    ),
                  ],
                ),
              ),
              const Positioned(
                top: 10,
                left: 10,
                child: Icon(Icons.zoom_in_rounded, color: _rsCream, size: 20),
              ),
            ],
          ),
        ),
      );
}

class _GalleryPhotoViewer extends StatelessWidget {
  final _GalleryItem item;

  const _GalleryPhotoViewer({required this.item});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFF050906),
        appBar: AppBar(
          backgroundColor: const Color(0xFF050906),
          foregroundColor: _rsGold,
          centerTitle: true,
          title: Text(item.titleFa, style: const TextStyle(fontSize: 15)),
        ),
        body: SafeArea(
          child: InteractiveViewer(
            minScale: 1,
            maxScale: 5,
            child: Center(
              child: Image.network(item.asset, fit: BoxFit.contain, filterQuality: FilterQuality.high, errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported_outlined, color: _rsGold, size: 48)),
            ),
          ),
        ),
      );
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
