import 'package:flutter/material.dart';

class RoyalClubPhotoAlbumPage extends StatelessWidget {
  const RoyalClubPhotoAlbumPage({super.key});

  static const gold = Color(0xFFE8C36A);

  static const photos = [
    'assets/image/RC_Approved.jpg',
    'assets/image/deal_vip_night.png',
    'assets/image/deal_live_music.png',
    'assets/image/deal_dinner.png',
    'assets/image/deal_dessert.png',
    'assets/image/deal_jackpot.png',
  ];

  void _open(BuildContext context, String asset) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withOpacity(.96),
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(12),
        child: Stack(
          children: [
            InteractiveViewer(
              minScale: .8,
              maxScale: 4,
              child: Image.asset(
                asset,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton.filled(
                onPressed: () => Navigator.of(context).pop(),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black87,
                  foregroundColor: gold,
                ),
                icon: const Icon(Icons.close_rounded),
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF16090B),
        foregroundColor: gold,
        centerTitle: true,
        title: const Text(
          'ROYAL CLUB • PHOTO ALBUM',
          style: TextStyle(fontSize: 15, letterSpacing: 1.2),
        ),
      ),
      body: SafeArea(
        child: GridView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: photos.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: .78,
          ),
          itemBuilder: (context, index) {
            final asset = photos[index];
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _open(context, asset),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: gold.withOpacity(.65)),
                    boxShadow: const [
                      BoxShadow(color: Color(0x332C1808), blurRadius: 14),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        asset,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                      ),
                      const Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        height: 48,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black87],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 10,
                        bottom: 10,
                        child: Text(
                          'ROYAL MOMENT ${index + 1}',
                          style: const TextStyle(
                            color: gold,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
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
    );
  }
}
