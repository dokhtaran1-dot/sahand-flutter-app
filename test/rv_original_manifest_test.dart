import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sahand_consortium/src/data/rv_salon_catalogue.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('User original eight-salon manifest matches bundled Flutter registry', () async {
    final source = jsonDecode(
        await rootBundle.loadString(RvSalonCatalogue.originalManifest))
        as Map<String, dynamic>;
    final salons = (source['salons'] as List).cast<Map<String, dynamic>>();
    expect(salons.length, 8);
    expect(RvSalonCatalogue.salons.length, 8);

    for (final s in salons) {
      final room = RvSalonCatalogue.forId(s['id'] as String);
      expect(room, isNotNull, reason: 'Unmapped original room: ${s['id']}');
      expect(room!.name, s['name']);
      expect(room.designCount, (s['designs'] as List).length);
      expect(room.cakeCount, (s['cakes'] as List).length);
      expect(room.coverAsset, isNotEmpty);
      final photo = await rootBundle.load(room.coverAsset);
      expect(photo.lengthInBytes,
        greaterThan(room.id == 'royale' ? 10000 : 50000));
    }

    expect(RvSalonCatalogue.forName('Salon Royale')!.coverAsset,
      'assets/image/rv_original_photos/royale.jpg');
    expect(RvSalonCatalogue.forName('Salon Royal')!.name, 'Salon Royale');
    expect(RvSalonCatalogue.originalCataloguePath('Salon Royale'), isNull);
    expect(RvSalonCatalogue.originalCataloguePath('Salon Doré'),
      'assets/image/rv_original_catalogues/dore.png');
    expect(RvSalonCatalogue.forId('rv_lounge_imperial')!.galleryFolder,
      'imperial');
    expect(RvSalonCatalogue.forId('rv_lounge_imperial')!.cakeCount, 20);
    expect(RvSalonCatalogue.forId('dore')!.cakeCount, 10);
    expect(RvSalonCatalogue.salons.every((s) => s.designCount == 10), isTrue);
    expect((source['app'] as Map<String, dynamic>)['cdnBaseUrl'],
      contains('YOUR-CDN-DOMAIN'));
  });
}
