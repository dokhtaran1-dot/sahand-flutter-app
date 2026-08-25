import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/premium_widgets.dart';

class ConsortiumPage extends StatelessWidget {
  static const routeName = '/consortium';

  const ConsortiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionTitle(title: 'کنسرسیوم سهند', subtitle: 'چارچوب اقتصادی نهادی برای سرمایه‌گذاری و مشارکت') ,
              const SizedBox(height: 20),
              PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text('کنسرسیوم سهند یک چارچوب اقتصادی نهادی است که بسترهای امن، پایدار و شفاف برای سرمایه‌گذاری و همکاری‌های راهبردی فراهم می‌کند.', style: AppTextStyles.body, textAlign: TextAlign.right),
                    SizedBox(height: 16),
                    _ConsortiumFeature(label: 'چارچوب سرمایه‌گذاری', description: 'سرمایه‌گذاری در فرصت‌های استراتژیک با تحلیل دقیق و ساختار شفاف.'),
                    _ConsortiumFeature(label: 'مشارکت‌های راهبردی', description: 'شکل‌دهی روابط شریک‌محور با استانداردهای اقتصادی و حقوقی بالا.'),
                    _ConsortiumFeature(label: 'ساختار حقوقی و حاکمیت شرکتی', description: 'پیاده‌سازی حاکمیت ساختاری و تفکیک مسئولیت‌ها در سطح نهادی.'),
                    _ConsortiumFeature(label: 'ارتباط رسمی', description: 'محیط مطمئن برای تصمیم‌گیری‌های اقتصادی بلندمدت و ارتباطات رسمی.'),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text('معرفی', style: AppTextStyles.titleMedium, textAlign: TextAlign.right),
                    SizedBox(height: 10),
                    Text('سند سهند بر پایه مجموعه‌ای از دارایی‌های راهبردی و مشارکت‌های ساختاری ساخته شده است. هدف ما ارائه روندی مطمئن و حرفه‌ای برای تصمیم‌گیری و توسعه سرمایه‌گذاری بلندمدت است.', style: AppTextStyles.body, textAlign: TextAlign.right),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text('خلاصه', style: AppTextStyles.titleMedium, textAlign: TextAlign.right),
                    SizedBox(height: 12),
                    Text('در این ساختار، حاکمیت شرکتی، امنیت حقوقی و شفافیت تصمیم‌گیری در مرکز توجه است. رویکرد تحلیلی و نهادی ما به شرکای سرمایه‌گذاری امکان می‌دهد تا دارایی‌های راهبردی را با اعتماد دنبال کنند.', style: AppTextStyles.body, textAlign: TextAlign.right),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: PremiumActionButton(label: 'شاخه‌های راهبردی', onPressed: () => Navigator.pushNamed(context, '/branches'))),
                  const SizedBox(width: 12),
                  Expanded(child: PremiumActionButton(label: 'دارایی‌های اصلی', onPressed: () => Navigator.pushNamed(context, '/brands'), isSecondary: true)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConsortiumFeature extends StatelessWidget {
  final String label;
  final String description;

  const _ConsortiumFeature({required this.label, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(label, style: AppTextStyles.titleMedium, textAlign: TextAlign.right),
                const SizedBox(height: 6),
                Text(description, style: AppTextStyles.body, textAlign: TextAlign.right),
              ],
            ),
          ),
          const SizedBox(width: 14),
          const Icon(Icons.check_circle, color: AppColors.accent, size: 20),
        ],
      ),
    );
  }
}
