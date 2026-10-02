import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'royal_club_membership_page.dart';
import 'royal_club_privileges_page.dart';
import 'royal_score_store.dart';

class RoyalClubProfilePage extends StatefulWidget {
  const RoyalClubProfilePage({super.key});

  @override
  State<RoyalClubProfilePage> createState() => _RoyalClubProfilePageState();
}

class _RoyalClubProfilePageState extends State<RoyalClubProfilePage> {
  static const gold = Color(0xFFE8C36A);

  String name = '';
  String phone = '';
  String displayName = '';
  int tickets = 0;
  int lifetime = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
    RoyalScoreStore.revision.addListener(_load);
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final currentDisplay = await RoyalScoreStore.displayName();
    final currentTickets = await RoyalScoreStore.ticketBalance();
    final currentLifetime = await RoyalScoreStore.lifetimeTickets();
    if (!mounted) return;
    setState(() {
      name =
          prefs.getString(RoyalClubMembershipPage.fullNameKey)?.trim() ?? '';
      phone = prefs.getString(RoyalClubMembershipPage.phoneKey)?.trim() ?? '';
      displayName = currentDisplay ?? '';
      tickets = currentTickets;
      lifetime = currentLifetime;
      loading = false;
    });
  }

  @override
  void dispose() {
    RoyalScoreStore.revision.removeListener(_load);
    super.dispose();
  }

  String get level {
    if (lifetime >= 15000) return 'DIAMOND';
    if (lifetime >= 5000) return 'BLACK';
    if (lifetime >= 1000) return 'GOLD';
    return 'SILVER';
  }

  Future<void> _editDisplayName() async {
    final controller = TextEditingController(text: displayName);
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF16090B),
        title: const Text(
          'نام نمایشی بازی‌ها',
          textDirection: TextDirection.rtl,
          style: TextStyle(color: gold),
        ),
        content: TextField(
          controller: controller,
          textDirection: TextDirection.rtl,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'نام نمایشی',
            hintStyle: TextStyle(color: Colors.white38),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: gold),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: gold),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('لغو'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('ذخیره', style: TextStyle(color: gold)),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result == null) return;
    try {
      await RoyalScoreStore.saveDisplayName(result);
      await _load();
    } on FormatException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final member = name.isNotEmpty && phone.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF16090B),
        foregroundColor: gold,
        centerTitle: true,
        title: const Text('ROYAL CLUB • PROFILE'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: gold),
                gradient: const LinearGradient(
                  colors: [Color(0xFF50101A), Color(0xFF16090B), Color(0xFF25170A)],
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: const Color(0xFF090706),
                    child: Text(
                      name.isNotEmpty ? name.characters.first : 'R',
                      style: const TextStyle(
                        color: gold,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    loading
                        ? '...'
                        : member
                            ? name
                            : 'ROYAL CLUB MEMBER',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    level,
                    style: const TextStyle(
                      color: gold,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.4,
                    ),
                  ),
                  if (member) ...[
                    const SizedBox(height: 7),
                    Text(
                      phone,
                      style: const TextStyle(color: Colors.white60),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _Stat(label: 'تیکت', value: '$tickets')),
                const SizedBox(width: 10),
                Expanded(child: _Stat(label: 'کل تیکت', value: '$lifetime')),
              ],
            ),
            const SizedBox(height: 16),
            _Action(
              icon: Icons.workspace_premium_outlined,
              title: member ? 'ویرایش عضویت' : 'فعال‌سازی عضویت',
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const RoyalClubMembershipPage(),
                  ),
                );
                await _load();
              },
            ),
            _Action(
              icon: Icons.badge_outlined,
              title: displayName.isEmpty
                  ? 'ثبت نام نمایشی بازی‌ها'
                  : 'نام نمایشی: $displayName',
              onTap: _editDisplayName,
            ),
            _Action(
              icon: Icons.diamond_outlined,
              title: 'امتیازات و مزایا',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const RoyalClubPrivilegesPage(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF160E0C),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0x66E8C36A)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFFE8C36A),
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              label,
              textDirection: TextDirection.rtl,
              style: const TextStyle(color: Colors.white60),
            ),
          ],
        ),
      );
}

class _Action extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _Action({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Material(
          color: const Color(0xFF160E0C),
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
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
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_left_rounded,
                      color: Color(0xFFE8C36A)),
                ],
              ),
            ),
          ),
        ),
      );
}
