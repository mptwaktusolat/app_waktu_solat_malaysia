import 'package:waktusolatmalaysia/models/mpti906api_location.dart';
import 'package:waktusolatmalaysia/networking/ApiProvider.dart';

class MptRepository {
  ApiProvider apiProvider = ApiProvider();
  Future<Mpti906Location> fetchLocation(
      String latitude, String longitude) async {
    final response = await apiProvider
        .get('https://mpt.i906.my/api/prayer/$latitude,$longitude');

    return Mpti906Location.fromJson(response);
  }
}
