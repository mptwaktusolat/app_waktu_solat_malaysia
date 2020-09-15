import 'package:get_storage/get_storage.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:waktusolatmalaysia/CONSTANTS.dart' as Constants;

import 'cachedPrayerData.dart';

class CopyAndShare {
  String message;
  var hijriToday = HijriCalendar.now().toFormat('dd MMMM yyyy');
  var dayFormat = DateFormat('EEEE').format(DateTime.now());
  var dateFormat = DateFormat('dd MMMM yyyy').format(DateTime.now());

  void updateMessage() {
    message = '''
Solat timetable today 
📍 ${GetStorage().read(Constants.kStoredKawasanKey)} (${GetStorage().read(Constants.kStoredNegeriKey)})
📆 $dayFormat, $dateFormat
📆 ${hijriToday}H

  ☁ Subuh: ${CachedPrayerTimeData.allPrayerTime()[0]}
  🌞 Zohor: ${CachedPrayerTimeData.allPrayerTime()[1]}
  ☀ Asr: ${CachedPrayerTimeData.allPrayerTime()[2]}
  🌙 Maghrib: ${CachedPrayerTimeData.allPrayerTime()[3]}
  ⭐ Isya': ${CachedPrayerTimeData.allPrayerTime()[4]}

Download app on Android: ${Constants.kPlayStoreListingShortLink}''';
    print(message);
  }

  String getMessage() {
    return message;
  }
}
