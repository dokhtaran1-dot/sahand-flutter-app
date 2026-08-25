import 'package:flutter/material.dart';
import '../../../src/theme/app_theme.dart';
import 'data/legal_tips_data.dart';
import 'models/legal_tip.dart';
import 'widgets/legal_tip_card.dart';

class CategoryDetailPage extends StatefulWidget {
  final String category;

  const CategoryDetailPage({super.key, required this.category});

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  String _searchText = '';

  List<LegalTip> get _allTips => LegalTipsData.tipsForCategory(widget.category);

  List<LegalTip> get _filteredTips {
    if (_searchText.isEmpty) {
      return _allTips;
    }

    final query = _searchText.trim();
    return _allTips.where((tip) {
      final lowerQuery = query;
      return tip.title.contains(lowerQuery) || tip.content.contains(lowerQuery) || tip.tags.any((tag) => tag.contains(lowerQuery));
    }).toList();
  }

  void _toggleFavorite(int id) {
    setState(() {
      LegalTipsData.toggleFavorite(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text('نکات ${widget.category}', style: AppTextStyles.heading(size: 20)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.category,
                style: AppTextStyles.heading(size: 24),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 12),
              Text(
                'برای جستجو نام نکته یا کلمه کلیدی را وارد کنید.',
                style: AppTextStyles.body,
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 16),
              TextField(
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: 'جستجوی نکات',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: theme.cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) => setState(() => _searchText = value),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _filteredTips.isEmpty
                    ? Center(
                        child: Text(
                          'هیچ نکته‌ای با این جستجو پیدا نشد.',
                          style: AppTextStyles.body,
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredTips.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final tip = _filteredTips[index];
                          return LegalTipCard(
                            tip: tip,
                            isFavorite: LegalTipsData.isFavorite(tip.id),
                            onFavoriteChanged: (_) => _toggleFavorite(tip.id),
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
