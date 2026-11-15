import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sahand_consortium/src/ettehad_page.dart';

void main() {
  testWidgets('RE project and consultation buttons show meaningful actions',
      (tester) async {
    tester.view.physicalSize = const Size(432, 980);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: EttehadPage()));

    final project = find.text('مشاهده پروژه‌ها');
    await tester.ensureVisible(project);
    await tester.tap(project);
    await tester.pumpAndSettle();
    expect(find.text('پروژه تجاری ۳۶۰۰ مترمربع رویال مال'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    final consultation = find.text('درخواست مشاوره');
    await tester.ensureVisible(consultation);
    await tester.tap(consultation);
    await tester.pumpAndSettle();
    expect(find.text('وب‌سایت رسمی کنسرسیوم'), findsOneWidget);
    expect(find.textContaining('ثبت آنلاین درخواست مشاوره'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
