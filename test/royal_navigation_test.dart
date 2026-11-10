import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sahand_consortium/src/home_page.dart';
import 'package:sahand_consortium/src/heritage_page.dart';
import 'package:sahand_consortium/src/royal_village_page.dart';

Widget app() => MaterialApp(theme: ThemeData.dark(), builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(disableAnimations: true), child: child!), home: const HomePage());
void main() {
  testWidgets('Approved home: all portals fit and heritage is reachable', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byWidgetPredicate((w) => w is RoyalTouchTarget && w.label.startsWith('ENTER ')), findsNWidgets(3));
    await expectLater(find.byType(HomePage), matchesGoldenFile('goldens/royal_one_home_390.png'));
    await tester.tap(find.byWidgetPredicate((w) => w is RoyalTouchTarget && w.label == 'میراث سهند'));
    await tester.pumpAndSettle();
    expect(find.byType(HeritagePage), findsOneWidget);
    expect(find.text('حامد قنبری'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('RV ENTER opens readable salon selection on a small phone', (tester) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await tester.tap(find.byWidgetPredicate((w) => w is RoyalTouchTarget && w.label == 'ENTER رویال ویلاژ کافه'));
    await tester.pumpAndSettle();
    expect(find.byType(RoyalVillagePage), findsOneWidget);
    expect(find.text('رزرو میز و سالن'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await expectLater(find.byType(RoyalVillagePage), matchesGoldenFile('goldens/royal_village_360.png'));
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);
  });
}
