import 'package:get_storage/get_storage.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:waktusolatmalaysia/CONSTANTS.dart' as Constants;
import 'package:waktusolatmalaysia/utils/location/locationDatabase.dart';

import 'cachedPrayerData.dart';

class CopyAndShare {
  LocationDatabase _locationDatabase = LocationDatabase();
  String message;
  var hijriToday = HijriCalendar.now().toFormat('dd MMMM yyyy');
  var dayFormat = DateFormat('EEEE').format(DateTime.now());
  var dateFormat = DateFormat('dd MMMM yyyy').format(DateTime.now());
  var _globalIndex = GetStorage().read(Constants.kStoredGlobalIndex);

  void updateMessage() {
    var daerah = _locationDatabase.getDaerah(_globalIndex);
    var negeri = _locationDatabase.getNegeri(_globalIndex);
    message = '''
Solat timetable today

📍 $daerah ($negeri)
📆 $dayFormat, $dateFormat
📆 ${hijriToday}H

  ☁ Subuh: ${CachedPrayerTimeData.allPrayerTime()[0]}
  🌞 Zohor: ${CachedPrayerTimeData.allPrayerTime()[1]}
  ☀ Asr: ${CachedPrayerTimeData.allPrayerTime()[2]}
  🌙 Maghrib: ${CachedPrayerTimeData.allPrayerTime()[3]}
  ⭐ Isya': ${CachedPrayerTimeData.allPrayerTime()[4]}

Get the app: ${Constants.kPlayStoreListingShortLink}''';

    // print('share and copy message is $message');
  }

  String getMessage() {
    return message;
  }
}
