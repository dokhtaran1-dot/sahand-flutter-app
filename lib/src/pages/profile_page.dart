import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/premium_widgets.dart';

class ProfilePage extends StatelessWidget {
  static const routeName = '/about-hamed';

  const ProfilePage({super.key});

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
              const SectionTitle(title: 'حامد قنبری', subtitle: 'راهبری راهبردی در چارچوب اصول حاکمیت شرکتی'),
              const SizedBox(height: 20),
              PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('تجربه‌ی رهبری شرکتی و طراحی ساختارهای سرمایه‌گذاری نهادی', style: AppTextStyles.body.copyWith(color: AppColors.textPrimary), textAlign: TextAlign.right),
                              const SizedBox(height: 14),
                              Text(
                                'با تمرکز بر حاکمیت ساختاری، انضباط حقوقی و تحلیل دقیق، خدماتی برای تصمیم‌گیری‌های اقتصادی بلندمدت ارائه می‌شود.',
                                style: AppTextStyles.body,
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: Image.asset(
                            'assets/images/1.png',
                            width: 110,
                            height: 140,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.end,
                      children: const [
                        _ProfileTag(label: 'مشاوره راهبردی'),
                        _ProfileTag(label: 'ساختاردهی همکاری‌ها'),
                        _ProfileTag(label: 'رویکرد نهادی'),
                        _ProfileTag(label: 'نگاه بلندمدت'),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text('گفتار', style: AppTextStyles.titleMedium, textAlign: TextAlign.right),
                    const SizedBox(height: 10),
                    Text(
                      'ساختارهای اقتصادی موفق زمانی شکل می‌گیرند که تصمیم‌گیری‌ها بر مبنای شفافیت، پایداری و انطباق حقوقی باشد. مشاوره ما با تمرکز بر چارچوب‌های نهادی، مسیر همکاری و سرمایه‌گذاری را برای شما روشن می‌کند.',
                      style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 16),
                    PremiumActionButton(
                      label: 'ارتباط رسمی',
                      onPressed: () => Navigator.pushNamed(context, '/contact'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('راز اعتماد', style: AppTextStyles.titleMedium, textAlign: TextAlign.right),
                    const SizedBox(height: 8),
                    Text(
                      'تمرکز بر رویکرد بلندمدت و توجه به ساختار حقوقی، پایه مشاوره‌های ما را شکل می‌دهد. این رویکرد به تصمیم‌سازان امکان می‌دهد تا سرمایه‌گذاری و توسعه را با ثبات بیشتری دنبال کنند.',
                      style: AppTextStyles.body,
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileTag extends StatelessWidget {
  final String label;

  const _ProfileTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(label, style: AppTextStyles.label.copyWith(color: AppColors.textPrimary)),
    );
  }
}
