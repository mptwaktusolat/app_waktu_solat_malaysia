///Connect to API

import 'package:get_storage/get_storage.dart';
import 'package:waktusolatmalaysia/CONSTANTS.dart';
import 'package:waktusolatmalaysia/models/jakim_prayer_model.dart';
import 'package:waktusolatmalaysia/networking/ApiProvider.dart';

class AzanTimesTodayRepository {
  ApiProvider _provider = ApiProvider();

  Future<JakimPrayerModel> fetchPrayerMonth(String location) async {
    Uri url = Uri.https("www.e-solat.gov.my", "/index.php",
        {"r": "esolatApi/takwimsolat", "period": "month", "zone": location});

    GetStorage().write(kStoredApiPrayerCall, url.toString());
    final response = await _provider.get(url);
    return JakimPrayerModel.fromJson(response);
  }
}
