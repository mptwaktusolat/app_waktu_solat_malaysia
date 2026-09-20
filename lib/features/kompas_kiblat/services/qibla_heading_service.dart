import 'package:flutter_device_compass/flutter_device_compass.dart';

class QiblaHeadingReading {
  const QiblaHeadingReading({
    required this.heading,
    this.accuracy,
  });

  final double? heading;
  final double? accuracy;
}

abstract class QiblaHeadingService {
  Future<bool> hasSensors();

  Stream<QiblaHeadingReading> get readings;
}

class DeviceQiblaHeadingService implements QiblaHeadingService {
  const DeviceQiblaHeadingService();

  @override
  Future<bool> hasSensors() async => await FlutterCompass.hasSensors ?? false;

  @override
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
