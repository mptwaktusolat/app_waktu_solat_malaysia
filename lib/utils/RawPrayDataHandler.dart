//Convert a json array to List object

import 'package:intl/intl.dart';
import 'package:waktusolatmalaysia/models/jakim_prayer_model.dart';
import 'package:waktusolatmalaysia/utils/DateAndTime.dart';
import 'package:waktusolatmalaysia/utils/prayer_time_model.dart';

final int day = int.parse(DateFormat('d').format(DateTime.now()));
CustomPrayerTimeModel todayPrayData;
List<CustomPrayerTimeModel> prayDataCurrentDateOnwards = [];
List<CustomPrayerTimeModel> customPrayerTime = [];

class PrayDataHandler {
  PrayDataHandler(List<PrayerTime> _prayerTime) {
    customPrayerTime.clear();

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
    todayPrayData = customPrayerTime[day - 1]; // match day with list index
  }

  List<dynamic> getPrayDataList() => customPrayerTime;

  List<CustomPrayerTimeModel> getPrayDataCurrentDateOnwards() {
    prayDataCurrentDateOnwards.clear();
    print('total day is ${customPrayerTime.length}');
    for (int i = 0; i < customPrayerTime.length; i++) {
      if (!(i < day - 1)) {
        prayDataCurrentDateOnwards.add(customPrayerTime[i]);
      }
    }

    return prayDataCurrentDateOnwards;
  }

  CustomPrayerTimeModel getTodayPrayData() {
    return todayPrayData;
  }
}
