import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'royal_club_member_service.dart';

/// Real phone-verified membership: no local-only activation or false success.
class RoyalClubMembershipPage extends StatefulWidget {
  const RoyalClubMembershipPage({super.key});

  // Legacy keys kept to support older app screens until their migration.
  static const fullNameKey = 'rc_member_full_name_v1';
  static const phoneKey = 'rc_member_phone_v1';
  static const joinedAtKey = 'rc_member_joined_at_v1';

  @override
  State<RoyalClubMembershipPage> createState() =>
      _RoyalClubMembershipPageState();
}

class _RoyalClubMembershipPageState extends State<RoyalClubMembershipPage> {
  static const gold = Color(0xFFE8C36A);
  static const ivory = Color(0xFFF1E8D8);
  static const dark = Color(0xFF10070A);
  static const accent = Color(0xFF650D21);

  final name = TextEditingController();
  final phone = TextEditingController();
  final otp = TextEditingController();
  Timer? timer;
  bool loading = true;
  bool busy = false;
  bool consent = false;
  bool codeSent = false;
  bool editing = false;
  bool authenticated = false;
  int resendSeconds = 0;
  String pendingPhone = '';
  String pendingName = '';
  String verifiedPhone = '';
  String? error;
  RoyalClubMember? member;

  SupabaseClient get db => RoyalClubMemberService.client;

  @override
  void initState() {
    super.initState();
    _restore();
  }

  Future<void> _restore() async {
    final user = RoyalClubMemberService.currentUser;
    if (user == null) {
      if (mounted) setState(() => loading = false);
      return;
    }
    try {
      final profile = await RoyalClubMemberService.loadCurrent();
      if (!mounted) return;
      setState(() {
        member = profile;
        authenticated = true;
        verifiedPhone = user.phone ?? '';
        name.text = profile?.fullName ?? '';
        phone.text = verifiedPhone;
        error = null;
        loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        authenticated = true;
        verifiedPhone = user.phone ?? '';
        loading = false;
        error = 'دریافت اطلاعات عضویت ممکن نشد؛ اتصال اینترنت را بررسی کنید و دوباره تلاش کنید.';
      });
    }
  }

  String get normalizedPhone =>
      RoyalClubMemberService.normalizeIranMobile(phone.text);

  bool get validName => name.text.trim().replaceAll(
      RegExp(r'\s+'), ' ').length >= 3 &&
      name.text.trim().length <= 120;

