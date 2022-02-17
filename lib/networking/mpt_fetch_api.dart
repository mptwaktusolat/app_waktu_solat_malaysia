import 'dart:convert';
import 'dart:io';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../CONSTANTS.dart';
import '../models/jakim_esolat_model.dart';
import '../utils/date_and_time.dart';
import '../utils/debug_toast.dart';

class MptApiFetch {
  /// Attempt to read from cache first, if cache not available,
  /// proceed using JAKIM's API, if unreachable, use the backup API.
  static Future<JakimEsolatModel> fetchMpt(String location) async {
    if (GetStorage().read(kJsonCache) != null) {
      var json = GetStorage().read(kJsonCache);

      var parsedModel = JakimEsolatModel.fromJson(json);
      // Check is same location code, month and year
      if (_validateResponse(parsedModel, location)) {
        DebugToast.show('Reading from cache');
        return parsedModel;
      }
    }
    try {
      final api = Uri.https('www.e-solat.gov.my', 'index.php', {
        'r': 'esolatApi/takwimsolat',
        'period': 'month',
        'zone': location,
      });
      DebugToast.show('Calling jakim api');

      // timeout is sueful in a case that JAKIM return nothing at all
      final response = await http.get(api).timeout(
            const Duration(seconds: 8),
            onTimeout: () => http.Response('Error', 408),
          );

      GetStorage()
          .write(kStoredApiPrayerCall, api.toString()); //for debug dialog
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        var json = jsonDecode(response.body);
        GetStorage().write(kJsonCache, json);
        return JakimEsolatModel.fromJson(json);
      } else {
        // If jakim failed, call the backup API
        final api =
            Uri.parse('https://mpt-backup-api.herokuapp.com/solat/$location');
        final response = await http.get(api);
        GetStorage()
            .write(kStoredApiPrayerCall, api.toString()); //for debug dialog
        DebugToast.show("Cannot reach JAKIM at the moment. Using backup API.");

        if (response.statusCode == 200) {
          var json = jsonDecode(response.body);
          var parsedModel = JakimEsolatModel.fromJson(json);

          if (_validateResponse(parsedModel, location)) {
            GetStorage().write(kJsonCache, json);
            return parsedModel;
          }
        } else {
          throw 'Failed to load prayer time (backup API). Status code ${response.statusCode}';
        }

        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw 'Failed to load prayer time. Status code ${response.statusCode}';
      }
    } on SocketException {
      throw 'No internet connection.';
    }
  }

  static bool _validateResponse(
      JakimEsolatModel model, String requestedLocationCode) {
    var lastApiFetched = DateTime.parse(model.serverTime!);

    return (model.zone == requestedLocationCode) &&
        DateAndTime.isSameMonthFromM(lastApiFetched.month) &&
        DateAndTime.isTheSameYear(lastApiFetched.year);
  }
}
