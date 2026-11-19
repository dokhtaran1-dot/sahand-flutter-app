import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'my_reservations_page.dart';
import 'royal_club_game_page.dart';
import 'royal_club_membership_page.dart';
import 'royal_club_privileges_page.dart';
import 'royal_club_profile_page.dart';
import 'royal_score_store.dart';
import 'reservation_store.dart';

/// ROYAL ONE > PROFILE: the compact black-and-champagne-gold member dashboard
/// from the owner's approved eight-screen Royal One reference poster.
/// No invented portrait, numeric points, real offers, or fake scannable QR code.
class RoyalOneMyProfilePage extends StatefulWidget {
  const RoyalOneMyProfilePage({super.key});

  @override
  State<RoyalOneMyProfilePage> createState() => _RoyalOneMyProfilePageState();
}

class _RoyalOneMyProfilePageState extends State<RoyalOneMyProfilePage> {
  static const _bg = Color(0xFF030907);
  static const _panel = Color(0xFF081611);
  static const _gold = Color(0xFFDABB80);
  static const _muted = Color(0xFFA4A99F);

  String _name = '';
  String _phone = '';
  int? _localTickets;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadMember();
    RoyalScoreStore.revision.addListener(_loadMember);
  }

  @override
  void dispose() {
    RoyalScoreStore.revision.removeListener(_loadMember);
    super.dispose();
  }

  Future<void> _loadMember() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int? balance;
      try {
        balance = await RoyalScoreStore.ticketBalance();
      } catch (_) {
        // Read-only preview can render even before account backend is ready.
      }
      if (!mounted) return;
      setState(() {
        _name = prefs.getString(RoyalClubMembershipPage.fullNameKey)?.trim() ?? '';
        _phone = prefs.getString(RoyalClubMembershipPage.phoneKey)?.trim() ?? '';
        _localTickets = balance;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _open(Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    ).then((_) {
      if (mounted) _loadMember();
    });
  }

  void _openMembership() => _open(const RoyalClubMembershipPage());
  void _openReservations() => _open(const MyReservationsPage());
  void _openPoints() => _open(const RoyalClubPrivilegesPage());
  void _openOffers() => _open(const RoyalClubPrivilegesPage());
  void _openSettings() => _open(const RoyalClubProfilePage());
  void _openNotifications() => _open(const _ProfileNotificationsPage());

  void _home() {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) navigator.pop();
  }

  String get _memberName => _name.isEmpty ? 'ROYAL ONE GUEST' : _name;
  String get _membershipText =>
      _phone.isEmpty ? 'Guest · مهمان' : 'ثبت محلی · تأیید عضویت لازم است';

  Widget _membershipCode() => InkWell(
    key: const ValueKey('profile-membership-code-action'),
    borderRadius: BorderRadius.circular(10),
    onTap: _openMembership,
    child: Container(
      width: 122,
      constraints: const BoxConstraints(minHeight: 100),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _gold, width: 1),
      ),
      padding: const EdgeInsets.all(10),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.qr_code_2_rounded, size: 44, color: Color(0xFF929292)),
          SizedBox(height: 5),
          Text('QR غیرفعال',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF333333), fontSize: 11)),
          SizedBox(height: 2),
          Text('فعالسازی عضویت',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF444444), fontSize: 9)),
        ],
      ),
    ),
  );

  Widget _profileHeader() => Column(
    children: [
      const SizedBox(height: 10),
      Container(
        key: const ValueKey('my-profile-avatar-placeholder'),
        width: 92,
        height: 92,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF101B17),
          border: Border.all(color: _gold, width: 1.5),
        ),
        child: const Icon(Icons.person_outline_rounded, size: 48, color: _gold),
      ),
      const SizedBox(height: 12),
      Text(
        _loading ? '...' : _memberName,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: .5,
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        _membershipText,
        style: const TextStyle(color: _gold, fontSize: 12),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 18),
      _membershipCode(),
      const SizedBox(height: 8),
      const Text(
        'کارت و QR معتبر پس از فعال‌سازی سامانه عضویت',
        style: TextStyle(color: _muted, fontSize: 10),
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
      ),
      const SizedBox(height: 23),
    ],
  );

  Widget _menuTile({
    required String keyName,
    required IconData icon,
    required String title,
    String? trailing,
    required VoidCallback onTap,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 2),
    child: Material(
      color: _panel,
      child: InkWell(
        key: ValueKey(keyName),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 66),
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0x334A765D))),
          ),
          child: Row(
            children: [
              Icon(icon, color: _gold, size: 22),
              const SizedBox(width: 13),
              Expanded(
                child: Text(title, style: const TextStyle(
                  color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500,
                )),
              ),
              if (trailing != null)
                Text(trailing, style: const TextStyle(
                  color: _gold, fontSize: 12,
                )),
              const SizedBox(width: 7),
              const Icon(Icons.chevron_right_rounded, color: _gold, size: 19),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _bottomBar() => Container(
    decoration: const BoxDecoration(
      color: Color(0xFF050B09),
      border: Border(top: BorderSide(color: Color(0x66DABB80), width: .6)),
    ),
    child: SafeArea(
      top: false,
      child: SizedBox(
        height: 61,
        child: Row(
          children: [
            _tab('Home', Icons.home_outlined, _home),
            _tab('Reservations', Icons.calendar_month_outlined, _openReservations),
            _tab('Club', Icons.star_border_rounded,
                () => _open(const RoyalClubGamePage())),
            _tab('Profile', Icons.person_rounded, () {}, selected: true),
          ],
        ),
      ),
    ),
  );

  Widget _tab(String label, IconData icon, VoidCallback onTap,
      {bool selected = false}) => Expanded(
    child: InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 21, color: selected ? _gold : _muted),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(
            color: selected ? _gold : _muted, fontSize: 10,
          )),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey('royal-one-my-profile'),
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        centerTitle: true,
        foregroundColor: _gold,
        title: const Text(
          'PROFILE',
          style: TextStyle(
            color: _gold,
            letterSpacing: 2.2,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 2, 18, 24),
              children: [
                _profileHeader(),
                _menuTile(
                  keyName: 'my-profile-reservations-action',
                  icon: Icons.calendar_month_outlined,
                  title: 'My Reservations · رزروهای من',
                  onTap: _openReservations,
                ),
                _menuTile(
                  keyName: 'my-profile-points-action',
                  icon: Icons.auto_awesome_outlined,
                  title: 'My Points · امتیازات من',
                  trailing: _loading ? '…' : (_localTickets?.toString() ?? '—'),
                  onTap: _openPoints,
                ),
                _menuTile(
                  keyName: 'my-profile-offers-action',
                  icon: Icons.local_offer_outlined,
                  title: 'My Offers · پیشنهادهای من',
                  onTap: _openOffers,
                ),
                _menuTile(
                  keyName: 'my-profile-notifications-action',
                  icon: Icons.notifications_none_rounded,
                  title: 'Notifications · اعلان‌ها',
                  onTap: _openNotifications,
                ),
                _menuTile(
                  keyName: 'my-profile-settings-action',
                  icon: Icons.settings_outlined,
                  title: 'Settings · تنظیمات حساب',
                  onTap: _openSettings,
                ),
                const SizedBox(height: 13),
                const Text(
                  'تیکت‌های نمایش‌داده‌شده ممکن است محلی باشند؛ جوایز نیازمند تأیید سرور هستند.',
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _muted, fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _bottomBar(),
    );
  }
}

class _ProfileNotificationsPage extends StatelessWidget {
  const _ProfileNotificationsPage();

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF030907),
    appBar: AppBar(
      backgroundColor: const Color(0xFF030907),
      foregroundColor: const Color(0xFFDABB80),
      title: const Text('NOTIFICATIONS'),
    ),
    body: const Center(
      child: Padding(
        padding: EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.notifications_none_rounded,
                color: Color(0xFFDABB80), size: 48),
            SizedBox(height: 16),
            Text('سامانه اعلان‌ها هنوز فعال نشده است.',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16)),
          ],
        ),
      ),
    ),
  );
}
