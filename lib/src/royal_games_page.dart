import 'package:flutter/material.dart';

import 'royal_crown_game_page.dart';
import 'royal_deal_intro_page.dart';
import 'royal_find_difference_page.dart';
import 'royal_leaderboard_page.dart';
import 'royal_rewards_page.dart';

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
                      onTap: () => _open(
                        context,
                        const RoyalDealIntroPage(),
                      ),
                    ),

                    _hotspot(
                      left: 36,
                      top: 866,
                      width: 868,
                      height: 273,
                      label: 'The Royal Crown',
                      onTap: () => _open(
                        context,
                        const RoyalCrownGamePage(),
                      ),
                    ),

                    _hotspot(
                      left: 36,
                      top: 1153,
                      width: 868,
                      height: 278,
                      label: 'Find the Difference',
                      onTap: () => _open(
                        context,
                        const RoyalFindDifferencePage(),
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
        ],
      ),
    );
  }
}
