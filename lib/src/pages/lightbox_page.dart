import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../theme/app_theme.dart';
import '../widgets/premium_widgets.dart';

class LightBoxPage extends StatefulWidget {
  const LightBoxPage({super.key});

  @override
  State<LightBoxPage> createState() => _LightBoxPageState();
}

class _LightBoxPageState extends State<LightBoxPage> {
  int _currentSlide = 0;

  static const List<String> _sliderImages = [
    'assets/images/light_box/F841CCB8-E0E1-4C15-A21E-25671D7EDBD9.png',
    'assets/images/light_box/IMG_1572.png',
    'assets/images/light_box/IMG_1574.png',
  ];

  static const String _contactNumber = 'tel:+989141159263';

  late final List<LightBoxPlan> _plans = [
    LightBoxPlan(
      title: 'Standard',
      location: 'طبقه دوم — مسیرهای عمومی مجتمع',
      priceCustomer: '۱۸ میلیون تومان',
      priceHarmonia: '۲۵ میلیون تومان',
      suitableFor: ['بوتیک‌ها', 'خدمات زیبایی', 'فروشگاه‌های محلی'],
    ),
    LightBoxPlan(
      title: 'Prime',
      location: 'طبقه دوم — نزدیک پله‌برقی و مسیر پرتردد',
      priceCustomer: '۲۸ میلیون تومان',
      priceHarmonia: '۳۵ میلیون تومان',
      suitableFor: ['پوشاک', 'کیف و کفش', 'آرایشی', 'اکسسوری'],
    ),
    LightBoxPlan(
      title: 'Premium',
      location: 'طبقه همکف — نقاط اصلی و پرتردد مجتمع',
      priceCustomer: '۴۵ میلیون تومان',
      priceHarmonia: '۵۵ میلیون تومان',
      suitableFor: ['برندهای لوکس', 'طلا و جواهر', 'ساعت', 'برندینگ حرفه‌ای'],
    ),
    LightBoxPlan(
      title: 'Exclusive',
      location: 'چند لایت‌باکس همزمان در همکف و طبقه دوم',
      priceCustomer: 'از ۸۵ میلیون تومان',
      priceHarmonia: 'از ۹۵ میلیون تومان',
      suitableFor: ['کمپین‌های بزرگ', 'لانچ برند', 'فروش ویژه', 'برندهای ملی'],
    ),
  ];

  Future<void> _launchPhone() async {
    try {
      final launched = await launchUrlString(_contactNumber, mode: LaunchMode.externalApplication);
      if (!launched) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('امکان تماس برقرار نشد.')),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('امکان باز کردن شماره وجود ندارد.')),
      );
    }
  }

  Widget _buildSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 260,
          child: PageView.builder(
            itemCount: _sliderImages.length,
            onPageChanged: (index) => setState(() => _currentSlide = index),
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Image.asset(
                    _sliderImages[index],
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _sliderImages.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: _currentSlide == index ? 18 : 10,
              height: 10,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: _currentSlide == index ? AppColors.accent : AppColors.textSecondary,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIntro() {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: const [
          Text(
            'تبلیغات محیطی در لایت‌باکس‌های پرتردد مجتمع تجاری رویال مال تبریز، همراه با چاپ حرفه‌ای، نصب تخصصی و امکان طراحی اختصاصی توسط تیم تبلیغاتی هارمونیا.',
            style: AppTextStyles.body,
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureInfo() {
    const features = [
      'چاپ با کیفیت Premium Backlit',
      'نورپردازی ثابت حرفه‌ای',
      'نصب و جمع‌آوری',
      'مدت نمایش: ۷ روز کامل',
    ];

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('تمامی پلن‌ها شامل:', style: AppTextStyles.titleMedium, textAlign: TextAlign.right),
          const SizedBox(height: 12),
          ...features.map((text) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(text, style: AppTextStyles.body, textAlign: TextAlign.right),
                    const SizedBox(width: 12),
                    const Icon(Icons.check_circle, color: AppColors.accent, size: 18),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildPlanCard(LightBoxPlan plan) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(plan.title, style: AppTextStyles.heading(size: 20), textAlign: TextAlign.right),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text('پلن', style: AppTextStyles.label),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(plan.location, style: AppTextStyles.body, textAlign: TextAlign.right),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('طراحی توسط مشتری', style: AppTextStyles.label, textAlign: TextAlign.right),
                    const SizedBox(height: 8),
                    Text(plan.priceCustomer, style: AppTextStyles.titleMedium, textAlign: TextAlign.right),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('طراحی توسط هارمونیا', style: AppTextStyles.label, textAlign: TextAlign.right),
                    const SizedBox(height: 8),
                    Text(plan.priceHarmonia, style: AppTextStyles.titleMedium, textAlign: TextAlign.right),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('مناسب برای:', style: AppTextStyles.label, textAlign: TextAlign.right),
          const SizedBox(height: 10),
          Wrap(
            runSpacing: 8,
            spacing: 8,
            children: plan.suitableFor
                .map(
                  (item) => Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(item, style: AppTextStyles.body),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: _launchPhone,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.background,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('تماس جهت سفارش', style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }

  Widget _buildHarmonyServices() {
    const services = [
      'طراحی تبلیغات لوکس و مدرن',
      'طراحی متناسب با معماری رویال مال',
      'طراحی ویژه برندهای فشن و لوکس',
      'آماده‌سازی فایل چاپ حرفه‌ای',
      'مشاوره هویت بصری تبلیغات',
    ];

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('خدمات تیم تبلیغاتی هارمونیا', style: AppTextStyles.heading(size: 20), textAlign: TextAlign.right),
          const SizedBox(height: 14),
          ...services.map(
            (text) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(text, style: AppTextStyles.body, textAlign: TextAlign.right),
                  const SizedBox(width: 12),
                  const Icon(Icons.star, color: AppColors.accent, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text('لایت‌باکس', textAlign: TextAlign.right),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSlider(),
              const SizedBox(height: 20),
              _buildIntro(),
              const SizedBox(height: 20),
              _buildFeatureInfo(),
              const SizedBox(height: 22),
              Text('پلن‌های لایت‌باکس', style: AppTextStyles.heading(size: 22), textAlign: TextAlign.right),
              const SizedBox(height: 14),
              ..._plans.map((plan) => Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: _buildPlanCard(plan),
                  )),
              const SizedBox(height: 10),
              _buildHarmonyServices(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class LightBoxPlan {
  final String title;
  final String location;
  final String priceCustomer;
  final String priceHarmonia;
  final List<String> suitableFor;

  const LightBoxPlan({
    required this.title,
    required this.location,
    required this.priceCustomer,
    required this.priceHarmonia,
    required this.suitableFor,
  });
}
