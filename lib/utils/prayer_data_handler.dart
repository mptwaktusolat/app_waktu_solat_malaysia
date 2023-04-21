import '../models/jakim_esolat_model.dart';
import '../networking/mpt_fetch_api.dart';

final int _day = DateTime.now().day;

class PrayDataHandler {
  static JakimEsolatModel? _esolatModel;

  /// This function must be called everytime the zone is changed
  /// Returns the hijri date
  static Future<String> init(String zone) async {
    _esolatModel = await MptApiFetch.fetchMpt(zone);
    return today().hijri.toString();
  }

  // Return all data for a montth
  static List<PrayerTime> month() {
    return _esolatModel!.prayerTime!;
  }

  static PrayerTime today() {
    return _esolatModel!.prayerTime![_day - 1];
  }

  /// remove past date for notification scheduling
  static List<PrayerTime> notificationTimes() =>
      _esolatModel!.prayerTime!.sublist(_day - 1);
}
