import 'package:waktusolatmalaysia/models/mpti906api.dart';
import 'package:waktusolatmalaysia/networking/ApiProvider.dart';

class MptRepository {
  ApiProvider apiProvider = ApiProvider();
  Future<Mpti906> fetchLocation(String latitude, String longitude) async {
    final response = await apiProvider
        .get('https://mpt.i906.my/api/prayer/$latitude,$longitude');
    print(
        "From repo link: 'https://mpt.i906.my/api/prayer/$latitude,$longitude'");
    return Mpti906.fromJson(response);
  }
}
