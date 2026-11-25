import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sahand_consortium/src/home_page.dart';
import 'package:sahand_consortium/src/heritage_page.dart';
import 'package:sahand_consortium/src/royal_village_page.dart';
import 'package:sahand_consortium/src/royal_mall_page.dart';

Widget app() => MaterialApp(theme: ThemeData.dark().copyWith(textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'PreviewSans')), builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(disableAnimations: true), child: child!), home: const HomePage());
Future<void> loadImages(WidgetTester tester, BuildContext context, List<String> assets) async {
  await tester.runAsync(() async {
    for (final asset in assets) { await precacheImage(AssetImage(asset), context); }
  });
  await tester.pumpAndSettle();
}
void main() {
  test('Approved SC rotates around its vertical axis without overlays', () {
    final source = File('lib/src/home_page.dart').readAsStringSync();
    expect(source.contains("class _VerticalSpinningSc"), isTrue);
    expect(source.contains("const Duration(seconds: 22)"), isTrue);
    expect(source.contains("longitude - turn + math.pi"), isTrue);
    expect(source.contains("ROYAL_ONE_HOME_APPROVED_FINAL.png"), isTrue);
  });
  test('All seven circular portal targets map to the original sections', () {
    final source = File('lib/src/home_page.dart').readAsStringSync();
    final mapping = <String, int>{};
    final pattern = RegExp(r"_OrbPortal\([^\n]*?label: '([^']+)'[^\n]*onTap: \(\) => open\((\d+)\)");
    for (final match in pattern.allMatches(source)) {
      mapping[match.group(1)!] = int.parse(match.group(2)!);
    }
    expect(mapping, <String, int>{
      'RM': 0, 'RC': 1, 'RV': 2, 'SC': 6,
      'RE': 3, 'RS': 4, 'RH': 5,
    });
  });
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
    await loadImages(tester, tester.element(find.byType(HomePage)), ['assets/image/ROYAL_ONE_HOME_APPROVED_FINAL.png', 'assets/image/ROYAL_ONE_SC_360_TEXTURE.png']);
    expect(tester.takeException(), isNull);
    // Visual anchor: the separate SC texture must exist for vertical-axis spin.
    expect(find.byKey(const Key('orb:SC')), findsOneWidget);
    for (final portal in ['RM', 'RC', 'RV', 'SC', 'RE', 'RS', 'RH']) {
      expect(find.byKey(Key('orb:' + portal)), findsOneWidget, reason: 'Missing restored orb: $portal');
    }
    expect(find.byWidgetPredicate((w) => w is RoyalTouchTarget && w.label.startsWith('ENTER ')), findsNothing);
    await tester.tap(find.byKey(const Key('orb:RM')));
    await tester.pumpAndSettle();
    expect(find.byType(RoyalMallPage), findsOneWidget);
    Navigator.of(tester.element(find.byType(RoyalMallPage))).pop();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('orb:SC')));
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
    await loadImages(tester, tester.element(find.byType(HomePage)), ['assets/image/ROYAL_ONE_HOME_APPROVED_FINAL.png', 'assets/image/ROYAL_ONE_SC_360_TEXTURE.png']);
    await tester.tap(find.byKey(const Key('orb:RV')));
    await tester.pumpAndSettle();
    expect(find.byType(RoyalVillagePage), findsOneWidget);
    await loadImages(tester, tester.element(find.byType(RoyalVillagePage)), ['Grand_Salon_Original.png', 'salon_gallery/lumiere/design_01.webp', 'salon_gallery/noir/design_01.webp', 'salon_gallery/jardin/design_01.webp', 'salon_gallery/prive/design_01.webp', 'salon_gallery/imperial/design_01.webp', 'salon_gallery/dore/design_01.webp', 'salon_gallery/ame_du_poete/design_01.webp', 'salon_gallery/royal/design_01.webp'].map((p) => 'assets/image/$p').toList());
    expect(find.text('رزرو میز و سالن'), findsOneWidget);
    expect(tester.takeException(), isNull);
    Navigator.of(tester.element(find.byType(RoyalVillagePage))).pop();
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);
  });
}
