import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:waktusolatmalaysia/models/mpt_server_solat.dart';
import 'package:waktusolatmalaysia/utils/hijri_date.dart';

void main() {
  test('Parse API response', () async {
    // The string below based on https://api.waktusolat.app/v2/solat/{zone}
    // The [prayers] array is shortened for brevity.
    const jsonString = '''
{
  "zone": "SGR01",
  "year": 2025,
  "month": "FEB",
  "last_updated": "2025-01-15T03:01:06.095Z",
  "prayers": [
    {
      "isha": 1738413600,
      "day": 1,
      "syuruk": 1738365960,
      "dhuhr": 1738387800,
      "hijri": "1446-08-02",
      "asr": 1738399860,
      "fajr": 1738361880,
      "maghrib": 1738409280
    },
    {
      "dhuhr": 1738474200,
      "maghrib": 1738495680,
      "day": 2,
      "asr": 1738486260,
      "hijri": "1446-08-03",
      "syuruk": 1738452360,
      "isha": 1738500000,
      "fajr": 1738448280
    }
  ]
}
''';
    final json = jsonDecode(jsonString);
    final solatData = MptServerSolat.fromJson(json);

    expect(solatData.zone, 'SGR01');
    expect(solatData.year, 2025);
    expect(solatData.month, 'FEB');

    final firstPrayer = solatData.prayers[0];

    expect(firstPrayer.fajr, DateTime(2025, 2, 1, 6, 18));

    final secondPrayer = solatData.prayers[1];
    expect(secondPrayer.hijri, HijriDate.parse('1446-08-03'));
  });
}
