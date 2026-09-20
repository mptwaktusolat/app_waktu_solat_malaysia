import 'package:flutter_device_compass/flutter_device_compass.dart';

enum QiblaHeadingAccuracy {
  high,
  medium,
  low,
  unavailable;

  static QiblaHeadingAccuracy fromDegrees(double? accuracy) {
    if (accuracy == null || !accuracy.isFinite || accuracy < 0) {
      return unavailable;
    }
    // the plugin converted sensor accuracy to degrees values. See https://pub.dev/packages/flutter_device_compass
    if (accuracy <= 15) return high;
    if (accuracy <= 30) return medium;
    return low;
  }

  bool get shouldCalibrate => this != high;
}

class QiblaHeadingReading {
  const QiblaHeadingReading({required this.heading, this.accuracy});

  final double? heading;
  final double? accuracy;
}

class QiblaHeadingService {
  const QiblaHeadingService();

  Future<bool> hasSensors() async => await FlutterCompass.hasSensors ?? false;

  Stream<QiblaHeadingReading> get readings {
    final events = FlutterCompass.eventsFor(CompassUpdateOptions.balanced);
    if (events == null) {
      return Stream<QiblaHeadingReading>.error(
        StateError('Compass event stream is unavailable.'),
      );
    }

    return events.map(
      (event) => QiblaHeadingReading(
        heading: event.heading,
        accuracy: event.accuracy,
      ),
    );
  }
}
