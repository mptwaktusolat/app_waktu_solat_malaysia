import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:waktusolatmalaysia/models/jakim_esolat_model.dart';

void main() {
  test('Parse PrayerTime from JSON api response', () {
    var apiResponse =
        '''
        {
          "hijri": "1444-02-04",
          "date": "01-Sep-2022",
          "day": "Thursday",
          "imsak": "05:50:00",
          "fajr": "06:00:00",
          "syuruk": "07:07:00",
          "dhuhr": "13:16:00",
          "asr": "16:25:00",
          "maghrib": "19:21:00",
          "isha": "20:30:00"
		    }
    ''';
    var parsed = PrayerTime.fromJson(jsonDecode(apiResponse));
    expect(parsed.hijri.day, 4);
    expect(parsed.asr, DateTime(2022, 9, 1, 16, 25));
  });
}
