import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../theme/app_theme.dart';
import '../widgets/premium_widgets.dart';

class PackagesPage extends StatelessWidget {
  static const routeName = '/packages';

  const PackagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('پکیج‌های مشاوره'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionTitle(title: 'پلن‌های مشاوره', subtitle: 'انتخاب مسیر رسمی و استراتژیک برای همکاری') ,
              const SizedBox(height: 18),
              Column(
                children: consultationPlans.map((plan) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: PremiumCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(plan.title, style: AppTextStyles.heading(size: 24), textAlign: TextAlign.right),
                            const SizedBox(height: 8),
                            Text(plan.subtitle, style: AppTextStyles.label, textAlign: TextAlign.right),
                            const SizedBox(height: 12),
                            Text(plan.price, style: AppTextStyles.heading(size: 28), textAlign: TextAlign.right),
                            const SizedBox(height: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: plan.features.map((feature) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(feature, style: AppTextStyles.body),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.check_circle, color: AppColors.accent, size: 18),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 18),
                            PremiumActionButton(
                              label: 'درخواست این پلن',
                              onPressed: () => Navigator.pushNamed(context, '/request-form', arguments: plan.id),
                            ),
                          ],
                        ),
                      ),
                    )).toList(),
              ),
              const SizedBox(height: 12),
              Text(
                'هر درخواست پس از بررسی اولیه و در چارچوب ارتباط رسمی پیگیری خواهد شد.',
                style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 12),
              Text(
                'ثبت درخواست به‌معنای پذیرش نهایی همکاری نیست و بررسی اولیه توسط مجموعه انجام می‌شود.',
                style: AppTextStyles.label,
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
