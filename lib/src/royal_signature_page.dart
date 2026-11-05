import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// First RS screen: a full-viewport entrance. The collection is a separate
/// scrollable screen so the Fold cover and inner displays can size naturally.
class RoyalSignaturePage extends StatelessWidget {
  const RoyalSignaturePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFF080D09),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/image/jd_signature/jd-concept-01.webp',
              fit: BoxFit.cover,
              alignment: Alignment.center,
              filterQuality: FilterQuality.high,
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0, .34, .72, 1],
                  colors: [
                    Color(0xD506120B),
                    Color(0x9F07120C),
                    Color(0xCC07120C),
                    Color(0xFF070D09),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final narrow = constraints.maxWidth < 450;
                  final compactHeight = constraints.maxHeight < 620;
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: narrow ? 22 : 48,
                          vertical: compactHeight ? 16 : 26,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  tooltip: 'بازگشت',
                                  onPressed: () => Navigator.of(context).pop(),
                                  icon: const Icon(Icons.arrow_back_ios_new,
                                      color: Color(0xFFDFC189)),
                                ),
                                const Spacer(),
                                const Text(
                                  'RS  /  ROYAL SIGNATURE',
                                  style: TextStyle(
                                    color: Color(0xFFDFC189),
                                    letterSpacing: 1.6,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: compactHeight ? 28 : 70,
                              ),
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 600),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: narrow ? 90 : 118,
                                      height: narrow ? 90 : 118,
                                      child: const _JDMonogram(),
                                    ),
                                    const SizedBox(height: 23),
                                    Text(
                                      'JAFAR DARGAHI',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: const Color(0xFFF3EBDD),
                                        fontFamily: 'serif',
                                        fontSize: narrow ? 27 : 40,
                                        letterSpacing: narrow ? 2.1 : 3.7,
                                      ),
                                    ),
                                    const SizedBox(height: 13),
                                    Text(
                                      'BEYOND GRAVITY',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: const Color(0xFFDFC189),
                                        fontSize: narrow ? 12 : 16,
                                        letterSpacing: narrow ? 2 : 3,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Text(
                                      'هنر، فراتر از جاذبه',
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: const Color(0xFFF3EBDD),
                                        fontSize: narrow ? 20 : 28,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'از مجموعه آثار و ایده‌های هنری تیم کنسرسیوم سهند',
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFFD4D7CC),
                                        fontSize: 13,
                                        height: 1.8,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 490),
                              child: SizedBox(
                                width: double.infinity,
                                child: FilledButton.icon(
                                  onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) =>
                                          const _RoyalSignatureCollectionPage(),
                                    ),
                                  ),
                                  icon: const Icon(Icons.arrow_forward_ios, size: 16),
                                  label: const Text('ورود به مجموعه آثار'),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: const Color(0xFFDFC189),
                                    foregroundColor: const Color(0xFF080D09),
                                    padding: const EdgeInsets.symmetric(vertical: 17),
                                    textStyle: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
}

/// RS artist edition: original proposed designs, not fabricated inventory.
class _RoyalSignatureCollectionPage extends StatelessWidget {
  const _RoyalSignatureCollectionPage();

  static const Color _black = Color(0xFF090D0A);
  static const Color _emerald = Color(0xFF163426);
  static const Color _gold = Color(0xFFDFC189);
  static const Color _cream = Color(0xFFF3EBDD);
  static const Color _muted = Color(0xFFA8B5A8);
  static const String _priceInquiryWhatsApp = '989141159263';

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

