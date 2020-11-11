import 'package:get_storage/get_storage.dart';
import 'package:waktusolatmalaysia/CONSTANTS.dart';
import 'package:waktusolatmalaysia/models/mpti906api_location.dart';
import 'package:waktusolatmalaysia/networking/ApiProvider.dart';

class MptRepository {
  ApiProvider apiProvider = ApiProvider();

  Future<Mpti906Location> fetchLocation(
      String latitude, String longitude) async {
    var url = 'https://mpt.i906.my/api/prayer/$latitude,$longitude';
    GetStorage().write(kStoredApiLocationCall, url);
    final response = await apiProvider.get(url);
    return Mpti906Location.fromJson(response);
  }
}
