import 'package:waktusolatmalaysia/models/azanproapi.dart';
import 'package:waktusolatmalaysia/networking/ApiProvider.dart';

class AzanTimesTodayRepository {
  ApiProvider _provider = ApiProvider();

  Future<PrayerTime> fetchAzanToday(String category, String format) async {
    final response =
        await _provider.get("times/today.json?zone=" + category + format);
    return PrayerTime.fromJson(response);
  }
}
