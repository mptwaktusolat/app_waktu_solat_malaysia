import 'package:flutter/material.dart';
import 'package:waktusolat_api_client/waktusolat_api_client.dart';

import '../services/prayer_time_service.dart';

/// Provider that manages prayer time state and business logic.
class PrayerTimeProvider with ChangeNotifier {
  final PrayerTimeService _service = PrayerTimeService();

  bool _isLoading = false;
  String? _errorMessage;
  String? _hijriDate;
  String? _currentZone;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get hijriDate => _hijriDate;
  bool get hasData => _service.hasData;
  String? get currentZone => _currentZone;

  /// Loads prayer time data for the specified zone
  Future<void> loadPrayerTimes(String zone) async {
    // Don't reload if already loading the same zone
    if (_isLoading && _currentZone == zone) return;

    // Don't reload if we already have data for this zone
    if (_currentZone == zone && _service.hasData) return;

    _currentZone = zone;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.loadPrayerTimeData(zone);
      _hijriDate = _service.getTodayPrayer().hijri.toString();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _hijriDate = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Gets today's prayer times
  MptPrayer? getTodayPrayer() {
    if (!_service.hasData) return null;
    try {
      return _service.getTodayPrayer();
    } catch (e) {
      return null;
    }
  }

  /// Gets all prayer times for the month
  List<MptPrayer>? getMonthPrayers() {
    if (!_service.hasData) return null;
    try {
      return _service.getMonthPrayers();
    } catch (e) {
      return null;
    }
  }

  /// Gets prayer times for notification scheduling (from today onwards)
  List<MptPrayer>? getPrayersForNotification() {
    if (!_service.hasData) return null;
    try {
      return _service.getPrayersForNotification();
    } catch (e) {
      return null;
    }
  }

  /// Reloads prayer data (useful when zone changes)
  Future<void> refresh(String zone) async {
    _service.clearData();
    await loadPrayerTimes(zone);
  }
}
