import 'package:get_storage/get_storage.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import '../CONSTANTS.dart' as constants;
import '../locationUtil/locationDatabase.dart';
import 'temp_prayer_data.dart';

class CopyAndShare {
  static String getMessage({int type = 1}) {
    var hijriToday = HijriCalendar.fromDate(DateTime.now()
            .add(Duration(days: GetStorage().read(constants.kHijriOffset))))
        .toFormat('dd MMMM yyyy');
    var _dayFormat = DateFormat('EEEE').format(DateTime.now()).toUpperCase();
    var _dateFormat = DateFormat('dd MMMM yyyy').format(DateTime.now());
    var _globalIndex = GetStorage().read(constants.kStoredGlobalIndex);
    var daerah = LocationDatabase.getDaerah(_globalIndex);
    var negeri = LocationDatabase.getNegeri(_globalIndex);
    switch (type) {
      case 1:
        return '''
Solat timetable: $_dayFormat, $_dateFormat

📍 $daerah ($negeri)
📆 ${hijriToday}H

☁ Subuh: ${TempPrayerTimeData.allPrayerTime()[0]}
🌞 Zohor: ${TempPrayerTimeData.allPrayerTime()[1]}
☀ Asar: ${TempPrayerTimeData.allPrayerTime()[2]}
🌙 Maghrib: ${TempPrayerTimeData.allPrayerTime()[3]}
⭐ Isyak: ${TempPrayerTimeData.allPrayerTime()[4]}

Get the app: ${constants.kMptFdlGetLink}''';
      case 2:
        return '''
*Solat timetable: $_dayFormat, $_dateFormat*

📍 _$daerah *($negeri)*_
📆 ${hijriToday}H

```☁ Subuh   : ${TempPrayerTimeData.allPrayerTime()[0]}```
```🌞 Zohor   : ${TempPrayerTimeData.allPrayerTime()[1]}```
```☀ Asar    : ${TempPrayerTimeData.allPrayerTime()[2]}```
```🌙 Maghrib : ${TempPrayerTimeData.allPrayerTime()[3]}```
```⭐ Isyak   : ${TempPrayerTimeData.allPrayerTime()[4]}```

Get the app: ${constants.kMptFdlGetLink}''';
      default:
        return '';
    }
  }
}
