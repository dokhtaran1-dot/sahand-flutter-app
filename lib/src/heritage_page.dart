import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'royal_mall_page.dart';
import 'royal_village_page.dart';

const _green = Color(0xFF041A13);
const _gold = Color(0xFFE4C17B);
const _cream = Color(0xFFF4ECD8);

/// Royal Heritage is the approved original FULL poster, not a new composition.
/// Everything visible in the poster is preserved; native Flutter hit targets
/// sit precisely over the 4 languages, 10 branches, founder, president,
/// central SC sphere, menu and 5 bottom actions.
class HeritagePage extends StatefulWidget {
  const HeritagePage({super.key});

  @override
  State<HeritagePage> createState() => _HeritagePageState();
}

class _HeritageBranch {
  const _HeritageBranch(this.id, this.name, this.fa, this.en,
      this.ar, this.fr, this.x, this.y, this.width, this.height);
  final String id, name, fa, en, ar, fr;
  final double x, y, width, height;
}

class _HeritagePageState extends State<HeritagePage> {
  static const double _artWidth = 941;
  static const double _artHeight = 1672;
  static const String _art =
      'assets/heritage/royal_heritage_approved_poster.png';

  String _language = 'FA';

  static const List<_HeritageBranch> _branches = [
    _HeritageBranch('rm', 'Royal Mall Tabriz',
        'رویال مال تبریز', 'Royal Mall Tabriz',
        'رويال مول تبريز', 'Royal Mall Tabriz',
        143, 555, 143, 147),
    _HeritageBranch('rv', 'RV Royal Village Café',
        'رویال ویلاژ کافه', 'Royal Village Café',
        'رويال فيلاج كافيه', 'Le Royal Village Café',
        43, 677, 157, 145),
    _HeritageBranch('uae', 'UAE Construction & Development',
        'ساخت‌وساز و توسعه امارات', 'UAE Construction & Development',
        'البناء والتطوير في الإمارات', 'Construction et développement EAU',
        37, 833, 167, 147),
    _HeritageBranch('shirin', 'Shirin Sahand Azerbaijan',
        'شیرین سهند آذربایجان', 'Shirin Sahand Azerbaijan',
        'شيرين سهند أذربيجان', 'Shirin Sahand Azerbaïdjan',
        133, 950, 175, 160),
    _HeritageBranch('agriculture', 'Agriculture Stone Fruits',
        'کشاورزی و میوه‌های هسته‌دار', 'Agriculture · Stone Fruits',
        'الزراعة والفواكه ذات النواة', 'Agriculture · fruits à noyau',
        296, 1003, 165, 164),
    _HeritageBranch('iberchem', 'Iberchem Representation',
        'نمایندگی ایبرکم', 'Iberchem Representation',
        'وكالة إيبيركيم', 'Représentation Iberchem',
        468, 1001, 169, 169),
    _HeritageBranch('lova', 'Lova Coffee',
        'قهوه لوا', 'Lova Coffee',
        'قهوة لوفا', 'Café Lova',
        637, 953, 160, 155),
    _HeritageBranch('export', 'Export & Import Signature Product',
        'صادرات و واردات محصولات ویژه', 'Export & Import Signature Product',
        'الاستيراد والتصدير للمنتجات المميزة',
        'Import-export · produits Signature',
        733, 825, 160, 165),
    _HeritageBranch('media', 'Media Advertising Studio HQ',
        'رسانه، تبلیغات و استودیو', 'Media Advertising Studio HQ',
        'الإعلام والإعلان والاستوديو',
        'Média, publicité et studio',
        730, 676, 165, 150),
    _HeritageBranch('project', '1800 m² Project · Floor 3',
        'پروژه ۱۸۰۰ مترمربعی، طبقه سوم',
        '1800 m² Project · Floor 3',
        'مشروع ١٨٠٠ م² · الطابق الثالث',
        'Projet 1 800 m² · troisième étage',
        632, 552, 156, 149),
  ];

  String _tr(String fa, String en, String ar, String fr) {
    switch (_language) {
      case 'EN': return en;
      case 'AR': return ar;
      case 'FR': return fr;
      default: return fa;
    }
  }

