import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'royal_games_page.dart';
import 'royal_leaderboard_page.dart';
import 'royal_rewards_page.dart';
import 'royal_club_membership_page.dart';
import 'royal_prize_tv.dart';

class RoyalClubGamePage extends StatelessWidget {
  const RoyalClubGamePage({super.key});

  static const double _artWidth = 941;
  static const double _artHeight = 1672;
  static const String _art =
      'assets/image/ROYAL_ONE_Home_RC_Ultra_Final.png';
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

  void _openProfile(BuildContext context) {
    const configured =
        bool.fromEnvironment('ROYAL_CLUB_BACKEND_READY', defaultValue: false);
    if (configured) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const RoyalClubMembershipPage()),
      );
      return;
    }
    _showInfo(
      context,
      'ROYAL CLUB',
      'فرم عضویت آماده است و پس از اتصال سرویس عضویت فعال می‌شود.',
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
                      child: _TapZone(
                        onTap: () => _showInfo(
                          context,
                          'ROYAL CLUB',
                          'Membership • Games • Privileges • Photo Album',
                        ),
                      ),
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
                      child: _TapZone(onTap: () => _openProfile(context)),
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
                      child: _TapZone(onTap: () => _openRewards(context)),
                    ),

                    // Photo Album
                    Positioned(
                      left: 700,
                      top: 1140,
                      width: 223,
                      height: 300,
                      child: _TapZone(
                        onTap: () => _showInfo(
                          context,
                          'PHOTO ALBUM',
                          'آلبوم تصاویر اختصاصی Royal Club',
                        ),
                      ),
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
                      child: _TapZone(
                        onTap: () => _showInfo(
                          context,
                          'EXPLORE',
                          'دنیای Royal Club',
                        ),
                      ),
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
