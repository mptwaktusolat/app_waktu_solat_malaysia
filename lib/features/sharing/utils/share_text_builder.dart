import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:waktusolat_api_client/waktusolat_api_client.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/constants/constants.dart';
import '../../../shared/constants/env.dart';
import '../../../shared/extensions/date_time_extensions.dart';
import '../../../shared/services/location_service/location_database.dart';

/// Defines different targets for sharing prayer times.
enum ShareTarget {
  /// Share using the system share sheet
  universal,

  /// Copy to clipboard
  copy,

  /// Share directly to WhatsApp
  whatsapp,

  /// Share as an image
  image
}

/// Builder for generating formatted text for prayer time sharing.
///
/// This class creates properly formatted strings for different sharing targets
/// such as plain text, WhatsApp, etc. with appropriate formatting and emojis.
class ShareTextBuilder {
  /// Instance of [AppLocalizations] for localized strings.
  final AppLocalizations _appLocalizations;

  /// Whether to use 12-hour format (true) or 24-hour format (false).
  final bool _use12hourFormat;

  /// Formatted date string for the current date.
  final String _date;

  /// Current district name.
  final String _daerah;

  /// Current state name.
  final String _negeri;

  /// Prayer times for the current day.
  final MptPrayer _times;

  /// Padding length used for aligning text in WhatsApp format.
  final int _padLength = 8;

  /// Creates a new instance of [ShareTextBuilder].
  ///
  /// [_appLocalizations] provides localized strings.
  /// [times] is the prayer times data for today
  /// [use12hourFormat] determines if times should be displayed in 12-hour format.
  ShareTextBuilder(
    this._appLocalizations,
    this._times, {
    bool use12hourFormat = false,
  })  : _use12hourFormat = use12hourFormat,
        _date = DateFormat('EEEE, d MMMM yyyy', _appLocalizations.localeName)
            .format(DateTime.now()),
        _daerah = LocationDatabase.daerah(
            GetStorage().read(kStoredLocationJakimCode)),
        _negeri = LocationDatabase.negeri(
            GetStorage().read(kStoredLocationJakimCode));

  /// Formats prayer time text for sharing as plain text.
  ///
  /// Returns a string with prayer times formatted for general sharing.
  String formatPlainText() {
    final StringBuffer message = StringBuffer();
    message.write(_appLocalizations.shareTitle);
    message.writeln();
    message.writeln();
    message.writeln('🌺 $_date');
    message.writeln('📍 $_daerah ($_negeri)');
    message.writeln('📆 ${_times.hijri}H');
    message.writeln();
    message.writeln(
        '☁ ${_appLocalizations.fajrName}: ${_times.fajr.readable(_use12hourFormat)}');
    message.writeln(
        '🌞 ${_appLocalizations.dhuhrName}: ${_times.dhuhr.readable(_use12hourFormat)}');
    message.writeln(
        '☀ ${_appLocalizations.asrName}: ${_times.asr.readable(_use12hourFormat)}');
    message.writeln(
        '🌙 ${_appLocalizations.maghribName}: ${_times.maghrib.readable(_use12hourFormat)}');
    message.writeln(
        '⭐ ${_appLocalizations.ishaName}: ${_times.isha.readable(_use12hourFormat)}');
    message.writeln();
    message.write(_appLocalizations.shareGetApp(envAppWebsite));
    return message.toString();
  }

  /// Formats prayer time text specifically for WhatsApp sharing.
  ///
  /// Returns a string with prayer times formatted with WhatsApp markdown styling.
  String formatWhatsApp() {
    final StringBuffer message = StringBuffer();
    message.write(_appLocalizations.shareTitle);
    message.writeln();
    message.writeln();
    message.writeln('🌺 *$_date*');
    message.writeln('📍 _$_daerah *($_negeri)*_');
    message.writeln('📆 ${_times.hijri}H');
    message.writeln();
    message.writeln(
        '```☁ ${_appLocalizations.fajrName.padRight(_padLength)}: ${_times.fajr.readable(_use12hourFormat)}```');
    message.writeln(
        '```🌞 ${_appLocalizations.dhuhrName.padRight(_padLength)}: ${_times.dhuhr.readable(_use12hourFormat)}```');
    message.writeln(
        '```☀ ${_appLocalizations.asrName.padRight(_padLength)}: ${_times.asr.readable(_use12hourFormat)}```');
    message.writeln(
        '```🌙 ${_appLocalizations.maghribName.padRight(_padLength)}: ${_times.maghrib.readable(_use12hourFormat)}```');
    message.writeln(
        '```⭐ ${_appLocalizations.ishaName.padRight(_padLength)}: ${_times.isha.readable(_use12hourFormat)}```');
    message.writeln();
    message.write(_appLocalizations.shareGetApp(envAppWebsite));

    return message.toString();
  }
}
