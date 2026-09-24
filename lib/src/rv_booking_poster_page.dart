import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'reservation_page.dart';

/// Approved full-screen artwork; invisible hit zones preserve the poster exactly.
class RvBookingPosterPage extends StatefulWidget {
  const RvBookingPosterPage({super.key, required this.salonName});
  final String salonName;
  @override
  State<RvBookingPosterPage> createState() => _RvBookingPosterPageState();
}

class _RvBookingPosterPageState extends State<RvBookingPosterPage> {
  static const gold = Color(0xFFFFD77A);
  static const Map<String, String> posters = {
    'Salon Doré': 'dore', 'Salon Jardin': 'jardin',
    'Salon Noir': 'noir', 'Salon Âme du Poète': 'ame_du_poete',
    'Salon Royal': 'royal', 'RV Lounge Impérial Classique': 'imperial',
    'Salon Lumière': 'lumiere', 'Salon Privé': 'prive', 'Grand Salon': 'grand',
  };
  static const Map<String, List<String>> music = {
    'dore': ['Golden Hour – Piano', 'Éclat Doré – Violin', 'Soleil de Paris – Lounge'],
    'jardin': ['Jardin de Rêve – Piano', 'Fleurs de Paris – Violin', 'Matin au Jardin – Lounge'],
    'noir': ['Noir Élégance – Piano', 'Minuit Rouge – Violin', 'Ombre & Lumière – Lounge'],
    'ame_du_poete': ['Poème d’Amour – Piano', 'Rose de Paris – Violin', 'Rêve du Poète – Lounge'],
    'royal': ['Couronne Royale – Piano', 'Majesté – Violin', 'Royal Signature – Lounge'],
    'imperial': ['Impérial Classique – Piano', 'Prestige – Violin', 'Royal Night – Lounge'],
    'lumiere': ['Lumière Blanche – Piano', 'Venise Éternelle – Violin', 'Clair de Lumière – Lounge'],
    'prive': ['Nuit Privée – Piano', 'Velours Rouge – Violin', 'Secret de Minuit – Lounge'],
    'grand': ['Grand Élégance – Piano', 'La Cérémonie – Violin', 'Royal Evening – Lounge'],
  };
  DateTime? date;
  TimeOfDay? time;
  int? design;
  int? cake;
  String? selectedMusic;
  String? drink;
  bool magic = false;
  bool vip = false;
  final notes = TextEditingController();
  String get keyName => posters[widget.salonName] ?? 'dore';
  @override
  void dispose() { notes.dispose(); super.dispose(); }

