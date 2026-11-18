import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sahand_consortium/src/home_page.dart';

void main() {
  testWidgets('Approved Royal One home fits narrow and folded layouts without render exceptions',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetDevicePixelRatio);
    for (final size in const [Size(390, 844), Size(840, 740)]) {
      tester.view.physicalSize = size;
      await tester.pumpWidget(const MaterialApp(home: MediaQuery(
        data: MediaQueryData(disableAnimations: true), child: HomePage())));
      await tester.pump();
      expect(find.byKey(const ValueKey('royal-one-approved-art')), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
    addTearDown(tester.view.resetPhysicalSize);
  });
}
