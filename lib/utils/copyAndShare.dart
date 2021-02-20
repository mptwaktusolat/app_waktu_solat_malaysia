import 'package:get_storage/get_storage.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

import '../CONSTANTS.dart' as Constants;
import 'cachedPrayerData.dart';
import 'location/locationDatabase.dart';

class CopyAndShare {
  static String getMessage({int type = 1}) {
    var hijriToday = HijriCalendar.now().toFormat('dd MMMM yyyy');
    var dayFormat = DateFormat('EEEE').format(DateTime.now());
    var dateFormat = DateFormat('dd MMMM yyyy').format(DateTime.now());
    var _globalIndex = GetStorage().read(Constants.kStoredGlobalIndex);
    LocationDatabase _locationDatabase = LocationDatabase();
    var daerah = _locationDatabase.getDaerah(_globalIndex);
    var negeri = _locationDatabase.getNegeri(_globalIndex);
    switch (type) {
      case 1:
        return '''
Solat timetable today

📍 $daerah ($negeri)
📆 $dayFormat, $dateFormat
📆 ${hijriToday}H

☁ Subuh: ${CachedPrayerTimeData.allPrayerTime()[0]}
🌞 Zohor: ${CachedPrayerTimeData.allPrayerTime()[1]}
☀ Asar: ${CachedPrayerTimeData.allPrayerTime()[2]}
🌙 Maghrib: ${CachedPrayerTimeData.allPrayerTime()[3]}
⭐ Isyak: ${CachedPrayerTimeData.allPrayerTime()[4]}

Get the app: ${Constants.kPlayStoreListingShortLink}
                ''';
        break;
      case 2:
        return '''
*Solat timetable today*

📍 _$daerah ($negeri)_
📆 $dayFormat, *$dateFormat*
📆 ${hijriToday}H

```☁ Subuh: ${CachedPrayerTimeData.allPrayerTime()[0]}```
```🌞 Zohor: ${CachedPrayerTimeData.allPrayerTime()[1]}```
```☀ Asar: ${CachedPrayerTimeData.allPrayerTime()[2]}```
```🌙 Maghrib: ${CachedPrayerTimeData.allPrayerTime()[3]}```
```⭐ Isyak: ${CachedPrayerTimeData.allPrayerTime()[4]}```

Get the app: ${Constants.kPlayStoreListingShortLink}
                ''';
        break;
      default:
        return '';
    }
  }
}
