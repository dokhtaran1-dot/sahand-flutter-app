import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../theme/app_theme.dart';
import '../widgets/premium_widgets.dart';

class BranchesPage extends StatelessWidget {
  static const routeName = '/branches';

  const BranchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isPhone = screenWidth < 600;
    final double featureCardHeight = 160;
    final double featureCardWidth = isPhone 
        ? screenWidth - 40 
        : screenWidth / 2 - 26;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('شاخه‌های راهبردی'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionTitle(title: 'شاخه‌های کلیدی', subtitle: 'راهبردهای سرمایه‌گذاری و توسعه') ,
              const SizedBox(height: 18),

              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  ...strategicBranches.map((branch) {
                    return SizedBox(
                      width: featureCardWidth,
                      height: featureCardHeight,
                      child: PremiumCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(_mapIcon(branch.icon), color: AppColors.accent, size: 26),
                                Text(branch.title, style: AppTextStyles.titleMedium, textAlign: TextAlign.right),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: Text(branch.description, style: AppTextStyles.body, textAlign: TextAlign.right),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  SizedBox(
                    width: featureCardWidth,
                    height: featureCardHeight,
                    child: PremiumCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Text('Royal Mall', style: AppTextStyles.titleMedium, textAlign: TextAlign.right),
                          SizedBox(height: 8),
                          Expanded(
                            child: Text('پروژه تجاری ۱۸۰۰ مترمربع با طراحی نهادی و فرصت سرمایه‌گذاری در یک دارایی برجسته.', style: AppTextStyles.body, textAlign: TextAlign.right),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _mapIcon(String key) {
    switch (key) {
      case 'domain':
        return Icons.domain;
      case 'restaurant':
        return Icons.restaurant;
      case 'agriculture':
        return Icons.agriculture;
      case 'apartment':
        return Icons.apartment;
      case 'wine_bar':
        return Icons.wine_bar;
      case 'local_shipping':
        return Icons.local_shipping;
      default:
        return Icons.business;
    }
  }
}
