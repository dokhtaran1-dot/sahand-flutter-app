/// Royal Village main salons. Sourced from the user's original
/// royal_village_gallery.json (version 1), not from generic placeholders.
/// IDs preserve the uploaded manifest; asset paths map onto REAL files in
/// this Flutter repository. A placeholder CDN domain is NOT used.
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

  /// The app's previously approved display order is retained.
  static const salons = <RvSalonRecord>[
    RvSalonRecord(id: 'lumiere', name: 'Salon Lumière',
      coverAsset: 'assets/image/Salon_lumiere.png', galleryFolder: 'lumiere',
      designCount: 10, cakeCount: 10,
      doubleVip: false),
    RvSalonRecord(id: 'noir', name: 'Salon Noir',
      coverAsset: 'assets/image/Salon_noir.png', galleryFolder: 'noir',
      designCount: 10, cakeCount: 10,
      doubleVip: false),
    RvSalonRecord(id: 'jardin', name: 'Salon Jardin',
      coverAsset: 'assets/image/salon_jardin.png', galleryFolder: 'jardin',
      designCount: 10, cakeCount: 10,
      doubleVip: false),
    RvSalonRecord(id: 'prive', name: 'Salon Privé',
      coverAsset: 'assets/image/Salon_prive.png', galleryFolder: 'prive',
      designCount: 10, cakeCount: 10,
      doubleVip: false),
    RvSalonRecord(id: 'rv_lounge_imperial', name: 'RV Lounge Impérial Classique',
      coverAsset: 'assets/image/rv_lounge_imperial_classique.png', galleryFolder: 'imperial',
      designCount: 10, cakeCount: 20,
      doubleVip: true),
    RvSalonRecord(id: 'dore', name: 'Salon Doré',
      coverAsset: 'assets/image/salon_dore.png', galleryFolder: 'dore',
      designCount: 10, cakeCount: 10,
      doubleVip: false),
    RvSalonRecord(id: 'ame_du_poete', name: 'Salon Âme du Poète',
      coverAsset: 'assets/image/salon_ame_du_poete.png', galleryFolder: 'ame_du_poete',
      designCount: 10, cakeCount: 10,
      doubleVip: false),
    RvSalonRecord(id: 'royale', name: 'Salon Royale',
      coverAsset: 'assets/image/Salon_royal.png', galleryFolder: 'royal',
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
