import 'package:intl/intl.dart';

import '../utils/hijri_date.dart';

/// MPT-Server's V2 API Model
class MptServerSolat {
  late String zone;
  late int year;
  late String month;
  late int monthNumber;
  String? lastUpdated;
  late List<Prayers> prayers;

  MptServerSolat(
      {required this.zone,
      required this.year,
      required this.month,
      this.lastUpdated,
      required this.prayers});

  MptServerSolat.fromJson(Map<String, dynamic> json) {
    zone = json['zone'];
    year = json['year'];
    month = json['month'];
    // capitalize first letter only of month
    final monthName = month[0].toUpperCase() + month.substring(1).toLowerCase();
    monthNumber = DateFormat('MMM').parse(monthName).month;
    // monthNumber = DateTime.parse('2021-$month-01').month;
    lastUpdated = json['last_updated'];
    if (json['prayers'] != null) {
      prayers = <Prayers>[];
      json['prayers'].forEach((v) {
        prayers.add(Prayers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['zone'] = zone;
    data['year'] = year;
    data['month'] = month;
    data['last_updated'] = lastUpdated;
    data['prayers'] = prayers.map((v) => v.toJson()).toList();
    return data;
  }
}

class Prayers {
  late DateTime day;
  late HijriDate hijri;
  late DateTime imsak;
  late DateTime fajr;
  late DateTime syuruk;
  late DateTime dhuha;
  late DateTime dhuhr;
  late DateTime asr;
  late DateTime maghrib;
  late DateTime isha;

  Prayers({
    required this.day,
    required this.hijri,
    required this.imsak,
    required this.isha,
    required this.syuruk,
    required this.dhuhr,
    required this.maghrib,
    required this.fajr,
    required this.asr,
  });

  Prayers.fromJson(Map<String, dynamic> json) {
    hijri = HijriDate.parse(json['hijri']);

    fajr = DateTime.fromMillisecondsSinceEpoch(json['fajr'] * 1000);
    imsak = fajr.subtract(const Duration(minutes: 10));
    syuruk = DateTime.fromMillisecondsSinceEpoch(json['syuruk'] * 1000);
    dhuha = syuruk.add(const Duration(minutes: 28));
    dhuhr = DateTime.fromMillisecondsSinceEpoch(json['dhuhr'] * 1000);
    asr = DateTime.fromMillisecondsSinceEpoch(json['asr'] * 1000);
    maghrib = DateTime.fromMillisecondsSinceEpoch(json['maghrib'] * 1000);
    isha = DateTime.fromMillisecondsSinceEpoch(json['isha'] * 1000);

    day = fajr;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isha'] = isha.millisecondsSinceEpoch;
    data['syuruk'] = syuruk.millisecondsSinceEpoch;
    data['day'] = day.millisecondsSinceEpoch;
    data['dhuhr'] = dhuhr.millisecondsSinceEpoch;
    data['maghrib'] = maghrib.millisecondsSinceEpoch;
    data['fajr'] = fajr.millisecondsSinceEpoch;
    data['asr'] = asr.millisecondsSinceEpoch;
    data['hijri'] = hijri.toString();
    return data;
  }
}
