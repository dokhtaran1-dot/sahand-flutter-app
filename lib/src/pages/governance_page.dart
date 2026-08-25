import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/premium_widgets.dart';

class GovernancePage extends StatelessWidget {
  static const routeName = '/governance';

  const GovernancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('حقوقی و حاکمیت'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionTitle(title: 'حقوقی و حاکمیت', subtitle: 'چارچوبی رسمی برای اعتماد و نظارت') ,
              const SizedBox(height: 20),
              PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    _GovernanceItem(label: 'اصول حاکمیت', description: 'ساختارهای رسمی و پاسخگو در تمامی سطوح تصمیم‌گیری.'),
                    _GovernanceItem(label: 'شفافیت در تصمیم‌گیری', description: 'اطلاعات ساختاریافته برای شرکای مؤسسه و ذی‌نفعان.'),
                    _GovernanceItem(label: 'تفکیک مسئولیت‌ها', description: 'روال‌های حقوقی برای تعیین دقیق وظایف و اختیارات.'),
                    _GovernanceItem(label: 'پایبندی به تعهدات قراردادی', description: 'حفظ استانداردها و ضمانت اجرای تعهدات قراردادها.'),
                    _GovernanceItem(label: 'نظارت مستمر', description: 'بررسی دوره‌ای عملکردها و روندهای حقوقی مؤسسه.'),
                    _GovernanceItem(label: 'چارچوب حقوقی', description: 'پشتیبانی حقوقی تخصصی برای عملیات شرکتی و سرمایه‌گذاری.'),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              PremiumActionButton(
                label: 'تماس رسمی',
                onPressed: () => Navigator.pushNamed(context, '/contact'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GovernanceItem extends StatelessWidget {
  final String label;
  final String description;

  const _GovernanceItem({required this.label, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.gavel, color: AppColors.accent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(label, style: AppTextStyles.titleMedium),
                const SizedBox(height: 6),
                Text(description, style: AppTextStyles.body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
