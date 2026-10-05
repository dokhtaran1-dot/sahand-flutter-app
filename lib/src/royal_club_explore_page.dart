import 'package:flutter/material.dart';

import 'royal_club_membership_page.dart';
import 'royal_club_photo_album_page.dart';
import 'royal_club_privileges_page.dart';
import 'royal_club_profile_page.dart';
import 'royal_games_page.dart';
import 'royal_leaderboard_page.dart';

class RoyalClubExplorePage extends StatelessWidget {
  const RoyalClubExplorePage({super.key});

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const RoyalClubMembershipPage(),
      const RoyalGamesPage(),
      const RoyalClubPrivilegesPage(),
      const RoyalLeaderboardPage(),
      const RoyalClubPhotoAlbumPage(),
      const RoyalClubProfilePage(),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            const artW = 768.0;
            const artH = 1365.0;
            return FittedBox(
              fit: BoxFit.fill,
              child: SizedBox(
                width: artW,
                height: artH,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/image/royal_club_explore_luxury.png',
                      fit: BoxFit.fill,
                      filterQuality: FilterQuality.high,
                    ),
                    Positioned(
                      left: 22, top: 38, width: 92, height: 92,
                      child: _Hotspot(onTap: () => Navigator.of(context).pop()),
                    ),
                    _HotspotPosition(left: 24, top: 235, width: 356, height: 328,
                        onTap: () => _open(context, pages[0])),
                    _HotspotPosition(left: 388, top: 235, width: 356, height: 328,
                        onTap: () => _open(context, pages[1])),
                    _HotspotPosition(left: 24, top: 580, width: 356, height: 328,
                        onTap: () => _open(context, pages[2])),
                    _HotspotPosition(left: 388, top: 580, width: 356, height: 328,
                        onTap: () => _open(context, pages[3])),
                    _HotspotPosition(left: 24, top: 925, width: 356, height: 328,
                        onTap: () => _open(context, pages[4])),
                    _HotspotPosition(left: 388, top: 925, width: 356, height: 328,
                        onTap: () => _open(context, pages[5])),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HotspotPosition extends StatelessWidget {
  const _HotspotPosition({
    required this.left, required this.top, required this.width,
    required this.height, required this.onTap,
  });
  final double left, top, width, height;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Positioned(
    left: left, top: top, width: width, height: height,
    child: _Hotspot(onTap: onTap),
  );
}

class _Hotspot extends StatelessWidget {
  const _Hotspot({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      splashColor: const Color(0x22E8C36A),
      highlightColor: Colors.transparent,
    ),
  );
}
