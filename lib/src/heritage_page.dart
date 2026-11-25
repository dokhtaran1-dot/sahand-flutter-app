import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

const _jade = Color(0xFF071711);
const _panel = Color(0xFF103D32);
const _gold = Color(0xFFE7C77D);

void _open(BuildContext context, Widget page) {
  Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
}

class HeritagePage extends StatelessWidget {
  const HeritagePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _jade,
    appBar: AppBar(backgroundColor: _jade, foregroundColor: _gold, title: const Text('SAHAND / HERITAGE')),
    body: Directionality(textDirection: TextDirection.rtl, child: ListView(padding: const EdgeInsets.all(28), children: [
      const Text('SC', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'serif', fontSize: 100, color: _gold)),
      const Text('SAHAND CONSORTIUM\nSINCE 1351', textAlign: TextAlign.center, textDirection: TextDirection.ltr, style: TextStyle(letterSpacing: 3, height: 1.8, color: _gold)),
      const SizedBox(height: 32),
      const Text('ROYAL HERITAGE', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'serif', fontSize: 25, letterSpacing: 2, color: _gold)),
      const Text('FROM FATHER TO SON', textAlign: TextAlign.center, style: TextStyle(color: _gold, letterSpacing: 2, height: 2)),
      const SizedBox(height: 24),
      const Text('از پدر به پسر', style: TextStyle(fontSize: 30, color: _gold)),
      const SizedBox(height: 18),
      const Text('سهند از سال ۱۳۵۱، با تأسیس کارخانه توسط پدر، آغاز شد؛ نامی که میراث آن در مسیر توسعهٔ کنسرسیوم سهند ادامه یافت.', style: TextStyle(fontSize: 18, height: 2, color: Colors.white70)),
      const Divider(height: 48, color: Color(0xFF806B40)),
      _ArchiveTile(key: const Key('heritage:president'), icon: Icons.person_outline, title: 'PRESIDENT', subtitle: 'حامد قنبری درویش · زندگی‌نامه و آثار شخصی', onTap: () => _open(context, const PresidentPage())),
      const SizedBox(height: 24),
      ClipRRect(borderRadius: BorderRadius.circular(24), child: Image.asset('assets/images/1.png', height: 260, fit: BoxFit.contain)),
      const SizedBox(height: 24),
      const Text('حامد قنبری', style: TextStyle(fontSize: 30, color: _gold)),
      const SizedBox(height: 10),
      const Text('رئیس کنسرسیوم سهند\nسومین وارث؛ ادامه‌دهندهٔ نام سهند', style: TextStyle(fontSize: 18, height: 2, color: Colors.white70)),
      const SizedBox(height: 28),
      const Text('MBA · UOWD Dubai\nDALF C2 · Français', textDirection: TextDirection.ltr, style: TextStyle(height: 2, letterSpacing: 1, color: _gold)),
    ])),
  );
}

class _ArchiveTile extends StatelessWidget {
  const _ArchiveTile({super.key, required this.icon, required this.title, required this.subtitle, required this.onTap});
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.symmetric(vertical: 6),
    color: _panel,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: _gold, width: .7)),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      leading: Icon(icon, color: _gold, size: 28),
      title: Text(title, style: const TextStyle(color: _gold, fontSize: 18)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70, height: 1.6)),
      trailing: const Icon(Icons.chevron_left, color: _gold),
      onTap: onTap,
    ),
  );
}

class PresidentPage extends StatelessWidget {
  const PresidentPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _jade,
    appBar: AppBar(backgroundColor: _jade, foregroundColor: _gold, title: const Text('PRESIDENT')),
    body: Directionality(textDirection: TextDirection.rtl, child: ListView(padding: const EdgeInsets.all(20), children: [
      Center(child: ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.asset('assets/images/1.png', height: 220, fit: BoxFit.contain))),
      const SizedBox(height: 18),
      const Text('HAMED GHANBARI DARVISH', textDirection: TextDirection.ltr, textAlign: TextAlign.center, style: TextStyle(color: _gold, fontSize: 23, fontFamily: 'serif', letterSpacing: 1.5)),
      const Text('THIRD HEIR OF SAHAND', textAlign: TextAlign.center, style: TextStyle(color: _gold, letterSpacing: 2, height: 2)),
      const Divider(height: 40, color: _gold),
      const Text('Personal Manuscripts & Poetry', textDirection: TextDirection.ltr, textAlign: TextAlign.center, style: TextStyle(color: _gold, fontSize: 18, fontFamily: 'serif')),
      const SizedBox(height: 16),
      _ArchiveTile(icon: Icons.person_outline, title: 'زندگی‌نامه و سوابق', subtitle: 'Biography', onTap: () => _open(context, const _ArchivePage(title: 'زندگی‌نامه و سوابق', children: [
        Text('حامد قنبری درویش', style: TextStyle(color: _gold, fontSize: 26)),
        SizedBox(height: 16),
        Text('رئیس کنسرسیوم سهند؛ سومین وارث و ادامه‌دهنده نام سهند.', style: TextStyle(color: Colors.white70, height: 2, fontSize: 18)),
        SizedBox(height: 20),
        Text('MBA · UOWD Dubai\nDALF C2 · Français', textDirection: TextDirection.ltr, style: TextStyle(color: _gold, height: 2)),
      ]))),
      _ArchiveTile(icon: Icons.edit_note, title: 'دست‌نوشته‌های من', subtitle: 'Personal Manuscripts · فهرست آثار', onTap: () => _open(context, const ManuscriptIndexPage())),
      _ArchiveTile(key: const Key('president:philosophy'), icon: Icons.auto_stories_outlined, title: 'فلسفه مدیریت مرگ', subtitle: 'دست‌نوشته شخصی · از فروپاشی تا احیا · ۹ فصل', onTap: () => _open(context, const ManuscriptIndexPage())),
      _ArchiveTile(key: const Key('president:poetry'), icon: Icons.menu_book, title: 'مجموعه اشعار', subtitle: 'Poetry Collection · فهرست آثار', onTap: () => _open(context, const PoetryIndexPage())),
      _ArchiveTile(icon: Icons.format_quote, title: 'جملات و اندیشه‌های من', subtitle: 'Personal Reflections', onTap: () => _open(context, const _ArchivePage(title: 'جملات و اندیشه‌های من', children: [_EmptyArchive()]))),
      _ArchiveTile(icon: Icons.photo_library_outlined, title: 'آلبوم خاطرات', subtitle: 'Personal Archive', onTap: () => _open(context, const _ArchivePage(title: 'آلبوم خاطرات', children: [_EmptyArchive()]))),
      const SizedBox(height: 32),
      const Text('H. Darvish', textAlign: TextAlign.center, style: TextStyle(color: _gold, fontFamily: 'serif', fontStyle: FontStyle.italic, fontSize: 24)),
    ])),
  );
}