  static Future<void> _openPriceInquiry(
    BuildContext context, {
    _ArtConcept? concept,
  }) async {
    final reference = concept == null
        ? 'مجموعه آثار هنری جعفر درگاهی در Royal Signature'
        : 'طرح «${concept.titleFa}» (${concept.titleEn})، کد '
            'JD-${concept.number.toString().padLeft(2, '0')}';
    final link = Uri.https('wa.me', '/$_priceInquiryWhatsApp', {
      'text': 'سلام، برای استعلام قیمت و شرایط سفارش $reference پیام می‌دهم.',
    });

    try {
      if (await launchUrl(link, mode: LaunchMode.externalApplication)) return;
    } catch (_) {
      // A customer may not have an app available to open the WhatsApp link.
    }
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('واتساپ باز نشد؛ لطفاً نصب یا اتصال اینترنت را بررسی کنید.'),
      ),
    );
  }

  void _openArtwork(BuildContext context, _ArtConcept concept) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _ArtworkViewer(
          concept: concept,
          gold: _gold,
          cream: _cream,
          note: _note,
          onPriceInquiry: (viewerContext) =>
              _openPriceInquiry(viewerContext, concept: concept),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 1000 ? 4 : (width >= 620 ? 3 : 2);
    final tileAspectRatio = width < 390 ? .64 : .72;
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
              artwork: _concepts.first.asset,
              onOpen: () => _openArtwork(context, _concepts.first),
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
                    'مجسمه‌سازی، چیدمان هنری و جهانِ جزیره‌های معلق؛ '
                    'عضو تیم هنری کنسرسیوم سهند و مجری آثار هنری در رویال مال تبریز؛ '
                    'پیوند طبیعت، فرم و خیال در آثاری که جاذبه را به چالش می‌کشند.',
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
                childAspectRatio: tileAspectRatio,
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
                                  fit: BoxFit.contain,
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
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: () => _openPriceInquiry(context),
              icon: const Icon(Icons.chat_outlined, size: 19),
              label: const Text(
                'استعلام قیمت فقط از طریق واتساپ',
                textDirection: TextDirection.rtl,
              ),
              style: FilledButton.styleFrom(
                backgroundColor: _gold,
                foregroundColor: _black,
                padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 12),
                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Native Royal One artist-edition centerpiece. This is a Flutter widget,
/// not an embedded website or WebView. The hero image is a concept visual,
/// while the artist's real documentary photograph is not bundled in this app.
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
                  Image.asset(
                    artwork,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0, 0.3, 0.66, 1],
                        colors: [
                          Color(0xD008140C),
                          Color(0x7108140C),
                          Color(0xBB07110A),
                          Color(0xFF07100A),
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
                          'JD',
                          style: TextStyle(
                            color: Color(0xC6D7B77B),
                            fontFamily: 'serif',
                            fontSize: 68,
                            fontWeight: FontWeight.w300,
                            height: 0.9,
                            letterSpacing: -5,
                          ),
                        ),
                        const SizedBox(height: 14),
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
                        const SizedBox(height: 11),
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
                        const SizedBox(height: 17),
                        const Text(
                          'SCULPTURE  ·  SUSPENSION  ·  NATURE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFE3D1B0),
                            fontSize: 9,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD3AF71),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'مشاهده مجموعه',
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  color: Color(0xFF121711),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(width: 12),
                              Icon(Icons.arrow_forward_ios,
                                  color: Color(0xFF121711), size: 13),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'CONCEPT VISUAL  /  JD SIGNATURE COLLECTION',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFC0C8BB),
                            fontSize: 8,
                            letterSpacing: 1.1,
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
  final Future<void> Function(BuildContext) onPriceInquiry;

  const _ArtworkViewer({
    required this.concept,
    required this.gold,
    required this.cream,
    required this.note,
    required this.onPriceInquiry,
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final shortScreen = constraints.maxHeight < 600;
              final narrow = constraints.maxWidth < 400;
              final artwork = InteractiveViewer(
                minScale: 1,
                maxScale: 5,
                child: SizedBox.expand(
                  child: Image.asset(
                    concept.asset,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              );
              final details = Align(
                alignment: Alignment.center,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 680),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      narrow ? 16 : 28,
                      12,
                      narrow ? 16 : 28,
                      20,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          concept.titleFa,
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: cream,
                            fontSize: narrow ? 17 : 21,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          concept.titleEn,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'serif',
                            color: gold,
                            fontSize: narrow ? 14 : 18,
                          ),
                        ),
                        const SizedBox(height: 13),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () => onPriceInquiry(context),
                            icon: const Icon(Icons.chat_outlined, size: 19),
                            label: const Text('استعلام قیمت در واتساپ'),
                            style: FilledButton.styleFrom(
                              backgroundColor: gold,
                              foregroundColor: const Color(0xFF090D0A),
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              textStyle: const TextStyle(fontWeight: FontWeight.w700),
                            ),
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
                ),
              );

              // Short landscape windows scroll instead of overflowing the
              // artwork footer; taller windows keep the full image in view.
              if (shortScreen) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: constraints.maxHeight * .72,
                        child: artwork,
                      ),
                      details,
                    ],
                  ),
                );
              }
              return Column(
                children: [Expanded(child: artwork), details],
              );
            },
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
