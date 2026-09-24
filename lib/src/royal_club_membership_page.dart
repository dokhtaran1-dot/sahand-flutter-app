import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Phone OTP membership. No customer record is created before OTP verification.
class RoyalClubMembershipPage extends StatefulWidget {
  const RoyalClubMembershipPage({super.key});
  @override
  State<RoyalClubMembershipPage> createState() => _RoyalClubMembershipPageState();
}

class _RoyalClubMembershipPageState extends State<RoyalClubMembershipPage> {
  static const gold = Color(0xFFE8C36A);
  final name = TextEditingController();
  final phone = TextEditingController();
  final otp = TextEditingController();
  bool consent = false, sent = false, busy = false;
  String? error;
  SupabaseClient get db => Supabase.instance.client;

  String get normalizedPhone {
    var s = phone.text.replaceAll(RegExp(r'[^0-9+]'), '');
    if (s.startsWith('0098')) s = '+98${s.substring(4)}';
    if (s.startsWith('09')) s = '+98${s.substring(1)}';
    if (s.startsWith('98') && !s.startsWith('+')) s = '+$s';
    return s;
  }

  Future<void> sendCode() async {
    if (name.text.trim().length < 3 || !RegExp(r'^\+989\d{9}$').hasMatch(normalizedPhone) || !consent) {
      setState(() => error = 'نام، شماره موبایل ایران و پذیرش قوانین را بررسی کنید.');
      return;
    }
    setState(() { busy = true; error = null; });
    try {
      await db.auth.signInWithOtp(phone: normalizedPhone, shouldCreateUser: true);
      if (mounted) setState(() => sent = true);
    } catch (_) {
      if (mounted) setState(() => error = 'ارسال پیامک انجام نشد. تنظیمات پیامک یا شماره را بررسی کنید.');
    } finally { if (mounted) setState(() => busy = false); }
  }

  Future<void> verify() async {
    if (otp.text.trim().length < 4) return;
    setState(() { busy = true; error = null; });
    try {
      final result = await db.auth.verifyOTP(
        phone: normalizedPhone, token: otp.text.trim(), type: OtpType.sms,
      );
      if (result.user == null) throw StateError('No verified user');
      await db.from('royal_club_members').upsert({
        'user_id': result.user!.id,
        'full_name': name.text.trim(),
        'phone': normalizedPhone,
        'accepted_terms_at': DateTime.now().toUtc().toIso8601String(),
      }, onConflict: 'user_id');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('عضویت شما با موفقیت ثبت شد')),
      );
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) setState(() => error = 'تأیید یا ثبت اطلاعات ناموفق بود. کد و اتصال اینترنت را بررسی کنید.');
    } finally { if (mounted) setState(() => busy = false); }
  }

  @override
  void dispose() { name.dispose(); phone.dispose(); otp.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    const fieldBorder = OutlineInputBorder(borderSide: BorderSide(color: gold));
    return Scaffold(
      backgroundColor: const Color(0xFF10070A),
      appBar: AppBar(title: const Text('ROYAL CLUB • عضویت'), backgroundColor: const Color(0xFF270A12), foregroundColor: gold),
      body: SafeArea(child: Center(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: ListView(padding: const EdgeInsets.all(24), children: [
          const Icon(Icons.workspace_premium, size: 75, color: gold),
          const SizedBox(height: 12),
          const Text('عضویت اختصاصی رویال کلاب', textAlign: TextAlign.center,
            style: TextStyle(color: gold, fontSize: 23, fontWeight: FontWeight.bold)),
          const SizedBox(height: 28),
          if (!sent) ...[
            TextField(controller: name, textDirection: TextDirection.rtl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'نام و نام خانوادگی', labelStyle: TextStyle(color: gold), enabledBorder: fieldBorder, focusedBorder: fieldBorder)),
            const SizedBox(height: 16),
            TextField(controller: phone, keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'شماره موبایل (۰۹...)', labelStyle: TextStyle(color: gold), enabledBorder: fieldBorder, focusedBorder: fieldBorder)),
            const SizedBox(height: 12),
            CheckboxListTile(value: consent, activeColor: gold,
              title: const Text('با ثبت اطلاعات برای عضویت و دریافت پیامک تأیید موافقم.', style: TextStyle(color: Colors.white70, fontSize: 13)),
              onChanged: busy ? null : (v) => setState(() => consent = v ?? false)),
          ] else ...[
            Text('کد ارسال‌شده به $normalizedPhone', textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 16),
            TextField(controller: otp, keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'کد تأیید پیامکی', labelStyle: TextStyle(color: gold), enabledBorder: fieldBorder, focusedBorder: fieldBorder)),
            TextButton(onPressed: busy ? null : () => setState(() { sent = false; otp.clear(); }),
              child: const Text('اصلاح شماره', style: TextStyle(color: gold))),
          ],
          if (error != null) Padding(padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(error!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.redAccent))),
          const SizedBox(height: 18),
          ElevatedButton(onPressed: busy ? null : (sent ? verify : sendCode),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF650D21), foregroundColor: gold,
              padding: const EdgeInsets.all(17), side: const BorderSide(color: gold)),
            child: Text(busy ? 'لطفاً صبر کنید...' : sent ? 'تأیید و تکمیل عضویت' : 'دریافت کد تأیید')),
          const SizedBox(height: 20),
          const Text('اطلاعات عضویت فقط پس از تأیید شماره در سامانه ثبت می‌شود.',
            textAlign: TextAlign.center, style: TextStyle(color: Colors.white54)),
        ]),
      ))),
    );
  }
}
