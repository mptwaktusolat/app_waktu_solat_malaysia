import '../models/jakim_esolat_model.dart';
import '../networking/mpt_fetch_api.dart';
import 'date_and_time.dart';

final int _day = DateTime.now().day;

class PrayDataHandler {
  static JakimEsolatModel? _esolatModel;

  /// This function must be called everytime the zone is changed
  static Future<String> init(String zone) async {
    _esolatModel = await MptApiFetch.fetchMpt(zone);
    return todayEpoch().hijri!.toString();
  }

  // Return all data for a montth
  static List<PrayerTime> monthEpoch() {
    return _esolatModel!.prayerTime!;
  }

  /// Return today prayer times data
  static PrayerTime todayEpoch() {
    return _esolatModel!.prayerTime![_day - 1];
  }

  static List<String> todayReadable(bool is24h) {
    return _esolatModel!.prayerTime![_day - 1].times!
        .map((time) => DateAndTime.toTimeReadable(time, is24h))
        .toList();
  }

  /// remove past date for notification scheduling
  static List<PrayerTime> notificationTimes() =>
      _esolatModel!.prayerTime!.sublist(_day - 1);
}
