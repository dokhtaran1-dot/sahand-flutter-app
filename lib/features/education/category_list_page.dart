import 'package:flutter/material.dart';
import '../../../src/theme/app_theme.dart';
import 'data/legal_tips_data.dart';
import 'widgets/legal_category_card.dart';
import 'category_detail_page.dart';

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key});

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  String _searchText = '';

  List<String> get _filteredCategories {
    if (_searchText.isEmpty) {
      return LegalTipsData.allCategories;
    }

    final query = _searchText.trim();
    return LegalTipsData.allCategories.where((category) {
      final tips = LegalTipsData.tipsForCategory(category);
      return category.contains(query) ||
          tips.any((tip) => tip.title.contains(query) || tip.content.contains(query));
    }).toList();
  }

  IconData _iconForCategory(String category) {
    switch (category) {
      case 'مبانی حقوق تجارت':
        return Icons.gavel;
      case 'تشکیل شرکت و شخصیت حقوقی':
        return Icons.apartment;
      case 'اساسنامه، سهام و حقوق سهامداران':
        return Icons.how_to_reg;
      case 'مجامع عمومی و شرکت سهامی':
        return Icons.groups;
      case 'انحلال و تصفیه شرکت':
        return Icons.filter_alt_off;
      case 'شرکت با مسئولیت محدود':
        return Icons.shield;
      case 'شرکت تضامنی و مسئولیت شرکا':
        return Icons.handshake;
      case 'برات و مقررات آن':
        return Icons.credit_card;
      case 'سفته و چک':
        return Icons.receipt_long;
      case 'دلالی و حق‌العمل‌کاری':
        return Icons.handyman;
      case 'حمل‌ونقل و مسئولیت متصدی حمل':
        return Icons.local_shipping;
      case 'ورشکستگی و تصفیه تاجر':
        return Icons.account_balance;
      default:
        return Icons.book;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3)),
                ),
                child: Text(
                  'این مطلب از سایت صدای وکیل به آدرس:\nhttps://sedayevakil.com\nاستخراج شده است',
                  style: AppTextStyles.body.copyWith(fontSize: 12),
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'نکات مهم قانون تجارت',
                style: AppTextStyles.heading(size: 28),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 8),
              Text(
                'آموزش حقوقی با دسته‌بندی‌های کاربردی برای پیمایش سریع و یادگیری آسان.',
                style: AppTextStyles.body,
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 18),
              TextField(
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: 'جستجوی دسته‌ها یا کلمات کلیدی',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) => setState(() => _searchText = value),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: _filteredCategories.isEmpty
                    ? Center(
                        child: Text(
                          'هیچ دسته‌ای با این جستجو پیدا نشد.',
                          style: AppTextStyles.body,
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredCategories.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final category = _filteredCategories[index];
                          final tips = LegalTipsData.tipsForCategory(category);
                          return LegalCategoryCard(
                            title: category,
                            icon: _iconForCategory(category),
                            itemCount: tips.length,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CategoryDetailPage(category: category),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
