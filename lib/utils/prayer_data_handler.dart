import 'package:get_storage/get_storage.dart';
import 'package:waktusolat_api_client/waktusolat_api_client.dart';

import '../constants.dart';
import '../location_utils/location_database.dart';
import '../networking/mpt_fetch_api.dart';
import 'homescreen.dart';

final int _day = DateTime.now().day;

class PrayDataHandler {
  static MPTWaktuSolatV2? _mptServerSolat;

  /// This function must be called everytime the zone is changed
  /// Returns the hijri date
  static Future<String> init(String zone) async {
    _mptServerSolat = await MptApiFetch.fetchMpt(zone);

    // Alang2 init, we save the data to widget
    var widgetLocation = GetStorage().read(kWidgetLocation);
    if (widgetLocation == null || widgetLocation.isEmpty) {
      widgetLocation = LocationDatabase.daerah(zone);
    }
    Homescreen.savePrayerDataAndUpdateWidget(_mptServerSolat!, widgetLocation!);

    return today().hijri.toString();
  }

  // Return all data for a montth
  static List<MptPrayer> month() {
    return _mptServerSolat!.prayers;
  }

  static MptPrayer today() {
    return _mptServerSolat!.prayers[_day - 1];
  }

  /// remove past date for notification scheduling
  static List<MptPrayer> notificationTimes() =>
      _mptServerSolat!.prayers.sublist(_day - 1);
}
