import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RvGalleryPage extends StatefulWidget {
  const RvGalleryPage({super.key});

  @override
  State<RvGalleryPage> createState() => _RvGalleryPageState();
}

class _RvGalleryPageState extends State<RvGalleryPage> {
  static const _gold = Color(0xFFE5BE67);
  static const _bg = Color(0xFF03110D);

  final Map<String, String> _labels = const {
    '00_Salons': 'اتاق‌ها',
    '01_Cakes': 'کیک‌ها',
    '02_Fruit': 'میوه',
    '03_Drinks': 'نوشیدنی‌ها',
    '04_Desserts': 'دسرها',
    '05_Food': 'غذاها',
    '06_Hookah_VIP': 'قلیان VIP',
    '07_Menu_Posters': 'منوها',
  };

  late final Future<Map<String, List<String>>> _future = _loadManifest();
  String? _selected;

  Future<Map<String, List<String>>> _loadManifest() async {
    final raw = await rootBundle.loadString(
      'assets/image/rv_gallery_manifest.json',
    );
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final result = <String, List<String>>{};
    for (final entry in decoded.entries) {
      final values = (entry.value as List).map((e) => e.toString()).toList();
      if (values.isNotEmpty) result[entry.key] = values;
    }
    return result;
  }

  void _openImage(String asset) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: _gold,
          ),
          body: Center(
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 5,
              child: Image.asset(
                asset,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        foregroundColor: _gold,
        centerTitle: true,
        title: const Text(
          'ROYAL VILLAGE GALLERY',
          style: TextStyle(
            color: _gold,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: FutureBuilder<Map<String, List<String>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(color: _gold),
            );
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'گالری در دسترس نیست',
                textDirection: TextDirection.rtl,
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          final data = snapshot.data!;
          final keys = data.keys.toList()..sort();
          _selected ??= keys.first;
          final current = data[_selected] ?? const <String>[];

          return Column(
            children: [
              SizedBox(
                height: 62,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  scrollDirection: Axis.horizontal,
                  itemCount: keys.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final key = keys[index];
                    final selected = key == _selected;
                    return ChoiceChip(
                      selected: selected,
                      onSelected: (_) => setState(() => _selected = key),
                      label: Text(
                        '${_labels[key] ?? key} (${data[key]!.length})',
                        textDirection: TextDirection.rtl,
                      ),
                      selectedColor: _gold,
                      backgroundColor: const Color(0xFF092018),
                      labelStyle: TextStyle(
                        color: selected ? Colors.black : Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      side: const BorderSide(color: _gold),
                    );
                  },
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(10, 4, 10, 20),
                  itemCount: current.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.88,
                  ),
                  itemBuilder: (context, index) {
                    final asset = current[index];
                    return InkWell(
                      onTap: () => _openImage(asset),
                      borderRadius: BorderRadius.circular(16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: const Color(0xFF091B15),
                            border: Border.all(color: _gold.withOpacity(.55)),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Image.asset(
                            asset,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                            errorBuilder: (_, __, ___) => const Center(
                              child: Icon(Icons.image_not_supported_outlined, color: _gold),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
