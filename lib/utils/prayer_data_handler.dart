import '../models/mpt_server_solat.dart';
import '../networking/mpt_fetch_api.dart';

final int _day = DateTime.now().day;

class PrayDataHandler {
  static MptServerSolat? _mptServerSolat;

  /// This function must be called everytime the zone is changed
  /// Returns the hijri date
  static Future<String> init(String zone) async {
    _mptServerSolat = await MptApiFetch.fetchMpt(zone);
    return today().hijri.toString();
  }

  // Return all data for a montth
  static List<Prayers> month() {
    return _mptServerSolat!.prayers;
  }

  static Prayers today() {
    return _mptServerSolat!.prayers[_day - 1];
  }

  /// remove past date for notification scheduling
  static List<Prayers> notificationTimes() =>
      _mptServerSolat!.prayers.sublist(_day - 1);
}
