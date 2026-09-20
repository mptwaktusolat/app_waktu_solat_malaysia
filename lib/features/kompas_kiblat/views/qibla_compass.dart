import 'dart:math' as math;

import 'package:admonitions/admonitions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../l10n/app_localizations.dart';
import '../controllers/qibla_compass_controller.dart';
import '../services/qibla_heading_service.dart';
import 'compass_calibration_dialog.dart';
import 'location_error_widget.dart';
import 'no_compass_sensor.dart';

part 'components/compass_accuracy_indicator.dart';
part 'components/compass_graphic.dart';
part 'components/loading_state.dart';
part 'components/location_and_bearing.dart';
part 'components/ready_compass.dart';

class QiblaCompass extends StatefulWidget {
  const QiblaCompass({super.key, this.controller});

  final QiblaCompassController? controller;

  @override
  State<QiblaCompass> createState() => _QiblaCompassState();
}

class _QiblaCompassState extends State<QiblaCompass>
    with WidgetsBindingObserver {
  late final QiblaCompassController _controller;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _ownsController = widget.controller == null;
    _controller = widget.controller ??
        QiblaCompassController(onAligned: HapticFeedback.mediumImpact);
    _controller.addListener(_onControllerChanged);
    _controller.initialize();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _controller.resumeCompass();
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _controller.pauseCompass();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    switch (_controller.status) {
      case QiblaCompassStatus.loading:
        return _LoadingState(message: localizations.qiblaLoadingLocation);
      case QiblaCompassStatus.locationServiceDisabled:
        return LocationErrorWidget(
          error: localizations.qiblaLocationServiceDisabled,
          actionLabel: localizations.qiblaOpenLocationSettings,
          onPressed: _controller.openLocationSettings,
        );
      case QiblaCompassStatus.permissionDenied:
        return LocationErrorWidget(
          error: localizations.qiblaPermissionDenied,
          actionLabel: localizations.qiblaRetry,
          onPressed: _controller.retry,
        );
      case QiblaCompassStatus.permissionDeniedForever:
        return LocationErrorWidget(
          error: localizations.qiblaPermissionDeniedForever,
          actionLabel: localizations.qiblaOpenAppSettings,
          onPressed: _controller.openAppSettings,
        );
      case QiblaCompassStatus.ready:
      case QiblaCompassStatus.noSensor:
        return _ReadyCompass(controller: _controller);
      case QiblaCompassStatus.error:
        if (_controller.hasLocation) {
          return _ReadyCompass(controller: _controller);
        }
        return LocationErrorWidget(
          error: localizations.qiblaCompassError,
          actionLabel: localizations.qiblaRetry,
          onPressed: _controller.retry,
        );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.removeListener(_onControllerChanged);
    if (_ownsController) _controller.dispose();
    super.dispose();
  }
}
