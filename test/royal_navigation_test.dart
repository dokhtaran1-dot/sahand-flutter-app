import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sahand_consortium/src/home_page.dart';
import 'package:sahand_consortium/src/heritage_page.dart';
import 'package:sahand_consortium/src/royal_village_page.dart';

Widget app() => MaterialApp(theme: ThemeData.dark().copyWith(textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'PreviewSans')), builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(disableAnimations: true), child: child!), home: const HomePage());
Future<void> loadImages(WidgetTester tester, BuildContext context, List<String> assets) async {
  await tester.runAsync(() async {
    for (final asset in assets) { await precacheImage(AssetImage(asset), context); }
  });
  await tester.pumpAndSettle();
}
void main() {
  setUpAll(() async {
    final font = File('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf');
    if (await font.exists()) {
      final loader = FontLoader('PreviewSans')..addFont(Future.value(ByteData.sublistView(await font.readAsBytes())));
      await loader.load();
    }
  });
  testWidgets('Approved home: all portals fit and heritage is reachable', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(app());
    await loadImages(tester, tester.element(find.byType(HomePage)), ['assets/image/royal_one_approved_v21.jpg']);
    expect(tester.takeException(), isNull);
    expect(find.byWidgetPredicate((w) => w is RoyalTouchTarget && w.label.startsWith('ENTER ')), findsNWidgets(3));
    await expectLater(find.byType(HomePage), matchesGoldenFile('goldens/royal_one_home_390.png'));
    await tester.tap(find.byWidgetPredicate((w) => w is RoyalTouchTarget && w.label == 'میراث سهند'));
    await tester.pumpAndSettle();
    expect(find.byType(HeritagePage), findsOneWidget);
    await tester.scrollUntilVisible(find.text('حامد قنبری'), 250, scrollable: find.byType(Scrollable).last);
    await tester.pumpAndSettle();
    expect(find.text('حامد قنبری'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('RV ENTER opens readable salon selection on a small phone', (tester) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(app());
    await loadImages(tester, tester.element(find.byType(HomePage)), ['assets/image/royal_one_approved_v21.jpg']);
    await tester.tap(find.byWidgetPredicate((w) => w is RoyalTouchTarget && w.label == 'ENTER رویال ویلاژ کافه'));
    await tester.pumpAndSettle();
    expect(find.byType(RoyalVillagePage), findsOneWidget);
    await loadImages(tester, tester.element(find.byType(RoyalVillagePage)), ['Grand_Salon_Original.png', 'salon_gallery/lumiere/design_01.webp', 'salon_gallery/noir/design_01.webp', 'salon_gallery/jardin/design_01.webp', 'salon_gallery/prive/design_01.webp', 'salon_gallery/imperial/design_01.webp', 'salon_gallery/dore/design_01.webp', 'salon_gallery/ame_du_poete/design_01.webp', 'salon_gallery/royal/design_01.webp'].map((p) => 'assets/image/$p').toList());
    expect(find.text('رزرو میز و سالن'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await expectLater(find.byType(RoyalVillagePage), matchesGoldenFile('goldens/royal_village_360.png'));
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);
  });
}
