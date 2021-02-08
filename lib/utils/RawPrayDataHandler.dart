//Convert a json array to List object

import 'package:intl/intl.dart';
import 'package:waktusolatmalaysia/models/jakim_prayer_model.dart';
import 'package:waktusolatmalaysia/utils/DateAndTime.dart';
import 'package:waktusolatmalaysia/utils/prayer_time_model.dart';

final int day = int.parse(DateFormat('d').format(DateTime.now()));
var prayDataList;
CustomPrayerTimeModel todayPrayData;
var prayDataCurrentDateOnwards = [];
List<CustomPrayerTimeModel> customPrayerTime = [];

class PrayDataHandler {
  PrayDataHandler(List<PrayerTime> _prayerTime) {
    /// Map data from api to timestamp
    for (int i = 0; i < _prayerTime.length; i++) {
      var time = _prayerTime[i];
      customPrayerTime.add(CustomPrayerTimeModel(
        imsak: DateAndTime.convertToEpoch(date: time.date, time: time.imsak),
        subuh: DateAndTime.convertToEpoch(date: time.date, time: time.fajr),
        syuruk: DateAndTime.convertToEpoch(date: time.date, time: time.syuruk),
        dhuha: DateAndTime.convertToEpoch(
            date: time.date, time: time.syuruk, offset: Duration(minutes: 28)),
        zohor: DateAndTime.convertToEpoch(date: time.date, time: time.dhuhr),
        asar: DateAndTime.convertToEpoch(date: time.date, time: time.asr),
        maghrib:
            DateAndTime.convertToEpoch(date: time.date, time: time.maghrib),
        isyak: DateAndTime.convertToEpoch(date: time.date, time: time.isha),
      ));
    }
    todayPrayData = customPrayerTime[day - 1];
  }

  List<dynamic> getPrayDataList() => prayDataList;

  List<dynamic> getPrayDataCurrentDateOnwards() {
    prayDataCurrentDateOnwards.clear();
    for (int i = 0; i < prayDataList.length; i++) {
      //TODO: Check for notification functionality
      if (!(i < day - 1)) {
        print('day is ${i + 1} : ${prayDataList[i]}');
        prayDataCurrentDateOnwards.add(prayDataList[i]);
      }
    }

    return prayDataCurrentDateOnwards;
  }

  CustomPrayerTimeModel getTodayPrayData() {
    return todayPrayData;
  }
}
