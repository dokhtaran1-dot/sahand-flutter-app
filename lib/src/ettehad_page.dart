import 'dart:math' as math;

import 'package:flutter/material.dart';

/// The RE portal opens with the approved MNE seal, followed by the supplied
/// portfolio pages in their attachment order. All artwork is user-provided.
class EttehadPage extends StatefulWidget {
  const EttehadPage({super.key});

  @override
  State<EttehadPage> createState() => _EttehadPageState();
}

class _PortfolioSlide {
  const _PortfolioSlide({
    required this.asset,
    required this.fa,
    required this.description,
    this.concept = false,
    this.projectSpecs = false,
  });

  final String asset;
  final String fa;
  final String description;
  final bool concept;
  final bool projectSpecs;
}

class _EttehadPageState extends State<EttehadPage>
    with SingleTickerProviderStateMixin {
  static const _emerald = Color(0xFF041711);
  static const _gold = Color(0xFFE9C88A);
  static const _mutedGold = Color(0xFFAD9060);

  static const _slides = <_PortfolioSlide>[
    _PortfolioSlide(
      asset: 'assets/image/mne_02_overview.jpg',
      fa: 'نمای کلی مجموعه',
      description: 'مروری بر بخش‌های معرفی، خدمات تخصصی، پروژه‌ها و سوابق اجرایی این مجموعه.',
      concept: true,
    ),
    _PortfolioSlide(
      asset: 'assets/image/mne_03_home.jpg',
      fa: 'معرفی مسعود اتحاد‌نژاد',
      description: 'معرفی مسعود اتحادنژاد و نقش او در هماهنگی، مدیریت و اجرای امور ساختمانی.',
      concept: true,
    ),
    _PortfolioSlide(
      asset: 'assets/image/mne_04_services.jpg',
      fa: 'خدمات تخصصی',
      description: 'معرفی خدمات فنی، اجرایی و هماهنگی مراحل ساخت و توسعهٔ پروژه‌ها.',
      concept: true,
    ),
    _PortfolioSlide(
      asset: 'assets/image/mne_05_vision.jpg',
      fa: 'چشم‌انداز مدیریت و توسعه',
      description: 'نگاهی به رویکرد مدیریتی در توسعهٔ مجموعه، کیفیت اجرا و برنامه‌ریزی پروژه‌ها.',
      concept: true,
    ),
    _PortfolioSlide(
      asset: 'assets/image/mne_06_royal_mall.jpg',
      fa: 'پروژهٔ در حال ساخت رویال مال',
      description: 'معرفی پروژهٔ رویال مال و بخش‌های مرتبط با عملیات ساخت و توسعهٔ آن.',
      concept: true,
      projectSpecs: true,
    ),
    _PortfolioSlide(
      asset: 'assets/image/mne_07_royal_village.jpg',
      fa: 'رویال ویلاژ کافه',
      description: 'معرفی رویال ویلاژ کافه و بخشی از فعالیت‌های مرتبط با اجرای فضاهای مجموعه.',
      concept: true,
    ),
    _PortfolioSlide(
      asset: 'assets/image/mne_08_executive_profile.jpg',
      fa: 'پروفایل اجرایی و مدیریتی',
      description: 'مروری بر مسئولیت‌ها، حوزه‌های کاری و سوابق مدیریتی مسعود اتحادنژاد.',
      projectSpecs: true,
    ),
    _PortfolioSlide(
      asset: 'assets/image/mne_09_biography.jpg',
      fa: 'زندگی‌نامه و تخصص‌ها',
      description: 'معرفی زندگی‌نامهٔ حرفه‌ای، تخصص‌ها و تجربه‌های اجرایی.',
    ),
  ];

  late final AnimationController _floatController;
  late final PageController _pageController;
  bool _entered = false;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 13),
    )..repeat();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _floatController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _openPage(int index) {
    if (index < 0 || index >= _slides.length) return;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 560),
      curve: Curves.easeInOutCubic,
    );
  }

  void _returnToEntry() {
    if (_pageController.hasClients) _pageController.jumpToPage(0);
    setState(() {
      _currentPage = 0;
      _entered = false;
    });
  }

  void _showArtwork(BuildContext context, _PortfolioSlide slide) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withOpacity(.97),
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(6),
        child: Stack(
          children: [
            InteractiveViewer(
              minScale: .7,
              maxScale: 5,
              child: Center(
                child: Image.asset(
                  slide.asset,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: IconButton.filled(
                onPressed: () => Navigator.of(dialogContext).pop(),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF10261E),
                  foregroundColor: _gold,
                ),
                icon: const Icon(Icons.close_rounded),
                tooltip: 'بستن تصویر',
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _emerald,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 650),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: _entered
              ? _buildPortfolio(context)
              : _buildEntry(context),
        ),
      ),
    );
  }

  Widget _buildEntry(BuildContext context) {
    return Container(
      key: const ValueKey('mne_entry'),
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          radius: 1.3,
          center: Alignment(0, -.35),
          colors: [Color(0xFF123A2E), _emerald, Color(0xFF010403)],
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 18, 0),
            child: Row(
              children: [
                IconButton(
                  tooltip: 'بازگشت به رویال وان',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: _gold),
                ),
                const Expanded(
                  child: Text(
                    'اتحاد سازه رویال',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _mutedGold,
                      fontSize: 12,
                      letterSpacing: 1.7,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 42),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 9),
              child: AnimatedBuilder(
                animation: _floatController,
                child: Image.asset(
                  'assets/image/mne_01_entry.jpg',
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                  semanticLabel: 'مونوگرام طلایی مسعود اتحاد‌نژاد',
                ),
                builder: (context, child) => Transform.translate(
                  offset: Offset(
                    2 * math.cos(_floatController.value * math.pi * 2),
                    7 * math.sin(_floatController.value * math.pi * 2),
                  ),
                  child: child,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Text(
                  'مسعود اتحادنژاد',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _gold,
                    fontSize: 19,
                    letterSpacing: 2.1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'امور اجرایی ساختمان  •  مدیریت پروژه',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 34),
            child: SizedBox(
              width: double.infinity,
              height: 57,
              child: ElevatedButton(
                onPressed: () => setState(() => _entered = true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _gold,
                  foregroundColor: const Color(0xFF07140E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ورود به مجموعه',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: .8,
                      ),
                    ),
                    SizedBox(width: 15),
                    Icon(Icons.arrow_forward_rounded),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 17),
          const Text(
            'زیر نظر کنسرسیوم سهند',
            style: TextStyle(
              color: _mutedGold,
              fontSize: 10,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 14),
        ],
      ),
    );
  }

  Widget _buildPortfolio(BuildContext context) {
    final current = _slides[_currentPage];
    return Container(
      key: const ValueKey('mne_portfolio'),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF091C16), Color(0xFF010605)],
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 7, 12, 5),
            child: Row(
              children: [
                IconButton(
                  onPressed: _returnToEntry,
                  tooltip: 'بازگشت به صفحهٔ ورود',
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: _gold),
                ),
                const Expanded(
                  child: Column(
                    children: [
                      Text('مسعود اتحادنژاد',
                          style: TextStyle(
                            color: _gold,
                            fontSize: 24,
                            fontFamily: 'serif',
                            fontWeight: FontWeight.bold,
                          )),
                      Text('اتحاد سازه رویال',
                          style: TextStyle(
                            color: _mutedGold,
                            fontSize: 9,
                            letterSpacing: 1.6,
                          )),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _showPageMenu(context),
                  tooltip: 'فهرست صفحات',
                  icon: const Icon(Icons.grid_view_rounded, color: _gold),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 45,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _slides.length,
              separatorBuilder: (_, __) => const SizedBox(width: 7),
              itemBuilder: (context, index) {
                final selected = index == _currentPage;
                return ActionChip(
                  onPressed: () => _openPage(index),
                  backgroundColor: selected
                      ? const Color(0xFF634E2C)
                      : const Color(0xFF0A1914),
                  side: BorderSide(
                      color: selected ? _gold : _mutedGold.withOpacity(.45)),
                  label: Text(
                    _slides[index].fa,
                    style: TextStyle(
                      color: selected ? Colors.white : _gold,
                      fontSize: 12,
                      fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                );
              },
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _slides.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) => _PortfolioVisualPage(
                key: PageStorageKey('mne_slide_$index'),
                slide: _slides[index],
                overview: index == 0,
                onZoom: () => _showArtwork(context, _slides[index]),
                onOpenPage: _openPage,
                allSlides: _slides,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 7, 16, 8),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFF866D44))),
              color: Color(0xFF05130F),
            ),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: _currentPage == 0
                      ? null
                      : () => _openPage(_currentPage - 1),
                  icon: const Icon(Icons.chevron_left_rounded),
                  label: const Text('قبلی'),
                  style: TextButton.styleFrom(foregroundColor: _gold),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        current.fa,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: _gold,
                          fontSize: 10,
                          letterSpacing: .9,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_currentPage + 1} / ${_slides.length}',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: _currentPage == _slides.length - 1
                      ? null
                      : () => _openPage(_currentPage + 1),
                  style: TextButton.styleFrom(foregroundColor: _gold),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('بعدی'),
                      Icon(Icons.chevron_right_rounded),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPageMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF04140E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        side: BorderSide(color: _gold),
      ),
      builder: (sheetContext) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(sheetContext).height * .75,
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _slides.length,
            itemBuilder: (context, index) => ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF233B2F),
                child: Text('${index + 1}',
                    style: const TextStyle(color: _gold)),
              ),
              title: Text(_slides[index].fa,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(color: Colors.white)),
              subtitle: Text(_slides[index].description,
                  style: const TextStyle(color: _mutedGold)),
              trailing: const Icon(Icons.chevron_right_rounded, color: _gold),
              onTap: () {
                Navigator.of(sheetContext).pop();
                _openPage(index);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _PortfolioVisualPage extends StatelessWidget {
  const _PortfolioVisualPage({
    super.key,
    required this.slide,
    required this.overview,
    required this.onZoom,
    required this.onOpenPage,
    required this.allSlides,
  });

  final _PortfolioSlide slide;
  final bool overview;
  final VoidCallback onZoom;
  final void Function(int) onOpenPage;
  final List<_PortfolioSlide> allSlides;

  static const _gold = Color(0xFFE9C88A);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 26),
      child: Column(
        children: [
          Text(
            slide.fa,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _gold,
              fontSize: 16,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            slide.description,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 13),
          if (slide.projectSpecs) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
              decoration: BoxDecoration(
                color: const Color(0xFF0B2B20),
                border: Border.all(color: _gold.withOpacity(.8)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Text(
                    'مشخصات تأییدشدهٔ پروژه',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _gold, fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '۳۲۰۰ مترمربع  ·  ۲ طبقه  ·  در حال ساخت',
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'موقعیت: طبقهٔ سوم رویال مال (مجتمع ۴ طبقه)',
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 11.5),
                  ),

                ],
              ),
            ),
            const SizedBox(height: 9),
            const Text(
              'اعداد قدیمیِ داخل تصویر، بخشی از طرح اولیه‌اند؛ مشخصات معتبر در کادر بالا درج شده است.',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFFB5A88D), fontSize: 10),
            ),
            const SizedBox(height: 12),
          ],
          Semantics(
            button: true,
            label: 'بزرگ‌نمایی تصویر ${slide.fa}',
            child: GestureDetector(
              onTap: onZoom,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: _gold.withOpacity(.7), width: 1),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(color: Color(0x463A2F10), blurRadius: 16),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  slide.asset,
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: onZoom,
            icon: const Icon(Icons.zoom_in_rounded),
            label: const Text('بزرگ‌نمایی و مشاهدهٔ جزئیات'),
            style: TextButton.styleFrom(foregroundColor: _gold),
          ),
          if (slide.concept)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                'تصاویر مفهومی و ارائهٔ بصری؛ مشخصات پروژه و تصاویر اجرایی باید جداگانه تأیید شوند.',
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: Color(0xFFB5A88D),
                  fontSize: 10,
                  height: 1.7,
                ),
              ),
            ),
          if (overview) ...[
            const SizedBox(height: 17),
            const Text(
              'انتخاب بخش موردنظر',
              style: TextStyle(
                color: _gold,
                letterSpacing: 1.1,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 13),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var i = 1; i < allSlides.length; i++)
                  OutlinedButton(
                    onPressed: () => onOpenPage(i),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _gold,
                      side: BorderSide(color: _gold.withOpacity(.5)),
                    ),
                    child: Text(allSlides[i].fa),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
