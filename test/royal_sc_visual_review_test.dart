import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sahand_consortium/src/home_page.dart';

void main() {
  testWidgets('Capture the real rotating Home at four orientations', (tester) async {
    tester.view.physicalSize = const Size(780, 1688);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    const key = Key('home-review');
    await tester.pumpWidget(const RepaintBoundary(key: key, child: MaterialApp(home: HomePage())));
    await tester.runAsync(() async {
      final context = tester.element(find.byType(HomePage));
      for (final path in ['ROYAL_ONE_HOME_APPROVED_FINAL.png', 'SC_upright_feathered.png', 'SC_owner_approved_front.png']) {
        await precacheImage(AssetImage('assets/image/$path'), context);
      }
      await Future<void>.delayed(const Duration(milliseconds: 300));
    });
    await tester.pump();
    Directory('build/royal_visual_review').createSync(recursive: true);
    for (var i = 0; i < 4; i++) {
      if (i > 0) await tester.pump(const Duration(milliseconds: 5500));
      await tester.runAsync(() async {
        final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(key));
        final image = await boundary.toImage(pixelRatio: 2);
        final data = await image.toByteData(format: ui.ImageByteFormat.png);
        if (data != null) File('build/royal_visual_review/sc_$i.png').writeAsBytesSync(data.buffer.asUint8List());
        image.dispose();
      });
      expect(tester.takeException(), isNull);
    }
  });
}
