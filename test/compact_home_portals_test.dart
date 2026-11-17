import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sahand_consortium/src/home_page.dart';
import 'package:sahand_consortium/src/heritage_page.dart';
import 'package:sahand_consortium/src/royal_village_page.dart';

void main() {
  testWidgets('Approved seven image portals and five bilingual footer actions are interactive',
      (tester) async {
    tester.view.physicalSize = const Size(432, 960);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MaterialApp(
      home: MediaQuery(data: MediaQueryData(disableAnimations: true),
        child: HomePage()),
    ));
    await tester.pump();
    expect(find.byKey(const ValueKey('royal-one-approved-art')), findsOneWidget);
    expect(find.byKey(const ValueKey('royal-one-slow-sc-rotation')), findsOneWidget);
    for (final title in const [
      'رویال مال | Royal Mall',
      'باشگاه مشتریان VIP | Royal Club',
      'کافه رویال ویلاژ | Royal Village',
      'کنسرسیوم سهند | Sahand Consortium',
      'طراحی، ساخت، اجرا | Royal Etehad',
      'خریدهای سیگنیچر | Royal Signiture',
      'تبلیغات، سوشیال، فروش | Royal Harmonia',
      'خانه | Home', 'کشف | Explore',
      'باشگاه مشتریان | Royal Club',
      'رزرو | Reservations', 'حساب من | Profile',
      'منو | Menu', 'انتخاب زبان | Languages',
    ]) {
      expect(find.byWidgetPredicate((w) =>
        w is Semantics && w.properties.label == title), findsOneWidget,
        reason: 'Missing approved hit target: $title');
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC opens the original Heritage and RV enters the salon experience',
      (tester) async {
    tester.view.physicalSize = const Size(432, 960);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MaterialApp(
      home: MediaQuery(data: MediaQueryData(disableAnimations: true),
        child: HomePage()),
    ));
    await tester.pump();
    final sc = find.byWidgetPredicate((w) =>
        w is Semantics && w.properties.label ==
        'کنسرسیوم سهند | Sahand Consortium');
    await tester.tap(sc);
    await tester.pumpAndSettle();
    expect(find.byType(HeritagePage), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    final rv = find.byWidgetPredicate((w) =>
        w is Semantics && w.properties.label ==
        'کافه رویال ویلاژ | Royal Village');
    await tester.tap(rv);
    await tester.pumpAndSettle();
    expect(find.byType(RoyalVillagePage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
