import 'dart:math';

typedef _LocationDms = (int degree, double minute, double second);

/// Calculate the angle to Qibla
class QiblatCalculator {
  /// Calculate the angle to Qibla from the given latitude and longitude from North
  /// Reference formula:
  /// https://oarep.usim.edu.my/jspui/bitstream/123456789/19549/1/Mathematical%20Application%20In%20Determining%20Qibla%20Direction%20Of%20Tamhidi%20Centre%20Universiti%20Sains%20Islam%20Malaysia%20%28USIM%29%20By%20Using%20Spherical%20Trigonometry.pdf
  static double angleToQiblat(double latitude, double longitude) {
    final myLat = _toDms(latitude);
    final myLng = _toDms(longitude);

    const kaabaLat = (21, 25.0, 25.0);
    const kaabaLng = (39, 49.0, 39.0);

    final delta = _toRadians(myLng) - _toRadians(kaabaLng);

    // calculate the Qibla direction
    final x = sin(delta);
    final y = tan(_toRadians(kaabaLat)) * cos(_toRadians(myLat));
    final z = sin(_toRadians(myLat)) * cos(delta);

    final a = x / (y - z);

    final b = atan(a);

    final qiblaAngle = ((2 * pi) - b) * (180 / pi);

    return qiblaAngle;
  }

  /// Take a coordinate component (latitude or longitude) and convert it to DMS (Degree, Minute, Second)
  static _LocationDms _toDms(double coordinate) {
    final int degree = coordinate.toInt();
    final double minute = (coordinate - degree) * 60;
    final double second = (minute - minute.toInt()) * 60;

    return (degree, minute, second);
  }

  /// convert DMS to radians
  static double _toRadians(_LocationDms dms) {
    final double degree = dms.$1 + dms.$2 / 60 + dms.$3 / 3600;

    return degree * (pi / 180);
  }
}
