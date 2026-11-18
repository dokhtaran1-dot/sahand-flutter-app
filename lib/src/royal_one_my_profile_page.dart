import 'package:flutter/material.dart';

import 'heritage_page.dart';
import 'royal_club_profile_page.dart';
import 'royal_explore_page.dart';

/// The second-page My Profile destination in Royal One.
///
/// This is intentionally separate from the Royal Club membership/account page.
/// Its two photo slots and personal-information areas are deliberately empty
/// until the owner supplies approved content. No stock photos, fabricated
/// biography or copied membership information are inserted here.
class RoyalOneMyProfilePage extends StatelessWidget {
  const RoyalOneMyProfilePage({super.key});

  static const Color _background = Color(0xFF04150F);
  static const Color _emerald = Color(0xFF103B2C);
  static const Color _gold = Color(0xFFDFC18A);
  static const Color _muted = Color(0xFFC5CDBF);

  void _open(BuildContext context, Widget destination) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey('royal-one-my-profile'),
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF09241A),
        foregroundColor: _gold,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'MY PROFILE',
          style: TextStyle(
            color: _gold,
            letterSpacing: 2.8,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            tooltip: 'منوی پروفایل',
            icon: const Icon(Icons.more_vert_rounded, color: _gold),
            color: const Color(0xFF103427),
            onSelected: (choice) {
              if (choice == 'heritage') {
                _open(context, const HeritagePage());
              } else if (choice == 'club') {
                _open(context, const RoyalClubProfilePage());
              } else if (choice == 'explore') {
                _open(context, const RoyalExplorePage());
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'heritage', child: Text('میراث سهند')),
              PopupMenuItem(value: 'club', child: Text('حساب رویال کلاب')),
              PopupMenuItem(value: 'explore', child: Text('مجموعه‌ها')),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: _gold.withOpacity(.72)),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF164532),
                        Color(0xFF0B271C),
                        Color(0xFF04150F),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _gold.withOpacity(.12),
                        blurRadius: 28,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.fromLTRB(17, 22, 17, 22),
                  child: Column(
                    children: [
                      const Text(
                        'ROYAL ONE',
                        style: TextStyle(
                          color: _gold,
                          fontSize: 13,
                          letterSpacing: 4,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Container(height: 1, width: 92, color: _gold),
                      const SizedBox(height: 16),
                      const Text(
                        'پروفایل اختصاصی',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'PERSONAL PROFILE',
                        style: TextStyle(
                          color: _muted,
                          fontSize: 11,
                          letterSpacing: 2.2,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: const [
                          Expanded(
                            child: _EmptyPhotoSlot(
                              slotKey: 'my-profile-photo-1',
                              label: 'تصویر اصلی',
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _EmptyPhotoSlot(
                              slotKey: 'my-profile-photo-2',
                              label: 'تصویر دوم',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A291E),
                    border: Border.all(color: const Color(0x77DFC18A)),
                    borderRadius: BorderRadius.circular(23),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'اطلاعات اختصاصی',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: _gold,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 14),
                      _EmptyDetail(label: 'نام و عنوان'),
                      SizedBox(height: 11),
                      _EmptyDetail(label: 'معرفی کوتاه'),
                      SizedBox(height: 11),
                      _EmptyDetail(label: 'اطلاعات تکمیلی'),
                    ],
                  ),
                ),
                const SizedBox(height: 21),
                const Text(
                  'دسترسی به بخش‌های اپ',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: _gold,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                _NavigationTile(
                  key: const ValueKey('my-profile-club-action'),
                  icon: Icons.workspace_premium_outlined,
                  title: 'حساب رویال کلاب',
                  subtitle: 'عضویت، تیکت‌ها و امتیازات',
                  onTap: () => _open(context, const RoyalClubProfilePage()),
                ),
                _NavigationTile(
                  key: const ValueKey('my-profile-heritage-action'),
                  icon: Icons.auto_stories_outlined,
                  title: 'میراث کنسرسیوم سهند',
                  subtitle: 'OUR HERITAGE',
                  onTap: () => _open(context, const HeritagePage()),
                ),
                _NavigationTile(
                  key: const ValueKey('my-profile-explore-action'),
                  icon: Icons.explore_outlined,
                  title: 'مجموعه‌های رویال وان',
                  subtitle: 'EXPLORE',
                  onTap: () => _open(context, const RoyalExplorePage()),
                ),
                const SizedBox(height: 20),
                const Text(
                  'One Entrance. A Whole Royal World.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _muted, fontSize: 11, letterSpacing: 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyPhotoSlot extends StatelessWidget {
  const _EmptyPhotoSlot({required this.slotKey, required this.label});

  final String slotKey;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label: هنوز تصویری انتخاب نشده',
      child: Container(
        key: ValueKey(slotKey),
        height: 158,
        decoration: BoxDecoration(
          color: const Color(0xFF09251A),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xBBDFC18A), width: 1.1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.image_outlined, color: Color(0x80DFC18A), size: 30),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(color: Color(0xFFDFC18A), fontSize: 13),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyDetail extends StatelessWidget {
  const _EmptyDetail({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) => Semantics(
        label: '$label: هنوز تکمیل نشده',
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            SizedBox(
              width: 95,
              child: Text(
                label,
                style: const TextStyle(
                  color: Color(0xFFC5CDBF),
                  fontSize: 12,
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                  color: const Color(0xFF061B13),
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: const Color(0x66DFC18A)),
                ),
              ),
            ),
          ],
        ),
      );
}

class _NavigationTile extends StatelessWidget {
  const _NavigationTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 9),
        child: Material(
          color: const Color(0xFF0B2B20),
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0x77DFC18A)),
              ),
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  Icon(icon, color: const Color(0xFFDFC18A)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          title,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          subtitle,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                            color: Color(0xFFC5CDBF),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_left_rounded,
                      color: Color(0xFFDFC18A)),
                ],
              ),
            ),
          ),
        ),
      );
}