  String _name(_HeritageBranch branch) {
    switch (_language) {
      case 'EN': return branch.en;
      case 'AR': return branch.ar;
      case 'FR': return branch.fr;
      default: return branch.fa;
    }
  }

  void _open(Widget page) => Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page));

  Future<void> _external(String url) async {
    final uri = Uri.parse(url);
    try {
      final success = await launchUrl(uri,
          mode: LaunchMode.externalApplication);
      if (success) return;
    } catch (_) {
      // A native error sheet remains available when Android has no handler.
    }
    if (!mounted) return;
    _notice(_tr('باز کردن نشانی ممکن نشد', 'Could not open this link',
        'تعذر فتح الرابط', 'Impossible d’ouvrir ce lien'), url);
  }

  void _notice(String title, String description) {
    showModalBottomSheet<void>(
      context: context, backgroundColor: _green,
      showDragHandle: true, isScrollControlled: true,
      builder: (sheet) => SafeArea(child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 12, 25, 32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(title, textAlign: TextAlign.center,
              style: const TextStyle(color: _gold, fontSize: 21)),
          const SizedBox(height: 12),
          Text(description, textAlign: TextAlign.center,
              style: const TextStyle(color: _cream, height: 1.7)),
          const SizedBox(height: 15),
          TextButton(onPressed: () => Navigator.pop(sheet),
              child: Text(_tr('بستن', 'Close', 'إغلاق', 'Fermer'))),
        ]),
      )),
    );
  }

  void _selectLanguage(String code) {
    setState(() => _language = code);
    final message = switch (code) {
      'EN' => 'Royal Heritage · From Father to Son',
      'AR' => 'التراث الملكي · من الأب إلى الابن',
      'FR' => 'Héritage Royal · Du père au fils',
      _ => 'میراث سهند · از پدر به پسر'
    };
    _notice(code + '  ·  ' + message,
      _tr('زبان صفحه‌های تعاملی و معرفی شاخه‌ها تنظیم شد.',
          'Interactive details and navigation now use this language.',
          'تم اختيار اللغة للتفاصيل والقوائم التفاعلية.',
          'Cette langue est active pour les fiches et les menus interactifs.'));
  }

  void _branch(_HeritageBranch branch) {
    if (branch.id == 'rm') {
      _open(const RoyalMallPage());
      return;
    }
    if (branch.id == 'rv') {
      _open(const RoyalVillagePage());
      return;
    }
    if (branch.id == 'media') {
      _media();
      return;
    }
    final descriptions = <String, String>{
      'uae': 'UAE Construction & Development · Sahand Consortium',
      'shirin': 'Shirin Sahand Azerbaijan · Food manufacturing',
      'agriculture': 'Agriculture · Stone fruits',
      'iberchem': 'Iberchem · Representation',
      'lova': 'Lova Coffee · Coffee branches',
      'export': 'Export & Import · Signature Product',
      'project': 'Royal Mall Tabriz · Third-floor 1800 m² project',
    };
    _open(_HeritageInfoPage(
      title: _name(branch),
      subtitle: descriptions[branch.id] ?? branch.name,
      language: _language,
      actionText: branch.id == 'project'
        ? _tr('مشاهده رویال مال', 'Open Royal Mall',
            'عرض رويال مول', 'Voir Royal Mall')
        : _tr('وب‌سایت رسمی کنسرسیوم', 'Official consortium website',
            'الموقع الرسمي', 'Site officiel'),
      onAction: () {
        if (branch.id == 'project') {
          _open(const RoyalMallPage());
        } else {
          _external('https://sahand-consortium.com/');
        }
      },
    ));
  }

  void _founder() => _open(_HeritageProfilePage(
    title: _tr('بنیان‌گذار سهند', 'Founder of Sahand',
      'مؤسس سهند', 'Fondateur de Sahand'),
    name: 'صفر قنبری درویش',
    role: 'FOUNDER  ·  SINCE 1351',
    photo: 'assets/heritage/founder_original.jpg',
    description: _tr(
      'آغاز کارخانه سهند در خیابان مولوی تهران در سال ۱۳۵۱؛ میراثی از پدر برای نسل‌های بعد.',
      'Founded Sahand in 1351 in Tehran’s Molavi district, creating the legacy carried by the next generations.',
      'تأسست سهند سنة ١٣٥١ في حي مولوي بطهران، وامتد إرثها إلى الأجيال التالية.',
      'Création de Sahand en 1351 dans le quartier Molavi de Téhéran, à l’origine d’un héritage familial.',
    ),
  ));

  void _president() => _open(_HeritageProfilePage(
    title: _tr('رئیس کنسرسیوم', 'President',
       'رئيس الكونسورتيوم', 'Président'),
    name: 'حامد قنبری درویش',
    role: 'PRESIDENT  ·  THIRD HEIR OF SAHAND',
    photo: 'assets/images/1.png',
    description: _tr(
      'سومین وارث سهند و ادامه‌دهنده میراث پدر؛ رئیس کنسرسیوم سهند. MBA از UOWD دبی و DALF C2 فرانسه.',
      'Third heir of Sahand and President of Sahand Consortium, carrying forward his father’s legacy. MBA, UOWD Dubai; DALF C2.',
      'الوريث الثالث لسهند ورئيس كونسورتيوم سهند، يواصل إرث والده.',
      'Troisième héritier de Sahand et président du Consortium Sahand, poursuivant l’héritage de son père. MBA, UOWD Dubai ; DALF C2.',
    ),
  ));

  void _history() => _open(_HeritageHistoryPage(language: _language));

  void _branchesPage() => _open(_HeritageBranchListPage(
    branches: _branches,
    language: _language,
    onSelected: _branch,
  ));

  void _media() => _open(const _HeritageMediaPage());

  void _contact() => _open(_HeritageContactPage(
    onOpenWebsite: () => _external('https://sahand-consortium.com/'),
    onOpenInstagram: () => _external('https://www.instagram.com/the_royalmall/'),
    language: _language,
  ));

  void _menu() {
    final actions = [
      (Icons.person_outline, 'President', _president),
      (Icons.auto_stories_outlined, 'Our Heritage', _history),
      (Icons.hub_outlined, 'Branches', _branchesPage),
      (Icons.play_circle_outline, 'Media', _media),
      (Icons.call_outlined, 'Contact Us', _contact),
    ];
    showModalBottomSheet<void>(
      context: context, backgroundColor: _green,
      isScrollControlled: true, showDragHandle: true,
      builder: (sheet) => SafeArea(child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('SAHAND CONSORTIUM',
              style: TextStyle(color: _gold, letterSpacing: 2,
                  fontSize: 17)),
          const SizedBox(height: 9),
          ...actions.map((action) => ListTile(
            leading: Icon(action.$1, color: _gold),
            title: Text(action.$2, style: const TextStyle(color: _cream)),
            trailing: const Icon(Icons.chevron_right, color: _gold),
            onTap: () {
              Navigator.pop(sheet);
              action.$3();
            },
          )),
          ListTile(
            leading: const Icon(Icons.language, color: _gold),
            title: Text(_tr('زبان / Language', 'Language',
                'اللغة', 'Langue'),
                style: const TextStyle(color: _cream)),
            onTap: () {
              Navigator.pop(sheet);
              _languageMenu();
            },
          ),
        ]),
      )),
    );
  }

  void _languageMenu() {
    showModalBottomSheet<void>(
      context: context, backgroundColor: _green, showDragHandle: true,
      builder: (sheet) => SafeArea(child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final code in const ['FA', 'EN', 'AR', 'FR'])
            ListTile(
              leading: Icon(_language == code
                  ? Icons.check_circle : Icons.language, color: _gold),
              title: Text(code,
                  style: const TextStyle(color: _cream)),
              onTap: () {
                Navigator.pop(sheet);
                _selectLanguage(code);
              },
            ),
        ],
      )),
    );
  }

  Widget _hit({
    required double left, required double top,
    required double width, required double height,
    required String label, required VoidCallback onTap,
    bool round = false,
  }) => Positioned(
    left: left, top: top, width: width, height: height,
    child: Semantics(
      button: true, label: label,
      child: Tooltip(
        message: label,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            customBorder: round
              ? const CircleBorder()
              : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            splashColor: const Color(0x55E4C17B),
            highlightColor: const Color(0x33E4C17B),
            onTap: onTap,
            child: const SizedBox.expand(),
          ),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF00150E),
    body: AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          final width = math.min(constraints.maxWidth, 680.0);
          final height = width * _artHeight / _artWidth;
          return SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: width, height: height,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: SizedBox(
                    width: _artWidth, height: _artHeight,
                    child: Stack(children: [
                      const Positioned.fill(child: Image(
                        image: AssetImage(_art), fit: BoxFit.fill,
                        filterQuality: FilterQuality.high,
                        excludeFromSemantics: true,
                      )),
                      // Actual portrait touch areas, not an unrelated card UI.
                      _hit(left: 18, top: 135, width: 288, height: 402,
                        label: 'Sofr Ghanbari · Founder',
                        onTap: _founder),
                      _hit(left: 623, top: 135, width: 298, height: 402,
                        label: 'Hamed Ghanbari · President',
                        onTap: _president),
                      _hit(left: 325, top: 60, width: 291, height: 231,
                        label: 'Sahand Consortium · Since 1351',
                        onTap: _history),
                      // The ten bubbles match the ten labels drawn on poster.
                      for (final branch in _branches)
                        _hit(left: branch.x, top: branch.y,
                          width: branch.width, height: branch.height,
                          round: true, label: branch.name,
                          onTap: () => _branch(branch)),
                      // The central SC sphere is its own functional action.
                      _hit(left: 310, top: 690, width: 315, height: 310,
                        round: true, label: 'SC · Our Heritage',
                        onTap: _history),
                      _hit(left: 170, top: 1252, width: 594, height: 216,
                        label: 'Royal Heritage · From Father to Son',
                        onTap: _history),
                      // Four functional language controls.
                      _hit(left: 22, top: 11, width: 51, height: 49,
                        label: 'فارسی FA',
                        onTap: () => _selectLanguage('FA')),
                      _hit(left: 76, top: 11, width: 49, height: 49,
                        label: 'English EN',
                        onTap: () => _selectLanguage('EN')),
                      _hit(left: 128, top: 11, width: 50, height: 49,
                        label: 'العربية AR',
                        onTap: () => _selectLanguage('AR')),
                      _hit(left: 179, top: 11, width: 52, height: 49,
                        label: 'Français FR',
                        onTap: () => _selectLanguage('FR')),
                      _hit(left: 851, top: 6, width: 69, height: 66,
                        label: 'Main menu', onTap: _menu),
                      // Five bottom tabs: real Flutter navigation actions.
                      _hit(left: 11, top: 1490, width: 186, height: 142,
                        label: 'President', onTap: _president),
                      _hit(left: 198, top: 1490, width: 180, height: 142,
                        label: 'Our Heritage', onTap: _history),
                      _hit(left: 380, top: 1490, width: 180, height: 142,
                        label: 'Branches', onTap: _branchesPage),
                      _hit(left: 564, top: 1490, width: 171, height: 142,
                        label: 'Media', onTap: _media),
                      _hit(left: 735, top: 1490, width: 195, height: 142,
                        label: 'Contact Us', onTap: _contact),
                    ]),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    ),
  );
}

