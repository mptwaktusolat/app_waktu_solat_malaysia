import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'DateAndTime.dart';
import 'debug_toast.dart';
import '../models/jakim_esolat_model.dart';
import '../CONSTANTS.dart';

class MptApiFetch {
  /// Attempt to read from cache first, if failed, fetch the api
  static Future<JakimEsolatModel> fetchMpt(String location) async {
    if (GetStorage().read(kJsonCache) != null) {
      var json = GetStorage().read(kJsonCache);

      var parsedModel = JakimEsolatModel.fromJson(json);
      // Check is same location code, month and year
      if (_cacheValidationChecker(parsedModel, location)) {
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
      final response = await http.get(api);
      GetStorage()
          .write(kStoredApiPrayerCall, api.toString()); //for debug dialog
      DebugToast.show('Calling $api');
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        var json = jsonDecode(response.body);
        GetStorage().write(kJsonCache, json);
        return JakimEsolatModel.fromJson(json);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw 'Failed to load prayer time. Status code ${response.statusCode}';
      }
    } on SocketException {
      throw 'No internet connection.';
    }
  }

  static bool _cacheValidationChecker(
      JakimEsolatModel model, String requestedLocationCode) {
    var lastApiFetched = DateTime.parse(model.serverTime!);

    return (model.zone == requestedLocationCode) &&
        DateAndTime.isSameMonthFromM(lastApiFetched.month) &&
        DateAndTime.isTheSameYear(lastApiFetched.year);
  }
}
