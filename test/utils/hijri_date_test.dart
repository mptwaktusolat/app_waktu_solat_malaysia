import 'package:flutter_test/flutter_test.dart';
import 'package:waktusolatmalaysia/utils/hijri_date.dart';

void main() {
  test('From JAKIM API response, parse to HijriDate object', () async {
    const apiResponse = '1444-02-24';
    final res = HijriDate.parse(apiResponse);
    expect(res.day, 24);
    expect(res.month, 2);
    expect(res.year, 1444);
    expect(res.monthName, 'Safar');
    expect(res.shortMonthName, 'Saf');
  });
}
