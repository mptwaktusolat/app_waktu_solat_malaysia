import 'package:get_storage/get_storage.dart';
import 'package:waktusolat_api_client/waktusolat_api_client.dart';

import '../../../shared/constants/constants.dart';
import '../../../location_utils/location_database.dart';
import '../../../networking/mpt_fetch_api.dart';
import '../../../shared/utils/homescreen.dart';

/// Service class responsible for fetching and managing prayer time data.
class PrayerTimeService {
  MPTWaktuSolatV2? _prayerData;
  final int _currentDay = DateTime.now().day;

  /// Fetches prayer time data for the given zone.
  /// This also updates the widget data with the latest prayer times.
  ///
  /// Returns the full [MPTWaktuSolatV2] model containing all prayer data for the month.
  Future<MPTWaktuSolatV2> loadPrayerTimeData(String zone) async {
    _prayerData = await MptApiFetch.fetchMpt(zone);

    // Update widget data after fetching
    await _updateWidgetData(zone);

    return _prayerData!;
  }

  /// Updates the home screen widget with current prayer time data
  Future<void> _updateWidgetData(String zone) async {
    if (_prayerData == null) return;

    var widgetLocation = GetStorage().read(kWidgetLocation);
    if (widgetLocation == null || widgetLocation.isEmpty) {
      widgetLocation = LocationDatabase.daerah(zone);
    }
    await Homescreen.savePrayerDataAndUpdateWidget(
        _prayerData!, widgetLocation!);
  }

  /// Returns prayer data for today only.
  /// Throws [StateError] if prayer data hasn't been loaded yet.
  MptPrayer getTodayPrayer() {
    if (_prayerData == null) {
      throw StateError(
          'Prayer data not loaded. Call loadPrayerTimeData first.');
    }
    return _prayerData!.prayers[_currentDay - 1];
  }

  /// Returns all prayer times for the current month.
  /// Throws [StateError] if prayer data hasn't been loaded yet.
  List<MptPrayer> getMonthPrayers() {
    if (_prayerData == null) {
      throw StateError(
          'Prayer data not loaded. Call loadPrayerTimeData first.');
    }
    return _prayerData!.prayers;
  }

  /// Returns prayer times from today onwards (used for notification scheduling).
  /// This removes past dates to avoid scheduling notifications for times that have passed.
  /// Throws [StateError] if prayer data hasn't been loaded yet.
  List<MptPrayer> getPrayersForNotification() {
    if (_prayerData == null) {
      throw StateError(
          'Prayer data not loaded. Call loadPrayerTimeData first.');
    }
    return _prayerData!.prayers.sublist(_currentDay - 1);
  }

  /// Checks if prayer data has been loaded
  bool get hasData => _prayerData != null;

  /// Gets the current prayer data (may be null if not loaded yet)
  MPTWaktuSolatV2? get currentData => _prayerData;

  /// Clears the cached prayer data
  void clearData() {
    _prayerData = null;
  }
}
