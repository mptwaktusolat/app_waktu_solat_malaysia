import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../CONSTANTS.dart';
import '../models/mpt_server_solat.dart';
import '../utils/debug_toast.dart';

class MptApiFetch {
  /// Attempt to read from cache first, if cache not available,
  /// fetch data from mpt-server's API
  static Future<MptServerSolat> fetchMpt(String location) async {
    if (GetStorage().read(kJsonCache) != null) {
      var json = GetStorage().read(kJsonCache);

      var parsedModel = MptServerSolat.fromJson(json);
      // Check is same location code, month and year
      if (_validateResponse(parsedModel, location)) {
        DebugToast.show('Reading from cache');
        await FirebaseAnalytics.instance
            .logEvent(name: kEventFetch, parameters: {"type": "cached"});
        return parsedModel;
      }
    }

    final apiResponse = await _mptServerApi(location);
    GetStorage().write(kJsonCache, apiResponse);

    DebugToast.show('Using mpt-server api');
    GetStorage()
        .write(kStoredApiPrayerCall, apiResponse.toString()); //for debug dialog

    return MptServerSolat.fromJson(apiResponse);
  }

  static Future<dynamic> _mptServerApi(String location) async {
    final api = Uri.https(kApiBaseUrl, 'api/v2/solat/$location', {
      'year': DateTime.now().year.toString(),
      'month': DateTime.now().month.toString(),
    });
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

  /// Check if data is valid by comparing its month and year
  static bool _validateResponse(
      MptServerSolat model, String requestedLocationCode) {
    final now = DateTime.now();
    final month =
        DateFormat.MMM().format(DateTime(now.year, now.month, 1)).toUpperCase();

    return model.month == month && model.year == now.year ? true : false;
  }
}
