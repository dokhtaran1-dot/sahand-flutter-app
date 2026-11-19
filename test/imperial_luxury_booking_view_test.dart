import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sahand_consortium/src/imperial_luxury_booking_view.dart';
import 'package:sahand_consortium/src/salon_detail_page.dart';

void main() {
  testWidgets('Imperial screen preserves all live booking action targets',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var taps = 0;
    await tester.pumpWidget(MaterialApp(
      home: ImperialLuxuryBookingView(
        salonName: 'RV Lounge Impérial Classique',
        imageAsset: 'assets/image/rv_original_photos/rv_lounge_imperial.jpg',
        date: null, time: null,
        designCount: 10, cakeCount: 20,
        designNumber: null, cakeNumber: null, music: null,
        onDate: () => taps++,
        onTime: () => taps++,
        onDesigns: () => taps++,
        onCakes: () => taps++,
        onMusic: () => taps++,
        onCatalogue: () => taps++,
        onReserve: () => taps++,
      ),
    ));
    await tester.pump();

    expect(find.byKey(const ValueKey('imperial-luxury-booking')),
        findsOneWidget);
    expect(find.byKey(const ValueKey('imperial-date')), findsOneWidget);
    expect(find.byKey(const ValueKey('imperial-time')), findsOneWidget);
    expect(find.text('10 دیزاین تولد اختصاصی'), findsOneWidget);
    expect(find.text('20 مدل کیک اختصاصی'), findsOneWidget);
    expect(find.text('۳ موسیقی اختصاصی'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('imperial-date')));
    await tester.pump();
    expect(taps, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Imperial Lounge is routed through existing SalonDetailPage',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(
      home: SalonDetailPage(salonName: 'RV Lounge Impérial Classique'),
    ));
    await tester.pump();
    expect(find.byKey(const ValueKey('imperial-luxury-booking')),
        findsOneWidget);
    expect(find.text('20 مدل کیک اختصاصی'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
