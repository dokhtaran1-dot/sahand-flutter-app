import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
  bool verifiedMember = false;
  String? memberCode;
  String? avatarUrl;
  String? statusMessage;
  StreamSubscription<Map<String, int>>? _liveTickets;

  @override
  void initState() {
    super.initState();
    _load();
    RoyalScoreStore.revision.addListener(_load);
    _liveTickets = RoyalScoreStore.liveTicketStats().listen((stats) {
      if (!mounted) return;
      setState(() {
        tickets = stats['balance'] ?? 0;
        lifetime = stats['lifetime'] ?? 0;
        loading = false;
      });
    });
  }

  Future<void> _load() async {
    try {
      final client = Supabase.instance.client;
      final user = client.auth.currentUser;
      if (user == null || client.auth.currentSession == null) {
        if (!mounted) return;
        setState(() {
          name = '';
          phone = '';
          displayName = '';
          tickets = 0;
          lifetime = 0;
          verifiedMember = false;
          memberCode = null;
          avatarUrl = null;
          statusMessage = 'برای مشاهدهٔ کارت عضویت، شماره خود را تأیید کنید.';
          loading = false;
        });
        return;
      }
      final record = await client.from('royal_club_members')
          .select('full_name,phone,member_code,avatar_path')
          .eq('user_id', user.id)
          .maybeSingle();
      if (!mounted) return;
      if (record == null) {
        setState(() {
          name = '';
          phone = '';
          verifiedMember = false;
          memberCode = null;
          avatarUrl = null;
          statusMessage = 'حساب وارد شده است؛ تکمیل عضویت لازم است.';
          loading = false;
        });
        return;
      }
      String? signedPhoto;
      final path = record['avatar_path']?.toString();
      if (path != null && path.isNotEmpty) {
        try {
          signedPhoto = await client.storage
              .from('royal-club-avatars').createSignedUrl(path, 3600);
        } catch (_) {}
      }
      final alias = await RoyalScoreStore.displayName();
      final balance = await RoyalScoreStore.ticketBalance();
      final earned = await RoyalScoreStore.lifetimeTickets();
      if (!mounted) return;
      setState(() {
        name = (record['full_name'] ?? '').toString();
        phone = (record['phone'] ?? '').toString();
        memberCode = record['member_code']?.toString();
        avatarUrl = signedPhoto;
        displayName = alias ?? '';
        tickets = balance;
        lifetime = earned;
        verifiedMember = true;
        statusMessage = null;
        loading = false;
      });
    } catch (_) {
      if (mounted) setState(() {
        verifiedMember = false;
        statusMessage = 'در حال حاضر اتصال به سامانه عضویت برقرار نیست.';
        loading = false;
      });
    }
  }

  Future<void> _signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(RoyalClubMembershipPage.fullNameKey);
      await prefs.remove(RoyalClubMembershipPage.phoneKey);
      await prefs.remove(RoyalClubMembershipPage.joinedAtKey);
      await _load();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('خروج از حساب انجام نشد.')),
      );
    }
  }

  @override
  void dispose() {
    RoyalScoreStore.revision.removeListener(_load);
    _liveTickets?.cancel();
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
    final member = verifiedMember;

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
                    radius: 39,
                    backgroundColor: gold,
                    child: CircleAvatar(
                      radius: 36,
                      backgroundColor: const Color(0xFF090706),
                      backgroundImage: member && avatarUrl != null
                        ? NetworkImage(avatarUrl!) : null,
                      child: avatarUrl == null
                        ? Icon(member ? Icons.verified_user_outlined
                            : Icons.person_outline, color: gold, size: 32)
                        : null,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    loading
                        ? '...'
                        : member
                            ? name
                            : 'عضویت تأیید نشده',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    member ? level : 'برای عضویت ثبت‌نام کنید',
                    style: const TextStyle(
                      color: gold,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                  if (member && memberCode != null) ...[
                    const SizedBox(height: 10),
                    Text('شماره عضویت: ' + memberCode!,
                      style: const TextStyle(color: gold)),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(9),
                      color: Colors.white,
                      child: QrImageView(
                        data: 'ROYAL-CLUB:' + memberCode!,
                        version: QrVersions.auto,
                        size: 155,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      'کد مخصوص عضو؛ پذیرش حضوری با اسکن هنوز فعال نیست.',
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 10),
                    ),
                  ],
                  if (!member && statusMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(statusMessage!,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70, fontSize: 12)),
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
              title: member ? 'ویرایش عضویت و عکس پروفایل' : 'ثبت‌نام و فعال‌سازی عضویت',
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
              onTap: member ? _editDisplayName : () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const RoyalClubMembershipPage()),
              ),
            ),
            if (member)
              _Action(
                icon: Icons.logout,
                title: 'خروج امن از حساب',
                onTap: _signOut,
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
