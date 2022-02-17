import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../CONSTANTS.dart' as constants;
import '../locationUtil/locationDatabase.dart';
import '../providers/settingsProvider.dart';
import 'prayer_data_handler.dart';

class CopyAndShare {
  static const int _padLength = 8;

  static String getMessage(BuildContext context, {int type = 1}) {
    var _localization = AppLocalizations.of(context);
    var _date = DateFormat('EEEE, d MMMM yyyy', _localization!.localeName)
        .format(DateTime.now());
    var _currentLocation =
        GetStorage().read(constants.kStoredLocationJakimCode);
    var _daerah = LocationDatabase.daerah(_currentLocation);
    var _negeri = LocationDatabase.negeri(_currentLocation);
    var _times = PrayDataHandler.todayReadable(
        Provider.of<SettingProvider>(context, listen: false).use12hour!);
    var _hijriToday = PrayDataHandler.todayEpoch().hijri;
    switch (type) {
      case 1:
        String message = _localization.shareTitle;
        message += '\n\n';
        message += '🌺 $_date\n';
        message += '📍 $_daerah ($_negeri)\n';
        message += '📆 ${_hijriToday}H\n';
        message += '\n';
        message += '☁ ${_localization.fajrName}: ${_times[1]}\n';
        message += '🌞 ${_localization.dhuhrName}: ${_times[4]}\n';
        message += '☀ ${_localization.asrName}: ${_times[5]}\n';
        message += '🌙 ${_localization.maghribName}: ${_times[6]}\n';
        message += '⭐ ${_localization.ishaName}: ${_times[7]}\n';
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
            '```☁ ${_localization.fajrName.padRight(_padLength)}: ${_times[1]}```\n';
        message +=
            '```🌞 ${_localization.dhuhrName.padRight(_padLength)}: ${_times[4]}```\n';
        message +=
            '```☀ ${_localization.asrName.padRight(_padLength)}: ${_times[5]}```\n';
        message +=
            '```🌙 ${_localization.maghribName.padRight(_padLength)}: ${_times[6]}```\n';
        message +=
            '```⭐ ${_localization.ishaName.padRight(_padLength)}: ${_times[7]}```\n';
        message += '\n';
        message += _localization.shareGetApp(constants.kMptFdlGetLink);

        return message;
      default:
        return '';
    }
  }
}
