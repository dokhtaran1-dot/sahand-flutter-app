import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'royal_club_member_service.dart';
import 'royal_club_membership_page.dart';
import 'royal_club_privileges_page.dart';
import 'royal_score_store.dart';

/// The private member card only renders when a verified remote member exists.
class RoyalClubProfilePage extends StatefulWidget {
  const RoyalClubProfilePage({super.key});

  @override
  State<RoyalClubProfilePage> createState() => _RoyalClubProfilePageState();
}

class _RoyalClubProfilePageState extends State<RoyalClubProfilePage> {
  static const gold = Color(0xFFE8C36A);
  static const cream = Color(0xFFF4EAD8);
  static const dark = Color(0xFF110D0B);
  static const bucket = 'royal-club-avatars';

  RoyalClubMember? member;
  String? imageUrl;
  Uint8List? avatarBytes;
  String? error;
  bool loading = true;
  bool working = false;
  int tickets = 0;
  int lifetime = 0;

  SupabaseClient get db => RoyalClubMemberService.client;

  @override
  void initState() {
    super.initState();
    _load();
    RoyalScoreStore.revision.addListener(_refreshCounters);
  }

  Future<void> _refreshCounters() async {
    try {
      final b = await RoyalScoreStore.ticketBalance();
      final l = await RoyalScoreStore.lifetimeTickets();
      if (mounted && member != null) {
        setState(() { tickets = b; lifetime = l; });
      }
    } catch (_) {}
  }

  Future<void> _load() async {
    if (mounted) setState(() { loading = true; error = null; });
    try {
      final row = await RoyalClubMemberService.loadCurrent();
      if (!mounted) return;
      setState(() {
        member = row;
        imageUrl = null;
        avatarBytes = null;
        loading = false;
      });
      if (row != null) {
        await _refreshCounters();
        await _loadAvatar(row);
      }
    } catch (_) {
      if (mounted) setState(() {
        member = null;
        loading = false;
        error = 'بررسی عضویت انجام نشد. اینترنت را بررسی کنید و دوباره تلاش کنید.';
      });
    }
  }

  Future<void> _loadAvatar(RoyalClubMember row) async {
    final path = row.avatarPath;
    if (path == null || !path.startsWith(row.userId + '/')) return;
    try {
      final url = await db.storage.from(bucket).createSignedUrl(path, 3600);
      if (mounted && member?.userId == row.userId) {
        setState(() => imageUrl = url);
      }
    } catch (_) {
      // No public fallback for private profile pictures.
    }
  }

