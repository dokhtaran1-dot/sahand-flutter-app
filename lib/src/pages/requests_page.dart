import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../theme/app_theme.dart';
import '../widgets/premium_widgets.dart';

class RequestsPage extends StatelessWidget {
  static const routeName = '/requests';

  const RequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('درخواست‌های من'),
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
              const SectionTitle(title: 'درخواست‌ها', subtitle: 'بخشی آماده برای اتصال به سیستم مدیریت درخواست‌های شما'),
              const SizedBox(height: 18),
              Column(
                children: sampleRequests.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: PremiumCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item.code, style: AppTextStyles.titleMedium),
                              MiniStatusLabel(text: item.status, color: AppColors.accent),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(item.title, style: AppTextStyles.body.copyWith(color: AppColors.textPrimary), textAlign: TextAlign.right),
                          const SizedBox(height: 8),
                          Text(item.subtitle, style: AppTextStyles.body, textAlign: TextAlign.right),
                          const SizedBox(height: 14),
                          LinearProgressIndicator(value: item.progress / 100, color: AppColors.accent, backgroundColor: AppColors.surfaceVariant),
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
