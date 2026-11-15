import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sahand_consortium/src/reservation_page.dart';
import 'package:sahand_consortium/src/rv_online_booking_service.dart';
import 'package:sahand_consortium/src/rv_media_page.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('Reservation phone numbers normalize without exposing local formatting', () {
    expect(RvOnlineBookingService.normalizePhone('0914 123 4567'),
      '+989141234567');
    expect(RvOnlineBookingService.normalizePhone('0098 914 123 4567'),
      '+989141234567');
    expect(RvOnlineBookingService.normalizePhone('+989141234567'),
      '+989141234567');
  });

  testWidgets('RV reservation clearly separates online submission and draft',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(
      home: ReservationPage(salonName: 'Salon Noir')));
    await tester.pumpAndSettle();

    expect(find.text('ارسال آنلاین درخواست رزرو'), findsOneWidget);
    expect(find.text('ذخیره پیش‌نویس فقط روی این گوشی'), findsOneWidget);
    expect(find.text('درخواست‌های من و وضعیت آنلاین'), findsOneWidget);
    expect(find.textContaining('قطعی‌شدن رزرو نیست'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Approved media without published files stays transparent',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: RvMediaPage()));
    await tester.pumpAndSettle();
    expect(find.textContaining('ویدیوی تأییدشده هنوز'),
      findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
