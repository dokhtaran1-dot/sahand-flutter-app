/// Royal Village main salons. Sourced from the user's original
/// royal_village_gallery.json (version 1), not from generic placeholders.
/// IDs preserve the uploaded manifest; the seven source photos were restored
/// from commit ac94557573e15519e35b3b5f7b99388bb2553bed and cropped
/// from each original room's catalogue. The historical Royal file is
/// mislabeled Émeraude, so Royale displays an explicit pending placeholder
/// rather than a false picture. The user's manifest remains unchanged.
class RvSalonRecord {
  const RvSalonRecord({
    required this.id,
    required this.name,
    required this.coverAsset,
    required this.galleryFolder,
    required this.designCount,
    required this.cakeCount,
    this.doubleVip = false,
  });
  final String id, name, coverAsset, galleryFolder;
  final int designCount, cakeCount;
  final bool doubleVip;
}

class RvSalonCatalogue {
  RvSalonCatalogue._();

  static const originalManifest = 'assets/rv/royal_village_gallery.json';

  /// The original birthday-and-cake catalogue is separate from the room image.
  /// Royale has no verified source poster; never display Émeraude instead.
  static String? originalCataloguePath(String name) {
    final record = forName(name);
    if (record == null || record.id == 'royale') return null;
    return 'assets/image/rv_original_catalogues/${record.id}.png';
  }

  /// The app's previously approved display order is retained.
  static const salons = <RvSalonRecord>[
    RvSalonRecord(id: 'lumiere', name: 'Salon Lumière',
      coverAsset: 'assets/image/rv_original_photos/lumiere.jpg', galleryFolder: 'lumiere',
      designCount: 10, cakeCount: 10,
      doubleVip: false),
    RvSalonRecord(id: 'noir', name: 'Salon Noir',
      coverAsset: 'assets/image/rv_original_photos/noir.jpg', galleryFolder: 'noir',
      designCount: 10, cakeCount: 10,
      doubleVip: false),
    RvSalonRecord(id: 'jardin', name: 'Salon Jardin',
      coverAsset: 'assets/image/rv_original_photos/jardin.jpg', galleryFolder: 'jardin',
      designCount: 10, cakeCount: 10,
      doubleVip: false),
    RvSalonRecord(id: 'prive', name: 'Salon Privé',
      coverAsset: 'assets/image/rv_original_photos/prive.jpg', galleryFolder: 'prive',
      designCount: 10, cakeCount: 10,
      doubleVip: false),
    RvSalonRecord(id: 'rv_lounge_imperial', name: 'RV Lounge Impérial Classique',
      coverAsset: 'assets/image/rv_original_photos/rv_lounge_imperial.jpg', galleryFolder: 'imperial',
      designCount: 10, cakeCount: 20,
      doubleVip: true),
    RvSalonRecord(id: 'dore', name: 'Salon Doré',
      coverAsset: 'assets/image/rv_original_photos/dore.jpg', galleryFolder: 'dore',
      designCount: 10, cakeCount: 10,
      doubleVip: false),
    RvSalonRecord(id: 'ame_du_poete', name: 'Salon Âme du Poète',
      coverAsset: 'assets/image/rv_original_photos/ame_du_poete.jpg', galleryFolder: 'ame_du_poete',
      designCount: 10, cakeCount: 10,
      doubleVip: false),
    RvSalonRecord(id: 'royale', name: 'Salon Royale',
      coverAsset: 'assets/image/rv_original_photos/royale_pending.jpg', galleryFolder: 'royal',
      designCount: 10, cakeCount: 10,
      doubleVip: false),
  ];

  static RvSalonRecord? forName(String name) {
    // Historical app links still using the short older spelling work.
    final normalized = name == 'Salon Royal' ? 'Salon Royale' : name;
    for (final salon in salons) {
      if (salon.name == normalized || salon.id == normalized) return salon;
    }
    return null;
  }

  static RvSalonRecord? forId(String id) {
    for (final salon in salons) {
      if (salon.id == id) return salon;
    }
    return null;
  }
}
