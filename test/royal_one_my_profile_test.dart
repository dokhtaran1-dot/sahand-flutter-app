import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sahand_consortium/src/royal_one_my_profile_page.dart';

void main() {
  testWidgets('My Profile retains empty approved portrait and detail slots',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final viewport in const [Size(390, 844), Size(840, 740)]) {
      tester.view.physicalSize = viewport;
      await tester.pumpWidget(const MaterialApp(
        home: RoyalOneMyProfilePage(),
      ));
      await tester.pump();

      expect(
        find.byKey(const ValueKey('royal-one-my-profile')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('my-profile-photo-1')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('my-profile-photo-2')),
        findsOneWidget,
      );
      // Profile placeholders intentionally contain no substitute portraits.
      expect(find.byType(Image), findsNothing);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('My Profile Explore action navigates in-app',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(
      home: RoyalOneMyProfilePage(),
    ));
    await tester.ensureVisible(
      find.byKey(const ValueKey('my-profile-explore-action')),
    );
    await tester.tap(
      find.byKey(const ValueKey('my-profile-explore-action')),
    );
    await tester.pumpAndSettle();

    expect(find.text('EXPLORE · کشف'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
