//Convert a json array to List object

import 'dart:convert';

import 'package:intl/intl.dart';

final int day = int.parse(DateFormat('d').format(DateTime.now()));
var prayDataList;
var todayPrayData;
var prayDataCurrentDateOnwards = [];

class PrayDataHandler {
  PrayDataHandler(String dataStream) {
    prayDataList = jsonDecode(dataStream);
    todayPrayData = prayDataList[day - 1];
  }

  List<dynamic> getPrayDataList() => prayDataList;

  List<dynamic> getPrayDataCurrentDateOnwards() {
    prayDataCurrentDateOnwards.clear();
    for (int i = 0; i < prayDataList.length; i++) {
      if (!(i < day - 1)) {
        print('day is ${i + 1} : ${prayDataList[i]}');
        prayDataCurrentDateOnwards.add(prayDataList[i]);
      }
    }

    return prayDataCurrentDateOnwards;
  }

  List<dynamic> getTodayPrayData() {
    return todayPrayData;
  }
}
