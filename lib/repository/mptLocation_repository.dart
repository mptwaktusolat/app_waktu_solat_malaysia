import 'package:get_storage/get_storage.dart';

import '../CONSTANTS.dart';
import '../models/mpti906api_location.dart';
import '../networking/ApiProvider.dart';

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