class _HeritageInfoPage extends StatelessWidget {
  const _HeritageInfoPage({
    required this.title, required this.subtitle,
    required this.language, required this.actionText, required this.onAction,
  });
  final String title, subtitle, language, actionText;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) => _HeritageScreen(
    title: title,
    children: [
      const Icon(Icons.public, color: _gold, size: 60),
      const SizedBox(height: 25),
      Text(title, textAlign: TextAlign.center,
        style: const TextStyle(color: _cream, fontSize: 25)),
      const SizedBox(height: 15),
      Text(subtitle, textAlign: TextAlign.center,
        style: const TextStyle(color: _gold, height: 1.6)),
      const SizedBox(height: 35),
      FilledButton.icon(
        onPressed: onAction,
        icon: const Icon(Icons.open_in_new),
        label: Text(actionText),
        style: FilledButton.styleFrom(
          backgroundColor: _gold, foregroundColor: _green),
      ),
    ],
  );
}

class _HeritageProfilePage extends StatelessWidget {
  const _HeritageProfilePage({
    required this.title, required this.name, required this.role,
    required this.photo, required this.description,
  });
  final String title, name, role, photo, description;

  @override
  Widget build(BuildContext context) => _HeritageScreen(
    title: title,
    children: [
      Center(child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          photo, height: 310, width: 290,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          errorBuilder: (_, __, ___) => const SizedBox(
            height: 170,
            child: Icon(Icons.person_outline,
              color: _gold, size: 60),
          ),
        ),
      )),
      const SizedBox(height: 23),
      Text(name, textAlign: TextAlign.center,
        style: const TextStyle(color: _cream,
          fontSize: 26, fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      Text(role, textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
        style: const TextStyle(color: _gold, letterSpacing: 1.5)),
      const SizedBox(height: 20),
      Text(description, textAlign: TextAlign.center,
        style: const TextStyle(color: _cream, height: 1.9)),
    ],
  );
}

