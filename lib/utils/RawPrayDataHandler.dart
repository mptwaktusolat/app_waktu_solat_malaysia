import 'package:waktusolatmalaysia/models/jakim_esolat_model.dart';

final int day = DateTime.now().day;

class PrayDataHandler {
  /// return prayer times for today and the future, past days are removed
  static List<PrayerTime> removePastDate(List<PrayerTime> times) =>
      times.sublist(day - 1);

  static List<int>? todayPrayData(List<PrayerTime> times) =>
      times[day - 1].times;
}
