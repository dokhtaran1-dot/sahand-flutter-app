import 'package:flutter/material.dart';

import 'royal_crown_game_page.dart';
import 'royal_deal_page.dart';

class RoyalClubGamePage extends StatelessWidget {
  const RoyalClubGamePage({super.key});

  static const Color _gold = Color(0xFFE8C36A);
  static const Color _burgundy = Color(0xFF6D0711);

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
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -.55),
              radius: 1.2,
              colors: [Color(0xFF24130A), Color(0xFF070707), Colors.black],
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 12, 2),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _gold),
                    ),
                    const Spacer(),
                    const Text(
                      'ROYAL CLUB',
                      style: TextStyle(
                        color: _gold,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.5,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => _message(context, 'اعلان‌های باشگاه'),
                      icon: const Icon(Icons.notifications_none_rounded, color: _gold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 6, 18, 110),
                  child: Column(
                    children: [
                      const Text(
                        'Rc',
                        style: TextStyle(
                          color: _gold,
                          fontSize: 76,
                          fontFamily: 'serif',
                          fontWeight: FontWeight.w700,
                          letterSpacing: -4,
                        ),
                      ),
                      const Text(
                        'باشگاه رویال',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 29,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'MORE THAN A CLUB  •  A ROYAL LIFESTYLE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 10,
                          letterSpacing: 2.2,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Crown + Deal or No Deal only. No cards and no chips.
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0C0907),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: _gold.withOpacity(.7)),
                          boxShadow: [
                            BoxShadow(color: _gold.withOpacity(.10), blurRadius: 26),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.workspace_premium_rounded, color: _gold, size: 86),
                                SizedBox(width: 22),
                                Icon(Icons.business_center_rounded, color: _gold, size: 86),
                              ],
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              'DEAL OR NO DEAL',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 7),
                            const Text(
                              'بازی ویژه اعضای باشگاه رویال',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(color: _gold, fontSize: 15),
                            ),
                            const SizedBox(height: 18),
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton.icon(
                                onPressed: () => _openDeal(context),
                                icon: const Icon(Icons.play_arrow_rounded),
                                label: const Text(
                                  'شروع DEAL OR NO DEAL',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _burgundy,
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: _gold),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.35,
                        children: [
                          _RcTile(
                            icon: Icons.emoji_events_outlined,
                            title: 'تاج رویال',
                            subtitle: 'چالش و امتیاز',
                            onTap: () => _openCrown(context),
                          ),
                          _RcTile(
                            icon: Icons.sports_esports_outlined,
                            title: 'بازی‌ها',
                            subtitle: 'چالش‌های باشگاه',
                            onTap: () => _openCrown(context),
                          ),
                          _RcTile(
                            icon: Icons.person_outline_rounded,
                            title: 'پروفایل من',
                            subtitle: 'اطلاعات و عضویت',
                            onTap: () => _message(context, 'پروفایل در حال تکمیل است'),
                          ),
                          _RcTile(
                            icon: Icons.card_membership_rounded,
                            title: 'ثبت‌نام',
                            subtitle: 'عضویت در Royal Club',
                            onTap: () => _message(context, 'فرم ثبت‌نام در حال تکمیل است'),
                          ),
                          _RcTile(
                            icon: Icons.card_giftcard_rounded,
                            title: 'جوایز ویژه',
                            subtitle: 'امتیاز و هدایا',
                            onTap: () => _message(context, 'جوایز ویژه'),
                          ),
                          _RcTile(
                            icon: Icons.local_offer_outlined,
                            title: 'پیشنهادهای خاص',
                            subtitle: 'ویژه اعضا',
                            onTap: () => _message(context, 'پیشنهادهای اختصاصی Royal Club'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            color: const Color(0xFF090806),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: _gold.withOpacity(.65)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BottomItem(
                icon: Icons.home_rounded,
                label: 'خانه',
                onTap: () => Navigator.of(context).pop(),
              ),
              _BottomItem(
                icon: Icons.sports_esports_outlined,
                label: 'بازی‌ها',
                onTap: () => _openCrown(context),
              ),
              _BottomItem(
                icon: Icons.workspace_premium_rounded,
                label: 'RC',
                onTap: () {},
                active: true,
              ),
              _BottomItem(
                icon: Icons.person_outline_rounded,
                label: 'پروفایل',
                onTap: () => _message(context, 'پروفایل در حال تکمیل است'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RcTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _RcTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF0D0A08),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: RoyalClubGamePage._gold.withOpacity(.45)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: RoyalClubGamePage._gold, size: 31),
            const SizedBox(height: 8),
            Text(
              title,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white54, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool active;

  const _BottomItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? Colors.white : RoyalClubGamePage._gold;
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 25),
            const SizedBox(height: 3),
            Text(label, style: TextStyle(color: color, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