class _HeritageHistoryPage extends StatelessWidget {
  const _HeritageHistoryPage({required this.language});
  final String language;

  @override
  Widget build(BuildContext context) => _HeritageScreen(
    title: 'ROYAL HERITAGE',
    children: [
      const Text('FROM FATHER TO SON',
        textAlign: TextAlign.center,
        style: TextStyle(letterSpacing: 2.3, color: _gold)),
      const SizedBox(height: 23),
      const Text('از پدر به پسر',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 29, color: _cream)),
      const SizedBox(height: 15),
      const Text(
        'سهند از کارخانه‌ای در خیابان مولوی تهران در سال ۱۳۵۱ آغاز شد. '
        'بنیان‌گذار، صفر قنبری درویش، این نام را بنا نهاد. '
        'حامد قنبری درویش، سومین وارث، آن را در قالب کنسرسیوم سهند ادامه داد.',
        textDirection: TextDirection.rtl, textAlign: TextAlign.center,
        style: TextStyle(color: _cream, height: 2, fontSize: 16),
      ),
      const SizedBox(height: 25),
      ClipRRect(borderRadius: BorderRadius.circular(15),
        child: Image.asset('assets/heritage/founder_original.jpg',
          height: 260, fit: BoxFit.contain)),
      const SizedBox(height: 22),
      FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: _gold, foregroundColor: _green),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const PhilosophyBookPage())),
        icon: const Icon(Icons.auto_stories),
        label: const Text('فلسفه مدیریت مرگ · کتاب کامل ۹ فصل'),
      ),
    ],
  );
}

