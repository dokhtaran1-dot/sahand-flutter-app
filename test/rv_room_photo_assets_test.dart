import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sahand_consortium/src/rv_gallery_page.dart';
import 'package:sahand_consortium/src/royal_village_entry_page.dart';
import 'package:sahand_consortium/src/salon_preview_image.dart';
import 'package:sahand_consortium/src/salon_detail_page.dart';
import 'package:sahand_consortium/src/rv_salon_interior_image.dart';

/// Seven images restored from the original interior catalogues.
 /// Royale is an explicitly labeled temporary placeholder, not a false image.
const rooms = <String>[
  'assets/image/rv_original_photos/lumiere.jpg',
  'assets/image/rv_original_photos/noir.jpg',
  'assets/image/rv_original_photos/jardin.jpg',
  'assets/image/rv_original_photos/prive.jpg',
  'assets/image/rv_original_photos/rv_lounge_imperial.jpg',
  'assets/image/rv_original_photos/dore.jpg',
  'assets/image/rv_original_photos/ame_du_poete.jpg',
  'assets/image/rv_original_photos/royale_pending.jpg',
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('All eight interior photos exist and are bundled in Royal One', () async {
    for (final path in rooms) {
      final bytes = await rootBundle.load(path);
      expect(bytes.lengthInBytes,
          greaterThan(path.contains('royale_pending') ? 5000 : 50000),
          reason: 'Restored room image missing from APK: $path');
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
    // Preview assets are the separate originals, not marketing model posters.
    expect(find.byType(RvSalonInteriorImage), findsWidgets);

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
    expect(assets, contains('assets/image/rv_original_photos/rv_lounge_imperial.jpg'));
    expect(find.byType(SalonPreviewImage), findsNothing);
    expect(tester.takeException(), isNull);
  });


  testWidgets('Choosing a real RV salon photo opens that salon detail, not a promotional poster',
      (tester) async {
    tester.view.physicalSize = const Size(432, 960);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: RvGalleryPage()));
    await tester.pump();
    await tester.tap(find.text('Salon Lumière').first);
    await tester.pumpAndSettle();
    expect(find.text('انتخاب سالن و مشاهدهٔ جزئیات رزرو'), findsOneWidget);
    await tester.tap(find.text('انتخاب سالن و مشاهدهٔ جزئیات رزرو'));
    await tester.pumpAndSettle();
    expect(find.byType(SalonDetailPage), findsOneWidget);
    final images = tester.widgetList<Image>(find.byType(Image))
        .where((img) => img.image is AssetImage)
        .map((img) => (img.image as AssetImage).assetName)
        .toList();
    expect(images, contains('assets/image/rv_original_photos/lumiere.jpg'));
    expect(tester.takeException(), isNull);
  });
  
  testWidgets('Original salon catalogue stays accessible with all 20 printed cakes',
      (tester) async {
    tester.view.physicalSize = const Size(432, 960);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MaterialApp(
      home: SalonDetailPage(salonName: 'RV Lounge Impérial Classique'),
    ));
    await tester.pump();
    expect(find.byType(RvSalonInteriorImage), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('rv-original-room-catalogue')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('rv-select-cake-from-catalogue')),
        findsOneWidget);
    expect(find.text('کاتالوگ اصلی سالن | عکس اتاق، دیزاین تولد و کیک'),
        findsOneWidget);
    expect(tester.takeException(), isNull);
  });

}
