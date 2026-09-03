import 'package:flutter/material.dart';

class SalonDetailPage extends StatefulWidget {
  final String salonName;

  const SalonDetailPage({
    super.key,
    required this.salonName,
  });

  @override
  State<SalonDetailPage> createState() => _SalonDetailPageState();
}

class _SalonDetailPageState extends State<SalonDetailPage> {
  static const bg = Color(0xFF050807);
  static const panel = Color(0xFF0C1210);
  static const gold = Color(0xFFD6B15E);
  static const gold2 = Color(0xFFFFD77A);
  static const emerald = Color(0xFF0B3A2A);

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int? selectedDesign;
  int? selectedCake;

  final Map<String, String> salonImages = {
    'Salon Lumière': 'assets/image/salon_lumiere.png',
    'Salon Noir': 'assets/image/salon_noir.png',
    'Salon Jardin': 'assets/image/salon_jardin.png',
    'Salon Privé': 'assets/image/salon_prive.png',
    'RV Lounge Impérial Classique':
        'assets/image/rv_lounge_imperial_classique.png',
    'Salon Doré': 'assets/image/salon_dore.png',
    'Salon Âme du Poète': 'assets/image/salon_ame_du_poete.png',
    'Salon Royal': 'assets/image/salon_de_lame.png',
  };

  final Map<String, String> salonDescriptions = {
    'Salon Lumière':
        'فضایی روشن، ظریف و لوکس برای دورهمی‌ها و مراسم خاص.',
    'Salon Noir':
        'فضایی دراماتیک، خصوصی و متفاوت برای لحظه‌های فراموش‌نشدنی.',
    'Salon Jardin':
        'حال‌وهوای باغی، گل‌آرایی خاص و فضایی رؤیایی.',
    'Salon Privé':
        'فضایی آرام و خصوصی برای مهمانی‌ها و لحظه‌های ویژه.',
    'RV Lounge Impérial Classique':
        'لانژ اختصاصی و امضای VIP مجموعه Royal Village.',
    'Salon Doré':
        'ترکیب طراحی مدرن و فضای طلایی برای یک مراسم لوکس.',
    'Salon Âme du Poète':
        'فضایی شاعرانه، نوستالژیک و متفاوت با شخصیت هنری.',
    'Salon Royal':
        'فضای کلاسیک و سلطنتی برای پذیرایی‌ها و مراسم رسمی.',
  };

  String get imagePath =>
      salonImages[widget.salonName] ??
      'assets/image/royal_village.png';

  String get description =>
      salonDescriptions[widget.salonName] ??
      'فضای اختصاصی Royal Village برای مراسم ویژه.';