class _HeritageBranchListPage extends StatelessWidget {
  const _HeritageBranchListPage({
    required this.branches, required this.language, required this.onSelected,
  });
  final List<_HeritageBranch> branches;
  final String language;
  final ValueChanged<_HeritageBranch> onSelected;
  String _label(_HeritageBranch b) => switch (language) {
    'EN' => b.en, 'AR' => b.ar, 'FR' => b.fr, _ => b.fa,
  };

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _green,
    appBar: AppBar(
      backgroundColor: _green, foregroundColor: _gold,
      title: const Text('SAHAND · BRANCHES')),
    body: SafeArea(child: ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: branches.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) => Material(
        color: const Color(0xFF113323),
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFF254C36),
            child: Text((i + 1).toString(),
              style: const TextStyle(color: _gold))),
          title: Text(_label(branches[i]),
            style: const TextStyle(color: _cream)),
          trailing: const Icon(Icons.chevron_right, color: _gold),
          onTap: () => onSelected(branches[i]),
        ),
      ),
    )),
  );
}

class _HeritageMediaPage extends StatelessWidget {
  const _HeritageMediaPage();
  static const _photos = [
    ('Royal Mall', 'assets/image/Grand_Salon_Original.png'),
    ('Royal One', 'assets/image/ROYAL_ONE_Home_RC_Ultra_Final.png'),
    ('Royal Club', 'assets/image/RC_Games_Luxury.png'),
  ];
  @override
  Widget build(BuildContext context) => _HeritageScreen(
    title: 'SAHAND · MEDIA',
    children: [
      for (final photo in _photos) ...[
        Card(
          color: const Color(0xFF0B261D),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute<void>(
              builder: (_) => Scaffold(
                backgroundColor: Colors.black,
                appBar: AppBar(
                  backgroundColor: Colors.black,
                  foregroundColor: _gold,
                  title: Text(photo.$1)),
                body: InteractiveViewer(minScale: 1, maxScale: 5,
                  child: Center(child: Image.asset(photo.$2,
                      fit: BoxFit.contain))),
              ))),
            child: Column(children: [
              AspectRatio(
                aspectRatio: 1.65,
                child: Image.asset(photo.$2, fit: BoxFit.cover,
                  filterQuality: FilterQuality.high)),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(photo.$1,
                  style: const TextStyle(color: _gold, fontSize: 16))),
            ]),
          ),
        ),
        const SizedBox(height: 12),
      ],
    ],
  );
}