class ManuscriptIndexPage extends StatelessWidget {
  const ManuscriptIndexPage({super.key});
  static const chapters = [
    'فلسفه مدیریت مرگ', 'مسیر سقوط', 'مدیریت مرگ چیست', 'مراحل مدیریت مرگ',
    'اصول شخصی من در مدیریت مرگ', 'تفاوت مدیریت بحران و مدیریت مرگ',
    'کاربرد مدیریت مرگ', 'نتیجه', 'سخن پایانی',
  ];
  @override
  Widget build(BuildContext context) => _ArchivePage(title: 'دست‌نوشته‌های من', children: [
    const Text('اثر ۰۱ / فلسفه مدیریت مرگ', style: TextStyle(color: _gold, fontSize: 24)),
    const SizedBox(height: 8),
    const Text('از فروپاشی تا احیا\nنظریه شخصی در تجارت و زندگی\nبه قلم حامد قنبری درویش', style: TextStyle(color: Colors.white70, height: 2, fontSize: 17)),
    const SizedBox(height: 18),
    _ArchiveTile(icon: Icons.auto_stories_outlined, title: 'مطالعه دست‌نوشته کامل', subtitle: 'Read manuscript · ۹ فصل', onTap: () => _open(context, const PhilosophyBookPage())),
    const Divider(height: 35, color: _gold),
    const Text('فهرست فصل‌ها', style: TextStyle(color: _gold, fontSize: 20)),
    for (var i = 0; i < chapters.length; i++)
      ListTile(title: Text(chapters[i], style: const TextStyle(color: Colors.white70)), leading: Text('${i + 1}', style: const TextStyle(color: _gold)), trailing: const Icon(Icons.chevron_left, color: _gold), onTap: () => _open(context, PhilosophyBookPage(chapter: i))),
  ]);
}

// Add author-approved poems here, preserving their exact text.
class _Poem {
  const _Poem(this.title, this.text);
  final String title;
  final String text;
}
class PoetryIndexPage extends StatelessWidget {
  const PoetryIndexPage({super.key});
  static const poems = <_Poem>[];
  @override
  Widget build(BuildContext context) => _ArchivePage(title: 'مجموعه اشعار', children: [
    const Text('POETRY COLLECTION', textAlign: TextAlign.center, style: TextStyle(color: _gold, letterSpacing: 2)),
    const SizedBox(height: 20),
    const Text('فهرست اشعار · H. Darvish', style: TextStyle(color: _gold, fontSize: 21)),
    if (poems.isEmpty) const _EmptyArchive(),
    for (final poem in poems) _ArchiveTile(icon: Icons.menu_book, title: poem.title, subtitle: 'H. Darvish', onTap: () => _open(context, _ArchivePage(title: poem.title, children: [
      Text(poem.text, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 19, height: 2.3)),
      const SizedBox(height: 32), const Text('H. Darvish', textAlign: TextAlign.center, style: TextStyle(color: _gold, fontStyle: FontStyle.italic)),
    ]))),
  ]);
}

class _EmptyArchive extends StatelessWidget {
  const _EmptyArchive();
  @override
  Widget build(BuildContext context) => const Padding(padding: EdgeInsets.symmetric(vertical: 40), child: Text('هنوز اثری در این فهرست منتشر نشده است.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, height: 2)));
}
class _ArchivePage extends StatelessWidget {
  const _ArchivePage({required this.title, required this.children});
  final String title;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _jade,
    appBar: AppBar(backgroundColor: _jade, foregroundColor: _gold, title: Text(title)),
    body: Directionality(textDirection: TextDirection.rtl, child: ListView(padding: const EdgeInsets.all(24), children: children)),
  );
}

class PhilosophyBookPage extends StatefulWidget {
  const PhilosophyBookPage({super.key, this.chapter});
  final int? chapter;

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
      ..setNavigationDelegate(NavigationDelegate(onPageFinished: (_) async {
        final chapter = widget.chapter;
        if (chapter != null) {
          await _controller.runJavaScript("document.getElementById('chapter-$chapter')?.scrollIntoView();");
        }
      }))
      ..loadFlutterAsset('assets/heritage/philosophy_book.html');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF071E1B),
    appBar: AppBar(
      backgroundColor: const Color(0xFF071E1B),
      foregroundColor: const Color(0xFFE7C77D),
      title: const Text('فلسفه مدیریت مرگ'),
    ),
    body: WebViewWidget(controller: _controller),
  );
}