  void _showTerms() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF16251C),
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('اطلاعات عضویت و حریم خصوصی',
                textDirection: TextDirection.rtl,
                style: TextStyle(color: gold, fontSize: 19,
                  fontWeight: FontWeight.w800)),
              const SizedBox(height: 14),
              const Text(
                'برای ساخت حساب، نام و نام خانوادگی، شمارهٔ موبایل تأییدشده '
                'و زمان پذیرش این اطلاعیه در سامانهٔ رویال کلاب ثبت می‌شود. '
                'این اطلاعات برای شناسایی عضو، مدیریت حساب و ارائهٔ خدمات عضویت '
                'استفاده می‌شوند. عکس پروفایل اجباری نیست. '
                'عضویت به‌خودی‌خود مجوز شرکت در قرعه‌کشی یا دریافت جایزهٔ واقعی نیست. '
                'برای خریدها، خدمات مالی و برنامه‌های جایزه‌دار شرایط جداگانه لازم است. '
                'این اطلاعیه خلاصهٔ نسخهٔ آزمایشی است و پیش از عرضهٔ عمومی '
                'باید متن رسمی حریم خصوصی و شرایط خدمات تصویب و منتشر شود.',
                textDirection: TextDirection.rtl,
                style: TextStyle(color: ivory, fontSize: 13, height: 1.8)),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: gold, foregroundColor: dark),
                child: const Text('متوجه شدم'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validate({required bool needPhone}) {
    if (!validName) {
      setState(() => error = 'نام و نام خانوادگی باید بین ۳ تا ۱۲۰ حرف باشد.');
      return false;
    }
    if (needPhone && !RoyalClubMemberService.validIranMobile(phone.text)) {
      setState(() => error = 'شمارهٔ معتبر ایران وارد کنید؛ مانند ۰۹۱۲۱۲۳۴۵۶۷.');
      return false;
    }
    if (!consent) {
      setState(() => error = 'برای عضویت، ابتدا اطلاعیهٔ حریم خصوصی را بپذیرید.');
      return false;
    }
    return true;
  }

  String _errorText(Object e, {required String action}) {
    if (e is FormatException) return e.message;
    final value = e.toString().toLowerCase();
    if (value.contains('rate limit') || value.contains('429') ||
        value.contains('too many')) {
      return 'درخواست‌های زیادی ارسال شده؛ چند دقیقه دیگر دوباره تلاش کنید.';
    }
    if (value.contains('expired') || value.contains('invalid') ||
        value.contains('token')) {
      return 'کد تأیید نامعتبر یا منقضی شده است. کد جدید دریافت کنید.';
    }
    if (value.contains('provider') || value.contains('unsupported') ||
        value.contains('sms not enabled')) {
      return 'ارسال پیامک در سرور هنوز فعال نیست؛ مدیر سامانه باید سرویس پیامک را تنظیم کند.';
    }
    if (e is AuthException) {
      return action == 'send'
          ? 'ارسال کد موفق نبود؛ شماره، اتصال اینترنت و سرویس پیامک را بررسی کنید.'
          : 'تأیید شماره موفق نبود؛ کد یا سرویس پیامک را بررسی کنید.';
    }
    if (e is PostgrestException) {
      return 'ثبت اطلاعات در سرور انجام نشد. دوباره تلاش کنید.';
    }
    return 'ارتباط با سامانه برقرار نشد. اینترنت را بررسی کنید و دوباره تلاش کنید.';
  }

  void _startCountdown() {
    timer?.cancel();
    setState(() => resendSeconds = 60);
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (resendSeconds <= 1) {
        t.cancel();
        setState(() => resendSeconds = 0);
      } else {
        setState(() => resendSeconds--);
      }
    });
  }

  Future<void> _sendCode({bool resend = false}) async {
    if (busy || (resend && resendSeconds > 0)) return;
    if (!resend && !_validate(needPhone: true)) return;
    final number = resend ? pendingPhone : normalizedPhone;
    final person = resend ? pendingName : name.text.trim();
    setState(() { busy = true; error = null; });
    try {
      await db.auth.signInWithOtp(
        phone: number,
        shouldCreateUser: true,
      );
      if (!mounted) return;
      setState(() {
        pendingPhone = number;
        pendingName = person;
        codeSent = true;
        otp.clear();
      });
      _startCountdown();
    } catch (e) {
      if (mounted) setState(() => error = _errorText(e, action: 'send'));
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  String _latinCode(String raw) {
    const p = '۰۱۲۳۴۵۶۷۸۹';
    const a = '٠١٢٣٤٥٦٧٨٩';
    final output = StringBuffer();
    for (final c in raw.trim().split('')) {
      final pi = p.indexOf(c);
      final ai = a.indexOf(c);
      output.write(pi >= 0 ? pi : ai >= 0 ? ai : c);
    }
    return output.toString();
  }

  Future<void> _verifyCode() async {
    if (busy || !codeSent) return;
    final code = _latinCode(otp.text);
    if (!RegExp(r'^[0-9]{6}$').hasMatch(code)) {
      setState(() => error = 'کد شش‌رقمی پیامک را وارد کنید.');
      return;
    }
    setState(() { busy = true; error = null; });
    try {
      final verified = await db.auth.verifyOTP(
        phone: pendingPhone, token: code, type: OtpType.sms);
      if (verified.user == null) {
        throw const FormatException('تأیید شمارهٔ تلفن انجام نشد.');
      }
      if (!mounted) return;
      // OTP is now verified even if saving the profile later fails.
      setState(() {
        authenticated = true;
        verifiedPhone = verified.user!.phone ?? pendingPhone;
        codeSent = false;
      });
      final result = await RoyalClubMemberService.saveVerifiedMember(pendingName);
      if (!mounted) return;
      timer?.cancel();
      setState(() {
        member = result;
        name.text = result.fullName;
        phone.text = result.phone;
        error = null;
        otp.clear();
        resendSeconds = 0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('عضویت شما با تأیید شماره ثبت شد.')));
    } catch (e) {
      if (mounted) setState(() => error = _errorText(e, action: 'verify'));
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _saveProfile() async {
    if (busy || !authenticated) return;
    if (!_validate(needPhone: false) && member == null) return;
    if (!validName) {
      setState(() => error = 'نام و نام خانوادگی معتبر وارد کنید.');
      return;
    }
    setState(() { busy = true; error = null; });
    try {
      final result = await RoyalClubMemberService.saveVerifiedMember(name.text);
      if (!mounted) return;
      setState(() { member = result; editing = false; consent = false; });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('پروفایل عضویت ذخیره شد.')));
    } catch (e) {
      if (mounted) setState(() => error = _errorText(e, action: 'save'));
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _logOut() async {
    setState(() { busy = true; error = null; });
    try {
      await RoyalClubMemberService.signOut();
      if (!mounted) return;
      setState(() {
        authenticated = false;
        member = null;
        verifiedPhone = '';
        pendingPhone = '';
        pendingName = '';
        codeSent = false;
        editing = false;
        consent = false;
        name.clear();
        phone.clear();
        otp.clear();
      });
    } catch (_) {
      if (mounted) setState(() => error = 'خروج از حساب انجام نشد.');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    name.dispose();
    phone.dispose();
    otp.dispose();
    super.dispose();
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    TextInputType keyboard = TextInputType.text,
    bool enabled = true,
    int? maxLength,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled && !busy,
      keyboardType: keyboard,
      maxLength: maxLength,
      textDirection: TextDirection.rtl,
      style: const TextStyle(color: ivory),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: gold),
        counterStyle: const TextStyle(color: Colors.white54),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: gold)),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: gold, width: 1.5)),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white24)),
      ),
    );
  }

  Widget _consent() => Column(children: [
    CheckboxListTile(
      value: consent,
      activeColor: gold,
      checkColor: dark,
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: busy ? null : (v) => setState(() => consent = v ?? false),
      title: const Text(
        'با ثبت اطلاعات ضروری برای عضویت و استفاده از خدمات رویال کلاب موافقم.',
        textDirection: TextDirection.rtl,
        style: TextStyle(color: ivory, fontSize: 12),
      ),
    ),
    Align(
      alignment: Alignment.centerRight,
      child: TextButton.icon(
        onPressed: _showTerms,
        icon: const Icon(Icons.privacy_tip_outlined),
        label: const Text('مطالعهٔ توضیحات حریم خصوصی'),
        style: TextButton.styleFrom(foregroundColor: gold),
      ),
    ),
  ]);

  Widget _activeMember() => Column(children: [
    const Icon(Icons.verified_rounded, color: Color(0xFF78D5A0), size: 53),
    const SizedBox(height: 10),
    const Text('عضویت تأییدشدهٔ رویال کلاب',
      textAlign: TextAlign.center,
      style: TextStyle(color: ivory, fontSize: 18,
        fontWeight: FontWeight.bold)),
    const SizedBox(height: 17),
    SelectableText(member!.membershipCode,
      textAlign: TextAlign.center,
      style: const TextStyle(color: gold, letterSpacing: 2,
        fontSize: 23, fontWeight: FontWeight.bold)),
    const SizedBox(height: 7),
    Text(member!.fullName, textAlign: TextAlign.center,
      style: const TextStyle(color: ivory, fontSize: 17)),
    const SizedBox(height: 4),
    Text(member!.phone, textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.white70)),
    const SizedBox(height: 12),
    TextButton.icon(
      onPressed: () {
        Clipboard.setData(ClipboardData(text: member!.membershipCode));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('شمارهٔ عضویت کپی شد.')));
      },
      icon: const Icon(Icons.copy_rounded, size: 17),
      label: const Text('کپی شمارهٔ عضویت'),
      style: TextButton.styleFrom(foregroundColor: gold),
    ),
    const Divider(color: Color(0x556B5135), height: 30),
    if (editing) ...[
      _field(name, 'ویرایش نام و نام خانوادگی', maxLength: 120),
      const SizedBox(height: 12),
      _action('ذخیرهٔ نام', _saveProfile),
      TextButton(onPressed: busy ? null : () => setState(() {
        editing = false;
        name.text = member!.fullName;
      }), child: const Text('انصراف', style: TextStyle(color: gold))),
    ] else
      _action('ویرایش نام عضو', () => setState(() {
        name.text = member!.fullName;
        editing = true;
      })),
    const SizedBox(height: 10),
    TextButton.icon(
      onPressed: busy ? null : _logOut,
      icon: const Icon(Icons.logout),
      label: const Text('خروج از حساب'),
      style: TextButton.styleFrom(foregroundColor: Colors.white70),
    ),
    const SizedBox(height: 8),
    const Text(
      'شمارهٔ عضویت فقط شناسهٔ نمایشی است؛ '
      'برای استفاده از مزایا و عملیات مالی، تأیید امن حساب لازم است.',
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white54,
        fontSize: 11, height: 1.7)),
  ]);

  Widget _action(String title, VoidCallback onPressed) => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: busy ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: gold,
        side: const BorderSide(color: gold),
        padding: const EdgeInsets.symmetric(vertical: 15)),
      child: Text(busy ? 'در حال ارتباط با سرور...' : title,
        style: const TextStyle(fontWeight: FontWeight.w800,
          fontSize: 15)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dark,
      appBar: AppBar(
        title: const Text('ROYAL CLUB  ·  عضویت',
          style: TextStyle(fontSize: 16)),
        backgroundColor: const Color(0xFF270A12),
        foregroundColor: gold,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListView(
              padding: const EdgeInsets.all(19),
              children: [
                const Icon(Icons.workspace_premium,
                  size: 70, color: gold),
                const SizedBox(height: 12),
                const Text(
                  'ROYAL CLUB MEMBERSHIP',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: gold, fontSize: 20,
                    letterSpacing: 1.2, fontWeight: FontWeight.bold)),
                const SizedBox(height: 7),
                Text(
                  member != null ? 'کارت عضویت اختصاصی شما'
                  : codeSent ? 'تأیید شمارهٔ موبایل'
                  : authenticated ? 'تکمیل اطلاعات حساب تأییدشده'
                  : 'ثبت‌نام و ورود امن با پیامک',
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: ivory, fontSize: 14)),
                const SizedBox(height: 23),
                Container(
                  padding: const EdgeInsets.all(19),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(23),
                    border: Border.all(color: gold.withOpacity(.8)),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF36131C), dark,
                        Color(0xFF1A251A)]),
                  ),
                  child: loading
                    ? const Center(child: CircularProgressIndicator(color: gold))
                    : member != null
                      ? _activeMember()
                      : codeSent
                        ? Column(children: [
                            Text('کد ارسال‌شده به: '+pendingPhone,
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: ivory)),
                            const SizedBox(height: 14),
                            _field(otp, 'کد شش‌رقمی پیامک',
                              keyboard: TextInputType.number,
                              maxLength: 6),
                            const SizedBox(height: 14),
                            _action('تأیید کد و ثبت عضویت', _verifyCode),
                            const SizedBox(height: 7),
                            TextButton(
                              onPressed: busy || resendSeconds > 0
                                ? null : () => _sendCode(resend: true),
                              child: Text(resendSeconds > 0
                                  ? 'ارسال مجدد تا '+resendSeconds.toString()+' ثانیه'
                                  : 'ارسال مجدد کد',
                                style: const TextStyle(color: gold)),
                            ),
                            TextButton(
                              onPressed: busy ? null : () => setState(() {
                                codeSent = false;
                                otp.clear();
                                error = null;
                              }),
                              child: const Text('اصلاح شماره',
                                style: TextStyle(color: Colors.white70)),
                            ),
                          ])
                        : Column(children: [
                            _field(name, 'نام و نام خانوادگی',
                              maxLength: 120),
                            const SizedBox(height: 13),
                            if (authenticated)
                              Text(verifiedPhone,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: gold, fontSize: 15))
                            else
                              _field(phone, 'شماره همراه ایران (۰۹...)',
                                keyboard: TextInputType.phone,
                                maxLength: 16),
                            const SizedBox(height: 8),
                            _consent(),
                            const SizedBox(height: 14),
                            _action(
                              authenticated
                                ? 'ثبت اطلاعات حساب تأییدشده'
                                : 'دریافت کد تأیید پیامکی',
                              authenticated
                                ? _saveProfile : () => _sendCode(),
                            ),
                            if (authenticated) ...[
                              const SizedBox(height: 10),
                              TextButton(
                                onPressed: busy ? null : _logOut,
                                child: const Text('ورود با شمارهٔ دیگر',
                                  style: TextStyle(color: gold)),
                              ),
                            ],
                          ]),
                ),
                if (error != null) ...[
                  const SizedBox(height: 15),
                  Text(error!, textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(color: Colors.redAccent,
                      height: 1.7)),
                  if (authenticated && member == null)
                    TextButton(onPressed: loading || busy ? null : _restore,
                      child: const Text('تلاش مجدد برای دریافت عضویت',
                        style: TextStyle(color: gold))),
                ],
                const SizedBox(height: 18),
                const Text(
                  'فعال‌شدن عضویت فقط بعد از تأیید پیامک و ذخیرهٔ اطلاعات '
                  'در سرور انجام می‌شود. '
                  'عکس پروفایل اختیاری است و پرداخت واقعی هنوز فعال نیست.',
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(color: Colors.white54,
                    fontSize: 11, height: 1.8)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
