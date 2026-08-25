import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../theme/app_theme.dart';
import '../widgets/premium_widgets.dart';

class ContactPage extends StatelessWidget {
  static const routeName = '/contact';

  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ارتباط رسمی'),
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
              const SectionTitle(title: 'ارتباط رسمی', subtitle: 'کلیه مکاتبات در چارچوب رسمی و محرمانه بررسی می‌گردد.'),
              const SizedBox(height: 18),
              const CopyFieldItem(title: 'پیامک', value: '09123726555'),
              const SizedBox(height: 12),
              const CopyFieldItem(title: 'ایمیل عمومی', value: 'info@sahand-consortium.com'),
              const SizedBox(height: 12),
              const CopyFieldItem(title: 'ایمیل حقوقی', value: 'legal@sahand-consortium.com'),
              const SizedBox(height: 22),
              Row(
                children: const [
                  Expanded(child: ContactIconButton(label: 'ارسال پیامک', icon: Icons.sms, url: 'sms:+989141159263')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContactIconButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final String url;

  const ContactIconButton({super.key, required this.label, required this.icon, required this.url});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        final messenger = ScaffoldMessenger.of(context);
        try {
          final launched = await launchUrlString(url, mode: LaunchMode.externalApplication);
          if (!launched) {
            messenger.showSnackBar(
              const SnackBar(content: Text('باز کردن لینک با مشکل مواجه شد.')),
            );
          }
        } catch (_) {
          messenger.showSnackBar(
            const SnackBar(content: Text('امکان باز کردن لینک وجود ندارد.')),
          );
        }
      },
      icon: Icon(icon, size: 20),
      label: Text(label, style: AppTextStyles.button),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