class _HeritageContactPage extends StatelessWidget {
  const _HeritageContactPage({
    required this.language,
    required this.onOpenWebsite,
    required this.onOpenInstagram,
  });
  final String language;
  final VoidCallback onOpenWebsite, onOpenInstagram;
  @override
  Widget build(BuildContext context) => _HeritageScreen(
    title: 'SAHAND · CONTACT US',
    children: [
      const Text('SAHAND CONSORTIUM',
        textAlign: TextAlign.center,
        style: TextStyle(color: _gold, fontSize: 22,
          letterSpacing: 2)),
      const SizedBox(height: 23),
      ListTile(
        leading: const Icon(Icons.language, color: _gold),
        title: const Text('sahand-consortium.com',
          style: TextStyle(color: _cream)),
        onTap: onOpenWebsite,
        trailing: const Icon(Icons.open_in_new, color: _gold),
      ),
      ListTile(
        leading: const Icon(Icons.photo_camera_outlined, color: _gold),
        title: const Text('Instagram · The Royal Mall',
          style: TextStyle(color: _cream)),
        onTap: onOpenInstagram,
        trailing: const Icon(Icons.open_in_new, color: _gold),
      ),
      ListTile(
        leading: const Icon(Icons.copy, color: _gold),
        title: const Text('Copy official website',
          style: TextStyle(color: _cream)),
        onTap: () {
          Clipboard.setData(
              const ClipboardData(text: 'https://sahand-consortium.com/'));
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Website copied · لینک سایت کپی شد'),
          ));
        },
      ),
    ],
  );
}

class _HeritageScreen extends StatelessWidget {
  const _HeritageScreen({
    required this.title, required this.children,
  });
  final String title;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _green,
    appBar: AppBar(
      backgroundColor: _green, foregroundColor: _gold,
      centerTitle: true,
      title: Text(title, style:
        const TextStyle(fontSize: 15, letterSpacing: 1.1)),
    ),
    body: SafeArea(child: Center(child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 660),
      child: ListView(
        padding: const EdgeInsets.all(23),
        children: children,
      ),
    ))),
  );
}

/// The approved 9-chapter book is the only embedded HTML in this flow.
/// The Heritage poster and its interactive controls are entirely native.
class PhilosophyBookPage extends StatefulWidget {
  const PhilosophyBookPage({super.key});
  @override
  State<PhilosophyBookPage> createState() => _PhilosophyBookPageState();
}

class _PhilosophyBookPageState extends State<PhilosophyBookPage> {
  late final WebViewController _controller;
  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF071E1B))
      ..loadFlutterAsset('assets/heritage/philosophy_book.html');
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF071E1B),
    appBar: AppBar(
      backgroundColor: const Color(0xFF071E1B),
      foregroundColor: _gold,
      title: const Text('فلسفه مدیریت مرگ'),
    ),
    body: WebViewWidget(controller: _controller),
  );
}
