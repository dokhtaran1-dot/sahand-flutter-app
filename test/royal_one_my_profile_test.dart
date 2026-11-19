import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sahand_consortium/src/royal_one_my_profile_page.dart';
import 'package:sahand_consortium/src/my_reservations_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('Approved PROFILE is compact, black-gold, and no fake portrait/QR',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    for (final viewport in const [Size(390, 844), Size(840, 740)]) {
      tester.view.physicalSize = viewport;
      await tester.pumpWidget(
          const MaterialApp(home: RoyalOneMyProfilePage()));
      await tester.pump();

      expect(find.byKey(const ValueKey('royal-one-my-profile')),
          findsOneWidget);
      expect(find.text('PROFILE'), findsWidgets);
      expect(find.byKey(const ValueKey('my-profile-avatar-placeholder')),
          findsOneWidget);
      expect(find.byKey(const ValueKey('profile-membership-code-action')),
          findsOneWidget);
      expect(find.text('QR غیرفعال'), findsOneWidget);
      expect(find.byType(Image), findsNothing,
          reason: 'Do not substitute a stock portrait or fake QR asset');
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('Reservations menu opens existing real reservations screen',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
        const MaterialApp(home: RoyalOneMyProfilePage()));
    await tester.pump();
    await tester.tap(
        find.byKey(const ValueKey('my-profile-reservations-action')));
    await tester.pumpAndSettle();

    expect(find.byType(MyReservationsPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Notifications explain that online backend is not active',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
        const MaterialApp(home: RoyalOneMyProfilePage()));
    await tester.pump();
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('my-profile-notifications-action')),
      140,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(
        find.byKey(const ValueKey('my-profile-notifications-action')));
    await tester.pumpAndSettle();

    expect(find.text('NOTIFICATIONS'), findsOneWidget);
    expect(find.text('سامانه اعلان‌ها هنوز فعال نشده است.'),
        findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
