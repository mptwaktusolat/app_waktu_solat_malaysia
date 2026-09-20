import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import '../services/qibla_heading_service.dart';
import '../services/qibla_location_service.dart';
import '../utils/qibla_math.dart';

enum QiblaCompassStatus {
  loading,
  ready,
  locationServiceDisabled,
  permissionDenied,
  permissionDeniedForever,
  noSensor,
  error,
}

class QiblaCompassController extends ChangeNotifier {
  QiblaCompassController({
    QiblaLocationService? locationService,
    QiblaHeadingService? headingService,
    this.onAligned,
  })  : _locationService =
            locationService ?? const GeolocatorQiblaLocationService(),
        _headingService = headingService ?? const DeviceQiblaHeadingService();

  static const Duration _locationTimeout = Duration(seconds: 15);
  static const double _alignedThreshold = 2;
  static const double _alignmentResetThreshold = 5;

  final QiblaLocationService _locationService;
  final QiblaHeadingService _headingService;
  final Future<void> Function()? onAligned;

  StreamSubscription<QiblaHeadingReading>? _headingSubscription;
  int _requestGeneration = 0;
  bool _disposed = false;
  bool _alignmentArmed = true;
  bool _compassActive = true;

  QiblaCompassStatus status = QiblaCompassStatus.loading;
  String? locationLabel;
  String? isoCountryCode;
  double? qiblaBearing;
  double? heading;
  double? turnDegrees;
  double? displayTurnDegrees;
  double? headingAccuracy;
  bool? sensorAvailable;
  bool isAligned = false;
  bool isCountryResolutionPending = false;
  Object? lastError;

  bool get hasLocation => qiblaBearing != null && locationLabel != null;

  bool get shouldShowOutsideMalaysiaWarning =>
      !isCountryResolutionPending && isoCountryCode?.toUpperCase() != 'MY';

