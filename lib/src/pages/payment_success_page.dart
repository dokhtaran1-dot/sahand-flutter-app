import 'package:flutter/material.dart';

import '../models/app_models.dart';
import '../theme/app_theme.dart';
import '../widgets/premium_widgets.dart';

class PaymentSuccessPage extends StatelessWidget {
  static const routeName = '/payment-success';

  const PaymentSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final request = ModalRoute.of(context)?.settings.arguments as ConsultationRequest?;
    final selectedPlan = request?.planId ?? 'gold';
    final code = 'HG-${DateTime.now().millisecondsSinceEpoch % 100000}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('ثبت موفق درخواست'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.check_circle, color: AppColors.accent, size: 64),
                const SizedBox(height: 18),
                Text('درخواست شما ثبت شد', style: AppTextStyles.heading(size: 26), textAlign: TextAlign.right),
                const SizedBox(height: 12),
                Text('کد درخواست: $code', style: AppTextStyles.body.copyWith(color: AppColors.textPrimary), textAlign: TextAlign.right),
                const SizedBox(height: 12),
                Text('پلن انتخابی: ${_planLabel(selectedPlan)}', style: AppTextStyles.body.copyWith(color: AppColors.textPrimary), textAlign: TextAlign.right),
                const SizedBox(height: 12),
                Text('درخواست شما ثبت شد و از طریق کانال انتخابی پیگیری خواهد شد.', style: AppTextStyles.body, textAlign: TextAlign.right),
                const SizedBox(height: 22),
                ContactActionButton(label: 'ارسال پیامک', url: 'sms:+989141159263', icon: Icons.sms),
                const SizedBox(height: 12),
                PremiumActionButton(label: 'بازگشت به خانه', onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _planLabel(String planId) {
    switch (planId) {
      case 'bronze':
        return 'برنزی';
      case 'silver':
        return 'نقره‌ای';
      case 'gold':
      default:
        return 'طلایی';
    }
  }
}
