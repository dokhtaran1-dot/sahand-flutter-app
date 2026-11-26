import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const imperialSalonName = 'RV Lounge Impérial Classique';

class ImperialBlackDiamondPage extends StatelessWidget {
  const ImperialBlackDiamondPage({super.key});
  static const gold = Color(0xFFE7C77D);
  static const bg = Color(0xFF031C15);
  static const ownerNumber = String.fromEnvironment('RV_IMPERIAL_WHATSAPP');

  Future<void> _request(BuildContext context) async {
    final number = ownerNumber.trim();
    if (!RegExp(r'^[1-9][0-9]{7,14}$').hasMatch(number)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('مسیر اختصاصی رزرو هنوز فعال نشده است.'),
      ));
      return;
    }
    final uri = Uri.https('wa.me', '/$number', {
      'text': 'سلام، برای رزرو اختصاصی RV Lounge Impérial Classique — BLACK DIAMOND درخواست دارم. لطفاً برای هماهنگی و تأیید شخصی راهنمایی بفرمایید.',
    });
    try {
      if (await launchUrl(uri, mode: LaunchMode.externalApplication)) return;
      if (await launchUrl(uri, mode: LaunchMode.platformDefault)) return;
    } catch (_) {}
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('باز کردن واتس‌اپ ممکن نشد. دوباره تلاش کنید.'),
    ));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: bg,
    appBar: AppBar(backgroundColor: bg, foregroundColor: gold,
      title: const Text('BLACK DIAMOND', style: TextStyle(letterSpacing: 2))),
    body: ListView(padding: const EdgeInsets.fromLTRB(18, 10, 18, 28), children: [
      const Icon(Icons.diamond_outlined, color: gold, size: 54),
      const SizedBox(height: 10),
      const Text('RV LOUNGE\nIMPÉRIAL CLASSIQUE', textAlign: TextAlign.center,
        style: TextStyle(fontFamily: 'serif', color: gold, fontSize: 25, height: 1.25)),
      const SizedBox(height: 12),
      ClipRRect(borderRadius: BorderRadius.circular(18), child: AspectRatio(
        aspectRatio: 1.5, child: Image.asset('assets/image/rv_real_imperial.jpg',
          fit: BoxFit.cover, filterQuality: FilterQuality.high,
          errorBuilder: (_, __, ___) => Image.asset('assets/image/rv_lounge_imperial_classique.png',
            fit: BoxFit.cover, filterQuality: FilterQuality.high)))),
      const SizedBox(height: 18),
      const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.lock_outline, color: gold, size: 20),
        SizedBox(width: 8), Text('BY INVITATION ONLY', style: TextStyle(color: gold, letterSpacing: 1.6)),
      ]),
      const SizedBox(height: 16),
      const Text('تمام دنیا در یک اتاق', textAlign: TextAlign.center,
        textDirection: TextDirection.rtl, style: TextStyle(color: gold, fontSize: 25, fontWeight: FontWeight.bold)),
      const SizedBox(height: 14),
      const Text(
        'اینجا تنها یک سالن اختصاصی نیست؛ جهانی مستقل در قلب رویال ویلیج کافه است.\n\n'
        'در مرکز این جهان، صخره‌ای عظیم و معلق قرار دارد که طراحی آن از طبیعت و معماری منطقه‌ای در اسلواکی الهام گرفته شده است.\n\n'
        'از هنر و معماری بارسلونا تا اصالت مراکش، از شکوه موزه لوور فرانسه تا رازهای تمدن مصر، هر گوشه از این سالن روایتی از فرهنگ و تاریخ جهان است.\n\n'
        'میز شطرنج آنتیک، نمادهای تاریخی اسلواکی، تابلوی اروپا، مبلمان منحصربه‌فرد، تخت استراحت، پروژکتور اختصاصی، پذیرایی ویژه، قلیان‌های خاص ایتالیایی و امکانات سلف‌سرویس خصوصی، همگی برای خلق تجربه‌ای متفاوت در کنار یکدیگر قرار گرفته‌اند.\n\n'
        'در اینجا حتی کوچک‌ترین جزئیات، از هدایا تا ظروف پذیرایی، دارای هویت و داستانی اختصاصی هستند.\n\n'
        'با عبور از دروازه ایمپریال، از دنیای روزمره فاصله می‌گیرید و وارد جهانی می‌شوید که برای عموم طراحی نشده است.\n\n'
        'اینجا، جهان به دیدار شما می‌آید.',
        textDirection: TextDirection.rtl, textAlign: TextAlign.start,
        style: TextStyle(color: Color(0xFFF5EEDB), fontSize: 16, height: 1.85)),
      const SizedBox(height: 18),
      const Text('Le monde entier dans un seul salon.\nThe whole world in one room.',
        textAlign: TextAlign.center, style: TextStyle(color: gold, fontFamily: 'serif', fontSize: 16, height: 1.6)),
      const Divider(color: Color(0xFF806B40), height: 40),
      const Text('ورود صرفاً با دعوت اختصاصی. ارسال پیام به معنی تأیید رزرو نیست؛ رزرو فقط پس از تأیید شخص مالک نهایی خواهد شد.',
        textAlign: TextAlign.center, textDirection: TextDirection.rtl, style: TextStyle(color: gold, height: 1.7)),
    ]),
    bottomNavigationBar: SafeArea(child: Padding(padding: const EdgeInsets.all(16),
      child: FilledButton.icon(
        style: FilledButton.styleFrom(backgroundColor: gold, foregroundColor: bg,
          minimumSize: const Size.fromHeight(54)),
        onPressed: () => _request(context),
        icon: const Icon(Icons.chat_outlined),
        label: const Text('رزرو اختصاصی از طریق واتس‌اپ'),
      ))),
  );
}
