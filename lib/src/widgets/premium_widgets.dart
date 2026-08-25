import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../theme/app_theme.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const SectionTitle({super.key, required this.title, this.subtitle = ''});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(title, style: AppTextStyles.heading(size: 22), textAlign: TextAlign.right),
        if (subtitle.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(subtitle, style: AppTextStyles.body, textAlign: TextAlign.right),
        ],
      ],
    );
  }
}

class PremiumCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final BorderRadiusGeometry borderRadius;

  const PremiumCard({super.key, required this.child, this.padding = const EdgeInsets.all(20), this.color = AppColors.surface, this.borderRadius = const BorderRadius.all(Radius.circular(22))});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, 8)),
        ],
      ),
      child: child,
    );
  }
}

class PremiumActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isSecondary;

  const PremiumActionButton({super.key, required this.label, required this.onPressed, this.isSecondary = false});

  @override
  Widget build(BuildContext context) {
    if (isSecondary) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.border),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text(label, style: AppTextStyles.button),
      );
    }
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label, style: AppTextStyles.button),
    );
  }
}

class MiniStatusLabel extends StatelessWidget {
  final String text;
  final Color color;

  const MiniStatusLabel({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withAlpha(46),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: AppTextStyles.label.copyWith(color: color)),
    );
  }
}

class SecondaryActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const SecondaryActionCard({super.key, required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(title, style: AppTextStyles.titleMedium),
                const SizedBox(height: 6),
                Text(subtitle, style: AppTextStyles.body),
              ],
            ),
            Icon(icon, color: AppColors.accent, size: 26),
          ],
        ),
      ),
    );
  }
}

class ContactActionButton extends StatelessWidget {
  final String label;
  final String url;
  final IconData icon;

  const ContactActionButton({super.key, required this.label, required this.url, required this.icon});

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
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

class CopyFieldItem extends StatelessWidget {
  final String title;
  final String value;

  const CopyFieldItem({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(title, style: AppTextStyles.label),
                const SizedBox(height: 4),
                Text(value, style: AppTextStyles.body.copyWith(color: AppColors.textPrimary)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy, color: AppColors.accent),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('کپی شد')),
              );
            },
          ),
        ],
      ),
    );
  }
}
