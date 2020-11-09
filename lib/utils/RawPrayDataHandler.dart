import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:waktusolatmalaysia/utils/DateAndTime.dart';

final int day = int.parse(DateFormat('d').format(DateTime.now()));
var prayDataList;
var todayPrayData;

class PrayDataHandler {
  PrayDataHandler(String dataStream) {
    prayDataList = jsonDecode(dataStream);
    todayPrayData = prayDataList[day - 1];
  }

  List<dynamic> getTodayPrayData() {
    return todayPrayData;
  }
}
