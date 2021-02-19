///Connect to API

import 'package:get_storage/get_storage.dart';
import 'package:waktusolatmalaysia/CONSTANTS.dart';
import 'package:waktusolatmalaysia/models/mpti906PrayerData.dart';
import 'package:waktusolatmalaysia/networking/ApiProvider.dart';

class AzanTimesTodayRepository {
  ApiProvider _provider = ApiProvider();

  Future<Mpti906PrayerModel> fetchAzanMptMonth(String location) async {
    String url = 'https://mpt.i906.my/api/prayer/$location';
    GetStorage().write(kStoredApiPrayerCall, url);
    final response = await _provider.get(url);
    return Mpti906PrayerModel.fromJson(response);
  }
}
