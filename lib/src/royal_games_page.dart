import 'package:flutter/material.dart';

import 'royal_crown_game_page.dart';
import 'royal_deal_page.dart';
import 'royal_find_difference_page.dart';
import 'royal_leaderboard_page.dart';
import 'royal_rewards_page.dart';
import 'royal_score_store.dart';

/// The single entrance for all three Royal Club mini-games.
class RoyalGamesPage extends StatelessWidget {
  const RoyalGamesPage({super.key});

  static const gold = Color(0xFFE8C36A);

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  Widget _ticketBalance() {
    return ValueListenableBuilder<int>(
      valueListenable: RoyalScoreStore.revision,
      builder: (context, version, _) => FutureBuilder<int>(
        future: RoyalScoreStore.ticketBalance(),
        builder: (context, snapshot) {
          final count = snapshot.data ?? 0;
          return Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 22, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF301D14),
              borderRadius: BorderRadius.circular(23),
              border: Border.all(color: gold, width: 1.3),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.confirmation_number_outlined,
                    color: gold, size: 30),
                const SizedBox(width: 13),
                Text('$count', style: const TextStyle(
                    color: Colors.white, fontSize: 29,
                    fontWeight: FontWeight.w900)),
                const SizedBox(width: 10),
                const Text('RC TICKETS',
                    style: TextStyle(
                        color: gold, letterSpacing: 1.2,
                        fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF130A0D),
        foregroundColor: gold,
        title: const Text('RC GAMES',
            style: TextStyle(color: gold,
                letterSpacing: 2, fontWeight: FontWeight.w800)),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            radius: 1.4,
            center: Alignment.topCenter,
            colors: [
              Color(0xFF3E1921),
              Color(0xFF170D0D),
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 19, 16, 30),
            children: [
              const Icon(Icons.workspace_premium_rounded,
                  color: gold, size: 48),
              const SizedBox(height: 8),
              const Text('ROYAL CLUB',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: gold,
                      fontSize: 24, fontWeight: FontWeight.w900,
                      letterSpacing: 3)),
              const SizedBox(height: 5),
              const Text('سه بازی، یک باشگاه، امتیازهای ماندگار',
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(color: Colors.white,
                      fontSize: 16)),
              const SizedBox(height: 17),
              _ticketBalance(),
              const SizedBox(height: 23),
              _GameOption(
                index: '01',
                title: 'DEAL OR NO DEAL',
                description: 'چمدان انتخاب کن و پیشنهاد بانکدار را بپذیر یا ادامه بده',
                image: 'assets/image/deal_case.png',
                onTap: () => _open(context, const RoyalDealPage()),
              ),
              const SizedBox(height: 13),
              _GameOption(
                index: '02',
                title: 'THE ROYAL CROWN',
                description: 'چالش ۶۰ ثانیه‌ای تاج و ثبت امتیاز',
                symbol: '👑',
                onTap: () => _open(context, const RoyalCrownGamePage()),
              ),
              const SizedBox(height: 13),
              _GameOption(
                index: '03',
                title: 'FIND THE DIFFERENCE',
                description: '۵ تفاوت در عکس‌های ۳ سالن رویال ویلیج پیدا کن',
                image: 'assets/image/salon_jardin.png',
                onTap: () => _open(
                    context, const RoyalFindDifferencePage()),
              ),
              const SizedBox(height: 21),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _open(
                          context, const RoyalLeaderboardPage()),
                      icon: const Icon(Icons.leaderboard_rounded),
                      label: const Text('TOP 10'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: gold,
                        minimumSize: const Size.fromHeight(51),
                        side: const BorderSide(color: gold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _open(
                          context, const RoyalRewardsPage()),
                      icon: const Icon(Icons.card_giftcard_rounded),
                      label: const Text('REWARDS'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: gold,
                        minimumSize: const Size.fromHeight(51),
                        side: const BorderSide(color: gold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 17),
              const Text(
                'تیکت‌ها فعلاً به‌صورت آزمایشی روی این دستگاه ذخیره '
                'می‌شوند و هنوز برای دریافت جوایز واقعی قابل استفاده نیستند.',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white60, fontSize: 12, height: 1.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GameOption extends StatelessWidget {
  const _GameOption({
    required this.index,
    required this.title,
    required this.description,
    required this.onTap,
    this.image,
    this.symbol,
  });

  final String index;
  final String title;
  final String description;
  final VoidCallback onTap;
  final String? image;
  final String? symbol;

  @override
  Widget build(BuildContext context) {
    const gold = RoyalGamesPage.gold;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF392616),
                Color(0xFF130D0D),
                Color(0xFF35121E),
              ],
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: gold.withOpacity(.75), width: 1.2),
          ),
          child: Row(
            children: [
              Container(
                height: 101,
                width: 98,
                decoration: BoxDecoration(
                  color: const Color(0xFF180F10),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: gold.withOpacity(.4)),
                ),
                clipBehavior: Clip.antiAlias,
                child: symbol != null
                    ? Center(child: Text(symbol!,
                        style: const TextStyle(fontSize: 59)))
                    : Image.asset(image!, fit: BoxFit.cover,
                        filterQuality: FilterQuality.high),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ROYAL GAME $index',
                        style: const TextStyle(
                            color: gold, fontSize: 11,
                            letterSpacing: 1.5)),
                    const SizedBox(height: 5),
                    Text(title,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 16,
                            fontWeight: FontWeight.w900)),
                    const SizedBox(height: 8),
                    Text(description,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12,
                            height: 1.5)),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Icon(Icons.play_circle_fill_rounded,
                            color: gold, size: 20),
                        SizedBox(width: 5),
                        Text('PLAY NOW',
                            style: TextStyle(
                                color: gold,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.1)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
