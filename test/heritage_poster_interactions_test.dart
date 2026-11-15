import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sahand_consortium/src/heritage_page.dart';

void main() {
  testWidgets('Approved Heritage poster exposes all 10 branches and native controls',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: HeritagePage()));
    await tester.pump();

    const fourLanguages = [
      'فارسی FA', 'English EN', 'العربية AR', 'Français FR'
    ];
    const tenBranches = [
      'Royal Mall Tabriz',
      'RV Royal Village Café',
      'UAE Construction & Development',
      'Shirin Sahand Azerbaijan',
      'Agriculture Stone Fruits',
      'Iberchem Representation',
      'Lova Coffee',
      'Export & Import Signature Product',
      'Media Advertising Studio HQ',
      '1800 m² Project · Floor 3',
    ];
    const fiveFooterActions = [
      'President', 'Our Heritage', 'Branches', 'Media', 'Contact Us'
    ];

    for (final name in [
      ...fourLanguages,
      ...tenBranches,
      ...fiveFooterActions,
      'Main menu',
      'Sofr Ghanbari · Founder',
      'Hamed Ghanbari · President',
      'SC · Our Heritage',
    ]) {
      expect(find.byTooltip(name), findsOneWidget,
          reason: 'The original poster must have a working hit target for ' + name);
    }

    // A language button must change state and show translated content.
    await tester.tap(find.byTooltip('English EN'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Royal Heritage · From Father to Son'),
        findsOneWidget);
  });
}