  Future<void> _pickPhoto() async {
    final current = member;
    if (working || current == null) return;
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
        requestFullMetadata: false,
      );
      if (picked == null) return;
      final data = await picked.readAsBytes();
      if (data.isEmpty || data.lengthInBytes > 2 * 1024 * 1024) {
        _message('عکس انتخابی باید کمتر از دو مگابایت باشد.');
        return;
      }
      // Determine the MIME type from actual bytes, not the file name.
      String? mime;
      String? extension;
      if (data.length >= 3 && data[0] == 0xFF &&
          data[1] == 0xD8 && data[2] == 0xFF) {
        mime = 'image/jpeg';
        extension = 'jpg';
      } else if (data.length >= 4 && data[0] == 0x89 &&
          data[1] == 0x50 && data[2] == 0x4E && data[3] == 0x47) {
        mime = 'image/png';
        extension = 'png';
      } else if (data.length >= 12 &&
          String.fromCharCodes(data.sublist(0, 4)) == 'RIFF' &&
          String.fromCharCodes(data.sublist(8, 12)) == 'WEBP') {
        mime = 'image/webp';
        extension = 'webp';
      } else {
        _message('فرمت عکس باید JPG، PNG یا WebP باشد.');
        return;
      }
      if (!mounted) return;
      setState(() => working = true);
      final path = current.userId + '/avatar.' + extension;
      await db.storage.from(bucket).uploadBinary(
        path,
        data,
        fileOptions: FileOptions(contentType: mime, upsert: true),
      );
      await db.from('royal_club_members')
          .update({'avatar_path': path})
          .eq('user_id', current.userId);
      if (current.avatarPath != null && current.avatarPath != path) {
        try {
          await db.storage.from(bucket).remove([current.avatarPath!]);
        } catch (_) {
          // Old private file remains inaccessible to other users.
        }
      }
      if (!mounted) return;
      await _load();
      if (!mounted) return;
      setState(() => avatarBytes = data);
      _message('عکس خصوصی پروفایل ذخیره شد.');
    } catch (_) {
      _message('بارگذاری عکس انجام نشد؛ اتصال اینترنت را بررسی کنید.');
    } finally {
      if (mounted) setState(() => working = false);
    }
  }

  Future<void> _removePhoto() async {
    final current = member;
    final path = current?.avatarPath;
    if (working || current == null || path == null) return;
    setState(() => working = true);
    try {
      await db.from('royal_club_members')
          .update({'avatar_path': null})
          .eq('user_id', current.userId);
      try {
        await db.storage.from(bucket).remove([path]);
      } catch (_) {
        // Database no longer exposes the old private avatar.
      }
      if (!mounted) return;
      await _load();
      _message('عکس پروفایل حذف شد.');
    } catch (_) {
      _message('حذف عکس انجام نشد؛ دوباره تلاش کنید.');
    } finally {
      if (mounted) setState(() => working = false);
    }
  }

  void _message(String value) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(value, textDirection: TextDirection.rtl)),
    );
  }

  Future<void> _editAlias() async {
    final current = member;
    if (current == null || working) return;
    final input = TextEditingController(text: current.displayName ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF14281B),
        title: const Text('نام نمایشی', textDirection: TextDirection.rtl,
          style: TextStyle(color: gold)),
        content: TextField(
          controller: input,
          maxLength: 30,
          textDirection: TextDirection.rtl,
          style: const TextStyle(color: cream),
          decoration: const InputDecoration(
            hintText: 'نامی که دیگران در بازی می‌بینند',
            hintStyle: TextStyle(color: Colors.white54),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('انصراف')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, input.text.trim()),
            child: const Text('ذخیره', style: TextStyle(color: gold))),
        ],
      ),
    );
    input.dispose();
    if (result == null) return;
    if (result.isNotEmpty && (result.length < 2 || result.length > 30)) {
      _message('نام نمایشی باید بین ۲ تا ۳۰ کاراکتر باشد.');
      return;
    }
    setState(() => working = true);
    try {
      await db.from('royal_club_members')
          .update({'display_name': result.isEmpty ? null : result})
          .eq('user_id', current.userId);
      if (result.isNotEmpty) {
        try { await RoyalScoreStore.saveDisplayName(result); } catch (_) {}
      }
      await _load();
      _message('نام نمایشی در پروفایل ذخیره شد.');
    } catch (_) {
      _message('نام نمایشی ذخیره نشد؛ دوباره تلاش کنید.');
    } finally {
      if (mounted) setState(() => working = false);
    }
  }

  Future<void> _logout() async {
    if (working) return;
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF15221B),
        title: const Text('خروج از حساب', textDirection: TextDirection.rtl,
          style: TextStyle(color: gold)),
        content: const Text(
          'با خروج، برای ورود دوباره باید شمارهٔ موبایل را با پیامک تأیید کنید.',
          textDirection: TextDirection.rtl,
          style: TextStyle(color: cream)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false),
              child: const Text('انصراف')),
          TextButton(onPressed: () => Navigator.pop(ctx, true),
              child: const Text('خروج', style: TextStyle(color: gold))),
        ],
      ),
    );
    if (yes != true || !mounted) return;
    setState(() => working = true);
    try {
      await RoyalClubMemberService.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(RoyalClubMembershipPage.fullNameKey);
      await prefs.remove(RoyalClubMembershipPage.phoneKey);
      await prefs.remove(RoyalClubMembershipPage.joinedAtKey);
      if (mounted) setState(() {
        member = null;
        imageUrl = null;
        avatarBytes = null;
        tickets = 0;
        lifetime = 0;
        working = false;
      });
    } catch (_) {
      if (mounted) setState(() => working = false);
      _message('خروج از حساب انجام نشد.');
    }
  }

  void _showQr() {
    final current = member;
    if (current == null) return;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0D2017),
        title: const Text('کارت عضویت رویال کلاب',
          textAlign: TextAlign.center,
          style: TextStyle(color: gold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(14),
              child: QrImageView(
                data: 'royalone:member:' + current.memberCode,
                version: QrVersions.auto,
                size: 207,
              ),
            ),
            const SizedBox(height: 10),
            Text(current.memberCode, style: const TextStyle(
              color: gold, fontWeight: FontWeight.bold,
              fontSize: 17, letterSpacing: 2)),
            const SizedBox(height: 8),
            const Text(
              'این کد فقط شناسهٔ عضویت است؛ برای دریافت خدمات باید اعتبار عضویت توسط سامانه بررسی شود.',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: TextStyle(color: cream, fontSize: 11, height: 1.6)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx),
            child: const Text('بستن', style: TextStyle(color: gold))),
        ],
      ),
    );
  }

  @override
  void dispose() {
    RoyalScoreStore.revision.removeListener(_refreshCounters);
    super.dispose();
  }

  Widget _action(IconData icon, String title, VoidCallback onTap) => Padding(
    padding: const EdgeInsets.only(bottom: 9),
    child: Material(
      color: const Color(0xFF1B1511),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: working ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: Row(textDirection: TextDirection.rtl, children: [
            Icon(icon, color: gold),
            const SizedBox(width: 12),
            Expanded(child: Text(title,
              textDirection: TextDirection.rtl,
              style: const TextStyle(color: cream,
                fontWeight: FontWeight.w700))),
            const Icon(Icons.chevron_left_rounded, color: gold),
          ]),
        ),
      ),
    ),
  );

  Widget _profilePhoto() {
    return CircleAvatar(
      radius: 48,
      backgroundColor: const Color(0xFF171E19),
      child: ClipOval(
        child: SizedBox(
          width: 90, height: 90,
          child: avatarBytes != null
              ? Image.memory(avatarBytes!, fit: BoxFit.cover)
              : imageUrl != null
                  ? Image.network(imageUrl!, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _letterAvatar())
                  : _letterAvatar(),
        ),
      ),
    );
  }

  Widget _letterAvatar() => Center(
    child: Text(
      member?.fullName.isNotEmpty == true
        ? member!.fullName.characters.first : 'R',
      style: const TextStyle(
        color: gold, fontSize: 35, fontWeight: FontWeight.w900)),
  );

  @override
  Widget build(BuildContext context) {
    final current = member;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('پروفایل رویال کلاب'),
        centerTitle: true,
        backgroundColor: dark,
        foregroundColor: gold,
        actions: [
          IconButton(
            tooltip: 'بازخوانی عضویت',
            icon: const Icon(Icons.refresh),
            onPressed: loading ? null : _load),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: ListView(
              padding: const EdgeInsets.all(17),
              children: [
                if (loading) const LinearProgressIndicator(color: gold),
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(error!,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.redAccent)),
                  ),
                if (current == null) ...[
                  const SizedBox(height: 45),
                  const Icon(Icons.account_circle_outlined,
                    color: gold, size: 85),
                  const SizedBox(height: 17),
                  const Text('برای دریافت کارت عضویت، ابتدا شماره‌ات را تأیید کن.',
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: cream, fontSize: 16)),
                  const SizedBox(height: 25),
                  _action(Icons.workspace_premium_outlined,
                    'ثبت‌نام یا ورود با پیامک', () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const RoyalClubMembershipPage()));
                      await _load();
                    }),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.all(21),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(color: gold),
                      gradient: const LinearGradient(colors: [
                        Color(0xFF253B2B), Color(0xFF110D0B),
                        Color(0xFF39221A)]),
                    ),
                    child: Column(children: [
                      _profilePhoto(),
                      const SizedBox(height: 12),
                      Text(current.fullName,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: cream,
                          fontSize: 21, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 7),
                      const Text('عضویت استاندارد • فعال',
                        style: TextStyle(color: gold, fontSize: 12)),
                      const SizedBox(height: 13),
                      Text(current.memberCode,
                        style: const TextStyle(color: gold,
                          fontWeight: FontWeight.w900,
                          fontSize: 20, letterSpacing: 2)),
                      const SizedBox(height: 8),
                      Text(current.phone,
                        style: const TextStyle(color: Colors.white60)),
                      if (current.displayName != null) ...[
                        const SizedBox(height: 6),
                        Text('نام نمایشی: ' + current.displayName!,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(color: cream, fontSize: 12)),
                      ],
                    ]),
                  ),
                  const SizedBox(height: 13),
                  Row(children: [
                    Expanded(child: _stat('تیکت آزمایشی', tickets)),
                    const SizedBox(width: 9),
                    Expanded(child: _stat('مجموع تیکت', lifetime)),
                  ]),
                  const SizedBox(height: 9),
                  const Text(
                    'تیکت‌های بازی در این نسخه مبنای دریافت جوایز واقعی نیستند.',
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(color: Colors.white54, fontSize: 11)),
                  const SizedBox(height: 17),
                  _action(Icons.qr_code_2_rounded,
                    'نمایش QR اختصاصی عضویت', _showQr),
                  _action(Icons.add_a_photo_outlined,
                    'انتخاب یا تغییر عکس پروفایل (اختیاری)', _pickPhoto),
                  if (current.avatarPath != null)
                    _action(Icons.delete_outline,
                      'حذف عکس پروفایل', _removePhoto),
                  _action(Icons.badge_outlined,
                    'ویرایش نام نمایشی', _editAlias),
                  _action(Icons.manage_accounts_outlined,
                    'ویرایش نام و اطلاعات عضویت', () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const RoyalClubMembershipPage()));
                      await _load();
                    }),
                  _action(Icons.diamond_outlined,
                    'مزایا و امتیازات باشگاه', () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const RoyalClubPrivilegesPage()));
                    }),
                  const SizedBox(height: 9),
                  _action(Icons.logout_rounded, 'خروج امن از حساب', _logout),
                  const SizedBox(height: 9),
                  const Text(
                    'عکس پروفایل در فضای خصوصی ذخیره می‌شود و بدون دسترسی مجاز عمومی نیست.',
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white54,
                      fontSize: 11, height: 1.8)),
                ],
                if (working)
                  const Padding(
                    padding: EdgeInsets.all(14),
                    child: LinearProgressIndicator(color: gold)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _stat(String title, int count) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: dark,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0x66786241))),
    child: Column(children: [
      Text('$count', style: const TextStyle(
        color: gold, fontSize: 22, fontWeight: FontWeight.bold)),
      Text(title, style: const TextStyle(
        color: Colors.white70, fontSize: 11)),
    ]),
  );
}
