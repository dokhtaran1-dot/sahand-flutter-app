import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'royal_club_member_service.dart';

/// Server-verified Royal Club registration and sign-in.
/// A name or a phone saved locally is never considered active membership.
class RoyalClubMembershipPage extends StatefulWidget {
  const RoyalClubMembershipPage({super.key});

  static const fullNameKey = 'rc_member_full_name_v1';
  static const phoneKey = 'rc_member_phone_v1';
  static const joinedAtKey = 'rc_member_joined_at_v1';

  @override
  State<RoyalClubMembershipPage> createState() =>
      _RoyalClubMembershipPageState();
}

class _RoyalClubMembershipPageState extends State<RoyalClubMembershipPage> {
  static const gold = Color(0xFFE8C36A);
  static const cream = Color(0xFFF5EBDC);
  static const background = Color(0xFF100A0C);

  final name = TextEditingController();
  final phone = TextEditingController();
  final nickname = TextEditingController();
  final otp = TextEditingController();

  bool consent = false;
  bool sent = false;
  bool busy = false;
  bool loading = true;
  String? error;
  RoyalClubMember? member;
  int resendIn = 0;
  Timer? resendTimer;

  String get normalizedPhone =>
      RoyalClubMemberService.normalizeIranMobile(phone.text);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = await RoyalClubMemberService.loadCurrent();
      if (!mounted) return;
      setState(() {
        member = saved;
        name.text = saved?.fullName ??
            (prefs.getString(RoyalClubMembershipPage.fullNameKey) ?? '');
        phone.text = saved?.phone ??
            (prefs.getString(RoyalClubMembershipPage.phoneKey) ?? '');
        nickname.text = saved?.displayName ?? '';
        consent = saved != null;
        loading = false;
      });
    } catch (_) {
      if (mounted) setState(() {
        loading = false;
        error = 'اتصال به سامانهٔ اعضا برقرار نشد. دوباره تلاش کنید.';
      });
    }
  }

  void _startResendTimer() {
    resendTimer?.cancel();
    setState(() => resendIn = 60);
    resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (resendIn <= 1) {
        timer.cancel();
        setState(() => resendIn = 0);
      } else {
        setState(() => resendIn--);
      }
    });
  }

  bool _validate() {
    final full = name.text.trim().replaceAll(RegExp(r'\s+'), ' ');
    final alias = nickname.text.trim();
    if (full.length < 3 || full.length > 120) {
      setState(() => error = 'نام و نام خانوادگی باید بین ۳ تا ۱۲۰ کاراکتر باشد.');
      return false;
    }
    if (!RoyalClubMemberService.validIranMobile(phone.text)) {
      setState(() =>
          error = 'شماره موبایل ایران را وارد کنید؛ مثلاً ۰۹۱۲۱۲۳۴۵۶۷.');
      return false;
    }
    if (alias.isNotEmpty && (alias.length < 2 || alias.length > 30)) {
      setState(() => error = 'نام نمایشی باید بین ۲ تا ۳۰ کاراکتر باشد.');
      return false;
    }
    if (!consent) {
      setState(() => error = 'برای عضویت، پذیرش شرایط و پردازش اطلاعات ضروری است.');
      return false;
    }
    return true;
  }

  Future<void> _sendCode() async {
    if (busy || resendIn > 0 || !_validate()) return;
    setState(() { busy = true; error = null; });
    try {
      final user = RoyalClubMemberService.currentUser;
      if (user != null && user.phone == normalizedPhone) {
        // The identity is already authenticated; never send a second OTP
        // unnecessarily. Persist the profile securely.
        await _saveVerified();
      } else {
        await RoyalClubMemberService.client.auth.signInWithOtp(
          phone: normalizedPhone,
          shouldCreateUser: true,
        );
        if (!mounted) return;
        setState(() => sent = true);
        _startResendTimer();
      }
    } on AuthException catch (e) {
      if (mounted) setState(() {
        error = e.statusCode == '429'
            ? 'درخواست‌های پیامک زیاد شده؛ کمی بعد دوباره امتحان کنید.'
            : 'پیامک ارسال نشد. اتصال اینترنت و سرویس پیامک را بررسی کنید.';
      });
    } catch (_) {
      if (mounted) setState(() => error =
          'امکان ارسال کد وجود ندارد. تنظیمات سرویس پیامک را بررسی کنید.');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _verify() async {
    final code = otp.text.trim();
    if (!RegExp(r'^[0-9]{6}$').hasMatch(code)) {
      setState(() => error = 'کد تأیید شش‌رقمی را درست وارد کنید.');
      return;
    }
    if (busy) return;
    setState(() { busy = true; error = null; });
    try {
      final verified = await RoyalClubMemberService.client.auth.verifyOTP(
        phone: normalizedPhone,
        token: code,
        type: OtpType.sms,
      );
      if (verified.user == null) {
        throw const FormatException('شماره هنوز تأیید نشده است.');
      }
      await _saveVerified();
    } on AuthException catch (_) {
      if (mounted) setState(() =>
          error = 'کد نامعتبر یا منقضی است. دوباره بررسی یا ارسال مجدد کنید.');
    } catch (_) {
      if (mounted) setState(() =>
          error = 'شماره تأیید شدنی نبود یا اطلاعات ذخیره نشد؛ دوباره تلاش کنید.');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _saveVerified() async {
    final newMember = await RoyalClubMemberService.saveVerifiedMember(
      name.text,
      displayName: nickname.text,
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(RoyalClubMembershipPage.fullNameKey,
        newMember.fullName);
    await prefs.setString(RoyalClubMembershipPage.phoneKey,
        newMember.phone);
    await prefs.setString(RoyalClubMembershipPage.joinedAtKey,
        (newMember.createdAt ?? DateTime.now()).toUtc().toIso8601String());
    if (!mounted) return;
    resendTimer?.cancel();
    setState(() {
      member = newMember;
      phone.text = newMember.phone;
      name.text = newMember.fullName;
      nickname.text = newMember.displayName ?? '';
      sent = false;
      resendIn = 0;
      error = null;
      otp.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('عضویت در سامانه با موفقیت تأیید شد')),
    );
  }

  @override
  void dispose() {
    resendTimer?.cancel();
    name.dispose();
    phone.dispose();
    nickname.dispose();
    otp.dispose();
    super.dispose();
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboard,
    int? maxLength,
    bool readOnly = false,
    List<TextInputFormatter>? formatters,
  }) => TextField(
    controller: controller,
    keyboardType: keyboard,
    readOnly: readOnly,
    maxLength: maxLength,
    inputFormatters: formatters,
    style: const TextStyle(color: cream),
    textDirection: TextDirection.rtl,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: gold),
      counterStyle: const TextStyle(color: Colors.white38),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0x997C6249))),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: gold, width: 1.5)),
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: background,
    appBar: AppBar(
      backgroundColor: const Color(0xFF1E1112),
      foregroundColor: gold,
      title: const Text('عضویت رویال کلاب'),
      centerTitle: true,
    ),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 550),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 19, 20, 35),
            children: [
              const Icon(Icons.workspace_premium_outlined,
                  size: 65, color: gold),
              const SizedBox(height: 10),
              const Text('ROYAL CLUB',
                textAlign: TextAlign.center,
                style: TextStyle(color: gold, fontSize: 24,
                  fontWeight: FontWeight.w900, letterSpacing: 3)),
              const SizedBox(height: 5),
              const Text('عضویت اختصاصی کنسرسیوم سهند',
                textAlign: TextAlign.center,
                style: TextStyle(color: cream, fontSize: 13)),
              const SizedBox(height: 20),
              if (loading)
                const Center(child: CircularProgressIndicator(color: gold)),
              if (member != null) ...[
                Container(
                  padding: const EdgeInsets.all(19),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(colors: [
                      Color(0xFF17402B), Color(0xFF101D15)]),
                    border: Border.all(color: gold),
                  ),
                  child: Column(children: [
                    const Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.verified_user_rounded,
                          color: Color(0xFF91DDA8)),
                        SizedBox(width: 9),
                        Text('عضویت تأییدشده',
                          style: TextStyle(color: cream,
                            fontSize: 17, fontWeight: FontWeight.bold)),
                      ]),
                    const SizedBox(height: 7),
                    Text(member!.membershipCode,
                      style: const TextStyle(color: gold,
                        fontSize: 23, letterSpacing: 2,
                        fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    const Text('کد عضویت اختصاصی',
                      style: TextStyle(color: Colors.white70, fontSize: 11)),
                  ]),
                ),
                const SizedBox(height: 13),
                const Text('اطلاعاتت را می‌توانی ویرایش کنی. تغییر شماره موبایل نیاز به تأیید دوباره دارد.',
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white60, fontSize: 12)),
                const SizedBox(height: 18),
              ],
              if (!sent) ...[
                _field(controller: name,
                  label: 'نام و نام خانوادگی', maxLength: 120),
                const SizedBox(height: 12),
                _field(controller: phone,
                  label: 'شماره موبایل ایران (۰۹...)',
                  keyboard: TextInputType.phone,
                  readOnly: member != null),
                const SizedBox(height: 14),
                _field(controller: nickname,
                  label: 'نام نمایشی (اختیاری)',
                  maxLength: 30),
                const SizedBox(height: 12),
                CheckboxListTile(
                  value: consent,
                  contentPadding: EdgeInsets.zero,
                  activeColor: gold,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text(
                    'با شرایط عضویت و ذخیرهٔ نام، شمارهٔ تأییدشده و اطلاعات پروفایل در سامانهٔ رویال کلاب موافقم.',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(color: cream, fontSize: 12, height: 1.6)),
                  onChanged: busy ? null :
                    (value) => setState(() => consent = value ?? false),
                ),
              ] else ...[
                Text('کد پیامکی ارسال شده به: $normalizedPhone',
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: cream, fontSize: 14)),
                const SizedBox(height: 17),
                _field(controller: otp,
                  label: 'کد شش‌رقمی پیامک',
                  maxLength: 6,
                  keyboard: TextInputType.number,
                  formatters: [FilteringTextInputFormatter.digitsOnly]),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: busy ? null :
                        () => setState(() { sent = false; otp.clear(); error = null; }),
                      child: const Text('اصلاح شماره',
                        style: TextStyle(color: gold))),
                    TextButton(
                      onPressed: busy || resendIn > 0 ? null : _sendCode,
                      child: Text(resendIn > 0
                        ? 'ارسال مجدد تا $resendIn ثانیه'
                        : 'ارسال دوبارهٔ کد',
                        style: TextStyle(color: resendIn > 0
                          ? Colors.white38 : gold)),
                    ),
                  ]),
              ],
              if (error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(error!,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(color: Colors.redAccent, fontSize: 13)),
                ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: busy || loading
                  ? null : (sent ? _verify : _sendCode),
                icon: Icon(sent
                  ? Icons.verified_outlined : Icons.sms_outlined),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF581128),
                  foregroundColor: gold,
                  side: const BorderSide(color: gold),
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                ),
                label: Text(busy ? 'در حال پردازش...'
                  : sent ? 'تأیید کد و تکمیل عضویت'
                  : member == null ? 'ارسال کد تأیید'
                  : 'ذخیرهٔ تغییرات پروفایل'),
              ),
              const SizedBox(height: 12),
              const Text(
                'ثبت‌نام فقط بعد از تأیید پیامک و ثبت موفق در سرور فعال می‌شود. '
                'در صورت اختلال سرویس پیامک، عضویت تأیید نشده نمایش داده نمی‌شود.',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54, fontSize: 11, height: 1.7)),
              if (member != null) ...[
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: () => Navigator.of(context).pop(true),
                  icon: const Icon(Icons.person_outline),
                  label: const Text('بازگشت به پروفایل'),
                  style: TextButton.styleFrom(foregroundColor: gold),
                ),
              ],
            ],
          ),
        ),
      ),
    ),
  );
}
