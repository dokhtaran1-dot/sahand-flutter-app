import 'package:flutter/material.dart';

import 'salon_detail_page.dart';

class RvGalleryPage extends StatelessWidget {
  const RvGalleryPage({super.key});

  static const Color _bg = Color(0xFF020706);
  static const Color _gold = Color(0xFFD6B15E);

  static const List<_SalonItem> _salons = [
    _SalonItem('RV Lounge Impérial Classique', 'assets/image/rv_lounge_imperial_classique.png'),
    _SalonItem('Salon Jardin', 'assets/image/salon_jardin.png'),
    _SalonItem('Salon Lumière', 'assets/image/salon_lumiere.png'),
    _SalonItem('Salon Doré', 'assets/image/salon_dore.png'),
    _SalonItem('Grand Salon', 'assets/image/Rv_page2.png'),
    _SalonItem('Salon Royal', 'assets/image/salon_royal.png'),
    _SalonItem('Salon Privé', 'assets/image/salon_prive.png'),
    _SalonItem('Salon Noir', 'assets/image/salon_noir.png'),
    _SalonItem('Salon Âme du Poète', 'assets/image/salon_ame_du_poete.png'),
  ];

  void _open(BuildContext context, String name) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SalonDetailPage(salonName: name)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: _gold,
        centerTitle: true,
        title: const Text(
          'ROYAL VILLAGE • SALONS',
          style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1.2),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.fromLTRB(12, 14, 12, 30),
        itemCount: _salons.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: .90,
        ),
        itemBuilder: (context, index) {
          final item = _salons[index];
          return InkWell(
            onTap: () => _open(context, item.name),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF08100D),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _gold.withOpacity(.65)),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    item.image,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (_, __, ___) => const ColoredBox(
                      color: Color(0xFF08100D),
                      child: Center(
                        child: Icon(Icons.meeting_room_outlined, color: _gold, size: 46),
                      ),
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xDD000000)],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    right: 10,
                    bottom: 10,
                    child: Text(
                      item.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        shadows: [Shadow(color: Colors.black, blurRadius: 8)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SalonItem {
  final String name;
  final String image;
  const _SalonItem(this.name, this.image);
}
