import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sahand_consortium/src/rv_gallery_page.dart';
import 'package:sahand_consortium/src/royal_village_entry_page.dart';
import 'package:sahand_consortium/src/salon_preview_image.dart';

/// These are the eight existing interior-photo assets, not the model-based
/// booking posters. Check the app bundles them before shipping to customers.
const rooms = <String>[
  'assets/image/Salon_lumiere.png',
  'assets/image/Salon_noir.png',
  'assets/image/salon_jardin.png',
  'assets/image/Salon_prive.png',
  'assets/image/rv_lounge_imperial_classique.png',
  'assets/image/salon_dore.png',
  'assets/image/salon_ame_du_poete.png',
  'assets/image/Salon_royal.png',
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('All eight interior photos exist and are bundled in Royal One', () async {
    for (final path in rooms) {
      final bytes = await rootBundle.load(path);
      expect(bytes.lengthInBytes, greaterThan(100000),
          reason: 'Original salon interior photo missing from APK: $path');
    }
  });

  testWidgets('VIP gallery displays room images instead of promotional poster crops',
      (tester) async {
    tester.view.physicalSize = const Size(432, 960);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: RvGalleryPage()));
    await tester.pump();
    expect(find.byType(SalonPreviewImage), findsNothing);
    expect(find.text('۸ سالن اختصاصی رویال ویلاژ'), findsOneWidget);

    final assets = tester.widgetList<Image>(find.byType(Image)).map(
      (img) => img.image is AssetImage ? (img.image as AssetImage).assetName : ''
    ).toList();
    expect(assets, contains(rooms[0]));
    expect(assets, isNot(contains('assets/image/booking_posters/lumiere.png')));
    expect(tester.takeException(), isNull);
  });

  testWidgets('RV entry uses VIP interior hero instead of cropped ceiling poster',
      (tester) async {
    tester.view.physicalSize = const Size(432, 960);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: RoyalVillageEntryPage()));
    await tester.pump();

    final assets = tester.widgetList<Image>(find.byType(Image)).map(
      (img) => img.image is AssetImage ? (img.image as AssetImage).assetName : ''
    ).toList();
    expect(assets, contains('assets/image/rv_lounge_imperial_classique.png'));
    expect(find.byType(SalonPreviewImage), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
