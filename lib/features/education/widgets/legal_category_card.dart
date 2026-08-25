import 'package:flutter/material.dart';
import '../../../src/theme/app_theme.dart';

class LegalCategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final int itemCount;
  final VoidCallback onTap;

  const LegalCategoryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.itemCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: AppColors.accent, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(title, style: AppTextStyles.titleMedium, textAlign: TextAlign.right),
                  const SizedBox(height: 8),
                  Text(
                    '$itemCount نکته',
                    style: AppTextStyles.body,
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.arrow_back_ios_new, color: AppColors.secondary, size: 18),
          ],
        ),
      ),
    );
  }
}
