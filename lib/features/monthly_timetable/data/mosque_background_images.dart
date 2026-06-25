/// List of file of mosque image background
const _mosqueBackgroundImages = {
  'JHR': 'JHR-SultanIskandar.jpeg',
  'KDH': 'KDH-Zahir.jpg',
  'KTN': 'KTN-alismaili.jpg',
  'MLK': 'MLK-SelatMelaka.jpg',
  'NGS': 'NGS-Sendayan.jpg',
  'PHG': 'PHG-Shas.jpg',
  'PLS': 'PLS-alhussain.jpg',
  'PNG': 'PNG-MasjidTerapung.jpg',
  'PRK': 'PRK-Ubudiah.jpg',
  'SBH': 'SBH-KK.jpg',
  'SGR': 'SGR-UIA.webp',
  'SWK': 'SWK-Terapung.webp',
  'TRG': 'TRG-Kristal.jpg',
  'WLY01': 'WLY01-Putra.jpeg',
  'WLY02': 'WLY02-AnNur.jpg',
};

/// The bucket URL.
const _mediaBucketUrl = 'https://bucket.waktusolat.app/mosque_background_imgs';

class MosqueBackgroundImages {
  /// Get the mosque image URI for a given zone
  static Uri getMosqueUriFromZoneCode(String zoneCode) {
    final normalizedZoneCode = zoneCode.trim().toUpperCase();

    final imageFileName = _mosqueBackgroundImages[normalizedZoneCode] ??
        _mosqueBackgroundImages[_getZonePrefix(normalizedZoneCode)];

    if (imageFileName == null) {
      throw ArgumentError.value(
        zoneCode,
        'zoneCode',
        'Unsupported JAKIM zone code.',
      );
    }

    return Uri.parse('$_mediaBucketUrl/$imageFileName');
  }

  static String _getZonePrefix(String zoneCode) {
    if (zoneCode.length < 3) {
      throw ArgumentError.value(
        zoneCode,
        'zoneCode',
        'Zone code must be at least 3 characters long.',
      );
    }

    return zoneCode.substring(0, 3);
  }
}
