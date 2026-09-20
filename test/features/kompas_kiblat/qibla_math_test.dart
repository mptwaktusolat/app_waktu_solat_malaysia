import 'package:flutter_test/flutter_test.dart';
import 'package:waktusolatmalaysia/features/kompas_kiblat/utils/qibla_math.dart';

void main() {
  group('QiblaMath.bearingToKaaba', () {
    final cityBearings =
        <String, ({double latitude, double longitude, double bearing})>{
      'Kuala Lumpur': (
        latitude: 3.139003,
        longitude: 101.686855,
        bearing: 292.5377,
      ),
      'London': (
        latitude: 51.5074,
        longitude: -0.1278,
        bearing: 118.9872,
      ),
      'New York City': (
        latitude: 40.7128,
        longitude: -74.0060,
        bearing: 58.4817,
      ),
      'Sydney': (
        latitude: -33.8688,
        longitude: 151.2093,
        bearing: 277.4996,
      ),
    };

    for (final MapEntry(key: city, value: coordinates)
        in cityBearings.entries) {
      test('calculates the bearing from $city', () {
        final bearing = QiblaMath.bearingToKaaba(
          latitude: coordinates.latitude,
          longitude: coordinates.longitude,
        );

        expect(bearing, closeTo(coordinates.bearing, 0.0001));
      });
    }
  });

  group('QiblaMath.normalizeDegrees', () {
    test('normalizes values into the zero-to-360 range', () {
      expect(QiblaMath.normalizeDegrees(360), 0);
      expect(QiblaMath.normalizeDegrees(725), 5);
      expect(QiblaMath.normalizeDegrees(-10), 350);
      expect(QiblaMath.normalizeDegrees(-720), 0);
    });
  });

  group('QiblaMath.shortestTurn', () {
    test('turns clockwise across north', () {
      expect(
        QiblaMath.shortestTurn(fromHeading: 358, toBearing: 2),
        4,
      );
    });

    test('turns counter-clockwise across north', () {
      expect(
        QiblaMath.shortestTurn(fromHeading: 2, toBearing: 358),
        -4,
      );
    });

    test('normalizes input headings', () {
      expect(
        QiblaMath.shortestTurn(fromHeading: 725, toBearing: -10),
        -15,
      );
    });

    test('uses negative 180 for an exactly opposite bearing', () {
      expect(
        QiblaMath.shortestTurn(fromHeading: 0, toBearing: 180),
        -180,
      );
    });
  });

  group('QiblaMath.unwrapAngle', () {
    test('continues increasing clockwise across north', () {
      expect(
        QiblaMath.unwrapAngle(
          previousUnwrapped: 358,
          nextNormalized: 2,
        ),
        362,
      );
    });

    test('continues decreasing counter-clockwise across north', () {
      expect(
        QiblaMath.unwrapAngle(
          previousUnwrapped: 2,
          nextNormalized: 358,
        ),
        -2,
      );
    });

    test('preserves multiple completed rotations', () {
      expect(
        QiblaMath.unwrapAngle(
          previousUnwrapped: 722,
          nextNormalized: 358,
        ),
        718,
      );
    });
  });
}
