import 'package:flutter/material.dart';

import 'royal_club_membership_page.dart';
import 'royal_club_photo_album_page.dart';
import 'royal_club_privileges_page.dart';
import 'royal_club_profile_page.dart';
import 'royal_games_page.dart';
import 'royal_leaderboard_page.dart';

class RoyalClubExplorePage extends StatelessWidget {
  const RoyalClubExplorePage({super.key});

  static const gold = Color(0xFFE8C36A);

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final items = <_ExploreItem>[
      _ExploreItem(
        'عضویت کلاب',
        'MEMBERSHIP',
        Icons.workspace_premium_outlined,
        const RoyalClubMembershipPage(),
      ),
      _ExploreItem(
        'بازی‌ها',
        'GAMES',
        Icons.sports_esports_rounded,
        const RoyalGamesPage(),
      ),
      _ExploreItem(
        'امتیازات و مزایا',
        'PRIVILEGES',
        Icons.diamond_outlined,
        const RoyalClubPrivilegesPage(),
      ),
      _ExploreItem(
        '۱۰ نفر برتر',
        'TOP 10',
        Icons.leaderboard_rounded,
        const RoyalLeaderboardPage(),
      ),
      _ExploreItem(
        'آلبوم عکس',
        'PHOTO ALBUM',
        Icons.photo_library_outlined,
        const RoyalClubPhotoAlbumPage(),
      ),
      _ExploreItem(
        'پروفایل من',
        'PROFILE',
        Icons.person_outline_rounded,
        const RoyalClubProfilePage(),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF16090B),
        foregroundColor: gold,
        centerTitle: true,
        title: const Text(
          'EXPLORE ROYAL CLUB',
          style: TextStyle(letterSpacing: 1.4, fontSize: 16),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.2,
            colors: [Color(0xFF50101A), Color(0xFF16090B), Colors.black],
          ),
        ),
        child: SafeArea(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: .93,
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _open(context, item.page),
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: gold.withOpacity(.62)),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF34151A), Color(0xFF0B0807)],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item.icon, color: gold, size: 45),
                        const SizedBox(height: 13),
                        Text(
                          item.title,
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          item.english,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: gold,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.3,
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
      ),
    );
  }
}

class _ExploreItem {
  final String title;
  final String english;
  final IconData icon;
  final Widget page;
  const _ExploreItem(this.title, this.english, this.icon, this.page);
}
