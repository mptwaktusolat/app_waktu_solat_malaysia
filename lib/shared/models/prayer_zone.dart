import 'package:flutter/foundation.dart';

@immutable
class PrayerZone {
  const PrayerZone({
    required this.jakimCode,
    required this.negeri,
    required this.daerah,
  });

  final String jakimCode;
  final String negeri;
  final String daerah;

  factory PrayerZone.fromJson(Map<String, Object?> json) {
    final jakimCode = json['jakimCode'] as String;
    final negeri = json['negeri'] as String;
    final daerah = json['daerah'] as String;

    return PrayerZone(
      jakimCode: jakimCode.trim().toUpperCase(),
      negeri: negeri.trim(),
      daerah: daerah.trim(),
    );
  }

  Map<String, String> toJson() => {
        'jakimCode': jakimCode,
        'negeri': negeri,
        'daerah': daerah,
      };
}
