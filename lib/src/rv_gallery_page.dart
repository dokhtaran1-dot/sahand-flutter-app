import 'package:flutter/material.dart';
import 'rv_booking_poster_page.dart';

/// Eight approved private salons, in the user's confirmed Royal One order.
class RvGalleryPage extends StatelessWidget {
  const RvGalleryPage({super.key});

  static const Color _bg = Color(0xFF04140F);
  static const Color _gold = Color(0xFFD6B15E);

  static const List<({String name, String image})> _salons = [
    (name: 'Salon Lumière', image: 'assets/image/Salon_lumiere.png'),
    (name: 'Salon Noir', image: 'assets/image/Salon_noir.png'),
    (name: 'Salon Jardin', image: 'assets/image/salon_jardin.png'),
    (name: 'Salon Privé', image: 'assets/image/Salon_prive.png'),
    (name: 'RV Lounge Impérial Classique', image: 'assets/image/rv_lounge_imperial_classique.png'),
    (name: 'Salon Doré', image: 'assets/image/salon_dore.png'),
    (name: 'Salon Âme du Poète', image: 'assets/image/salon_ame_du_poete.png'),
    (name: 'Salon Royal', image: 'assets/image/Salon_royal.png'),
  ];

  static void _open(BuildContext context, int index) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => _SalonImageViewer(initialIndex: index, salons: _salons),
    ));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _bg,
    appBar: AppBar(
      backgroundColor: _bg,
      foregroundColor: _gold,
      centerTitle: true,
      title: const Text('LE ROYAL VILLAGE CAFÉ',
          style: TextStyle(letterSpacing: 1.4, fontSize: 16)),
    ),
    body: Column(children: [
      const Padding(padding: EdgeInsets.fromLTRB(20, 24, 20, 12), child: Column(children: [
        Text('THE EIGHT PRIVATE SALONS',
            textAlign: TextAlign.center,
            style: TextStyle(color: _gold, letterSpacing: 2.6, fontSize: 12)),
        SizedBox(height: 8),
        Text('۸ سالن اختصاصی رویال ویلاژ',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 21, color: Colors.white)),
        SizedBox(height: 7),
        Text('برای بزرگ‌نمایی تصویر و مشاهدهٔ رزرو، سالن را لمس کنید',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFFC9C4B5), fontSize: 12)),
      ])),
      Expanded(child: LayoutBuilder(builder: (context, constraints) {
        final count = constraints.maxWidth > 700 ? 3 : 2;
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 30),
          itemCount: _salons.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: count, crossAxisSpacing: 12,
            mainAxisSpacing: 14, childAspectRatio: 0.88,
          ),
          itemBuilder: (context, i) {
            final item = _salons[i];
            return Semantics(
              label: item.name, button: true,
              child: Material(color: const Color(0xFF0E2319),
                borderRadius: BorderRadius.circular(17),
                clipBehavior: Clip.antiAlias,
                child: InkWell(onTap: () => _open(context, i),
                  child: Stack(fit: StackFit.expand, children: [
                    Image.asset(item.image,
                      fit: BoxFit.cover, alignment: Alignment.center,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (_, __, ___) =>
                          const Center(child: Icon(Icons.broken_image_outlined,
                            color: _gold, size: 37))),
                    const DecoratedBox(decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter, end: Alignment.bottomCenter,
                        stops: [0, .52, 1],
                        colors: [Colors.transparent, Color(0x11000000), Color(0xE6000000)]))),
                    Positioned(left: 10, right: 10, bottom: 15,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Text(item.name, textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white,
                            fontWeight: FontWeight.w800, fontSize: 14)),
                        const SizedBox(height: 5),
                        const Icon(Icons.zoom_in_rounded, color: _gold, size: 21),
                      ])),
                  ]),
                ),
              ),
            );
          },
        );
      })),
    ]),
  );
}

class _SalonImageViewer extends StatefulWidget {
  const _SalonImageViewer({required this.initialIndex, required this.salons});
  final int initialIndex;
  final List<({String name, String image})> salons;
  @override
  State<_SalonImageViewer> createState() => _SalonImageViewerState();
}

class _SalonImageViewerState extends State<_SalonImageViewer> {
  late int index = widget.initialIndex;
  late final PageController controller = PageController(initialPage: index);
  @override
  void dispose() { controller.dispose(); super.dispose(); }

  void book() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => RvBookingPosterPage(salonName: widget.salons[index].name),
    ));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF030806),
    appBar: AppBar(
      backgroundColor: const Color(0xFF030806), foregroundColor: const Color(0xFFD6B15E),
      title: Text(widget.salons[index].name, style: const TextStyle(fontSize: 17)),
    ),
    body: Column(children: [
      Expanded(child: PageView.builder(
        controller: controller,
        itemCount: widget.salons.length,
        onPageChanged: (i) => setState(() => index = i),
        itemBuilder: (_, i) => InteractiveViewer(
          minScale: 1.0, maxScale: 5.0,
          child: Center(child: SizedBox(
            width: MediaQuery.sizeOf(context).width * .92,
            height: MediaQuery.sizeOf(context).height * .57,
            child: Image.asset(widget.salons[i].image,
              fit: BoxFit.contain, filterQuality: FilterQuality.high,
              errorBuilder: (_, __, ___) => const Center(
                child: Text('تصویر این سالن در دسترس نیست',
                  style: TextStyle(color: _gold))))),
        ),
      )),
      SafeArea(top: false, child: Padding(
        padding: const EdgeInsets.fromLTRB(17, 8, 17, 22),
        child: Column(children: [
          Text('${index + 1} / ${widget.salons.length}',
            style: const TextStyle(color: Color(0xFFCCB47B))),
          const SizedBox(height: 9),
          SizedBox(width: double.infinity, height: 52, child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFD6B15E),
              foregroundColor: const Color(0xFF03130D)),
            onPressed: book,
            child: const Text('انتخاب سالن و مشاهدهٔ جزئیات رزرو',
              style: TextStyle(fontWeight: FontWeight.w800)),
          )),
        ]),
      )),
    ]),
  );
}
