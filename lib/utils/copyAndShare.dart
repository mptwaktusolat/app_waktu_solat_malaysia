import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

import '../CONSTANTS.dart' as constants;
import '../locationUtil/locationDatabase.dart';
import 'temp_prayer_data.dart';

class CopyAndShare {
  static const int _padLength = 8;
  static String getMessage(BuildContext context, {int type = 1}) {
    var _localization = AppLocalizations.of(context);
    var _hijriToday = HijriCalendar.fromDate(DateTime.now()
            .add(Duration(days: GetStorage().read(constants.kHijriOffset))))
        .toFormat('dd MMMM yyyy');
    var _date = DateFormat('EEEE, d MMMM yyyy', _localization!.localeName)
        .format(DateTime.now());
    var _currentLocation =
        GetStorage().read(constants.kStoredLocationJakimCode);
    var _daerah = LocationDatabase.daerah(_currentLocation);
    var _negeri = LocationDatabase.negeri(_currentLocation);
    var _times = TempPrayerTimeData.allPrayerTime();
    switch (type) {
      case 1:
        String message = _localization.shareTitle;
        message += '\n\n';
        message += '🌺 $_date\n';
        message += '📍 $_daerah ($_negeri)\n';
        message += '📆 ${_hijriToday}H\n';
        message += '\n';
        message += '☁ ${_localization.fajrName}: ${_times[0]}\n';
        message += '🌞 ${_localization.dhuhrName}: ${_times[1]}\n';
        message += '☀ ${_localization.asrName}: ${_times[2]}\n';
        message += '🌙 ${_localization.maghribName}: ${_times[3]}\n';
        message += '⭐ ${_localization.ishaName}: ${_times[4]}\n';
        message += '\n';
        message += _localization.shareGetApp(constants.kMptFdlGetLink);

        return message;
      case 2:
        String message = _localization.shareTitle;
        message += '\n\n';
        message += '🌺 *$_date*\n';
        message += '📍 _$_daerah *($_negeri)*_\n';
        message += '📆 ${_hijriToday}H\n';
        message += '\n';
        message +=
            '```☁ ${_localization.fajrName.padRight(_padLength)}: ${_times[0]}```\n';
        message +=
            '```🌞 ${_localization.dhuhrName.padRight(_padLength)}: ${_times[1]}```\n';
        message +=
            '```☀ ${_localization.asrName.padRight(_padLength)}: ${_times[2]}```\n';
        message +=
            '```🌙 ${_localization.maghribName.padRight(_padLength)}: ${_times[3]}```\n';
        message +=
            '```⭐ ${_localization.ishaName.padRight(_padLength)}: ${_times[4]}```\n';
        message += '\n';
        message += _localization.shareGetApp(constants.kMptFdlGetLink);

        return message;
      default:
        return '';
    }
  }
}
