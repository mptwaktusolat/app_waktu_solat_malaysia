import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../env.dart';
import '../exceptions/prayer_zone_exceptions.dart';
import '../models/zones_info.dart';

class PrayerZoneServices {
  /// Ask API for JAKIM code based on coordinates
  static Future<String> getNearestJakimZonedFomCoordinates(
    double latitude,
    double longitude,
  ) async {
    final uri = Uri.https(envApiBaseHost, 'api/zones/gps', {
      'lat': latitude.toString(),
      'long': longitude.toString(),
    });
    final res = await http.get(uri);

    if (res.statusCode == 200) {
      final result = ZonesInfo.fromJson(jsonDecode(res.body));
      return result.zone;
    } else if (res.statusCode == 404) {
      // location not in bound

      throw PrayerZoneExceptions('Location not in bound');
    } else {
      throw PrayerZoneExceptions(
        'Failed to load prayer zone: ${res.statusCode}',
      );
    }
  }
}