  Future<void> pickDate() async {
    final now = DateTime.now();
    final d = await showDatePicker(context: context, initialDate: now,
      firstDate: now, lastDate: now.add(const Duration(days: 365)));
    if (d != null && mounted) setState(() => date = d);
  }
  Future<void> pickTime() async {
    final t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (t != null && mounted) setState(() => time = t);
  }
  Future<void> gallery(String kind) async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final prefix = 'assets/image/salon_gallery/$keyName/${kind}_';
    final images = manifest.listAssets()
      .where((p) => p.startsWith(prefix) && p.endsWith('.webp')).toList()..sort();
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context, backgroundColor: const Color(0xFF07140F),
      isScrollControlled: true,
      builder: (sheet) => SafeArea(child: SizedBox(
        height: MediaQuery.sizeOf(sheet).height * .8,
        child: Column(children: [
          Padding(padding: const EdgeInsets.all(16),
            child: Text(kind == 'cake' ? '۱۰ کیک اختصاصی' : '۱۰ دیزاین اختصاصی',
              style: const TextStyle(color: gold, fontSize: 21))),
          Expanded(child: images.isEmpty
            ? const Center(child: Text('تصاویر این گالری هنوز بارگذاری نشده‌اند.',
                style: TextStyle(color: Colors.white)))
            : GridView.builder(
              padding: const EdgeInsets.all(12), itemCount: images.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemBuilder: (_, i) => InkWell(
                onTap: () { setState(() { if (kind == 'cake') { cake = i+1; }
                  else { design = i+1; } }); Navigator.pop(sheet); },
                child: Stack(fit: StackFit.expand, children: [
                  Image.asset(images[i], fit: BoxFit.cover),
                  Align(alignment: Alignment.bottomCenter,
                    child: Container(color: Colors.black87, padding: const EdgeInsets.all(7),
                      child: Text('${kind == 'cake' ? 'کیک' : 'دیزاین'} ${i+1}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: gold)))),
                ]))),
          ),
        ]),
      )),
    );
  }
  void chooseMusic() => showModalBottomSheet<void>(
    context: context, backgroundColor: const Color(0xFF07140F),
    builder: (sheet) => SafeArea(child: Column(mainAxisSize: MainAxisSize.min,
      children: (music[keyName] ?? const <String>[]).map((track) => ListTile(
        title: Text(track, style: const TextStyle(color: gold)),
        onTap: () { setState(() => selectedMusic = track); Navigator.pop(sheet); },
      )).toList())),
  );
  void editNotes() {
    showModalBottomSheet<void>(context: context, isScrollControlled: true,
      backgroundColor: const Color(0xFF07140F),
      builder: (sheet) => Padding(
        padding: EdgeInsets.fromLTRB(20, 24, 20,
          MediaQuery.viewInsetsOf(sheet).bottom + 20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('درخواست‌های شما', style: TextStyle(color: gold, fontSize: 20)),
          TextField(controller: notes, maxLines: 4,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(hintText: 'توضیحات و درخواست خاص',
              hintStyle: TextStyle(color: Colors.white54))),
          TextButton(onPressed: () => Navigator.pop(sheet),
            child: const Text('تأیید', style: TextStyle(color: gold))),
        ])));
  }
  void toggle(String item) {
    setState(() { if (item == 'magic') { magic = !magic; }
      else if (item == 'vip') { vip = !vip; }
      else { drink = drink == null ? 'آبمیوه اختصاصی سالن' : null; } });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(item == 'magic' ? (magic ? 'تردست دو نفره انتخاب شد' : 'تردست حذف شد')
        : item == 'vip' ? (vip ? 'VIP انتخاب شد' : 'VIP حذف شد')
        : (drink == null ? 'آبمیوه حذف شد' : 'آبمیوه اختصاصی انتخاب شد'))));
  }
  void reserve() {
    if (date == null || time == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('ابتدا تاریخ و ساعت را انتخاب کنید')));
      return;
    }
    final extras = <String>[
      if (drink != null) drink!, if (magic) 'تردست برای ۲ نفر',
      if (vip) 'تجربه VIP', if (notes.text.trim().isNotEmpty) notes.text.trim(),
    ].join(' | ');
    Navigator.push(context, MaterialPageRoute(builder: (_) => ReservationPage(
      salonName: widget.salonName, initialDate: date, initialTime: time,
      initialDesign: design == null ? null : 'دیزاین $design',
      initialCake: cake == null ? null : 'کیک $cake',
      initialMusic: selectedMusic,
      initialExtras: extras.isEmpty ? null : extras,
    )));
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    body: LayoutBuilder(builder: (context, c) {
      final sx = c.maxWidth / 864;
      final sy = c.maxHeight / 1536;
      Widget hit(double x, double y, double w, double h, VoidCallback action) =>
        Positioned(left: x*sx, top: y*sy, width: w*sx, height: h*sy,
          child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: action));
      return Stack(fit: StackFit.expand, children: [
        if (keyName == 'grand')
          Image.asset('assets/image/Grand_Salon_Original.png',
            fit: BoxFit.cover, filterQuality: FilterQuality.high,
            errorBuilder: (_, __, ___) => Image.asset('assets/image/Rv_page2.png', fit: BoxFit.cover))
        else
          Image.asset('assets/image/booking_posters/$keyName.png',
            fit: BoxFit.fill, filterQuality: FilterQuality.high),
        if (keyName == 'grand') ...[
          Positioned.fill(child: IgnorePointer(child: Column(children: [
            const Spacer(flex: 4),
            Expanded(flex: 6, child: Container(decoration: const BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Color(0xE600130E), Color(0xFF00140E)])))),
          ]))),
          Positioned(top: 20*sy, left: 100*sx, right: 100*sx,
            child: const Text('GRAND SALON', textAlign: TextAlign.center,
              style: TextStyle(color: gold, fontSize: 28, fontWeight: FontWeight.bold))),
          for (final item in <(double,double,double,double,String)>[
            (15,500,410,128,'ساعت'), (436,500,414,128,'تاریخ'),
            (15,633,410,142,'۱۰ دیزاین اختصاصی'), (436,633,414,142,'۱۰ کیک اختصاصی'),
            (15,780,410,130,'نوشیدنی اختصاصی'), (436,780,414,130,'۳ موسیقی'),
            (15,913,410,135,'تردست دونفره'), (436,913,414,135,'درخواست ویژه'),
            (15,1050,834,250,'تجربه VIP'), (50,1305,760,125,'ادامه و ثبت رزرو'),
          ]) Positioned(left:item.$1*sx,top:item.$2*sy,width:item.$3*sx,height:item.$4*sy,
            child: IgnorePointer(child: Container(margin: const EdgeInsets.all(3),
              alignment: Alignment.center,
              decoration: BoxDecoration(color: const Color(0xE007281C),
                border: Border.all(color: gold),borderRadius: BorderRadius.circular(13)),
              child: Text(item.$5,textAlign: TextAlign.center,
                style: const TextStyle(color: gold,fontSize: 16,fontWeight: FontWeight.bold))))),
        ],
        hit(0, 0, 95, 100, () => Navigator.pop(context)),
        hit(15, 500, 410, 128, pickTime),
        hit(436, 500, 414, 128, pickDate),
        hit(15, 633, 410, 142, () => gallery('design')),
        hit(436, 633, 414, 142, () => gallery('cake')),
        hit(15, 780, 410, 130, () => toggle('drink')),
        hit(436, 780, 414, 130, chooseMusic),
        hit(15, 913, 410, 135, () => toggle('magic')),
        hit(436, 913, 414, 135, editNotes),
        hit(15, 1050, 834, 250, () => toggle('vip')),
        hit(50, 1305, 760, 125, reserve),
      ]);
    }),
  );
}
