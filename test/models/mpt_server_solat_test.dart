import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:waktusolatmalaysia/models/mpt_server_solat.dart';

void main() {
  test('Parse API response', () async {
    const jsonString =
        '''
{
    "zone": "SGR01",
    "year": 2023,
    "month": "MAY",
    "last_updated": "2023-05-18T18:48:11.892Z",
    "prayers": [
        {
            "syuruk": 1682895720,
            "dhuhr": 1682917980,
            "maghrib": 1682940000,
            "hijri": "1444-10-10",
            "isha": 1682944260,
            "fajr": 1682891640,
            "day": 1,
            "asr": 1682929860
        },
        {
            "maghrib": 1683026400,
            "dhuhr": 1683004380,
            "hijri": "1444-10-11",
            "day": 2,
            "isha": 1683030660,
            "fajr": 1682977980,
            "asr": 1683016260,
            "syuruk": 1682982120
        },
    ]
}
''';
    final json = jsonDecode(jsonString);
    final solatData = MptServerSolat.fromJson(json);

    expect(solatData.zone, 'SGR01');
    expect(solatData.year, 2023);
    expect(solatData.month, 'MAY');
    expect(solatData.prayers.length, 2);

    final firstPrayer = solatData.prayers[0];
    expect(firstPrayer.day, 1);
    expect(firstPrayer.fajr, DateTime(2023, 5, 1, 5, 54));

    final secondPrayer = solatData.prayers[1];
    expect(secondPrayer.day, 2);
    expect(secondPrayer.hijri, '1444-10-11');
  });
}
