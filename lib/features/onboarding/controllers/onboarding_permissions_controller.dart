import 'package:auto_start_flutter/auto_start_flutter.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

/// Keeps system permission state separate from the user's autostart acknowledgement.
class OnboardingPermissionsController extends ChangeNotifier {
  OnboardingPermissionsController({OnboardingPermissionService? service})
    : _service = service ?? OnboardingPermissionService();

  final OnboardingPermissionService _service;
  bool locationGranted = false;
  bool notificationsGranted = false;
  bool exactAlarmsGranted = false;
  bool? autoStartAvailable;
  bool autoStartAcknowledged = false;
  bool loaded = false;
  bool busy = false;
  bool hasError = false;
  bool _disposed = false;

  bool get supportsExactAlarms => _service.supportsExactAlarms;
  bool get allComplete =>
      loaded &&
      !hasError &&
      locationGranted &&
      notificationsGranted &&
      (!supportsExactAlarms || exactAlarmsGranted) &&
      (autoStartAvailable == false || autoStartAcknowledged);

  Future<void> refresh() => _run(() async {});

  Future<void> requestLocation() => _run(_service.requestLocation);

  Future<void> requestNotifications() => _run(_service.requestNotifications);

  Future<void> requestExactAlarms() => _run(_service.requestExactAlarms);

  Future<void> openAutoStart() => _run(_service.openAutoStart);

  void acknowledgeAutoStart(bool value) {
    autoStartAcknowledged = value;
    notifyListeners();
  }

  Future<void> _run(Future<void> Function() action) async {
    if (busy || _disposed) return;
    busy = true;
    hasError = false;
    notifyListeners();
    try {
      await action();
    } catch (error) {
      hasError = true;
      debugPrint('Could not open onboarding permission settings: $error');
    }
    try {
      locationGranted = await _service.locationGranted();
      notificationsGranted = await _service.notificationsGranted();
      exactAlarmsGranted = await _service.exactAlarmsGranted();
      autoStartAvailable = await _service.autoStartAvailable();
      loaded = true;
    } catch (error) {
      // Unknown state must never be reported as a completed checklist.
      loaded = false;
      hasError = true;
      debugPrint('Could not check onboarding permissions: $error');
    } finally {
      busy = false;
      if (!_disposed) notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

class OnboardingPermissionService {
  bool get supportsExactAlarms => defaultTargetPlatform == TargetPlatform.android;

  Future<bool> locationGranted() async {
    final status = await Geolocator.checkPermission();
    return status == LocationPermission.whileInUse || status == LocationPermission.always;
  }

  Future<void> requestLocation() async {
    final status = await Geolocator.checkPermission();
    if (status == LocationPermission.deniedForever) {
      if (!await Geolocator.openAppSettings()) throw StateError('Cannot open location settings');
    } else if (status == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
  }

  Future<bool> notificationsGranted() => Permission.notification.isGranted;

  Future<bool> exactAlarmsGranted() async =>
      !supportsExactAlarms || await Permission.scheduleExactAlarm.isGranted;

  Future<bool> autoStartAvailable() async {
    if (!supportsExactAlarms) return false;
    // Samsung exposes no usable autostart toggle (issue #89).
    final info = await DeviceInfoPlugin().androidInfo;
    if (info.brand.toLowerCase() == 'samsung') return false;
    return await isAutoStartAvailable ?? false;
  }

  Future<void> requestNotifications() async {
    final status = await Permission.notification.status;
    if (status.isGranted) return;
    if (status.isPermanentlyDenied || status.isRestricted) {
      if (!await openAppSettings()) throw StateError('Cannot open app settings');
    } else {
      await Permission.notification.request();
    }
  }

  Future<void> requestExactAlarms() async {
    if (supportsExactAlarms) await Permission.scheduleExactAlarm.request();
  }

  Future<void> openAutoStart() async {
    if (!await getAutoStartPermission()) {
      if (!await openAppSettings()) throw StateError('Cannot open autostart settings');
    }
  }
}
