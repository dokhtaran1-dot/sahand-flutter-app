import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Verified Royal Club membership. A local cache is never proof of membership.
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
  static const ivory = Color(0xFFF7EFE0);
  static const background = Color(0xFF0E1410);
  static const avatarBucket = 'royal-club-avatars';

  final name = TextEditingController();
  final phone = TextEditingController();
  final otp = TextEditingController();

  bool consent = false;
  bool waitingForCode = false;
  bool busy = false;
  bool loading = true;
  bool member = false;
  int cooldown = 0;
  Timer? cooldownTimer;
  String? error;
  String? info;
  String? memberCode;
  String? avatarPath;
  String? avatarUrl;
  Uint8List? photoBytes;
  String photoExtension = 'jpg';
  String photoMime = 'image/jpeg';

  SupabaseClient get db => Supabase.instance.client;

  String _westernDigits(String input) {
    const fa = '۰۱۲۳۴۵۶۷۸۹';
    const ar = '٠١٢٣٤٥٦٧٨٩';
    return input.split('').map((c) {
      final a = fa.indexOf(c);
      if (a != -1) return a.toString();
      final b = ar.indexOf(c);
      return b == -1 ? c : b.toString();
    }).join();
  }

  String get cleanedName =>
      name.text.trim().replaceAll(RegExp(r'\s+'), ' ');

  String get normalizedPhone {
    var p = _westernDigits(phone.text).replaceAll(RegExp(r'[^0-9+]'), '');
    if (p.startsWith('0098')) p = '+' + p.substring(2);
    if (p.startsWith('98')) p = '+' + p;
    if (p.startsWith('09')) p = '+98' + p.substring(1);
    if (RegExp(r'^9\d{9}$').hasMatch(p)) p = '+98' + p;
    return p;
  }

  bool get validPhone => RegExp(r'^\+989\d{9}$').hasMatch(normalizedPhone);

  @override
  void initState() {
    super.initState();
    _restore();
  }

  Future<void> _restore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentUser = db.auth.currentUser;
      if (currentUser == null || db.auth.currentSession == null) {
        if (!mounted) return;
        name.text = prefs.getString(RoyalClubMembershipPage.fullNameKey) ?? '';
        phone.text = prefs.getString(RoyalClubMembershipPage.phoneKey) ?? '';
        setState(() {
          member = false;
          loading = false;
          info = 'برای فعال‌سازی عضویت باید شماره موبایل با پیامک تأیید شود.';
        });
        return;
      }
      final result = await db.from('royal_club_members')
          .select('full_name,phone,member_code,avatar_path')
          .eq('user_id', currentUser.id).maybeSingle();
      if (!mounted) return;
      if (result != null) {
        name.text = (result['full_name'] ?? '').toString();
        phone.text = (result['phone'] ?? '').toString();
        setState(() {
          member = true;
          memberCode = result['member_code']?.toString();
          avatarPath = result['avatar_path']?.toString();
          consent = true;
          loading = false;
        });
        await _loadAvatar();
      } else {
        // A verified login may still need its profile row completed.
        phone.text = currentUser.phone ?? '';
        name.text = prefs.getString(RoyalClubMembershipPage.fullNameKey) ?? '';
        setState(() {
          loading = false;
          member = false;
          info = 'شماره قبلاً تأیید شده است؛ اطلاعات عضویت را کامل کنید.';
        });
      }
    } catch (_) {
      if (mounted) setState(() {
        loading = false;
        error = 'بازیابی حساب از سرور انجام نشد. اتصال اینترنت را بررسی کنید.';
      });
    }
  }

  bool _validate() {
    if (cleanedName.length < 3 || cleanedName.length > 120) {
      setState(() => error = 'نام و نام خانوادگی باید بین ۳ تا ۱۲۰ کاراکتر باشد.');
      return false;
    }
    if (!validPhone) {
      setState(() => error = 'شماره موبایل ایران را به صورت ۰۹۱۴... وارد کنید.');
      return false;
    }
    if (!consent) {
      setState(() => error = 'برای عضویت، پذیرش شرایط و اطلاعیه حریم خصوصی لازم است.');
      return false;
    }
    setState(() => error = null);
    return true;
  }

  Future<void> _sendCode() async {
    if (!_validate() || busy || cooldown > 0) return;
    setState(() {
      busy = true;
      error = null;
      info = null;
    });
    try {
      final currentUser = db.auth.currentUser;
      if (db.auth.currentSession != null &&
          currentUser != null &&
          currentUser.phone == normalizedPhone) {
        await _saveVerifiedMember(currentUser);
        return;
      }
      await db.auth.signInWithOtp(
        phone: normalizedPhone,
        shouldCreateUser: true,
      );
      if (!mounted) return;
      setState(() {
        waitingForCode = true;
        cooldown = 60;
        info = 'کد ورود به شماره ثبت‌شده پیامک شد. آن را با کسی به اشتراک نگذارید.';
      });
      cooldownTimer?.cancel();
      cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        if (cooldown <= 1) {
          timer.cancel();
          setState(() => cooldown = 0);
        } else {
          setState(() => cooldown--);
        }
      });
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() => error = e.statusCode == '429'
          ? 'درخواست پیامک بیش از حد بوده؛ کمی بعد دوباره تلاش کنید.'
          : 'ارسال پیامک ناموفق بود. سرویس پیامک و اتصال اینترنت را بررسی کنید.');
    } catch (_) {
      if (mounted) setState(() =>
          error = 'ارسال پیامک امکان‌پذیر نشد. سرویس پیامک ممکن است فعال نباشد.');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _verify() async {
    final token = _westernDigits(otp.text).replaceAll(RegExp(r'\D'), '');
    if (!RegExp(r'^\d{6}$').hasMatch(token)) {
      setState(() => error = 'کد شش‌رقمی پیامک را وارد کنید.');
      return;
    }
    setState(() { busy = true; error = null; });
    try {
      final response = await db.auth.verifyOTP(
        phone: normalizedPhone,
        token: token,
        type: OtpType.sms,
      );
      if (response.user == null || db.auth.currentSession == null) {
        throw StateError('No verified session');
      }
      await _saveVerifiedMember(response.user!);
    } on AuthException {
      if (mounted) setState(() =>
          error = 'کد نادرست یا منقضی است. دوباره تلاش کنید.');
    } catch (_) {
      if (mounted) setState(() =>
          error = 'تأیید یا ثبت پروفایل ناموفق بود. دوباره تلاش کنید.');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _saveVerifiedMember(User user) async {
    if (db.auth.currentSession == null ||
        (user.phone ?? '') != normalizedPhone) {
      throw StateError('Verified phone does not match');
    }
    // Never allow client-only local data to assert verified membership.
    final row = await db.from('royal_club_members').upsert({
      'user_id': user.id,
      'full_name': cleanedName,
      'phone': normalizedPhone,
      'accepted_terms_at': DateTime.now().toUtc().toIso8601String(),
    }, onConflict: 'user_id')
        .select('member_code,avatar_path,full_name,phone').single();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(RoyalClubMembershipPage.fullNameKey, cleanedName);
    await prefs.setString(RoyalClubMembershipPage.phoneKey, normalizedPhone);
    if (!prefs.containsKey(RoyalClubMembershipPage.joinedAtKey)) {
      await prefs.setString(RoyalClubMembershipPage.joinedAtKey,
          DateTime.now().toUtc().toIso8601String());
    }
    if (!mounted) return;
    setState(() {
      member = true;
      waitingForCode = false;
      otp.clear();
      memberCode = row['member_code']?.toString();
      avatarPath = row['avatar_path']?.toString();
      info = 'عضویت شما با تأیید شماره موبایل در سامانه ثبت شد.';
      error = null;
    });
    cooldownTimer?.cancel();
    if (photoBytes != null) {
      await _uploadPhoto();
    } else {
      await _loadAvatar();
    }
  }

  Future<void> _choosePhoto() async {
    if (busy) return;
    try {
      final photo = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 77,
      );
      if (photo == null) return;
      final suffix = photo.name.toLowerCase();
      final extension = suffix.endsWith('.png') ? 'png' :
          suffix.endsWith('.webp') ? 'webp' :
          (suffix.endsWith('.jpg') || suffix.endsWith('.jpeg')) ? 'jpg' : null;
      if (extension == null) {
        setState(() => error = 'عکس باید با فرمت JPG، PNG یا WEBP باشد.');
        return;
      }
      final bytes = await photo.readAsBytes();
      if (bytes.lengthInBytes > 2097152) {
        setState(() => error = 'اندازه عکس باید کمتر از دو مگابایت باشد.');
        return;
      }
      if (!mounted) return;
      setState(() {
        photoBytes = bytes;
        photoExtension = extension;
        photoMime = extension == 'png' ? 'image/png' :
            extension == 'webp' ? 'image/webp' : 'image/jpeg';
        error = null;
      });
      if (member) {
        setState(() => busy = true);
        try {
          await _uploadPhoto();
        } finally {
          if (mounted) setState(() => busy = false);
        }
      }
    } catch (_) {
      if (mounted) setState(() =>
          error = 'انتخاب یا بارگذاری عکس انجام نشد. دوباره تلاش کنید.');
    }
  }

  Future<void> _uploadPhoto() async {
    final user = db.auth.currentUser;
    final bytes = photoBytes;
    if (user == null || db.auth.currentSession == null || bytes == null) return;
    final newPath = user.id + '/avatar.' + photoExtension;
    try {
      await db.storage.from(avatarBucket).uploadBinary(
        newPath,
        bytes,
        fileOptions: FileOptions(upsert: true, contentType: photoMime),
      );
      await db.from('royal_club_members').update({
        'avatar_path': newPath,
      }).eq('user_id', user.id);
      if (!mounted) return;
      setState(() {
        avatarPath = newPath;
        photoBytes = null;
        info = 'عکس پروفایل با موفقیت ذخیره شد.';
      });
      await _loadAvatar();
    } catch (_) {
      if (mounted) setState(() =>
          error = 'عضویت ثبت شده، اما عکس بارگذاری نشد. بعداً دوباره امتحان کنید.');
    }
  }

  Future<void> _loadAvatar() async {
    if (avatarPath == null || avatarPath!.isEmpty) return;
    try {
      final url = await db.storage.from(avatarBucket)
          .createSignedUrl(avatarPath!, 3600);
      if (mounted) setState(() => avatarUrl = url);
    } catch (_) {
      if (mounted) setState(() => avatarUrl = null);
    }
  }

  @override
  void dispose() {
    cooldownTimer?.cancel();
    name.dispose();
    phone.dispose();
    otp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderSide: BorderSide(color: gold),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    );
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('عضویت رویال کلاب'),
        centerTitle: true,
        backgroundColor: const Color(0xFF112C20),
        foregroundColor: gold,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 550),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 17, 20, 35),
              children: [
                const Icon(Icons.diamond_outlined, color: gold, size: 48),
                const SizedBox(height: 5),
                const Text('ROYAL CLUB · SAHAND CONSORTIUM',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: gold, letterSpacing: 1.2,
                    fontSize: 11)),
                const SizedBox(height: 20),
                if (loading)
                  const Center(child: CircularProgressIndicator(color: gold))
                else ...[
                  if (member)
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFF163628),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: gold),
                      ),
                      child: Column(children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.verified, color: Color(0xFF82E6A2)),
                            SizedBox(width: 7),
                            Text('حساب تأییدشده',
                              style: TextStyle(color: ivory,
                                fontSize: 17, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        if (memberCode != null) ...[
                          const SizedBox(height: 10),
                          Text('شماره عضویت: ' + memberCode!,
                            style: const TextStyle(color: gold,
                              fontSize: 14)),
                          const SizedBox(height: 12),
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(11),
                            child: QrImageView(
                              data: 'ROYAL-CLUB:' + memberCode!,
                              version: QrVersions.auto,
                              size: 178,
                              backgroundColor: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 9),
                          const Text(
                            'کد عضویت شخصی است؛ اسکن و اعتبارسنجی خدمات حضوری بعداً فعال می‌شود.',
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white70,
                              fontSize: 11)),
                        ],
                      ]),
                    ),
                  if (member) const SizedBox(height: 18),
                  Center(child: Stack(children: [
                    CircleAvatar(
                      radius: 49,
                      backgroundColor: const Color(0xFF5F4C24),
                      child: CircleAvatar(
                        radius: 46,
                        backgroundColor: const Color(0xFF11271B),
                        backgroundImage: photoBytes != null
                          ? MemoryImage(photoBytes!) as ImageProvider
                          : avatarUrl != null
                            ? NetworkImage(avatarUrl!) : null,
                        child: photoBytes == null && avatarUrl == null
                          ? const Icon(Icons.person_rounded,
                            color: gold, size: 48) : null,
                      ),
                    ),
                    Positioned(
                      right: 0, bottom: 0,
                      child: IconButton.filled(
                        onPressed: busy ? null : _choosePhoto,
                        tooltip: 'انتخاب عکس پروفایل (اختیاری)',
                        icon: const Icon(Icons.photo_camera_outlined),
                        style: IconButton.styleFrom(
                          backgroundColor: gold,
                          foregroundColor: background),
                      ),
                    ),
                  ])),
                  const SizedBox(height: 5),
                  const Text('عکس اختیاری است و فقط در فضای خصوصی شما ذخیره می‌شود.',
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white54, fontSize: 11)),
                  const SizedBox(height: 20),
                  if (!waitingForCode) ...[
                    TextField(
                      controller: name,
                      enabled: !busy,
                      textDirection: TextDirection.rtl,
                      textCapitalization: TextCapitalization.words,
                      maxLength: 120,
                      style: const TextStyle(color: ivory),
                      decoration: const InputDecoration(
                        labelText: 'نام و نام خانوادگی',
                        labelStyle: TextStyle(color: gold),
                        enabledBorder: border, focusedBorder: border,
                        counterStyle: TextStyle(color: Colors.white38),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: phone,
                      enabled: !member && !busy,
                      keyboardType: TextInputType.phone,
                      textDirection: TextDirection.ltr,
                      style: const TextStyle(color: ivory),
                      decoration: InputDecoration(
                        labelText: member ? 'موبایل تأییدشده' : 'شماره موبایل ایران (۰۹...)',
                        labelStyle: const TextStyle(color: gold),
                        enabledBorder: border, focusedBorder: border,
                        helperText: member ? 'برای تغییر شماره، ابتدا از حساب خارج شوید.' : null,
                        helperStyle: const TextStyle(color: Colors.white60),
                      ),
                    ),
                    const SizedBox(height: 10),
                    CheckboxListTile(
                      value: consent,
                      onChanged: busy ? null :
                        (v) => setState(() => consent = v ?? false),
                      activeColor: gold,
                      checkColor: background,
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'شرایط عضویت و پردازش نام، شماره موبایل و عکس اختیاری '
                        'برای ارائه خدمات رویال کلاب را می‌پذیرم.',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(color: Colors.white70,
                          height: 1.6, fontSize: 12),
                      ),
                    ),
                  ] else ...[
                    Text('کد ارسال‌شده به ' + normalizedPhone,
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(color: ivory)),
                    const SizedBox(height: 13),
                    TextField(
                      controller: otp,
                      autofocus: true,
                      enabled: !busy,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      inputFormatters: [FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9۰-۹٠-٩]'))],
                      decoration: const InputDecoration(
                        labelText: 'کد شش‌رقمی پیامک',
                        labelStyle: TextStyle(color: gold),
                        enabledBorder: border, focusedBorder: border,
                      ),
                      style: const TextStyle(color: ivory, fontSize: 24,
                        letterSpacing: 4),
                    ),
                    TextButton(
                      onPressed: busy ? null : () => setState(() {
                        waitingForCode = false;
                        otp.clear();
                        error = null;
                      }),
                      child: const Text('اصلاح شماره',
                        style: TextStyle(color: gold)),
                    ),
                    TextButton(
                      onPressed: busy || cooldown > 0 ? null : _sendCode,
                      child: Text(cooldown > 0
                          ? 'ارسال دوباره کد تا ' + cooldown.toString() + ' ثانیه'
                          : 'ارسال دوباره کد',
                        style: TextStyle(
                          color: cooldown > 0 ? Colors.white54 : gold)),
                    ),
                  ],
                  if (info != null) Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(info!,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFF94D9A7))),
                  ),
                  if (error != null) Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(error!,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.redAccent))),
                  const SizedBox(height: 11),
                  ElevatedButton(
                    onPressed: busy ? null :
                      waitingForCode ? _verify :
                      member ? () async {
                        if (!_validate()) return;
                        setState(() => busy = true);
                        try {
                          final user = db.auth.currentUser;
                          if (user != null) await _saveVerifiedMember(user);
                        } catch (_) {
                          if (mounted) setState(() =>
                            error = 'ذخیرهٔ تغییرات انجام نشد.');
                        } finally {
                          if (mounted) setState(() => busy = false);
                        }
                      } : _sendCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF542018),
                      foregroundColor: gold,
                      padding: const EdgeInsets.all(16),
                      side: const BorderSide(color: gold),
                    ),
                    child: Text(
                      busy ? 'لطفاً صبر کنید...' :
                      waitingForCode ? 'تأیید کد و تکمیل عضویت' :
                      member ? 'ذخیرهٔ اطلاعات' : 'دریافت کد تأیید پیامکی',
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'فعال‌سازی فقط با شمارهٔ تأییدشده و ثبت موفق در سرور انجام می‌شود. '
                    'شماره موبایل در کارت عضویت عمومی نمایش داده نمی‌شود.',
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white54,
                      fontSize: 11, height: 1.7)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
