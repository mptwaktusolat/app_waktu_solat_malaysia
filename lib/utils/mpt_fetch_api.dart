import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:waktusolatmalaysia/utils/DateAndTime.dart';
import '../CONSTANTS.dart';
import '../models/mpti906PrayerData.dart';

class MptApiFetch {
  /// Attempt to read from cache first, if failed, fetch the api
  static Future<Mpti906PrayerModel> fetchMpt(String location) async {
    if (GetStorage().read(kJsonCache) != null) {
      var json = GetStorage().read(kJsonCache);
      var parsedModel = Mpti906PrayerModel.fromJson(json);
      // Check is same location code, month and year
      if ((parsedModel.data.code == location) &&
          DateAndTime.isSameMonthFromM(parsedModel.data.month) &&
          DateAndTime.isTheSameYear(parsedModel.data.year)) {
        //print to tell that I read from cache
        // if (GetStorage().read(kIsDebugMode)) {
        Fluttertoast.showToast(msg: 'Reading from cache');
        // }
        return parsedModel;
      }
    }

    try {
      final api = Uri.https('mpt.i906.my', 'api/prayer/$location');
      final response = await http.get(api);
      GetStorage()
          .write(kStoredApiPrayerCall, api.toString()); //for debug dialog
      // if (GetStorage().read(kIsDebugMode)) {
      Fluttertoast.showToast(msg: api.toString());
      // }

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        var json = jsonDecode(response.body);
        GetStorage().write(kJsonCache, json);
        return Mpti906PrayerModel.fromJson(json);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw 'Failed to load prayer time. Status code ${response.statusCode}';
      }
    } on SocketException {
      throw 'No internet connection.';
    }
  }
}
