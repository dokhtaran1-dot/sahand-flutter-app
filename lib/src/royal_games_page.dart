import 'package:flutter/material.dart';

import 'royal_crown_game_page.dart';
import 'royal_deal_intro_page.dart';
import 'royal_find_difference_page.dart';
import 'royal_leaderboard_page.dart';
import 'royal_rewards_page.dart';
import 'royal_wallet_page.dart';

class RoyalGamesPage extends StatelessWidget {
  const RoyalGamesPage({super.key});

  static const String _art = 'assets/image/RC_Games_Luxury.png';
  static const double _artW = 941;
  static const double _artH = 1672;

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  void _openGamePreview(BuildContext context, {
    required String title,
    required String price,
    required Widget page,
  }) {
    const gold = Color(0xFFE8C36A);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF10251A),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        side: BorderSide(color: gold),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 25, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.sports_esports_rounded, color: gold, size: 38),
              const SizedBox(height: 11),
              Text(title, textAlign: TextAlign.center,
                style: const TextStyle(color: gold,
                  fontWeight: FontWeight.w900, fontSize: 21)),
              const SizedBox(height: 12),
              Text('نرخ پیشنهادی هر دست: $price تومان',
                textDirection: TextDirection.rtl,
                style: const TextStyle(color: Colors.white, fontSize: 16)),
              const SizedBox(height: 9),
              const Text(
                'طرح نهایی: یک بازی رایگان در روز، سپس پرداخت با Royal Wallet. '
                'در این نسخه آزمایشی، نه هزینه‌ای کسر می‌شود و نه نتایج '
                'مبنای دریافت جایزهٔ واقعی هستند.',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFBFC7BD),
                  height: 1.7, fontSize: 12),
              ),
              const SizedBox(height: 19),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    _open(context, page);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gold,
                    foregroundColor: const Color(0xFF17271B),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('شروع آزمایشی — بدون پرداخت'),
                ),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                  _open(context, const RoyalWalletPage());
                },
                icon: const Icon(Icons.account_balance_wallet_outlined),
                label: const Text('مشاهده کیف پول و بسته‌های شارژ'),
                style: TextButton.styleFrom(foregroundColor: gold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _hotspot({
    required double left,
    required double top,
    required double width,
    required double height,
    required VoidCallback onTap,
    String? label,
  }) {
    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: Semantics(
        button: true,
        label: label,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: const Color(0x22FFE3A0),
            highlightColor: const Color(0x11FFE3A0),
            borderRadius: BorderRadius.circular(34),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Soft blurred fill so the approved artwork always feels full-screen.
          ColorFiltered(
            colorFilter: const ColorFilter.mode(
              Color(0x55000000),
              BlendMode.darken,
            ),
            child: Image.asset(
              _art,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
            ),
          ),
          SafeArea(
            child: FittedBox(
              fit: BoxFit.fill,
              child: SizedBox(
                width: _artW,
                height: _artH,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      _art,
                      width: _artW,
                      height: _artH,
                      fit: BoxFit.fill,
                      filterQuality: FilterQuality.high,
                      isAntiAlias: true,
                      gaplessPlayback: true,
                    ),

                    _hotspot(
                      left: 22,
                      top: 18,
                      width: 115,
                      height: 100,
                      label: 'Back',
                      onTap: () => Navigator.of(context).pop(),
                    ),

                    _hotspot(
                      left: 36,
                      top: 575,
                      width: 868,
                      height: 278,
                      label: 'Deal or No Deal',
                      onTap: () => _openGamePreview(context,
                        title: 'ROYAL DEAL',
                        price: '۲۰٬۰۰۰',
                        page: const RoyalDealIntroPage(),
                      ),
                    ),

                    _hotspot(
                      left: 36,
                      top: 866,
                      width: 868,
                      height: 273,
                      label: 'The Royal Crown',
                      onTap: () => _openGamePreview(context,
                        title: 'ROYAL CROWN',
                        price: '۱۵٬۰۰۰',
                        page: const RoyalCrownGamePage(),
                      ),
                    ),

                    _hotspot(
                      left: 36,
                      top: 1153,
                      width: 868,
                      height: 278,
                      label: 'Find the Difference',
                      onTap: () => _openGamePreview(context,
                        title: 'FIND THE DIFFERENCE',
                        price: '۱۰٬۰۰۰',
                        page: const RoyalFindDifferencePage(),
                      ),
                    ),

                    _hotspot(
                      left: 36,
                      top: 1435,
                      width: 410,
                      height: 112,
                      label: 'Top 10',
                      onTap: () => _open(
                        context,
                        const RoyalLeaderboardPage(),
                      ),
                    ),

                    _hotspot(
                      left: 480,
                      top: 1435,
                      width: 425,
                      height: 112,
                      label: 'Rewards',
                      onTap: () => _open(
                        context,
                        const RoyalRewardsPage(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 9,
            right: 12,
            child: SafeArea(
              child: Material(
                color: const Color(0xEE102219),
                shape: const CircleBorder(
                  side: BorderSide(color: Color(0xFFE8C36A)),
                ),
                child: IconButton(
                  tooltip: 'کیف پول رویال',
                  icon: const Icon(Icons.account_balance_wallet_outlined,
                      color: Color(0xFFE8C36A)),
                  onPressed: () => _open(context, const RoyalWalletPage()),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
