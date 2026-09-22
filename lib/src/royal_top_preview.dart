import 'package:flutter/material.dart';

import 'royal_score_store.dart';

/// Tap-friendly condensed preview on the RC home artwork.
/// The full 10-player list lives in RoyalLeaderboardPage.
class RoyalTopTenPreview extends StatelessWidget {
  const RoyalTopTenPreview({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;
  static const gold = Color(0xFFE8C36A);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: RoyalScoreStore.revision,
      builder: (context, revision, _) => FutureBuilder<List<RoyalPlayerScore>>(
      future: RoyalScoreStore.topTen(),
      builder: (context, snapshot) {
        final players = snapshot.data ?? const <RoyalPlayerScore>[];
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(25),
            child: Container(
              padding: const EdgeInsets.fromLTRB(22, 12, 22, 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: gold, width: 2),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFA150D0C),
                    Color(0xF9392415),
                    Color(0xFA130D0D),
                  ],
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.emoji_events_rounded,
                      color: gold, size: 57),
                  const SizedBox(width: 13),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('TOP 10',
                          style: TextStyle(
                            color: gold,
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          )),
                      Text('ROYAL LEADERBOARD',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            letterSpacing: 1.2,
                          )),
                    ],
                  ),
                  const SizedBox(width: 22),
                  Container(width: 1, color: gold.withOpacity(.4)),
                  const SizedBox(width: 22),
                  Expanded(
                    child: players.isEmpty
                        ? const Text(
                            'اولین امتیاز را ثبت کن',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (var i = 0;
                                  i < players.length && i < 3;
                                  i++)
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 34,
                                      child: Text('#${i + 1}',
                                          style: const TextStyle(
                                            color: gold,
                                            fontSize: 19,
                                            fontWeight: FontWeight.w800,
                                          )),
                                    ),
                                    Expanded(
                                      child: Text(
                                        players[i].name,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${players[i].total}',
                                      style: const TextStyle(
                                        color: gold,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                  ),
                  const SizedBox(width: 14),
                  const Icon(Icons.chevron_right_rounded,
                      color: gold, size: 35),
                ],
              ),
            ),
          ),
        );
      },
      ),
    );
  }
}
