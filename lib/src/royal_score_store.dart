import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Local prototype score store. NOT a cross-device leaderboard or a basis
/// for awarding real prizes; production requires authenticated server writes
/// and server-side game result validation.
enum RoyalScoreGame { deal, crown, difference }

class RoyalPlayerScore {
  const RoyalPlayerScore({
    required this.name,
    this.deal = 0,
    this.crown = 0,
    this.difference = 0,
    required this.firstPlayed,
  });

  final String name;
  final int deal;
  final int crown;
  final int difference;
  final int firstPlayed;

  int get total => deal + crown + difference;

  int pointsFor(RoyalScoreGame? game) {
    switch (game) {
      case RoyalScoreGame.deal:
        return deal;
      case RoyalScoreGame.crown:
        return crown;
      case RoyalScoreGame.difference:
        return difference;
      case null:
        return total;
    }
  }

  RoyalPlayerScore add(RoyalScoreGame game, int points) {
    switch (game) {
      case RoyalScoreGame.deal:
        return RoyalPlayerScore(name: name, deal: deal + points,
            crown: crown, difference: difference, firstPlayed: firstPlayed);
      case RoyalScoreGame.crown:
        return RoyalPlayerScore(name: name, deal: deal,
            crown: crown + points, difference: difference,
            firstPlayed: firstPlayed);
      case RoyalScoreGame.difference:
        return RoyalPlayerScore(name: name, deal: deal, crown: crown,
            difference: difference + points, firstPlayed: firstPlayed);
    }
  }

  factory RoyalPlayerScore.fromJson(Map<String, dynamic> value) =>
      RoyalPlayerScore(
        name: value['name'] is String ? value['name'] as String : '',
        deal: _nonnegative(value['deal']),
        crown: _nonnegative(value['crown']),
        difference: _nonnegative(value['difference']),
        firstPlayed: _nonnegative(value['firstPlayed']),
      );

  static int _nonnegative(dynamic number) {
    return number is int && number >= 0 ? number : 0;
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'deal': deal,
    'crown': crown,
    'difference': difference,
    'firstPlayed': firstPlayed,
  };
}

class RoyalScoreStore {
  RoyalScoreStore._();

  static const _nameKey = 'rc_display_name_v1';
  static const _scoresKey = 'rc_local_scores_v1';
  static const _pendingKey = 'rc_pending_scores_v1';

  static Future<String?> displayName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_nameKey)?.trim();
    return name == null || name.isEmpty ? null : name;
  }

  /// Display names are intentionally separate from phone numbers / real names.
  static Future<void> saveDisplayName(String proposedName) async {
    final name = proposedName.trim().replaceAll(RegExp(r'\\s+'), ' ');
    if (name.length < 2 || name.length > 30) {
      throw const FormatException('نام نمایشی باید بین ۲ تا ۳۰ کاراکتر باشد.');
    }
    final prefs = await SharedPreferences.getInstance();
    final previousName = prefs.getString(_nameKey)?.trim() ?? '';
    final players = _readPlayers(prefs);
    final previousKey = previousName.toLowerCase();
    final nextKey = name.toLowerCase();

    // Renaming updates the same player's entry, rather than creating a
    // second leaderboard identity when the display name changes.
    if (previousKey.isNotEmpty && previousKey != nextKey &&
        players.containsKey(previousKey)) {
      if (players.containsKey(nextKey)) {
        throw const FormatException('این نام در همین دستگاه ثبت شده است.');
      }
      final old = players.remove(previousKey)!;
      players[nextKey] = RoyalPlayerScore(
        name: name, deal: old.deal, crown: old.crown,
        difference: old.difference, firstPlayed: old.firstPlayed,
      );
    } else if (players.containsKey(nextKey)) {
      final old = players[nextKey]!;
      players[nextKey] = RoyalPlayerScore(
        name: name, deal: old.deal, crown: old.crown,
        difference: old.difference, firstPlayed: old.firstPlayed,
      );
    }
    final pending = _readPending(prefs);
    var entry = players[nextKey] ??
        RoyalPlayerScore(name: name,
            firstPlayed: DateTime.now().millisecondsSinceEpoch);
    for (final game in RoyalScoreGame.values) {
      final amount = pending[game.name] ?? 0;
      if (amount > 0) entry = entry.add(game, amount);
    }
    players[nextKey] = entry;
    await prefs.setString(_nameKey, name);
    await prefs.setString(_scoresKey,
        jsonEncode(players.values.map((p) => p.toJson()).toList()));
    await prefs.remove(_pendingKey);
  }

  /// Records only scores from completed rounds. The current app has no
  /// verified accounts or protected scoring endpoint.
  static Future<void> recordScore(RoyalScoreGame game, int points) async {
    if (points <= 0 || points > 1000000) return;
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_nameKey)?.trim() ?? '';
    if (name.isEmpty) {
      final pending = _readPending(prefs);
      pending[game.name] = (pending[game.name] ?? 0) + points;
      await prefs.setString(_pendingKey, jsonEncode(pending));
      return;
    }
    final players = _readPlayers(prefs);
    final key = name.toLowerCase();
    final previous = players[key] ??
        RoyalPlayerScore(name: name,
            firstPlayed: DateTime.now().millisecondsSinceEpoch);
    players[key] = previous.add(game, points);
    await prefs.setString(_scoresKey,
        jsonEncode(players.values.map((p) => p.toJson()).toList()));
  }

  static Future<List<RoyalPlayerScore>> topTen(
      {RoyalScoreGame? game}) async {
    final prefs = await SharedPreferences.getInstance();
    final records = _readPlayers(prefs).values
        .where((score) => score.pointsFor(game) > 0).toList()
      ..sort((a, b) {
        final order = b.pointsFor(game).compareTo(a.pointsFor(game));
        return order != 0
            ? order
            : a.firstPlayed.compareTo(b.firstPlayed);
      });
    return records.take(10).toList(growable: false);
  }

  static Map<String, RoyalPlayerScore> _readPlayers(
      SharedPreferences prefs) {
    final data = prefs.getString(_scoresKey);
    if (data == null) return {};
    try {
      final items = jsonDecode(data);
      if (items is! List) return {};
      final results = <String, RoyalPlayerScore>{};
      for (final item in items) {
        if (item is! Map<String, dynamic>) continue;
        final score = RoyalPlayerScore.fromJson(item);
        if (score.name.isNotEmpty) {
          results[score.name.toLowerCase()] = score;
        }
      }
      return results;
    } catch (_) {
      return {};
    }
  }

  static Map<String, int> _readPending(SharedPreferences prefs) {
    final data = prefs.getString(_pendingKey);
    if (data == null) return {};
    try {
      final value = jsonDecode(data);
      if (value is! Map<String, dynamic>) return {};
      return {
        for (final game in RoyalScoreGame.values)
          game.name: value[game.name] is int && value[game.name] >= 0
              ? value[game.name] as int : 0,
      };
    } catch (_) {
      return {};
    }
  }
}
