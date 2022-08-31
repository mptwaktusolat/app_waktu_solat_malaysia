import 'dart:convert';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../CONSTANTS.dart';
import '../models/jakim_esolat_model.dart';
import '../utils/date_and_time.dart';
import '../utils/debug_toast.dart';

class MptApiFetch {
  /// Attempt to read from cache first, if cache not available,
  /// proceed using mpt-server's API, if data invalid, use JAKIM's
  static Future<JakimEsolatModel> fetchMpt(String location) async {
    if (GetStorage().read(kJsonCache) != null) {
      var json = GetStorage().read(kJsonCache);

      var parsedModel = JakimEsolatModel.fromJson(json);
      // Check is same location code, month and year
      if (_validateResponse(parsedModel, location)) {
        DebugToast.show('Reading from cache');
        await FirebaseAnalytics.instance
            .logEvent(name: kEventFetch, parameters: {"type": "cached"});
        return parsedModel;
      }
    }
    dynamic mptJsonResponse;

    // TODO: kemaskan, buat early return or smth
    try {
      final api = Uri.https('mpt-server.vercel.app', '/api/log');

      // return error if request takes too much time
      final response = await http.get(api).timeout(
            const Duration(seconds: 6),
            onTimeout: () => http.Response('Error', 408),
          );
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        if (DateAndTime.isTheSameYear(jsonResponse['valid_year']) &&
            DateAndTime.isSameMonthFromM(jsonResponse['valid_month'])) {
          mptJsonResponse = await _mptServerApi(location);
          GetStorage().write(kJsonCache, mptJsonResponse);
        } else {
          // If data is out of date, use JAKIM's API
          DebugToast.show('mpt-server data not valid');
          mptJsonResponse = await _jakimApi(location);
          GetStorage().write(kJsonCache, mptJsonResponse);
        }
      } else {
        // If return other than 200, use JAKIM's API
        mptJsonResponse = await _jakimApi(location);
        GetStorage().write(kJsonCache, mptJsonResponse);
      }

      return JakimEsolatModel.fromJson(mptJsonResponse);
    } on SocketException {
      throw 'No internet connection.';
    }
  }

  static Future<dynamic> _mptServerApi(String location) async {
    final api = Uri.https('mpt-server.vercel.app', 'api/solat/$location');
    DebugToast.show('Using mpt-server api');
    GetStorage().write(kStoredApiPrayerCall, api.toString()); //for debug dialog
    final response = await http.get(api).timeout(
          const Duration(seconds: 6),
          onTimeout: () => http.Response('Error', 408),
        );
    await FirebaseAnalytics.instance
        .logEvent(name: kEventFetch, parameters: {"type": "mpt-server"});
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return jsonDecode(response.body);
    } else {
      throw 'Error getting mpt-server api';
    }
  }

  static Future<dynamic> _jakimApi(String location) async {
    final api = Uri.https('www.e-solat.gov.my', 'index.php', {
      'r': 'esolatApi/takwimsolat',
      'period': 'month',
      'zone': location,
    });
    final response = await http.get(api);
    GetStorage().write(kStoredApiPrayerCall, api.toString()); //for debug dialog
    DebugToast.show("Using JAKIM api");

    await FirebaseAnalytics.instance
        .logEvent(name: kEventFetch, parameters: {"type": "jakim"});

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw 'Failed to load prayer time (JAKIM api). Status code ${response.statusCode}';
    }
  }

  /// Check if data is valid by compating its month and year
  static bool _validateResponse(
      JakimEsolatModel model, String requestedLocationCode) {
    var lastApiFetched = DateTime.parse(model.serverTime!);

    return (model.zone == requestedLocationCode) &&
        DateAndTime.isSameMonthFromM(lastApiFetched.month) &&
        DateAndTime.isTheSameYear(lastApiFetched.year);
  }
}
