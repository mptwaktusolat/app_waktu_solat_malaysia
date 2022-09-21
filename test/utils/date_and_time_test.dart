import 'package:flutter_test/flutter_test.dart';
import 'package:waktusolatmalaysia/utils/date_and_time.dart';

void main() {
  test('Format to readable time from DateTime', () {
    var dateTime = DateTime(2021, 7, 1, 12, 30);
    // test 12 hour format
    var readableTime = dateTime.format(true);
    expect(readableTime, '12:30 PM');
    // test 24 hour format
    readableTime = dateTime.format(false);
    expect(readableTime, '12:30');
  });

  test('Calculate one third of the night', () {
    var maghrib = DateTime(2022, 9, 21, 19, 26); // today's maghrib
    var subuh = DateTime(2022, 9, 21, 5, 53); // tomorrow's subh
    var oneThird = DateAndTime.nightOneThird(maghrib, subuh);
    expect(oneThird, DateTime(2022, 9, 21, 2, 24));
  });
}
