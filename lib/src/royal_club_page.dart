import 'package:flutter/material.dart';

import 'royal_club_game_page.dart';
import 'royal_deal_page.dart';

class RoyalClubPage extends StatelessWidget {
  const RoyalClubPage({super.key});

  static const double _designWidth = 941;
  static const double _designHeight = 1672;
  static const Color _gold = Color(0xFFE8C36A);

  void _openDeal(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RoyalDealPage()),
    );
  }

  void _openCrownGame(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RoyalClubGamePage()),
    );
  }

  void _goHome(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _showClubInfo(BuildContext context) {
    _sheet(
      context,
      title: 'ROYAL CLUB',
      child: const Text(
        'باشگاه رویال برای اعضای ویژه، بازی‌ها، امتیازها، جوایز و تجربه‌های اختصاصی طراحی شده است.',
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        style: TextStyle(color: Colors.white, fontSize: 16, height: 1.8),
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    _sheet(
      context,
      title: 'اعلان‌های Royal Club',
      child: const Column(
        children: [
          _InfoTile(icon: Icons.notifications_active_outlined, title: 'Royal Deal', subtitle: 'آفرها و نتایج بازی‌های شما اینجا نمایش داده می‌شود.'),
          _InfoTile(icon: Icons.workspace_premium_outlined, title: 'جوایز ویژه', subtitle: 'پیشنهادها و امتیازهای جدید Royal Club را از این بخش دنبال کنید.'),
        ],
      ),
    );
  }

  void _showRewards(BuildContext context) {
    _sheet(
      context,
      title: 'جوایز ویژه',
      child: const Column(
        children: [
          _InfoTile(icon: Icons.confirmation_number_outlined, title: 'R1 Tickets', subtitle: 'امتیاز و تیکت‌های R1'),
          _InfoTile(icon: Icons.restaurant_outlined, title: 'Dinner for Two', subtitle: 'جایزه ویژه Royal Village'),
          _InfoTile(icon: Icons.local_parking_outlined, title: 'VIP Parking', subtitle: 'پارکینگ ویژه'),
          _InfoTile(icon: Icons.music_note_outlined, title: 'Live Music VIP', subtitle: 'تجربه موسیقی زنده VIP'),
          _InfoTile(icon: Icons.nightlife_outlined, title: 'VIP Night', subtitle: 'Royal Village VIP Night'),
        ],
      ),
    );
  }

  void _showProfile(BuildContext context) {
    final name = TextEditingController();
    final phone = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0B0704),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        side: BorderSide(color: _gold),
      ),
      builder: (sheetContext) {
        return Padding(
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
                  decoration: _input('نام و نام خانوادگی', Icons.person_outline),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phone,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: Colors.white),
                  decoration: _input('شماره موبایل', Icons.phone_outlined),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          const SnackBar(
                            backgroundColor: Color(0xFF160A05),
                            content: Text(
                              'اطلاعات پروفایل ثبت شد',
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5B0710),
                      foregroundColor: _gold,
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
        );
      },
    );
  }

  InputDecoration _input(String label, IconData icon) {
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
      backgroundColor: const Color(0xFF0B0704),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        side: BorderSide(color: _gold),
      ),
      builder: (sheetContext) => SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'ROYAL CLUB',
                  style: TextStyle(color: _gold, fontSize: 21, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 14),
                _MenuButton(title: 'PEOPLE', icon: Icons.people_outline, onTap: () { Navigator.pop(sheetContext); _showClubInfo(context); }),
                _MenuButton(title: 'PRIVILEGES', icon: Icons.workspace_premium_outlined, onTap: () { Navigator.pop(sheetContext); _showRewards(context); }),
                _MenuButton(title: 'EXPERIENCES', icon: Icons.auto_awesome_outlined, onTap: () { Navigator.pop(sheetContext); _showClubInfo(context); }),
                _MenuButton(title: 'GAMES', icon: Icons.emoji_events_outlined, onTap: () { Navigator.pop(sheetContext); _openCrownGame(context); }),
                _MenuButton(title: 'REWARDS', icon: Icons.card_giftcard_outlined, onTap: () { Navigator.pop(sheetContext); _showRewards(context); }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _sheet(BuildContext context, {required String title, required Widget child}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0B0704),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        side: BorderSide(color: _gold),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(color: _gold, fontSize: 22, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 18),
              child,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.fill,
          alignment: Alignment.center,
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            width: _designWidth,
            height: _designHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/image/Rc_page2.png',
                  width: _designWidth,
                  height: _designHeight,
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                  gaplessPlayback: true,
                ),

                // Top menu
                Positioned(
                  left: 18,
                  top: 10,
                  width: 110,
                  height: 105,
                  child: _TapZone(onTap: () => _showMore(context)),
                ),

                // Notifications
                Positioned(
                  left: 812,
                  top: 8,
                  width: 115,
                  height: 105,
                  child: _TapZone(onTap: () => _showNotifications(context)),
                ),

                // Main Deal or No Deal CTA
                Positioned(
                  left: 195,
                  top: 990,
                  width: 540,
                  height: 125,
                  child: _TapZone(onTap: () => _openDeal(context)),
                ),

                // Games card
                Positioned(
                  left: 55,
                  top: 1125,
                  width: 270,
                  height: 230,
                  child: _TapZone(onTap: () => _openCrownGame(context)),
                ),

                // My profile card
                Positioned(
                  left: 332,
                  top: 1125,
                  width: 270,
                  height: 230,
                  child: _TapZone(onTap: () => _showProfile(context)),
                ),

                // Rewards card
                Positioned(
                  left: 607,
                  top: 1125,
                  width: 275,
                  height: 230,
                  child: _TapZone(onTap: () => _showRewards(context)),
                ),

                // Bottom: Home
                Positioned(
                  left: 35,
                  top: 1410,
                  width: 165,
                  height: 135,
                  child: _TapZone(onTap: () => _goHome(context)),
                ),

                // Bottom: Games
                Positioned(
                  left: 195,
                  top: 1410,
                  width: 180,
                  height: 135,
                  child: _TapZone(onTap: () => _openCrownGame(context)),
                ),

                // Bottom: RC center
                Positioned(
                  left: 380,
                  top: 1380,
                  width: 180,
                  height: 175,
                  child: _TapZone(onTap: () => _showClubInfo(context)),
                ),

                // Bottom: Royal Mall
                Positioned(
                  left: 550,
                  top: 1410,
                  width: 185,
                  height: 135,
                  child: _TapZone(onTap: () => _goHome(context)),
                ),

                // Bottom: More
                Positioned(
                  left: 735,
                  top: 1410,
                  width: 170,
                  height: 135,
                  child: _TapZone(onTap: () => _showMore(context)),
                ),
              ],
            ),
          ),
        ),
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

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: _RoyalClubPageGold.value),
      title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _MenuButton({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: const Color(0xFFE8C36A)),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2),
      ),
      trailing: const Icon(Icons.chevron_left, color: Color(0xFFE8C36A)),
    );
  }
}

class _RoyalClubPageGold {
  static const int value = 0xFFE8C36A;
}