  Future<void> initialize() async {
    final generation = ++_requestGeneration;
    await _cancelHeadingSubscription();
    _resetForLoading();

    try {
      if (!await _locationService.isLocationServiceEnabled()) {
        _setStatus(QiblaCompassStatus.locationServiceDisabled, generation);
        return;
      }

      var permission = await _locationService.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await _locationService.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        _setStatus(QiblaCompassStatus.permissionDeniedForever, generation);
        return;
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.unableToDetermine) {
        _setStatus(QiblaCompassStatus.permissionDenied, generation);
        return;
      }

      final coordinates =
          await _locationService.getCurrentPosition().timeout(_locationTimeout);
      if (!_isCurrent(generation)) return;

      qiblaBearing = QiblaMath.bearingToKaaba(
        latitude: coordinates.latitude,
        longitude: coordinates.longitude,
      );
      locationLabel = formatCoordinates(coordinates);
      isCountryResolutionPending = true;
      status = QiblaCompassStatus.ready;
      _notify();

      unawaited(_resolvePlace(coordinates, generation));
      await _startCompass(generation);
    } catch (error) {
      if (!_isCurrent(generation)) return;
      lastError = error;
      status = QiblaCompassStatus.error;
      _notify();
    }
  }

  Future<void> retry() => initialize();

  Future<void> openLocationSettings() =>
      _locationService.openLocationSettings();

  Future<void> openAppSettings() => _locationService.openAppSettings();

  Future<void> pauseCompass() {
    _compassActive = false;
    return _cancelHeadingSubscription();
  }

  Future<void> resumeCompass() async {
    _compassActive = true;
    if (status == QiblaCompassStatus.locationServiceDisabled ||
        status == QiblaCompassStatus.permissionDenied ||
        status == QiblaCompassStatus.permissionDeniedForever) {
      await initialize();
      return;
    }
    if (qiblaBearing == null || sensorAvailable != true) return;
    await _subscribeToHeading(_requestGeneration);
  }

  Future<void> _resolvePlace(
    QiblaCoordinates coordinates,
    int generation,
  ) async {
    try {
      final place = await _locationService.reverseGeocode(coordinates);
      if (!_isCurrent(generation)) return;
      if (place != null) {
        locationLabel = formatLocation(place, fallback: coordinates);
        isoCountryCode = _nonEmpty(place.isoCountryCode)?.toUpperCase();
      }
    } catch (_) {
      // Coordinates remain a useful, non-blocking fallback.
    } finally {
      if (_isCurrent(generation)) {
        isCountryResolutionPending = false;
        _notify();
      }
    }
  }

  Future<void> _startCompass(int generation) async {
    try {
      final supported = await _headingService.hasSensors();
      if (!_isCurrent(generation)) return;
      sensorAvailable = supported;
      if (!supported) {
        status = QiblaCompassStatus.noSensor;
        _notify();
        return;
      }
      status = QiblaCompassStatus.ready;
      _notify();
      if (!_compassActive) return;
      await _subscribeToHeading(generation);
    } catch (error) {
      if (!_isCurrent(generation)) return;
      sensorAvailable = false;
      lastError = error;
      status = QiblaCompassStatus.error;
      _notify();
    }
  }

  Future<void> _subscribeToHeading(int generation) async {
    await _cancelHeadingSubscription();
    if (!_isCurrent(generation) || !_compassActive) return;
    _headingSubscription = _headingService.readings.listen(
      (reading) => _handleHeading(reading, generation),
      onError: (Object error) {
        if (!_isCurrent(generation)) return;
        sensorAvailable = false;
        lastError = error;
        status = QiblaCompassStatus.error;
        _notify();
      },
    );
  }

  void _handleHeading(QiblaHeadingReading reading, int generation) {
    if (!_isCurrent(generation)) return;
    final rawHeading = reading.heading;
    final bearing = qiblaBearing;
    if (rawHeading == null || bearing == null || !rawHeading.isFinite) {
      sensorAvailable = false;
      status = QiblaCompassStatus.noSensor;
      _notify();
      return;
    }

    heading = QiblaMath.normalizeDegrees(rawHeading);
    headingAccuracy = reading.accuracy;
    final nextTurn = QiblaMath.shortestTurn(
      fromHeading: heading!,
      toBearing: bearing,
    );
    turnDegrees = nextTurn;
    displayTurnDegrees = displayTurnDegrees == null
        ? nextTurn
        : QiblaMath.unwrapAngle(
            previousUnwrapped: displayTurnDegrees!,
            nextNormalized: nextTurn,
          );

    final absoluteTurn = nextTurn.abs();
    isAligned = absoluteTurn <= _alignedThreshold;
    if (_alignmentArmed && isAligned) {
      _alignmentArmed = false;
      final callback = onAligned;
      if (callback != null) unawaited(callback());
    } else if (!_alignmentArmed && absoluteTurn >= _alignmentResetThreshold) {
      _alignmentArmed = true;
    }

    status = QiblaCompassStatus.ready;
    sensorAvailable = true;
    _notify();
  }

  void _resetForLoading() {
    status = QiblaCompassStatus.loading;
    locationLabel = null;
    isoCountryCode = null;
    qiblaBearing = null;
    heading = null;
    turnDegrees = null;
    displayTurnDegrees = null;
    headingAccuracy = null;
    sensorAvailable = null;
    isAligned = false;
    isCountryResolutionPending = false;
    lastError = null;
    _alignmentArmed = true;
    _notify();
  }

  void _setStatus(QiblaCompassStatus value, int generation) {
    if (!_isCurrent(generation)) return;
    status = value;
    _notify();
  }

  bool _isCurrent(int generation) =>
      !_disposed && generation == _requestGeneration;

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  Future<void> _cancelHeadingSubscription() async {
    await _headingSubscription?.cancel();
    _headingSubscription = null;
  }

  static String formatLocation(
    QiblaPlace place, {
    required QiblaCoordinates fallback,
  }) {
    final area = [
      place.subLocality,
      place.locality,
      place.subAdministrativeArea,
    ].map(_nonEmpty).whereType<String>().firstOrNull;

    final parts = <String>[];
    for (final value in [area, place.administrativeArea, place.country]) {
      final part = _nonEmpty(value);
      if (part == null) continue;
      if (parts.any((item) => item.toLowerCase() == part.toLowerCase())) {
        continue;
      }
      parts.add(part);
    }
    return parts.isEmpty ? formatCoordinates(fallback) : parts.join(', ');
  }

  static String formatCoordinates(QiblaCoordinates coordinates) =>
      '${coordinates.latitude.toStringAsFixed(4)}, '
      '${coordinates.longitude.toStringAsFixed(4)}';

  static String? _nonEmpty(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }

  @override
  void dispose() {
    _disposed = true;
    _compassActive = false;
    _requestGeneration++;
    unawaited(_cancelHeadingSubscription());
    super.dispose();
  }
}
