import 'package:flutter/material.dart';

/// RE / Royal Etehad — executive profile based on supplied role facts.
/// No unverified qualifications, dates, awards or claims are presented.
class RoyalEtehadProfilePage extends StatelessWidget {
  const RoyalEtehadProfilePage({super.key});

  static const _bg = Color(0xFF060D17);
  static const _panel = Color(0xFF101D30);
  static const _royalBlue = Color(0xFF18395E);
  static const _gold = Color(0xFFE3C78F);
  static const _white = Color(0xFFF4F0E8);
  static const _muted = Color(0xFFACBED1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        foregroundColor: _gold,
        centerTitle: true,
        title: const Text(
          'RE  /  ROYAL ETTEHAD',
          style: TextStyle(
            fontSize: 13, letterSpacing: 2.1,
            fontWeight: FontWeight.w600, color: _gold,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(17, 10, 17, 36),
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 25),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1E4674), Color(0xFF101E32), _bg],
                ),
                border: Border.all(color: const Color(0x668C7550)),
                borderRadius: BorderRadius.circular(23),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 120, height: 120,
                    child: _REEmblem(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'MASOUD ETTEHAD',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _gold, fontFamily: 'serif',
                      fontSize: 22, letterSpacing: 2.7,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'مسعود اتحاد',
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: _white, fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'بنیان‌گذار و مدیرعامل اتحاد سازه رویال',
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _white, fontSize: 14, height: 1.6),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'مشاور ارشد حوزهٔ ساخت در کنسرسیوم سهند',
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _muted, fontSize: 12, height: 1.7),
                  ),
                  const SizedBox(height: 19),
                  const Divider(color: Color(0x558F774E), height: 1),
                  const SizedBox(height: 17),
                  const Text(
                    'VISION  ·  STRUCTURE  ·  EXECUTION',
                    style: TextStyle(
                      color: _gold, fontSize: 10, letterSpacing: 1.9,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const _SectionHeading(en: 'EXECUTIVE PROFILE', fa: 'معرفی حرفه‌ای'),
            const SizedBox(height: 12),
            const Text(
              'مسعود اتحاد در حوزهٔ راهبری پروژه‌های عمرانی و توسعهٔ فضاهای تجاری '
              'فعالیت دارد. فعالیت‌های ثبت‌شدهٔ او بر هماهنگی اجرا، امور فنی، '
              'پشتیبانی پروژه و مدیریت عملیات ساختمانی متمرکز است.',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.justify,
              style: TextStyle(color: _white, fontSize: 13, height: 2),
            ),
            const SizedBox(height: 25),
            const _SectionHeading(en: 'SIGNATURE PROJECT', fa: 'پروژهٔ شاخص'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _panel,
                border: Border.all(color: const Color(0x668D7655)),
                borderRadius: BorderRadius.circular(19),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'ROYAL MALL  /  TABRIZ',
                    style: TextStyle(
                      color: _gold, fontSize: 12,
                      letterSpacing: 1.6, fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    'پروژهٔ توسعهٔ تجاری رویال مال',
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: _white, fontSize: 17, fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Row(
                    children: [
                      Expanded(child: _Metric(number: '3,600', label: 'مترمربع توسعه')),
                      SizedBox(width: 11),
                      Expanded(child: _Metric(number: '02', label: 'طبقهٔ تجاری')),
                    ],
                  ),
                  const SizedBox(height: 13),
                  const Text(
                    'پروژهٔ توسعه در مجموعهٔ رویال مال تبریز؛ '
                    'در چارچوب فعالیت‌های اجرایی و عمرانی اتحاد سازه رویال.',
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: TextStyle(color: _muted, fontSize: 12, height: 1.8),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const _SectionHeading(en: 'LEADERSHIP & ROLES', fa: 'مسئولیت‌های مدیریتی'),
            const SizedBox(height: 12),
            const _RoleCard(
              icon: Icons.apartment_outlined,
              en: 'ROYAL ETTEHAD SAZEH',
              fa: 'بنیان‌گذار و مدیرعامل',
              description: 'مدیریت فعالیت‌های اجرایی، فنی و هماهنگی پروژه‌های ساختمانی.',
            ),
            const SizedBox(height: 10),
            const _RoleCard(
              icon: Icons.account_balance_outlined,
              en: 'SAHAND CONSORTIUM',
              fa: 'مشاور ارشد حوزهٔ ساخت',
              description: 'مشارکت مشورتی در موضوعات ساخت و توسعهٔ پروژه‌های مجموعه.',
            ),
            const SizedBox(height: 10),
            const _RoleCard(
              icon: Icons.domain_outlined,
              en: 'ROYAL MALL · EXECUTIVE OFFICE',
              fa: 'مدیریت دفتر دوم و عملیات اجرایی',
              description: 'هماهنگی امور فنی، برنامه‌ریزی تعمیرات، تجهیزات اجرایی و نیروها.',
            ),
            const SizedBox(height: 25),
            const _SectionHeading(en: 'FOCUS AREAS', fa: 'حوزه‌های فعالیت'),
            const SizedBox(height: 12),
            const Wrap(
              spacing: 8,
              runSpacing: 9,
              alignment: WrapAlignment.end,
              children: [
                _FocusChip('توسعهٔ فضاهای تجاری'),
                _FocusChip('مدیریت پروژه'),
                _FocusChip('هماهنگی امور فنی'),
                _FocusChip('برنامه‌ریزی عملیات'),
                _FocusChip('تأمین تجهیزات اجرایی'),
                _FocusChip('هماهنگی نیروها'),
              ],
            ),
            const SizedBox(height: 27),
            const Center(child: SizedBox(width: 57, height: 57, child: _REEmblem())),
            const SizedBox(height: 8),
            const Text(
              'ROYAL ETTEHAD SAZEH',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _gold, letterSpacing: 2.3, fontSize: 11,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'DESIGN  ·  BUILD  ·  EXECUTE',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _muted, letterSpacing: 1.5, fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String en;
  final String fa;
  const _SectionHeading({required this.en, required this.fa});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(
        child: Text(
          en,
          style: const TextStyle(
            color: Color(0xFFE3C78F), fontSize: 10, letterSpacing: 1.5,
          ),
        ),
      ),
      const SizedBox(width: 10),
      Text(
        fa,
        textDirection: TextDirection.rtl,
        style: const TextStyle(
          color: Color(0xFFF4F0E8), fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

class _Metric extends StatelessWidget {
  final String number;
  final String label;
  const _Metric({required this.number, required this.label});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 9),
    decoration: BoxDecoration(
      color: const Color(0xFF192D45),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0x446E92B9)),
    ),
    child: Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            color: Color(0xFFE3C78F),
            fontSize: 25, fontWeight: FontWeight.w700,
            fontFamily: 'serif',
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          textDirection: TextDirection.rtl,
          style: const TextStyle(color: Color(0xFFD5E1EC), fontSize: 11),
        ),
      ],
    ),
  );
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String en;
  final String fa;
  final String description;
  const _RoleCard({
    required this.icon, required this.en,
    required this.fa, required this.description,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: const Color(0xFF101D30),
      border: Border.all(color: const Color(0x336F8FB0)),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFFE3C78F), size: 26),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                en,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Color(0xFFE3C78F),
                  fontSize: 10, letterSpacing: 1.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                fa,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  color: Color(0xFFF4F0E8),
                  fontSize: 15, fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                description,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Color(0xFFACBED1), fontSize: 12, height: 1.7,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _FocusChip extends StatelessWidget {
  final String title;
  const _FocusChip(this.title);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: const Color(0xFF172B43),
      border: Border.all(color: const Color(0x667F9AB4)),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      title,
      textDirection: TextDirection.rtl,
      style: const TextStyle(color: Color(0xFFDDE8F0), fontSize: 11),
    ),
  );
}

