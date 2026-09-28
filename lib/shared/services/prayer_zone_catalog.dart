import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waktusolat_api_client/waktusolat_api_client.dart';

import '../constants/constants.dart';
import '../models/prayer_zone.dart';

class PrayerZoneCatalog extends ChangeNotifier {
  PrayerZoneCatalog._() : _storage = GetStorage();

  static final PrayerZoneCatalog instance = PrayerZoneCatalog._();

  static const cacheLifetime = Duration(hours: 72); // 3 days

  final GetStorage _storage;
  List<PrayerZone> _zones = const [];
  DateTime? _lastSuccessfulFetch;
  Future<void>? _refreshInFlight;
  Object? _initialLoadError;
  bool _isInitialized = false;

  List<PrayerZone> get zones => _zones;
  bool get hasZones => _zones.isNotEmpty;
  bool get isInitialLoading => !hasZones && _refreshInFlight != null;
  bool get isBackgroundRefreshing => hasZones && _refreshInFlight != null;
  Object? get initialLoadError => _initialLoadError;

  // Load data from cache and refresh if necessary
  void initialize() {
    if (_isInitialized) return;
    _isInitialized = true;
    _loadCache();
    if (!hasZones || !_isCacheFresh()) {
      unawaited(refresh());
    }
  }

  Future<void> refresh() {
    final existing = _refreshInFlight;
    if (existing != null) return existing;

    late final Future<void> refreshFuture;
    refreshFuture = _performRefresh().whenComplete(() {
      if (identical(_refreshInFlight, refreshFuture)) {
        _refreshInFlight = null;
        notifyListeners();
      }
    });
    _refreshInFlight = refreshFuture;
    _initialLoadError = null;
    notifyListeners();

    return refreshFuture;
  }

  PrayerZone? zoneByCode(String? code) {
    final normalizedCode = _normalizeCode(code);
    if (normalizedCode.isEmpty) return null;

    for (final zone in _zones) {
      if (zone.jakimCode == normalizedCode) return zone;
    }
    return null;
  }

  String daerahForCode(String? code) => zoneByCode(code)?.daerah ?? _normalizeCode(code);

  String negeriForCode(String? code) => zoneByCode(code)?.negeri ?? _normalizeCode(code);

  void _loadCache() {
    try {
      final serializedZones = _storage.read<String>(kPrayerZoneCache);
      final timestamp = _storage.read<int>(kPrayerZoneCacheTimestamp);
      if (serializedZones == null) return;

      final decoded = jsonDecode(serializedZones) as List<Object?>;
      final parsedZones = decoded
          .map((entry) => PrayerZone.fromJson(entry as Map<String, Object?>))
          .toList(growable: false);
      final validatedZones = _validateZones(parsedZones);
      _zones = List.unmodifiable(validatedZones);

      if (timestamp != null) {
        try {
          _lastSuccessfulFetch = DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true);
        } on ArgumentError {
          _lastSuccessfulFetch = null;
        }
      }
    } catch (error) {
      debugPrint('Ignoring invalid prayer zone cache: $error');
      _zones = const [];
      _lastSuccessfulFetch = null;
    }
  }

  Future<void> _performRefresh() async {
    try {
      final response = await WaktuSolat.api.zones.getAllZones();
      final candidate = response
          .map(
            (zone) => PrayerZone(
              jakimCode: zone.jakimCode.trim().toUpperCase(),
              negeri: zone.negeri.trim(),
              daerah: zone.daerah.trim(),
            ),
          )
          .toList(growable: false);
      final validatedZones = _validateZones(candidate);
      final fetchedAt = DateTime.now().toUtc();
      final serialized = jsonEncode(validatedZones.map((zone) => zone.toJson()).toList());

      await _storage.write(kPrayerZoneCache, serialized);
      await _storage.write(
        kPrayerZoneCacheTimestamp,
        fetchedAt.millisecondsSinceEpoch,
      );

      _zones = List.unmodifiable(validatedZones);
      _lastSuccessfulFetch = fetchedAt;
      _initialLoadError = null;
      notifyListeners();
    } catch (error, stackTrace) {
      debugPrint('Unable to refresh prayer zone catalogue: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (!hasZones) {
        _initialLoadError = error;
        notifyListeners();
      }
    }
  }

  List<PrayerZone> _validateZones(List<PrayerZone> zones) {
    if (zones.isEmpty) {
      throw const FormatException('Prayer zone catalogue is empty');
    }

    final codes = <String>{};
    for (final zone in zones) {
      if (zone.jakimCode.isEmpty || zone.negeri.isEmpty || zone.daerah.isEmpty) {
        throw const FormatException('Prayer zone fields cannot be empty');
      }
      if (!codes.add(zone.jakimCode)) {
        throw FormatException('Duplicate prayer zone code: ${zone.jakimCode}');
      }
    }
    return zones;
  }

  bool _isCacheFresh() {
    final timestamp = _lastSuccessfulFetch;
    if (timestamp == null) return false;
    final now = DateTime.now().toUtc();
    return !timestamp.isAfter(now) && now.difference(timestamp) < cacheLifetime;
  }

  static String _normalizeCode(String? code) => (code ?? '').trim().toUpperCase();
}
