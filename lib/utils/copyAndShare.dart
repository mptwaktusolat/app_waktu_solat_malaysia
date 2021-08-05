import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../CONSTANTS.dart' as Constants;
import 'cachedPrayerData.dart';
import 'location/locationDatabase.dart';

class CopyAndShare {
  static String getMessage({int type = 1}) {
    var dayFormat = DateFormat('EEEE').format(DateTime.now()).toUpperCase();
    var dateFormat = DateFormat('dd MMMM yyyy').format(DateTime.now());
    var _globalIndex = GetStorage().read(Constants.kStoredGlobalIndex);
    var daerah = LocationDatabase.getDaerah(_globalIndex);
    var negeri = LocationDatabase.getNegeri(_globalIndex);
    switch (type) {
      case 1:
        return '''
Solat timetable: $dayFormat, $dateFormat

📍 $daerah ($negeri)

☁ Subuh: ${CachedPrayerTimeData.allPrayerTime()[0]}
🌞 Zohor: ${CachedPrayerTimeData.allPrayerTime()[1]}
☀ Asar: ${CachedPrayerTimeData.allPrayerTime()[2]}
🌙 Maghrib: ${CachedPrayerTimeData.allPrayerTime()[3]}
⭐ Isyak: ${CachedPrayerTimeData.allPrayerTime()[4]}

Visit: waktusolat.web.app''';
        break;
      case 2:
        return '''
*Solat timetable: $dayFormat, $dateFormat*

📍 _$daerah *($negeri)*_

```☁ Subuh   : ${CachedPrayerTimeData.allPrayerTime()[0]}```
```🌞 Zohor   : ${CachedPrayerTimeData.allPrayerTime()[1]}```
```☀ Asar    : ${CachedPrayerTimeData.allPrayerTime()[2]}```
```🌙 Maghrib : ${CachedPrayerTimeData.allPrayerTime()[3]}```
```⭐ Isyak   : ${CachedPrayerTimeData.allPrayerTime()[4]}```

Visit: *waktusolat.web.app*''';
        break;
      default:
        return '';
    }
  }
}
