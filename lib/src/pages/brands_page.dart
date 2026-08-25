import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../theme/app_theme.dart';
import '../widgets/premium_widgets.dart';

class BrandsPage extends StatelessWidget {
  static const routeName = '/brands';

  const BrandsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('برندها و دارایی‌ها'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionTitle(title: 'پورتفولیوی برند', subtitle: 'دارایی‌ها و برندهای راهبردی') ,
              const SizedBox(height: 18),
              Column(
                children: brandPortfolio.map((brand) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: PremiumCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(brand.title, style: AppTextStyles.titleMedium),
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceVariant,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(brand.status, style: AppTextStyles.label.copyWith(color: AppColors.textPrimary)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(brand.subtitle, style: AppTextStyles.body, textAlign: TextAlign.right),
                          const SizedBox(height: 14),
                          Container(
                            height: 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              image: DecorationImage(
                                image: AssetImage(brand.imagePath),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
