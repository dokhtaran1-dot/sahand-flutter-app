import 'package:flutter/material.dart';
import 'reservation_store.dart';

class ReservationPage extends StatefulWidget {
  final String salonName;
  final DateTime? initialDate;
  final TimeOfDay? initialTime;
  final String? initialDesign;
  final String? initialCake;
  final String? initialMusic;

  const ReservationPage({
    super.key,
    required this.salonName,
    this.initialDate,
    this.initialTime,
    this.initialDesign,
    this.initialCake,
    this.initialMusic,
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

  Future<void> _submit() async {
    if (selectedDate == null ||
        selectedTime == null ||
        nameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'لطفاً نام، شماره تماس، تاریخ و ساعت را کامل کنید',
            textDirection: TextDirection.rtl,
          ),
        ),
      );
      return;
    }
    try {
      await ReservationStore.instance.add(
        ReservationRecord(
          salonName: widget.salonName,
          customerName: nameController.text.trim(),
          phone: phoneController.text.trim(),
          date: '${selectedDate!.year}/${selectedDate!.month}/${selectedDate!.day}',
          time: selectedTime!.format(context),
          guests: guests,
          design: design,
          cake: cake,
          music: music ?? '',
          note: noteController.text.trim(),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ذخیره درخواست انجام نشد؛ دوباره تلاش کنید.',
              textDirection: TextDirection.rtl),
        ),
      );
      return;
    }
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFF07110E),
          title: const Text(
            'درخواست روی گوشی شما ذخیره شد',
            textDirection: TextDirection.rtl,
            style: TextStyle(color: goldLight),
          ),
          content: Text(
            '${widget.salonName}\n'
            'تعداد مهمان: $guests نفر\n'
            'دیزاین: $design\n'
            'کیک: $cake\\n'
            'موسیقی: ${music ?? 'انتخاب نشده'}\\n\\n'
            'این درخواست هنوز برای مدیریت رویال ویلیج ارسال نشده '
            'و رزرو شما قطعی نیست.',
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              color: Colors.white,
              height: 1.8,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text(
                'تأیید',
                style: TextStyle(color: goldLight),
              ),
            ),
          ],
        );
      },
    );
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

              const SizedBox(height: 30),

              SizedBox(
                height: 60,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: emerald,
                    foregroundColor: goldLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: gold),
                    ),
                  ),
                  child: const Text(
                    'ثبت درخواست رزرو',
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
