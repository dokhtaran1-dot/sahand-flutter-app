import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sahand_consortium/src/home_page.dart';

void main() {
  testWidgets('Compact SC and three gently floating home portals remain interactive',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: true),
        child: HomePage(),
      ),
    ));
    await tester.pump();

    expect(find.byKey(const ValueKey('royal-home-sc-compact')), findsOneWidget);
    for (final symbol in const ['RM', 'RC', 'RV']) {
      expect(find.byKey(ValueKey('royal-home-portal-$symbol')), findsOneWidget);
    }
    expect(find.byWidgetPredicate(
      (w) => w is RoyalTouchTarget && w.label.startsWith('ENTER ')),
      findsNWidgets(3),
    );
    expect(find.byWidgetPredicate(
      (w) => w is RoyalTouchTarget && w.label == 'میراث سهند'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
