import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'reservation_store.dart';
import 'rv_online_booking_service.dart';
import 'my_reservations_page.dart';
import 'royal_club_membership_page.dart';

class ReservationPage extends StatefulWidget {
  final String salonName;
  final DateTime? initialDate;
  final TimeOfDay? initialTime;
  final String? initialDesign;
  final String? initialCake;
  final String? initialMusic;
  final String? initialExtras;

  const ReservationPage({
    super.key,
    required this.salonName,
    this.initialDate,
    this.initialTime,
    this.initialDesign,
    this.initialCake,
    this.initialMusic,
    this.initialExtras,
  });

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  static const bg = Color(0xFF020706);
  static const emerald = Color(0xFF063D30);
  static const gold = Color(0xFFD5AD57);
  static const goldLight = Color(0xFFF0D58C);

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int guests = 2;
  String design = 'Classic';
  String cake = 'بدون کیک';
  String? music;
  bool privacyConsent = false;
  bool sending = false;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    selectedTime = widget.initialTime;
    design = widget.initialDesign ?? design;
    cake = widget.initialCake ?? cake;
    music = widget.initialMusic;
    noteController.text = widget.initialExtras ?? '';
    _prefillMember();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (result != null) {
      setState(() => selectedDate = result);
    }
  }

  Future<void> _pickTime() async {
    final result = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? const TimeOfDay(hour: 20, minute: 0),
    );

    if (result != null) {
      setState(() => selectedTime = result);
    }
  }

  Future<void> _prefillMember() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    nameController.text = prefs.getString(RoyalClubMembershipPage.fullNameKey) ?? '';
    phoneController.text = prefs.getString(RoyalClubMembershipPage.phoneKey) ?? '';
  }

  ReservationRecord _buildRecord({String? onlineId}) => ReservationRecord(
    salonName: widget.salonName,
    customerName: nameController.text.trim(),
    phone: RvOnlineBookingService.normalizePhone(phoneController.text),
    date: '${selectedDate!.year}/${selectedDate!.month}/${selectedDate!.day}',
    time: '${selectedTime!.hour.toString().padLeft(2, '0')}:'
        '${selectedTime!.minute.toString().padLeft(2, '0')}',
    guests: guests,
    design: design,
    cake: cake,
    music: music ?? '',
    note: noteController.text.trim(),
    onlineId: onlineId,
  );

  void _alert(String title, String message) {
    if (!mounted) return;
    showDialog<void>(context: context, builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF07110E),
      title: Text(title, textDirection: TextDirection.rtl,
        style: const TextStyle(color: goldLight)),
      content: Text(message, textDirection: TextDirection.rtl,
        style: const TextStyle(color: Colors.white, height: 1.7)),
      actions: [TextButton(onPressed: () => Navigator.pop(context),
        child: const Text('متوجه شدم'))],
    ));
  }

  Future<void> _saveDraft() async {
    if (selectedDate == null || selectedTime == null ||
        nameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty) return;
    try {
      await ReservationStore.instance.add(_buildRecord());
      _alert('پیش‌نویس فقط روی گوشی ذخیره شد',
        'این درخواست به مدیریت ارسال نشده و رزرو قطعی نیست. '
        'پس از اتصال اینترنت و ورود با شماره تأییدشده، دوباره آن را ارسال کنید.');
    } catch (_) {
      _alert('ذخیره انجام نشد', 'ذخیره پیش‌نویس روی این دستگاه ناموفق بود.');
    }
  }

  Future<void> _submit() async {
    if (sending) return;
    if (selectedDate == null || selectedTime == null ||
        nameController.text.trim().length < 3 ||
        phoneController.text.trim().isEmpty) {
      _alert('اطلاعات ناقص', 'لطفاً نام، شماره تماس، تاریخ و ساعت را کامل کنید.');
      return;
    }
    if (guests > 30 || selectedTime!.hour < 7 ||
        selectedTime!.hour > 23 || noteController.text.length > 1000) {
      _alert('اطلاعات نامعتبر',
        'ساعت پذیرش درخواست از ۷:۰۰ تا ۲۴:۰۰، حداکثر ۳۰ مهمان '
        'و حداکثر ۱۰۰۰ نویسه توضیحات است.');
      return;
    }
    if (!privacyConsent) {
      _alert('تأیید حریم خصوصی', 'برای ارسال درخواست باید با استفاده از '
        'نام و شماره تماس جهت پیگیری رزرو موافقت کنید.');
      return;
    }
    if (!RvOnlineBookingService.configured) {
      _alert('ارسال آنلاین فعال نیست',
        'در این نسخه اتصال سرور تنظیم نشده است. '
        'درخواست برای مدیریت ارسال نشده و رزرو قطعی نیست.');
      return;
    }
    if (!RvOnlineBookingService.isVerified) {
      final go = await showDialog<bool>(context: context,
        builder: (dialog) => AlertDialog(
          backgroundColor: const Color(0xFF07110E),
          title: const Text('تأیید شماره موبایل',
            style: TextStyle(color: goldLight)),
          content: const Text('برای ارسال امن درخواست رزرو، '
            'ابتدا با کد پیامکی در رویال کلاب وارد شوید. '
            'سپس به همین فرم برگردید و ثبت را لمس کنید.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialog, false),
              child: const Text('بعداً')),
            FilledButton(onPressed: () => Navigator.pop(dialog, true),
              child: const Text('تأیید شماره')),
          ],
        ));
      if (go == true && mounted) {
        await Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (_) => const RoyalClubMembershipPage()));
        if (mounted) _alert('بازگشت به رزرو',
          'اگر شماره با کد پیامکی تأیید شد، دکمهٔ ثبت درخواست رزرو را دوباره بزنید.');
      }
      return;
    }

    setState(() => sending = true);
    try {
      final request = _buildRecord();
      final id = await RvOnlineBookingService.submit(
        request, date: selectedDate!,
        hour: selectedTime!.hour, minute: selectedTime!.minute);
      try {
        await ReservationStore.instance.add(_buildRecord(onlineId: id));
      } catch (_) {
        // Server already accepted it. Never report a failed submission or
        // encourage a duplicate because the local device storage failed.
      }
      if (!mounted) return;
      _alert('درخواست به سامانه مدیریت ارسال شد',
        'شماره پیگیری: ${id.substring(0, 8).toUpperCase()}\\n'
        'وضعیت: در انتظار تأیید مدیریت رویال ویلاژ. '
        'این پیام تأیید قطعی رزرو یا تضمین ظرفیت نیست. '
        'وضعیت را از «درخواست‌های من» بررسی کنید.');
    } on PostgrestException catch (e) {
      if (!mounted) return;
      if (e.code == '23505') {
        _alert('درخواست تکراری', 'برای همین سالن، تاریخ و ساعت '
          'قبلاً درخواست باز ثبت کرده‌اید. وضعیت را در درخواست‌های من ببینید.');
      } else {
        _alert('ارسال آنلاین ناموفق',
          'درخواست به مدیریت ارسال نشد. اتصال یا شماره تأییدشده را بررسی کنید. '
          'می‌توانید با دکمهٔ ذخیره پیش‌نویس، اطلاعات را فقط روی گوشی نگه دارید.');
      }
    } on FormatException catch (e) {
      _alert('اطلاعات رزرو', e.message);
    } on StateError catch (e) {
      _alert('تأیید رزرو انجام نشد', e.message.contains('PHONE')
        ? 'شماره تماس فرم باید با شماره تأییدشده شما یکسان باشد. '
          'شماره را اصلاح کنید و دوباره تلاش کنید.'
        : 'ورود یا اتصال سرور در دسترس نیست.');
    } catch (_) {
      _alert('ارسال آنلاین ناموفق',
        'درخواست به مدیریت ارسال نشد. پیش از تلاش دوباره اتصال اینترنت را بررسی کنید.');
    } finally {
      if (mounted) setState(() => sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: bg,
          elevation: 0,
          foregroundColor: goldLight,
          centerTitle: true,
          title: Text(
            widget.salonName,
            textDirection: TextDirection.ltr,
            style: const TextStyle(
              color: goldLight,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'PRIVATE RESERVATION',
                textAlign: TextAlign.center,
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  color: gold,
                  letterSpacing: 3,
                  fontSize: 11,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'رزرو اختصاصی رویال ویلیج',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 28),

              _field(
                controller: nameController,
                label: 'نام و نام خانوادگی',
                icon: Icons.person_outline,
              ),

              const SizedBox(height: 12),

              _field(
                controller: phoneController,
                label: 'شماره تماس',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: _selector(
                      icon: Icons.calendar_month_outlined,
                      title: selectedDate == null
                          ? 'انتخاب تاریخ'
                          : '${selectedDate!.year}/${selectedDate!.month}/${selectedDate!.day}',
                      onTap: _pickDate,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _selector(
                      icon: Icons.schedule_outlined,
                      title: selectedTime == null
                          ? 'انتخاب ساعت'
                          : selectedTime!.format(context),
                      onTap: _pickTime,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                'تعداد مهمان',
                style: TextStyle(
                  color: goldLight,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Container(
                height: 70,
                decoration: _box(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (guests > 1) {
                          setState(() => guests--);
                        }
                      },
                      icon: const Icon(
                        Icons.remove_circle_outline,
                        color: goldLight,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      '$guests نفر',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: () {
                        setState(() => guests++);
                      },
                      icon: const Icon(
                        Icons.add_circle_outline,
                        color: goldLight,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'دیزاین مراسم',
                style: TextStyle(
                  color: goldLight,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'Classic',
                  'Royal',
                  'Romantic',
                  'VIP',
                  'Birthday',
                  if (widget.initialDesign != null &&
                      !const ['Classic', 'Royal', 'Romantic', 'VIP', 'Birthday']
                          .contains(widget.initialDesign))
                    widget.initialDesign!,
                ].map((item) {
                  return ChoiceChip(
                    label: Text(item),
                    selected: design == item,
                    onSelected: (_) {
                      setState(() => design = item);
                    },
                    selectedColor: emerald,
                    backgroundColor: const Color(0xFF08110E),
                    side: const BorderSide(color: gold),
                    labelStyle: TextStyle(
                      color: design == item
                          ? goldLight
                          : Colors.white70,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              const Text(
                'کیک',
                style: TextStyle(
                  color: goldLight,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'بدون کیک',
                  'کیک اختصاصی',
                  'کیک تولد',
                  'کیک VIP',
                  if (widget.initialCake != null &&
                      !const ['بدون کیک', 'کیک اختصاصی', 'کیک تولد', 'کیک VIP']
                          .contains(widget.initialCake))
                    widget.initialCake!,
                ].map((item) {
                  return ChoiceChip(
                    label: Text(item),
                    selected: cake == item,
                    onSelected: (_) {
                      setState(() => cake = item);
                    },
                    selectedColor: emerald,
                    backgroundColor: const Color(0xFF08110E),
                    side: const BorderSide(color: gold),
                    labelStyle: TextStyle(
                      color: cake == item
                          ? goldLight
                          : Colors.white70,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              const Text(
                'موسیقی',
                style: TextStyle(color: goldLight, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (music != null)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: _box(),
                  child: Row(children: [
                    const Icon(Icons.music_note_rounded, color: goldLight),
                    const SizedBox(width: 10),
                    Expanded(child: Text(music!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                  ]),
                )
              else
                const Text('موسیقی در صفحه سالن انتخاب نشده است.', style: TextStyle(color: Colors.white54)),

              const SizedBox(height: 24),

              _field(
                controller: noteController,
                label: 'توضیحات یا درخواست ویژه',
                icon: Icons.edit_note_outlined,
                maxLines: 4,
              ),

              const SizedBox(height: 18),
              CheckboxListTile(
                value: privacyConsent,
                onChanged: sending ? null
                  : (value) => setState(() => privacyConsent = value ?? false),
                activeColor: gold,
                title: const Text(
                  'با ارسال نام و شماره تماس جهت بررسی درخواست رزرو موافقم. '
                  'ثبت درخواست به معنی قطعی‌شدن رزرو نیست.',
                  style: TextStyle(color: Colors.white70, fontSize: 12)),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: sending ? null : _saveDraft,
                icon: const Icon(Icons.save_outlined),
                label: const Text('ذخیره پیش‌نویس فقط روی این گوشی'),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute<void>(
                  builder: (_) => const MyReservationsPage())),
                icon: const Icon(Icons.receipt_long),
                label: const Text('درخواست‌های من و وضعیت آنلاین'),
              ),
              const SizedBox(height: 30),

              SizedBox(
                height: 60,
                child: ElevatedButton(
                  onPressed: sending ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: emerald,
                    foregroundColor: goldLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: gold),
                    ),
                  ),
                  child: const Text(
                    'ارسال آنلاین درخواست رزرو',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: gold),
        filled: true,
        fillColor: const Color(0xFF07100D),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: gold.withOpacity(.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: gold,
            width: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _selector({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 82,
        decoration: _box(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: goldLight),
            const SizedBox(height: 7),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _box() {
    return BoxDecoration(
      color: const Color(0xFF07100D),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: gold.withOpacity(.6),
      ),
    );
  }
}
