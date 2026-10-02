import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'royal_games_page.dart';
import 'royal_leaderboard_page.dart';
import 'royal_rewards_page.dart';
import 'royal_club_membership_page.dart';
import 'royal_club_privileges_page.dart';
import 'royal_club_photo_album_page.dart';
import 'royal_club_explore_page.dart';
import 'royal_club_profile_page.dart';
import 'royal_prize_tv.dart';

class RoyalClubGamePage extends StatelessWidget {
  const RoyalClubGamePage({super.key});

  static const double _artWidth = 941;
  static const double _artHeight = 1672;
  static const String _art = 'assets/image/RC_Approved.jpg';
  static const Color _gold = Color(0xFFE8C36A);

  void _openGames(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RoyalGamesPage()),
    );
  }

  void _openLeaderboard(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RoyalLeaderboardPage()),
    );
  }

  void _openRewards(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RoyalRewardsPage()),
    );
  }

  void _openMembership(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RoyalClubMembershipPage()),
    );
  }

  void _openPrivileges(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RoyalClubPrivilegesPage()),
    );
  }

  void _openPhotoAlbum(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RoyalClubPhotoAlbumPage()),
    );
  }

  void _openExplore(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RoyalClubExplorePage()),
    );
  }

  void _openProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RoyalClubProfilePage()),
    );
  }

  void _openMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF0A0705),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        side: BorderSide(color: _gold),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'ROYAL CLUB',
                style: TextStyle(
                  color: _gold,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 14),
              _MenuAction(
                icon: Icons.workspace_premium_outlined,
                title: 'عضویت کلاب',
                onTap: () {
                  Navigator.pop(sheetContext);
                  _openMembership(context);
                },
              ),
              _MenuAction(
                icon: Icons.sports_esports_rounded,
                title: 'بازی‌ها',
                onTap: () {
                  Navigator.pop(sheetContext);
                  _openGames(context);
                },
              ),
              _MenuAction(
                icon: Icons.diamond_outlined,
                title: 'امتیازات و مزایا',
                onTap: () {
                  Navigator.pop(sheetContext);
                  _openPrivileges(context);
                },
              ),
              _MenuAction(
                icon: Icons.photo_library_outlined,
                title: 'آلبوم عکس',
                onTap: () {
                  Navigator.pop(sheetContext);
                  _openPhotoAlbum(context);
                },
              ),
              _MenuAction(
                icon: Icons.person_outline_rounded,
                title: 'پروفایل من',
                onTap: () {
                  Navigator.pop(sheetContext);
                  _openProfile(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showInfo(BuildContext context, String title, String body) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0A0705),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        side: BorderSide(color: _gold),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 28),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: _gold,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  body,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.8,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          ImageFiltered(
            imageFilter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(.46),
                BlendMode.darken,
              ),
              child: Image.asset(_art, fit: BoxFit.cover),
            ),
          ),
          Center(
            child: FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: _artWidth,
                height: _artHeight,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      _art,
                      width: _artWidth,
                      height: _artHeight,
                      fit: BoxFit.fill,
                      filterQuality: FilterQuality.high,
                      isAntiAlias: true,
                      gaplessPlayback: true,
                    ),

                    // Top-right menu
                    Positioned(
                      left: 850,
                      top: 10,
                      width: 91,
                      height: 105,
                      child: _TapZone(onTap: () => _openMenu(context)),
                    ),

                    // Language selector
                    Positioned(
                      left: 640,
                      top: 10,
                      width: 205,
                      height: 90,
                      child: _TapZone(
                        onTap: () => _showInfo(
                          context,
                          'FA | EN | AR',
                          'انتخاب زبان رویال کلاب',
                        ),
                      ),
                    ),

                    // Left prize TV — 10 approved prizes, aspect ratio preserved.
                    Positioned(
                      left: 30,
                      top: 662,
                      width: 432,
                      height: 458,
                      child: RoyalPrizeTv(
                        onOpenRewards: () => _openRewards(context),
                      ),
                    ),

                    // Right Top 10 TV
                    Positioned(
                      left: 480,
                      top: 650,
                      width: 441,
                      height: 485,
                      child: _TapZone(onTap: () => _openLeaderboard(context)),
                    ),

                    // Membership
                    Positioned(
                      left: 18,
                      top: 1140,
                      width: 218,
                      height: 300,
                      child: _TapZone(onTap: () => _openMembership(context)),
                    ),

                    // Games
                    Positioned(
                      left: 240,
                      top: 1140,
                      width: 225,
                      height: 300,
                      child: _TapZone(onTap: () => _openGames(context)),
                    ),

                    // Privileges
                    Positioned(
                      left: 470,
                      top: 1140,
                      width: 225,
                      height: 300,
                      child: _TapZone(onTap: () => _openPrivileges(context)),
                    ),

                    // Photo Album
                    Positioned(
                      left: 700,
                      top: 1140,
                      width: 223,
                      height: 300,
                      child: _TapZone(onTap: () => _openPhotoAlbum(context)),
                    ),

                    // Bottom Home
                    Positioned(
                      left: 25,
                      top: 1450,
                      width: 255,
                      height: 175,
                      child: _TapZone(
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ),

                    // Bottom Explore
                    Positioned(
                      left: 300,
                      top: 1440,
                      width: 340,
                      height: 190,
                      child: _TapZone(onTap: () => _openExplore(context)),
                    ),

                    // Bottom Profile
                    Positioned(
                      left: 655,
                      top: 1450,
                      width: 260,
                      height: 175,
                      child: _TapZone(onTap: () => _openProfile(context)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TapZone extends StatelessWidget {
  final VoidCallback onTap;
  const _TapZone({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
    );
  }
}


class _MenuAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuAction({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Material(
        color: const Color(0xFF18100D),
        borderRadius: BorderRadius.circular(17),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(17),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17),
              border: Border.all(color: const Color(0x66E8C36A)),
            ),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Icon(icon, color: const Color(0xFFE8C36A)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_left_rounded,
                  color: Color(0xFFE8C36A),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
