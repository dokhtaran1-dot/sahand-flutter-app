import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/premium_widgets.dart';

class InvestorPage extends StatelessWidget {
  static const routeName = '/investor';

  const InvestorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Investor One-Pager'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionTitle(title: 'Investor One-Pager', subtitle: 'مرور نهادی برای سرمایه‌گذاران استراتژیک'),
              const SizedBox(height: 18),
              _buildBlock('Profile', 'حامد قنبری به عنوان مشاور راهبردی، تجربه اجرایی در حاکمیت شرکتی و سرمایه‌گذاری بلندمدت را ارائه می‌دهد.'),
              const SizedBox(height: 16),
              _buildBlock('Legacy & Continuity', 'تمرکز بر ثبات، ساختار حقوقی و فرهنگ تصمیم‌گیری نهادی برای تداوم ارزش‌ها.'),
              const SizedBox(height: 16),
              _buildBlock('Strategic Leadership', 'رویکردی تحلیلی و شرکتی برای برنامه‌ریزی و همراهی تصمیمات اقتصادی کلیدی.'),
              const SizedBox(height: 16),
              _buildBlock('Strategic Branches', 'ساخت‌وساز، غذا، کشاورزی، املاک و تجارت بین‌الملل به عنوان شاخه‌های متمرکز کنسرسیوم.'),
              const SizedBox(height: 16),
              _buildBlock('Flagship Assets & Projects', 'Royal Mall و برندهای پرمیوم Sahand و LOVA به عنوان دارایی‌های شاخص مجموعه.'),
              const SizedBox(height: 16),
              _buildBlock('Investment Philosophy', 'ارزش‌آفرینی بلندمدت، شفافیت ساختاری و حفظ استانداردهای حقوقی.'),
              const SizedBox(height: 16),
              PremiumActionButton(label: 'ارتباط رسمی', onPressed: () => Navigator.pushNamed(context, '/contact')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBlock(String title, String description) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(title, style: AppTextStyles.titleMedium),
          const SizedBox(height: 10),
          Text(description, style: AppTextStyles.body, textAlign: TextAlign.right),
        ],
      ),
    );
  }
}
