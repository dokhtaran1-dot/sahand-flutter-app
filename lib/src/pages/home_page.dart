import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../theme/app_theme.dart';
import '../widgets/premium_widgets.dart';
import '../../features/education/education_tab.dart';
import 'ads_screen.dart';
import 'contact_page.dart';
import 'consortium_page.dart';
import 'lightbox_page.dart';
import 'packages_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  static const List<BottomNavigationBarItem> navigationItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'خانه'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حامد قنبری'),
    BottomNavigationBarItem(icon: Icon(Icons.apartment), label: 'کنسرسیوم'),
    BottomNavigationBarItem(icon: Icon(Icons.workspace_premium), label: 'مشاوره'),
    BottomNavigationBarItem(icon: Icon(Icons.mail_outline), label: 'ارتباط'),
    BottomNavigationBarItem(icon: Icon(Icons.campaign), label: 'تبلیغات'),
    BottomNavigationBarItem(icon: Icon(Icons.lightbulb), label: 'لایت‌باکس'),
    BottomNavigationBarItem(icon: Icon(Icons.school), label: 'آموزش'),
  ];

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      _HomeScreen(onTapAds: () => setState(() => currentIndex = 5)),
      ProfilePage(),
      ConsortiumPage(),
      PackagesPage(),
      ContactPage(),
      const AdsScreen(),
      const LightBoxPage(),
      const EducationTab(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) => setState(() => currentIndex = value),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.textSecondary,
        items: navigationItems,
      ),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  final VoidCallback onTapAds;

  const _HomeScreen({required this.onTapAds});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHero(context),
              const SizedBox(height: 24),
              _buildSummaryCards(),
              const SizedBox(height: 22),
              _buildConsortiumHighlight(context),
              const SizedBox(height: 22),
              _buildPackagesPreview(context),
              const SizedBox(height: 22),
              _buildAdsPromotionCard(context),
              const SizedBox(height: 22),
              _buildCommunicationSection(context),
              const SizedBox(height: 18),
              const Divider(color: AppColors.border),
              const SizedBox(height: 12),
              Text('کنسرسیوم سهند | چارچوب اقتصادی نهادی', style: AppTextStyles.label, textAlign: TextAlign.right),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    return PremiumCard(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('مشاوره راهبردی برای تصمیم‌های مهم', style: AppTextStyles.heading(size: 32), textAlign: TextAlign.right),
                    const SizedBox(height: 14),
                    Text(
                      'ارائه خدمات مشاوره تخصصی در حوزه توسعه کسب‌وکار، سرمایه‌گذاری، ساختار همکاری و مشارکت‌های راهبردی',
                      style: AppTextStyles.body,
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 22),
                    Wrap(
                      alignment: WrapAlignment.end,
                      spacing: 14,
                      runSpacing: 8,
                      children: [
                        PremiumActionButton(
                          label: 'درخواست مشاوره',
                          onPressed: () => Navigator.pushNamed(context, '/request-form'),
                        ),
                        PremiumActionButton(
                          label: 'درباره حامد قنبری',
                          isSecondary: true,
                          onPressed: () => Navigator.pushNamed(context, ProfilePage.routeName),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              Container(
                width: 140,
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: AppColors.border),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/1.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: const [
              SizedBox(width: 280, child: _MiniSummaryCard(title: 'سرمایه‌گذاری و مشارکت راهبردی')),
              SizedBox(width: 280, child: _MiniSummaryCard(title: 'حاکمیت شرکتی و ساختار حقوقی')),
              SizedBox(width: 280, child: _MiniSummaryCard(title: 'توسعه کسب‌وکار و دارایی‌های راهبردی')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text('کنسرسیوم سهند یک ساختار اقتصادی نهادی است', style: AppTextStyles.titleLarge, textAlign: TextAlign.right),
                SizedBox(height: 12),
                Text('تمرکز بر توسعه پایدار، سرمایه‌گذاری بلندمدت و تصمیم‌گیری ساختاری برای شرکای خاص.', style: AppTextStyles.body, textAlign: TextAlign.right),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConsortiumHighlight(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('کنسرسیوم سهند', style: AppTextStyles.titleMedium),
          const SizedBox(height: 10),
          Text(
            'یک ساختار نهادی با رویکرد توسعه پایدار، حاکمیت شفاف و فرصت‌های سرمایه‌گذاری بلندمدت برای شرکای حرفه‌ای.',
            style: AppTextStyles.body,
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

  Widget _buildPackagesPreview(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SectionTitle(title: 'پکیج‌های مشاوره'),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: consultationPlans.map((plan) {
              return Container(
                width: 260,
                margin: const EdgeInsets.only(left: 12),
                child: PremiumCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(plan.title, style: AppTextStyles.titleMedium, textAlign: TextAlign.right),
                      const SizedBox(height: 8),
                      Text(plan.subtitle, style: AppTextStyles.label, textAlign: TextAlign.right),
                      const SizedBox(height: 14),
                      Text(plan.price, style: AppTextStyles.heading(size: 24)),
                      const SizedBox(height: 16),
                      ...plan.features.map((feature) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(child: Text(feature, style: AppTextStyles.body, textAlign: TextAlign.right)),
                                const SizedBox(width: 8),
                                const Icon(Icons.check_circle, color: AppColors.accent, size: 18),
                              ],
                            ),
                          )),
                      const SizedBox(height: 10),
                      PremiumActionButton(
                        label: 'درخواست این پلن',
                        onPressed: () => Navigator.pushNamed(context, '/request-form', arguments: plan.id),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildAdsPromotionCard(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('تبلیغات در مجتمع تجاری', style: AppTextStyles.titleMedium, textAlign: TextAlign.right),
          const SizedBox(height: 12),
          Text(
            'برند، فروشگاه یا کمپین فروش خود را روی دو TV Wall بزرگ مجتمع معرفی کنید.',
            style: AppTextStyles.body,
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 20),
          PremiumActionButton(
            label: 'مشاهده پلن‌های تبلیغاتی',
            onPressed: onTapAds,
          ),
        ],
      ),
    );
  }

  Widget _buildCommunicationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SectionTitle(title: 'ارتباط رسمی', subtitle: 'انتخاب کانال امن برای گفتگو و هماهنگی') ,
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ContactActionButton(
                label: 'ارسال پیامک',
                url: 'sms:+989141159263',
                icon: Icons.sms,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: PremiumActionButton(label: 'شاخه‌های راهبردی', onPressed: () => Navigator.pushNamed(context, '/branches'), isSecondary: true)),
            const SizedBox(width: 12),
            Expanded(child: PremiumActionButton(label: 'معرفی کنسرسیوم', onPressed: () => Navigator.pushNamed(context, ConsortiumPage.routeName), isSecondary: true)),
          ],
        ),
      ],
    );
  }
}

class _MiniSummaryCard extends StatelessWidget {
  final String title;

  const _MiniSummaryCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Text(title, style: AppTextStyles.titleMedium, textAlign: TextAlign.right),
    );
  }
}
