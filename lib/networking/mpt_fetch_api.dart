import 'dart:convert';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../constants.dart';
import '../models/mpt_server_solat.dart';
import '../utils/debug_toast.dart';

class MptApiFetch {
  /// Attempt to read from cache first, if cache not available,
  /// fetch data from mpt-server's API
  static Future<MptServerSolat> fetchMpt(String location) async {
    // build the URI
    final api = Uri.https(kApiBaseUrl, 'api/v2/solat/$location', {
      'year': DateTime.now().year.toString(),
      'month': DateTime.now().month.toString(),
    });

    // Generate hashcode from api url
    // so that the cache key is unique for different location, month & year
    // and we no longer need a method to check the data is valid based on the paramaters above
    var requestCacheKey = 'mpt-server-cache-${api.toString().hashCode}';
    var cacheData = _readFromCache(requestCacheKey);
    if (cacheData != null) return cacheData;

    final apiResponse = await _mptServerApi(api);
    _saveToCache(requestCacheKey, apiResponse);

    return MptServerSolat.fromJson(apiResponse);
  }

  /// Call MPT Server api to get prayer times data
  static Future<dynamic> _mptServerApi(Uri apiUri) async {
    DebugToast.show('Using mpt-server api');
    GetStorage()
        .write(kStoredApiPrayerCall, apiUri.toString()); //for debug dialog
    final response = await http.get(apiUri).timeout(
          const Duration(seconds: 6),
          onTimeout: () => http.Response('Error', 408),
        );
    await FirebaseAnalytics.instance
        .logEvent(name: kEventFetch, parameters: {"type": "mpt-server"});
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return jsonDecode(response.body);
    } else {
      throw 'Error getting mpt-server api';
    }
  }

  /// Read from cache, if cache not available, return null
  static MptServerSolat? _readFromCache(String cacheKey) {
    if (GetStorage().read(cacheKey) == null) return null;

    var cachedData = GetStorage().read(cacheKey);
    if (cachedData == null) return null;

    DebugToast.show('Using cached response');
    FirebaseAnalytics.instance
        .logEvent(name: kEventFetch, parameters: {"type": "cached"});

    var parsedModel = MptServerSolat.fromJson(cachedData);
    return parsedModel;
  }

  /// Save to cache
  static void _saveToCache(String cacheKey, Map<String, dynamic> response) =>
      GetStorage().write(cacheKey, response);

  static Future<File> downloadJadualSolat(String zone) async {
    var year = DateTime.now().year;
    var month = DateTime.now().month;

    final options = {
      'year': year.toString(),
      'month': month.toString(),
      'zone': zone,
    };

    final fileSuffix = '$zone-$year-$month';
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/jadual_solat_$fileSuffix.pdf');

    // check if file is exist
    if (await file.exists()) return file;

    // If not exist, download from server
    final url = Uri.https(kApiBaseUrl, 'api/jadual_solat', options);
    final data = await http.get(url);

    return file.writeAsBytes(data.bodyBytes);
  }
}
