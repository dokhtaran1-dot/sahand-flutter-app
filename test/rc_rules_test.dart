import 'package:flutter_test/flutter_test.dart';
import 'package:sahand_consortium/rc/rc_rules.dart';

void main() {
  test('Ticket costs and skill ceiling match approved rules', () {
    expect(ticketCost(RcGame.difference), 1);
    expect(ticketCost(RcGame.crown), 2);
    expect(ticketCost(RcGame.deal), 3);
    expect(RcRules.skillPoints.values.reduce((a, b) => a + b), 45);
    expect(RcRules.signupTickets, 20);
    expect(RcRules.dailyTickets, 5);
  });
  test('All 26 cases contain exactly the approved values', () {
    final round = DealRound.start();
    expect(round.values.length, 26);
    expect(round.values.toSet(), RcRules.caseValues.toSet());
    expect(round.playerCase, inInclusiveRange(0, 25));
  });
  test('Cannot open the selected case or reopen a case', () {
    final round = DealRound.start();
    expect(() => round.openCase(round.playerCase), throwsStateError);
    final index = (round.playerCase + 1) % 26;
    expect(round.openCase(index), round.values[index]);
    expect(() => round.openCase(index), throwsStateError);
  });
}
