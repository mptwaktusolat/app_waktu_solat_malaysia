import 'dart:math' as math;

/// Pure calculations used by the Qibla compass.
abstract final class QiblaMath {
  static const double _kaabaLatitude = 21.422487;
  static const double _kaabaLongitude = 39.826206;

  /// Normalizes an angle to the range `[0, 360)`.
  static double normalizeDegrees(double degrees) {
    final normalized = degrees % 360;

    return normalized == 0 ? 0 : normalized;
  }

  /// Returns the initial great-circle bearing from [latitude], [longitude]
  /// to the Kaaba, measured clockwise from north.
  static double bearingToKaaba({
    required double latitude,
    required double longitude,
  }) {
    final latitudeRadians = _toRadians(latitude);
    final kaabaLatitudeRadians = _toRadians(_kaabaLatitude);
    final longitudeDeltaRadians = _toRadians(_kaabaLongitude - longitude);

    final y = math.sin(longitudeDeltaRadians) * math.cos(kaabaLatitudeRadians);
    final x = math.cos(latitudeRadians) * math.sin(kaabaLatitudeRadians) -
        math.sin(latitudeRadians) *
            math.cos(kaabaLatitudeRadians) *
            math.cos(longitudeDeltaRadians);

    return normalizeDegrees(_toDegrees(math.atan2(y, x)));
  }

  /// Returns the shortest signed turn from [fromHeading] to [toBearing].
  ///
  /// Positive values indicate a clockwise (right) turn and negative values
  /// indicate a counter-clockwise (left) turn. The result is in `[-180, 180)`.
  static double shortestTurn({
    required double fromHeading,
    required double toBearing,
  }) {
    return normalizeDegrees(toBearing - fromHeading + 180) - 180;
  }

  /// Maps [nextNormalized] to the nearest equivalent angle around
  /// [previousUnwrapped], preventing long animations across north.
  static double unwrapAngle({
    required double previousUnwrapped,
    required double nextNormalized,
  }) {
    return previousUnwrapped +
        shortestTurn(
          fromHeading: normalizeDegrees(previousUnwrapped),
          toBearing: normalizeDegrees(nextNormalized),
        );
  }

  static double _toRadians(double degrees) => degrees * math.pi / 180;

  static double _toDegrees(double radians) => radians * 180 / math.pi;
}
