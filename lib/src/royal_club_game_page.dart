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
import 'royal_score_store.dart';
import 'royal_wallet_page.dart';

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

  void _openWallet(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RoyalWalletPage()),
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
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0A0705),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        side: BorderSide(color: _gold),
      ),
      builder: (sheetContext) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(sheetContext).height * .8,
          ),
          child: SingleChildScrollView(
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
                icon: Icons.account_balance_wallet_outlined,
                title: 'کیف پول رویال | Royal Wallet',
                onTap: () {
                  Navigator.pop(sheetContext);
                  _openWallet(context);
                },
              ),
              _MenuAction(
                icon: Icons.emoji_events_outlined,
                title: '۱۰ نفر برتر',
                onTap: () {
                  Navigator.pop(sheetContext);
                  _openLeaderboard(context);
                },
              ),
              _MenuAction(
                icon: Icons.card_giftcard_outlined,
                title: 'جوایز باشگاه',
                onTap: () {
                  Navigator.pop(sheetContext);
                  _openRewards(context);
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

                    // The approved render accidentally says "SINCE 1991".
                    // Keep the artwork, but correct the Sahand heritage date.
                    Positioned(
                      left: 106,
                      top: 92,
                      width: 113,
                      height: 26,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: const Color(0xFF170D0B),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Center(
                          child: Text(
                            'SINCE 1351',
                            style: TextStyle(
                              color: _gold,
                              fontSize: 13,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Top-right menu
                    Positioned(
                      left: 850,
                      top: 10,
                      width: 91,
                      height: 105,
                      child: _TapZone(
                        label: 'منوی رویال کلاب',
                        onTap: () => _openMenu(context),
                      ),
                    ),

                    // Language selector
                    Positioned(
                      left: 640,
                      top: 10,
                      width: 205,
                      height: 90,
                      child: _TapZone(
                        label: 'زبان فارسی، انگلیسی و عربی',
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

                    // The original artwork has illustrative, fixed rankings.
                    // Cover them with the real score feed; never present
                    // fabricated member numbers as an actual leaderboard.
                    Positioned(
                      left: 480,
                      top: 650,
                      width: 441,
                      height: 485,
                      child: _LiveClubTopTenCard(
                        onTap: () => _openLeaderboard(context),
                      ),
                    ),

                    // Membership
                    Positioned(
                      left: 18,
                      top: 1140,
                      width: 218,
                      height: 300,
                      child: _TapZone(
                        label: 'عضویت رویال کلاب',
                        onTap: () => _openMembership(context),
                      ),
                    ),

                    // Games
                    Positioned(
                      left: 240,
                      top: 1140,
                      width: 225,
                      height: 300,
                      child: _TapZone(
                        label: 'بازی‌های رویال کلاب',
                        onTap: () => _openGames(context),
                      ),
                    ),

                    // Privileges
                    Positioned(
                      left: 470,
                      top: 1140,
                      width: 225,
                      height: 300,
                      child: _TapZone(
                        label: 'مزایای عضویت در رویال کلاب',
                        onTap: () => _openPrivileges(context),
                      ),
                    ),

                    // Photo Album
                    Positioned(
                      left: 700,
                      top: 1140,
                      width: 223,
                      height: 300,
                      child: _TapZone(
                        label: 'آلبوم عکس رویال کلاب',
                        onTap: () => _openPhotoAlbum(context),
                      ),
                    ),

                    // Bottom Home
                    Positioned(
                      left: 25,
                      top: 1450,
                      width: 255,
                      height: 175,
                      child: _TapZone(
                        label: 'بازگشت به خانه رویال وان',
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
                        label: 'کاوش بخش‌های رویال کلاب',
                        onTap: () => _openExplore(context),
                      ),
                    ),

                    // Bottom Profile
                    Positioned(
                      left: 655,
                      top: 1450,
                      width: 260,
                      height: 175,
                      child: _TapZone(
                        label: 'پروفایل من',
                        onTap: () => _openProfile(context),
                      ),
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
  final String label;
  const _TapZone({required this.onTap, required this.label});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
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

/// Replaces the illustrative names and scores printed on RC_Approved.jpg.
/// Real membership totals are shown only when the score store supplies them.
class _LiveClubTopTenCard extends StatelessWidget {
  const _LiveClubTopTenCard({required this.onTap});

  final VoidCallback onTap;

  static const _gold = Color(0xFFE8C36A);
  static const _cream = Color(0xFFFFE4B0);

  static String _formatScore(int value) {
    final digits = value.toString();
    final result = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) result.write(',');
      result.write(digits[i]);
    }
    return result.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'مشاهده جدول واقعی ۱۰ نفر برتر رویال کلاب',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Material(
          color: const Color(0xFF100907),
          child: InkWell(
            onTap: onTap,
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: _gold, width: 3),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF33150D), Color(0xFF120B0A), Color(0xFF251409)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(19, 16, 19, 13),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.emoji_events_rounded,
                            color: _gold, size: 48),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('۱۰ نفر برتر',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    color: _cream,
                                    fontSize: 29,
                                    fontWeight: FontWeight.w900,
                                  )),
                              Text('TOP 10 MEMBERS',
                                  style: TextStyle(
                                    color: _gold,
                                    fontSize: 13,
                                    letterSpacing: 1.1,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ),
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: const Color(0xFF3C1111),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFFA3543F)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            child: Text(
                              RoyalScoreStore.backendReady ? '● LIVE' : 'LOCAL',
                              style: const TextStyle(
                                color: Color(0xFFFFD6BE),
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 11),
                    Divider(color: _gold.withOpacity(.6), height: 1),
                    const SizedBox(height: 7),
                    Expanded(
                      child: StreamBuilder<List<RoyalPlayerScore>>(
                        stream: RoyalScoreStore.liveTopTen(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const _TopTenStatus(
                              icon: Icons.wifi_off_rounded,
                              message: 'رتبه‌بندی فعلاً در دسترس نیست',
                            );
                          }
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: _gold,
                              ),
                            );
                          }
                          final players = snapshot.data!;
                          if (players.isEmpty) {
                            return const _TopTenStatus(
                              icon: Icons.military_tech_outlined,
                              message: 'هنوز امتیازی ثبت نشده\nاولین نفر باش!',
                            );
                          }
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: players.length > 10 ? 10 : players.length,
                            itemExtent: 32,
                            itemBuilder: (context, index) {
                              final player = players[index];
                              final accent = switch (index) {
                                0 => const Color(0xFFFFD05C),
                                1 => const Color(0xFFCDD4D7),
                                2 => const Color(0xFFDB9B6F),
                                _ => _gold,
                              };
                              return Row(
                                children: [
                                  SizedBox(
                                    width: 31,
                                    child: Text('${index + 1}',
                                        style: TextStyle(
                                          color: accent,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 18,
                                        )),
                                  ),
                                  Icon(Icons.account_circle_outlined,
                                      color: accent, size: 23),
                                  const SizedBox(width: 9),
                                  Expanded(
                                    child: Text(player.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        )),
                                  ),
                                  const Icon(Icons.local_activity_outlined,
                                      color: _gold, size: 18),
                                  const SizedBox(width: 6),
                                  Text(_formatScore(player.total),
                                      style: const TextStyle(
                                        color: _cream,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 15,
                                      )),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Divider(color: _gold.withOpacity(.4), height: 1),
                    const SizedBox(height: 7),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('مشاهده جدول کامل',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(color: _cream, fontSize: 15)),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward_ios_rounded,
                            color: _gold, size: 16),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TopTenStatus extends StatelessWidget {
  const _TopTenStatus({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFFE8C36A), size: 40),
            const SizedBox(height: 12),
            Text(message,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: const TextStyle(color: Colors.white, fontSize: 19)),
          ],
        ),
      );
}
