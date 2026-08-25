import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_theme.dart';
import '../widgets/premium_widgets.dart';

class AdsScreen extends StatelessWidget {
  static const routeName = '/ads';

  const AdsScreen({super.key});

  Future<void> _sendSmsOrder(String planName) async {
    final message = Uri.encodeComponent('درخواست پلن $planName و اطلاعات بیشتر را لطفاً ارسال کنید.');
    final uri = Uri.parse('sms:+989141159263?body=$message');
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  Widget _buildImageCard(String assetName) {
    return PremiumCard(
      color: AppColors.surfaceVariant,
      padding: const EdgeInsets.all(0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: Image.asset(
            assetName,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: AppColors.background,
                child: Center(
                  child: Text(
                    'تصویر بارگذاری نشد',
                    style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard(String title, String subtitle, List<String> features, List<String> priceLines, {required VoidCallback onTapSms}) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(title, style: AppTextStyles.titleMedium, textAlign: TextAlign.right),
          const SizedBox(height: 6),
          Text(subtitle, style: AppTextStyles.label, textAlign: TextAlign.right),
          const SizedBox(height: 16),
          ...features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Text(feature, style: AppTextStyles.body, textAlign: TextAlign.right)),
                  const SizedBox(width: 10),
                  const Icon(Icons.check_circle, color: AppColors.accent, size: 18),
                ],
              ),
            ),
          ),
          const Divider(color: AppColors.border),
          const SizedBox(height: 12),
          Text('قیمت:', style: AppTextStyles.titleMedium, textAlign: TextAlign.right),
          const SizedBox(height: 8),
          ...priceLines.map((line) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(line, style: AppTextStyles.body, textAlign: TextAlign.right),
              )),
          const SizedBox(height: 12),
          PremiumActionButton(label: 'درخواست پلن و مشخصات پیامک', onPressed: onTapSms),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('تبلیغات'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionTitle(
                title: 'تبلیغات روی TV Wall مجتمع تجاری رویال مال تبریز',
                subtitle: 'تبریز ، نصف راه ، مجتمع تجاری رویال مال',
              ),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  final cardWidth = constraints.maxWidth >= 700
                      ? (constraints.maxWidth - 16) / 2
                      : constraints.maxWidth;
                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      SizedBox(width: cardWidth, child: _buildImageCard('assets/images/ads/tv_wall_01.png')),
                      SizedBox(width: cardWidth, child: _buildImageCard('assets/images/ads/tv_wall_02.png')),
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),
              Text(
                'نمونه جانمایی تبلیغات برندها روی دو نمایشگر بزرگ مجتمع',
                style: AppTextStyles.label,
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 24),
              PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text(
                      'این بخش مخصوص برندها، فروشگاه‌ها و کسب‌وکارهایی است که قصد دارند محصولات، خدمات، جشنواره‌ها و کمپین‌های فروش خود را در فضای لوکس مجتمع تجاری معرفی کنند.',
                      style: AppTextStyles.body,
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const SectionTitle(title: 'پلن‌های تبلیغاتی'),
              const SizedBox(height: 18),
                  _buildPlanCard(
                'پلن ۱ — ECONOMY',
                'مناسب فروشگاه‌های داخل مجتمع و اطلاع‌رسانی اقتصادی',
                [
                  'نوع تبلیغ: فقط تصویر ثابت (Banner)، بدون ویدئو و موشن',
                  'مدت هر نمایش: 8 ثانیه',
                  'تعداد پخش: 48 بار در روز',
                  'فاصله تکرار: تقریبا هر 15 دقیقه',
                  'محل نمایش: فقط یک TV Wall',
                  'ساعات نمایش: 10 صبح تا 10 شب',
                  'محدودیت ساعات پیک: در ساعات پرتردد (6 عصر تا 10 شب) تعداد نمایش کمتر خواهد بود',
                  'مناسب: تخفیف فروشگاه، اطلاع‌رسانی جشنواره، معرفی خدمات داخل مجتمع',
                  'طراحی محتوا: ندارد',
                  'گزارش پخش: ندارد',
                  'مدت قرارداد: حداقل 7 روز',
                ],
                [
                  'هفتگی: 12 میلیون تومان',
                  'ماهیانه: 38 میلیون تومان',
                ],
                onTapSms: () => _sendSmsOrder('پلن ۱ — ECONOMY'),
              ),
              const SizedBox(height: 16),
              _buildPlanCard(
                'پلن ۲ — BUSINESS',
                'مناسب برندها، کمپین‌های فروش و تبلیغات حرفه‌ای',
                [
                  'نوع تبلیغ: تصویر ثابت، ویدئو Full HD، موشن گرافیک',
                  'مدت هر نمایش: 15 ثانیه',
                  'تعداد پخش: 144 بار در روز',
                  'فاصله تکرار: تقریبا هر 5 دقیقه',
                  'محل نمایش: هر دو TV Wall',
                  'ساعات نمایش: 10 صبح تا 10 شب',
                  'پوشش ساعات پیک: نمایش کامل در ساعات پرتردد',
                  'اولویت نمایش: متوسط',
                  'طراحی محتوا: 1 طراحی ساده رایگان',
                  'گزارش پخش: گزارش تعداد نمایش روزانه',
                  'مناسب: پوشاک، طلا و جواهر، ساعت، موبایل، لوازم دیجیتال، کافه و رستوران',
                ],
                [
                  'هفتگی: 42 میلیون تومان',
                  'ماهیانه: 120 میلیون تومان',
                ],
                onTapSms: () => _sendSmsOrder('پلن ۲ — BUSINESS'),
              ),
              const SizedBox(height: 16),
              _buildPlanCard(
                'پلن ۳ — VIP DIAMOND',
                'مناسب برندهای لوکس، افتتاحیه‌ها و کمپین‌های ویژه',
                [
                  'نوع تبلیغ: ویدئو 4K، تیزر تبلیغاتی، موشن حرفه‌ای، کمپین مناسبتی',
                  'مدت هر نمایش: 30 ثانیه',
                  'تعداد پخش: 288 بار در روز',
                  'فاصله تکرار: تقریبا هر 2 تا 3 دقیقه',
                  'محل نمایش: هر دو TV Wall',
                  'ساعات نمایش: 10 صبح تا 10 شب',
                  'اولویت ساعات پیک: اولویت ویژه در بازه 6 عصر تا 10 شب',
                  'خدمات ویژه: طراحی اختصاصی تبلیغ، تدوین ویدئو، اولویت رزرو مناسبت‌ها، پشتیبانی کمپین تبلیغاتی',
                  'گزارش حرفه‌ای: تعداد پخش، ساعات نمایش، گزارش کمپین',
                  'مناسب: برندهای لوکس، خودرو، جواهرات، ساعت‌های لاکچری، کمپین‌های افتتاحیه',
                ],
                [
                  'هفتگی: 95 میلیون تومان',
                  'ماهیانه: 280 میلیون تومان',
                ],
                onTapSms: () => _sendSmsOrder('پلن ۳ — VIP DIAMOND'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
