import 'package:flutter/material.dart';
import 'heritage_page.dart';
import 'royal_mall_page.dart';
import 'royal_club_game_page.dart';
import 'royal_village_page.dart';
import 'ettehad_page.dart';
import 'royal_signature_page.dart';
import 'royal_harmonia_page.dart';

/// Searchable second-level discovery menu for the approved Explore tab.
class RoyalExplorePage extends StatefulWidget {
  const RoyalExplorePage({super.key});
  @override
  State<RoyalExplorePage> createState() => _RoyalExplorePageState();
}

class _RoyalExplorePageState extends State<RoyalExplorePage> {
  String query = '';
  static const golden = Color(0xFFE1BF7B);

  @override
  Widget build(BuildContext context) {
    final data = <(String, String, Widget, IconData)>[
      ('SAHAND CONSORTIUM', 'کنسرسیوم سهند', const HeritagePage(), Icons.public),
      ('ROYAL MALL', 'فروشگاه‌ها', const RoyalMallPage(), Icons.storefront),
      ('ROYAL CLUB', 'باشگاه مشتریان VIP', const RoyalClubGamePage(), Icons.sports_esports),
      ('ROYAL VILLAGE', 'کافه رویال ویلاژ · رزرو لاکچری', const RoyalVillagePage(), Icons.restaurant),
      ('ROYAL ETEHAD', 'طراحی، ساخت، اجرا', const EttehadPage(), Icons.architecture),
      ('ROYAL SIGNITURE', 'خریدهای سیگنیچر', const RoyalSignaturePage(), Icons.shopping_bag),
      ('ROYAL HARMONIA', 'تبلیغات، سوشیال، فروش', const RoyalHarmoniaPage(), Icons.campaign),
    ];
    final items = data.where((e) =>
        ('${e.$1} ${e.$2}').toLowerCase().contains(query.toLowerCase())).toList();
    return Scaffold(
      backgroundColor: const Color(0xFF051810),
      appBar: AppBar(
        backgroundColor: const Color(0xFF08271B),
        foregroundColor: golden,
        title: const Text('EXPLORE · کشف'),
      ),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(children: [
          TextField(
            onChanged: (v) => setState(() => query = v.trim()),
            decoration: InputDecoration(
              hintText: 'جست‌وجوی مجموعه‌ها و خدمات',
              prefixIcon: const Icon(Icons.search, color: golden),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(19),
                borderSide: const BorderSide(color: golden)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(19),
                borderSide: const BorderSide(color: golden, width: 2)),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(child: ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 9),
            itemBuilder: (context, i) {
              final item = items[i];
              return Card(
                color: const Color(0xFF0B2F22),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                  side: const BorderSide(color: Color(0xAAE1BF7B))),
                child: ListTile(
                  leading: Icon(item.$4, color: golden),
                  title: Text(item.$1, style: const TextStyle(
                    color: golden, fontWeight: FontWeight.bold)),
                  subtitle: Text(item.$2),
                  trailing: const Icon(Icons.chevron_right, color: golden),
                  onTap: () => Navigator.push(context,
                    MaterialPageRoute<void>(builder: (_) => item.$3)),
                ),
              );
            },
          )),
        ]),
      )),
    );
  }
}
