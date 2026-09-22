import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'royal_crown_game_page.dart';
import 'royal_deal_page.dart';
import 'royal_club_tv.dart';
import 'royal_mall_page.dart';
import 'royal_rewards_page.dart';

class RoyalClubGamePage extends StatelessWidget {
  const RoyalClubGamePage({super.key});

  static const double _artWidth = 941;
  static const double _artHeight = 1672;
  static const String _art = 'assets/image/Rc_page2.png';
  static const Color _gold = Color(0xFFE8C36A);

  void _openDeal(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RoyalDealPage()),
    );
  }

  void _openCrown(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RoyalCrownGamePage()),
    );
  }

  void _openMall(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RoyalMallPage()),
    );
  }

  void _openRewards(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RoyalRewardsPage()),
    );
  }

  void _message(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF0B0907),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: _gold),
          ),
          content: Text(
            text,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: const TextStyle(color: Colors.white),
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

  void _showProfile(BuildContext context) {
    final name = TextEditingController();
    final phone = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0A0705),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        side: BorderSide(color: _gold),
      ),
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.fromLTRB(
          22,
          22,
          22,
          MediaQuery.of(sheetContext).viewInsets.bottom + 28,
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'پروفایل من',
                style: TextStyle(
                  color: _gold,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: name,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration(
                  'نام و نام خانوادگی',
                  Icons.person_outline,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phone,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration(
                  'شماره موبایل',
                  Icons.phone_outlined,
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    _message(context, 'اطلاعات پروفایل ثبت شد');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF650810),
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: _gold),
                  ),
                  child: const Text(
                    'ثبت اطلاعات',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: _gold),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _gold),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _gold, width: 1.6),
      ),
    );
  }

  void _showMore(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0A0705),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        side: BorderSide(color: _gold),
      ),
      builder: (sheetContext) => SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 26),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'ROYAL CLUB',
                  style: TextStyle(
                    color: _gold,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                _MenuTile(
                  icon: Icons.people_outline,
                  title: 'PEOPLE',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _showProfile(context);
                  },
                ),
                _MenuTile(
                  icon: Icons.workspace_premium_outlined,
                  title: 'PRIVILEGES',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _showInfo(
                      context,
                      'PRIVILEGES',
                      'مزایا، امتیازها و دسترسی‌های اختصاصی اعضای Royal Club.',
                    );
                  },
                ),
                _MenuTile(
                  icon: Icons.auto_awesome_outlined,
                  title: 'EXPERIENCES',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _showInfo(
                      context,
                      'EXPERIENCES',
                      'تجربه‌های ویژه، رویدادها و پیشنهادهای اختصاصی اعضا.',
                    );
                  },
                ),
                _MenuTile(
                  icon: Icons.sports_esports_outlined,
                  title: 'GAMES',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _openCrown(context);
                  },
                ),
                _MenuTile(
                  icon: Icons.card_giftcard_outlined,
                  title: 'REWARDS',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _openRewards(context);
                  },
                ),
                _MenuTile(
                  icon: Icons.card_membership_outlined,
                  title: 'ثبت‌نام',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _showProfile(context);
                  },
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
                Colors.black.withOpacity(.45),
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
                      gaplessPlayback: true,
                    ),

                    // Top menu
                    Positioned(
                      left: 0,
                      top: 0,
                      width: 150,
                      height: 150,
                      child: _TapZone(onTap: () => _showMore(context)),
                    ),

                    // Notification
                    Positioned(
                      left: 790,
                      top: 0,
                      width: 151,
                      height: 145,
                      child: _TapZone(
                        onTap: () => _showInfo(
                          context,
                          'اعلان‌ها',
                          'اعلان‌های Royal Club و پیشنهادهای جدید اینجا نمایش داده می‌شوند.',
                        ),
                      ),
                    ),

                    // Right menu: PEOPLE
                    Positioned(
                      left: 760,
                      top: 135,
                      width: 181,
                      height: 62,
                      child: _TapZone(onTap: () => _showProfile(context)),
                    ),

                    // PRIVILEGES
                    Positioned(
                      left: 760,
                      top: 197,
                      width: 181,
                      height: 58,
                      child: _TapZone(
                        onTap: () => _showInfo(
                          context,
                          'PRIVILEGES',
                          'مزایا و امتیازهای اختصاصی اعضای Royal Club.',
                        ),
                      ),
                    ),

                    // EXPERIENCES
                    Positioned(
                      left: 760,
                      top: 255,
                      width: 181,
                      height: 58,
                      child: _TapZone(
                        onTap: () => _showInfo(
                          context,
                          'EXPERIENCES',
                          'تجربه‌ها و رویدادهای اختصاصی Royal Club.',
                        ),
                      ),
                    ),

                    // GAMES
                    Positioned(
                      left: 760,
                      top: 313,
                      width: 181,
                      height: 58,
                      child: _TapZone(onTap: () => _openCrown(context)),
                    ),

                    // REWARDS
                    Positioned(
                      left: 760,
                      top: 371,
                      width: 181,
                      height: 58,
                      child: _TapZone(
                        onTap: () => _openRewards(context),
                      ),
                    ),

                    // Dedicated RC television above the games section.
                    // Existing artwork, menus, game buttons and rewards remain.
                    const Positioned(
                      left: 104,
                      top: 548,
                      width: 733,
                      height: 414,
                      child: RoyalClubTv(),
                    ),

                    // Deal or No Deal
                    Positioned(
                      left: 205,
                      top: 1000,
                      width: 535,
                      height: 125,
                      child: _TapZone(onTap: () => _openDeal(context)),
                    ),

                    // Games
                    Positioned(
                      left: 62,
                      top: 1130,
                      width: 260,
                      height: 225,
                      child: _TapZone(onTap: () => _openCrown(context)),
                    ),

                    // Profile
                    Positioned(
                      left: 336,
                      top: 1130,
                      width: 260,
                      height: 225,
                      child: _TapZone(onTap: () => _showProfile(context)),
                    ),

                    // Rewards
                    Positioned(
                      left: 610,
                      top: 1130,
                      width: 270,
                      height: 225,
                      child: _TapZone(
                        onTap: () => _openRewards(context),
                      ),
                    ),

                    // Bottom Home
                    Positioned(
                      left: 35,
                      top: 1400,
                      width: 165,
                      height: 145,
                      child: _TapZone(onTap: () => Navigator.of(context).pop()),
                    ),

                    // Bottom Games
                    Positioned(
                      left: 195,
                      top: 1400,
                      width: 175,
                      height: 145,
                      child: _TapZone(onTap: () => _openCrown(context)),
                    ),

                    // Bottom RC
                    Positioned(
                      left: 375,
                      top: 1370,
                      width: 190,
                      height: 185,
                      child: _TapZone(
                        onTap: () => _showInfo(
                          context,
                          'ROYAL CLUB',
                          'MORE THAN A CLUB • A ROYAL LIFESTYLE',
                        ),
                      ),
                    ),

                    // Bottom Royal Mall
                    Positioned(
                      left: 555,
                      top: 1400,
                      width: 180,
                      height: 145,
                      child: _TapZone(onTap: () => _openMall(context)),
                    ),

                    // Bottom More
                    Positioned(
                      left: 735,
                      top: 1400,
                      width: 175,
                      height: 145,
                      child: _TapZone(onTap: () => _showMore(context)),
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

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: const Color(0xFFE8C36A)),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_left,
        color: Color(0xFFE8C36A),
      ),
    );
  }
}
