import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home_page.dart';

class SplashPage extends StatelessWidget {
  static const routeName = '/';

  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0B0E14), Color(0xFF171E28)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 36, bottom: 24),
                      width: 84,
                      height: 84,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 18, offset: Offset(0, 12))],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/2.png',
                          width: 84,
                          height: 84,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text('حامد قنبری', style: AppTextStyles.heading(size: 34), textAlign: TextAlign.right),
                    const SizedBox(height: 12),
                    Text(
                      'مشاوره راهبردی کسب‌و‌کار و سرمایه‌گذاری',
                      style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 12),
                    Text('کنسرسیوم سهند', style: AppTextStyles.label.copyWith(color: AppColors.secondary), textAlign: TextAlign.right),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'یک تجربه حرفه‌ای و نهادی برای تصمیم‌سازی‌های مهم اقتصادی',
                      style: AppTextStyles.body,
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, HomePage.routeName);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.background,
                        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      ),
                      child: const Text('ورود به اپ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
