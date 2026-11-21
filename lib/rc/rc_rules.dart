import 'dart:math';

/// Royal Club rules. This is a client-side presentation model only.
/// Wallet mutations and reward approvals MUST be executed by trusted server RPCs.
abstract final class RcRules {
  static const signupTickets = 20;
  static const dailyTickets = 5;
  static const differenceEntry = 1;
  static const crownEntry = 2;
  static const dealEntry = 3;
  static const maxSkillPointsPerRound = 45;
  static const monthlyPrizeBudgetToman = 500000000;
  static const caseValues = <int>[
    1, 2, 3, 5, 8, 10, 15, 20, 25, 30, 40, 50, 75,
    100, 150, 200, 250, 300, 400, 500, 600, 750,
    1000, 1500, 2000, 3000,
  ];
  static const skillPoints = <String, int>{
    'logic': 10,
    'pattern': 15,
    'speed': 20,
  };
}

enum RcGame { difference, crown, deal }

int ticketCost(RcGame game) => switch (game) {
  RcGame.difference => RcRules.differenceEntry,
  RcGame.crown => RcRules.crownEntry,
  RcGame.deal => RcRules.dealEntry,
};

/// UI-only snapshot. Never use it to determine server-side rewards.
class DealRound {
  DealRound._(this.values, this.playerCase);
  final List<int> values;
  final int playerCase;
  final Set<int> opened = <int>{};

  factory DealRound.start({Random? random}) {
    final rng = random ?? Random.secure();
    final values = List<int>.from(RcRules.caseValues)..shuffle(rng);
    return DealRound._(List<int>.unmodifiable(values), rng.nextInt(26));
  }

  int openCase(int index) {
    if (index < 0 || index >= 26 || index == playerCase || !opened.add(index)) {
      throw StateError('Invalid or already opened case');
    }
    return values[index];
  }

  List<int> get remainingValues => [
    for (var i = 0; i < 26; i++)
      if (!opened.contains(i)) values[i],
  ];

  /// Illustrative offer only; no redeemable points result from this.
  int bankerOffer({double factor = 0.75}) {
    final available = remainingValues;
    return (available.reduce((a, b) => a + b) / available.length * factor).round();
  }
}