/// A custom architectural RE monogram — no external image required.
class _REEmblem extends StatelessWidget {
  const _REEmblem();

  @override
  Widget build(BuildContext context) => const CustomPaint(
    painter: _REEmblemPainter(),
    child: SizedBox.expand(),
  );
}

class _REEmblemPainter extends CustomPainter {
  const _REEmblemPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 220, size.height / 220);
    final gold = Paint()
      ..color = const Color(0xFFE3C78F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeJoin = StrokeJoin.round;
    final frame = Path()
      ..moveTo(110, 9)..lineTo(201, 56)..lineTo(201, 163)
      ..lineTo(110, 210)..lineTo(19, 163)..lineTo(19, 56)..close();
    canvas.drawPath(frame, gold);
    canvas.drawLine(const Offset(31, 167), const Offset(189, 167), gold);
    final r = Path()
      ..moveTo(56, 143)..lineTo(56, 66)..lineTo(87, 66)
      ..cubicTo(121, 66, 121, 101, 87, 101)
      ..lineTo(56, 101)
      ..moveTo(89, 101)..lineTo(119, 143);
    canvas.drawPath(r, gold..strokeWidth = 7);
    final e = Path()
      ..moveTo(160, 66)..lineTo(130, 66)..lineTo(130, 143)
      ..lineTo(162, 143)
      ..moveTo(130, 104)..lineTo(158, 104);
    canvas.drawPath(e, gold);
    final roof = Path()
      ..moveTo(44, 52)..lineTo(110, 24)..lineTo(176, 52);
    canvas.drawPath(roof, Paint()
      ..color = const Color(0xFF7EB7E8)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
