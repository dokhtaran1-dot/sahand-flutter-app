import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../models/app_models.dart';
import '../data/sample_data.dart';
import '../theme/app_theme.dart';
import '../widgets/premium_widgets.dart';

class PaymentPage extends StatelessWidget {
  static const routeName = '/payment';

  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)?.settings.arguments;
    final request = data is ConsultationRequest ? data : null;
    final plan = consultationPlans.firstWhere((element) => element.id == request?.planId, orElse: () => consultationPlans.first);

    return Scaffold(
      appBar: AppBar(
        title: const Text('پیش نمایش درخواست'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('خلاصه سفارش', style: AppTextStyles.heading(size: 24), textAlign: TextAlign.right),
                const SizedBox(height: 16),
                _buildDetailRow('نام پلن', plan.title),
                _buildDetailRow('مبلغ', plan.price),
                const Divider(color: AppColors.border),
                Text('اطلاعات متقاضی', style: AppTextStyles.titleMedium, textAlign: TextAlign.right),
                const SizedBox(height: 12),
                if (request != null) ...[
                  _buildDetailRow('نام و نام خانوادگی', request.fullName),
                  _buildDetailRow('موبایل', request.phone),
                  _buildDetailRow('ایمیل', request.email),
                  _buildDetailRow('شرکت', request.company),
                  _buildDetailRow('حوزه فعالیت', request.sector),
                ] else
                  Text('اطلاعات در دسترس نیست. لطفاً دوباره فرم را تکمیل کنید.', style: AppTextStyles.body, textAlign: TextAlign.right),
                const SizedBox(height: 20),
                Text('پس از تکمیل فرم، می‌توانید درخواست خود را از طریق پیامک ارسال کنید.', style: AppTextStyles.body, textAlign: TextAlign.right),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: request == null ? null : () => _sendSms(context, request),
                  icon: const Icon(Icons.sms, size: 20),
                  label: const Text('ارسال پیامک درخواست'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.label),
          Expanded(
            child: Text(value, style: AppTextStyles.body.copyWith(color: AppColors.textPrimary), textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }

  String _composeMessage(ConsultationRequest request, String contactMethod) {
    final plan = consultationPlans.firstWhere((element) => element.id == request.planId, orElse: () => consultationPlans.first);
    return '''درخواست مشاوره جدید:
نام و نام خانوادگی: ${request.fullName}
موبایل: ${request.phone}
ایمیل: ${request.email}
نام شرکت: ${request.company}
حوزه فعالیت: ${request.sector}
پلن انتخابی: ${plan.title}
روش ارتباط انتخاب‌شده: $contactMethod
''';
  }

  ConsultationRequest _copyWithContactMethod(ConsultationRequest request, String method) {
    return ConsultationRequest(
      fullName: request.fullName,
      phone: request.phone,
      email: request.email,
      company: request.company,
      sector: request.sector,
      subject: request.subject,
      details: request.details,
      planId: request.planId,
      contactMethod: method,
      agreed: request.agreed,
    );
  }

  Future<void> _sendSms(BuildContext context, ConsultationRequest request) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final message = _composeMessage(request, 'پیامک');
    final smsUrl = 'sms:+989141159263?body=${Uri.encodeComponent(message)}';
    try {
      final launched = await launchUrlString(smsUrl, mode: LaunchMode.externalApplication);
      if (!launched) {
        messenger.showSnackBar(const SnackBar(content: Text('باز کردن پیامک موفق نبود.')));
        return;
      }
      navigator.pushReplacementNamed('/payment-success', arguments: _copyWithContactMethod(request, 'پیامک'));
    } catch (_) {
      messenger.showSnackBar(const SnackBar(content: Text('پیامک باز نمی‌شود.')));
    }
  }
}
