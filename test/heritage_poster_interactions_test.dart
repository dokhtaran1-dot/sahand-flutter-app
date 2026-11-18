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
  testWidgets('Whole Heritage poster and clickable portraits/footer fit phone and Fold screens',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final size in const [
      Size(390, 844),
      Size(432, 960),
      Size(840, 740),
    ]) {
      tester.view.physicalSize = size;
      await tester.pumpWidget(const MaterialApp(home: HeritagePage()));
      await tester.pumpAndSettle();

      final frame = tester.getRect(
        find.byKey(const ValueKey('royal-heritage-poster-frame')));
      expect(frame.left, greaterThanOrEqualTo(-0.5));
      expect(frame.top, greaterThanOrEqualTo(-0.5));
      expect(frame.right, lessThanOrEqualTo(size.width + 0.5));
      expect(frame.bottom, lessThanOrEqualTo(size.height + 0.5));

      final founder = tester.getRect(find.byTooltip('Sofr Ghanbari · Founder'));
      final president = tester.getRect(find.byTooltip('Hamed Ghanbari · President'));
      final footer = tester.getRect(find.byTooltip('Contact Us'));
      expect(founder.top, greaterThanOrEqualTo(frame.top - 1));
      expect(president.top, greaterThanOrEqualTo(frame.top - 1));
      expect(footer.bottom, lessThanOrEqualTo(frame.bottom + 1));

      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('Heritage branch details remain in-app instead of opening mini-site',
      (tester) async {
    tester.view.physicalSize = const Size(432, 960);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: HeritagePage()));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Agriculture Stone Fruits'));
    await tester.pumpAndSettle();
    expect(find.text('تاریخچه کنسرسیوم در اپ'), findsOneWidget);

    await tester.tap(find.text('تاریخچه کنسرسیوم در اپ'));
    await tester.pumpAndSettle();
    expect(find.text('ROYAL HERITAGE'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

}
