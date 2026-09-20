import 'package:flutter_test/flutter_test.dart';
import 'package:waktusolatmalaysia/features/kompas_kiblat/services/qibla_heading_service.dart';

void main() {
  group('QiblaHeadingAccuracy.fromDegrees', () {
    test('classifies finite accuracy values', () {
      expect(
        QiblaHeadingAccuracy.fromDegrees(15),
        QiblaHeadingAccuracy.high,
      );
      expect(
        QiblaHeadingAccuracy.fromDegrees(30),
        QiblaHeadingAccuracy.medium,
      );
      expect(
        QiblaHeadingAccuracy.fromDegrees(45),
        QiblaHeadingAccuracy.low,
      );
    });

    test('treats missing or invalid accuracy as unavailable', () {
      expect(
        QiblaHeadingAccuracy.fromDegrees(null),
        QiblaHeadingAccuracy.unavailable,
      );
      expect(
        QiblaHeadingAccuracy.fromDegrees(double.nan),
        QiblaHeadingAccuracy.unavailable,
      );
      expect(
        QiblaHeadingAccuracy.fromDegrees(-1),
        QiblaHeadingAccuracy.unavailable,
      );
    });
  });
}
