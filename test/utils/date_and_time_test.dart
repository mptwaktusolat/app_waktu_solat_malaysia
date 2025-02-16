import 'package:flutter_test/flutter_test.dart';
import 'package:waktusolatmalaysia/shared/extensions/date_time_extensions.dart';
import 'package:waktusolatmalaysia/shared/utils/date_time_utils.dart';

void main() {
  test('Format to readable time from DateTime', () {
    final dateTime = DateTime(2021, 7, 1, 12, 30);
    // test 12 hour format
    var readableTime = dateTime.readable(true);
    expect(readableTime, '12:30 PM');
    // test 24 hour format
    readableTime = dateTime.readable(false);
    expect(readableTime, '12:30');
  });

  test('Calculate one third of the night', () {
    final maghrib = DateTime(2022, 9, 21, 19, 26); // today's maghrib
    final subuh = DateTime(2022, 9, 21, 5, 53); // tomorrow's subh
    final oneThird = DateTimeUtil.nightOneThird(maghrib, subuh);
    expect(oneThird, DateTime(2022, 9, 21, 2, 24));
  });
}