  Future<void> pickDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
    );

    if (result != null) {
      setState(() {
        selectedDate = result;
      });
    }
  }

  Future<void> pickTime() async {
    final result = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (result != null) {
      setState(() {
        selectedTime = result;
      });
    }
  }

  void showDesigns() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0B0D0C),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '۱۰ دیزاین اختصاصی',
                  style: TextStyle(
                    color: gold2,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.salonName,
                  style: const TextStyle(
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: 18),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 10,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2.6,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final number = index + 1;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedDesign = number;
                        });
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedDesign == number
                              ? emerald
                              : panel,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: selectedDesign == number
                                ? gold2
                                : gold.withOpacity(.45),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'دیزاین $number',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showCakes() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0B0D0C),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '۱۰ کیک اختصاصی',
                  style: TextStyle(
                    color: gold2,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.salonName,
                  style: const TextStyle(
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: 18),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 10,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2.6,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final number = index + 1;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedCake = number;
                        });
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedCake == number
                              ? emerald
                              : panel,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: selectedCake == number
                                ? gold2
                                : gold.withOpacity(.45),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'کیک $number',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void reserve() {
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'ابتدا تاریخ و ساعت مراسم را انتخاب کنید',
            textDirection: TextDirection.rtl,
          ),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: panel,
          title: const Text(
            'درخواست رزرو',
            textDirection: TextDirection.rtl,
            style: TextStyle(color: gold2),
          ),
          content: Text(
            '${widget.salonName}\n\n'
            'تاریخ: ${selectedDate!.year}/${selectedDate!.month}/${selectedDate!.day}\n'
            'ساعت: ${selectedTime!.format(context)}\n'
            'دیزاین: ${selectedDesign ?? "انتخاب نشده"}\n'
            'کیک: ${selectedCake ?? "انتخاب نشده"}',
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              color: Colors.white,
              height: 1.8,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'بازگشت',
                style: TextStyle(color: Colors.white60),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: emerald,
                foregroundColor: gold2,
              ),
              onPressed: () {
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'درخواست رزرو ثبت شد',
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                );
              },
              child: const Text('ثبت درخواست'),
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
          foregroundColor: gold,
          elevation: 0,
          centerTitle: true,
          title: Text(
            widget.salonName,
            textDirection: TextDirection.ltr,
            style: const TextStyle(
              color: gold2,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 30),
          children: [

            ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: Stack(
                children: [
                  Image.asset(
                    imagePath,
                    width: double.infinity,
                    height: 270,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        height: 270,
                        color: panel,
                        child: const Center(
                          child: Icon(
                            Icons.meeting_room_outlined,
                            color: gold,
                            size: 70,
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(.15),
                            Colors.black.withOpacity(.8),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 18,
                    left: 18,
                    bottom: 18,
                    child: Text(
                      widget.salonName,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: gold2,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 12,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.8,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'رزرو مراسم',
              style: TextStyle(
                color: gold2,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _ChoiceCard(
                    icon: Icons.calendar_month_outlined,
                    title: 'تاریخ',
                    value: selectedDate == null
                        ? 'انتخاب تاریخ'
                        : '${selectedDate!.year}/${selectedDate!.month}/${selectedDate!.day}',
                    onTap: pickDate,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ChoiceCard(
                    icon: Icons.access_time_rounded,
                    title: 'ساعت',
                    value: selectedTime == null
                        ? 'انتخاب ساعت'
                        : selectedTime!.format(context),
                    onTap: pickTime,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            _ActionCard(
              icon: Icons.celebration_outlined,
              title: '۱۰ مدل دیزاین اختصاصی',
              subtitle: selectedDesign == null
                  ? 'انتخاب تم و دیزاین مخصوص این سالن'
                  : 'دیزاین $selectedDesign انتخاب شده',
              button: 'مشاهده دیزاین‌ها',
              onTap: showDesigns,
            ),

            const SizedBox(height: 12),

            _ActionCard(
              icon: Icons.cake_outlined,
              title: '۱۰ مدل کیک اختصاصی',
              subtitle: selectedCake == null
                  ? 'انتخاب کیک متناسب با سالن و مراسم'
                  : 'کیک $selectedCake انتخاب شده',
              button: 'مشاهده کیک‌ها',
              onTap: showCakes,
            ),

            const SizedBox(height: 12),

            const _InfoCard(),

            const SizedBox(height: 18),

            SizedBox(
              height: 58,
              child: ElevatedButton(
                onPressed: reserve,
                style: ElevatedButton.styleFrom(
                  backgroundColor: emerald,
                  foregroundColor: gold2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: const BorderSide(
                      color: gold,
                    ),
                  ),
                ),
                child: const Text(
                  'ادامه و ثبت رزرو',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  const _ChoiceCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: _SalonDetailPageState.panel,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _SalonDetailPageState.gold.withOpacity(.55),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: _SalonDetailPageState.gold2,
              size: 27,
            ),
            const SizedBox(height: 7),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String button;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.button,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: _SalonDetailPageState.panel,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _SalonDetailPageState.gold.withOpacity(.7),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: _SalonDetailPageState.gold2,
                size: 31,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: _SalonDetailPageState.gold2,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: _SalonDetailPageState.gold2,
                side: const BorderSide(
                  color: _SalonDetailPageState.gold,
                ),
                padding: const EdgeInsets.all(14),
              ),
              child: Text(button),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF102319),
            Color(0xFF090C0A),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _SalonDetailPageState.gold,
        ),
      ),
      child: const Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.workspace_premium_outlined,
                color: _SalonDetailPageState.gold2,
                size: 31,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'VIP EXPERIENCE',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    color: _SalonDetailPageState.gold2,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'خدمات اختصاصی، دیزاین مراسم، کیک ویژه، پذیرایی و سورپرایز',
            style: TextStyle(
              color: Colors.white70,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}