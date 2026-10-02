import 'package:flutter/material.dart';

import 'royal_games_page.dart';
import 'royal_rewards_page.dart';
import 'royal_score_store.dart';

class RoyalClubPrivilegesPage extends StatefulWidget {
  const RoyalClubPrivilegesPage({super.key});

  @override
  State<RoyalClubPrivilegesPage> createState() =>
      _RoyalClubPrivilegesPageState();
}

class _RoyalClubPrivilegesPageState extends State<RoyalClubPrivilegesPage> {
  static const gold = Color(0xFFE8C36A);

  int balance = 0;
  int lifetime = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
    RoyalScoreStore.revision.addListener(_reload);
  }

  void _reload() => _load();

  Future<void> _load() async {
    final values = await Future.wait([
      RoyalScoreStore.ticketBalance(),
      RoyalScoreStore.lifetimeTickets(),
    ]);
    if (!mounted) return;
    setState(() {
      balance = values[0];
      lifetime = values[1];
      loading = false;
    });
  }

  @override
  void dispose() {
    RoyalScoreStore.revision.removeListener(_reload);
    super.dispose();
  }

  String get level {
    if (lifetime >= 15000) return 'DIAMOND';
    if (lifetime >= 5000) return 'BLACK';
    if (lifetime >= 1000) return 'GOLD';
    return 'SILVER';
  }

  int get nextTarget {
    if (lifetime < 1000) return 1000;
    if (lifetime < 5000) return 5000;
    if (lifetime < 15000) return 15000;
    return lifetime;
  }

  @override
  Widget build(BuildContext context) {
    final progress = nextTarget <= 0
        ? 1.0
        : (lifetime / nextTarget).clamp(0.0, 1.0).toDouble();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF16090B),
        foregroundColor: gold,
        centerTitle: true,
        title: const Text(
          'ROYAL PRIVILEGES',
          style: TextStyle(letterSpacing: 1.6, fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: gold),
                gradient: const LinearGradient(
                  colors: [Color(0xFF53101A), Color(0xFF16090B), Color(0xFF211508)],
                ),
              ),
              child: Column(
                children: [
                  const Icon(Icons.workspace_premium_rounded,
                      color: gold, size: 48),
                  const SizedBox(height: 8),
                  Text(
                    loading ? '...' : level,
                    style: const TextStyle(
                      color: gold,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: _Metric(
                          title: 'موجودی تیکت',
                          value: loading ? '...' : '$balance',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _Metric(
                          title: 'کل تیکت کسب‌شده',
                          value: loading ? '...' : '$lifetime',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  LinearProgressIndicator(
                    value: loading ? 0 : progress,
                    minHeight: 7,
                    borderRadius: BorderRadius.circular(10),
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation(gold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    lifetime >= 15000
                        ? 'بالاترین سطح عضویت فعال است'
                        : 'تا سطح بعدی: ${nextTarget - lifetime} تیکت',
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'مزایای رویال کلاب',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            const _Privilege(
              icon: Icons.event_available_rounded,
              title: 'رزرو اولویت‌دار',
              body: 'دسترسی سریع‌تر به رزروها و تجربه‌های ویژه.',
            ),
            const _Privilege(
              icon: Icons.local_offer_rounded,
              title: 'پیشنهادهای اختصاصی',
              body: 'پیشنهادهای مخصوص اعضا و کمپین‌های محدود.',
            ),
            const _Privilege(
              icon: Icons.diamond_outlined,
              title: 'ارتقای تجربه VIP',
              body: 'مزایای ویژه متناسب با سطح عضویت و تیکت‌های کسب‌شده.',
            ),
            const _Privilege(
              icon: Icons.celebration_outlined,
              title: 'رویدادها و سورپرایزها',
              body: 'دسترسی به رویدادها، بازی‌ها و جوایز Royal Club.',
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const RoyalRewardsPage(),
                      ),
                    ),
                    icon: const Icon(Icons.card_giftcard_rounded),
                    label: const Text('جوایز'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C111D),
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(54),
                      side: const BorderSide(color: gold),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const RoyalGamesPage(),
                      ),
                    ),
                    icon: const Icon(Icons.sports_esports_rounded),
                    label: const Text('بازی‌ها'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF211508),
                      foregroundColor: gold,
                      minimumSize: const Size.fromHeight(54),
                      side: const BorderSide(color: gold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String title;
  final String value;
  const _Metric({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.35),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _RoyalGold.value),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFE8C36A),
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _Privilege extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  const _Privilege({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF160E0C),
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: const Color(0xFFE8C36A).withOpacity(.45)),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Icon(icon, color: const Color(0xFFE8C36A), size: 32),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  body,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoyalGold {
  static const value = Color(0x66E8C36A);
}
