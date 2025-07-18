import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:waktusolat_api_client/waktusolat_api_client.dart';

import '../constants.dart';
import '../utils/debug_toast.dart';

class MptApiFetch {
  /// Attempt to read from cache first, if cache not available,
  /// fetch data from WaktuSolat's API
  static Future<MPTWaktuSolatV2> fetchMpt(String location) async {
    // Generate hashcode from api url
    // so that the cache key is unique for different location, month & year
    // and we no longer need a method to check the data is valid based on the paramaters above
    final requestCacheKey = 'waktusolat-cache-${location.hashCode}';
    final cacheData = _readFromCache(requestCacheKey);
    if (cacheData != null) return cacheData;

    late final MPTWaktuSolatV2 data;
    try {
      // If issue https://github.com/mptwaktusolat/app_waktu_solat_malaysia/issues/216 like
      // this ever happens again, the data will not be saved to cache
      data = await WaktuSolat.getWaktuSolatV2(location);
      _saveToCache(requestCacheKey, data.toJson());
    } catch (e) {
      rethrow;
    }

    return data;
  }

  static MPTWaktuSolatV2? _readFromCache(String cacheKey) {
    if (GetStorage().read(cacheKey) == null) return null;

    final cachedData = GetStorage().read(cacheKey);
    if (cachedData == null) return null;

    DebugToast.show('Using cached response');
    FirebaseAnalytics.instance
        .logEvent(name: kEventFetch, parameters: {"type": "cached"});

    final parsedModel = MPTWaktuSolatV2.fromJson(cachedData);
    return parsedModel;
  }

  /// Save to cache
  static void _saveToCache(String cacheKey, Map<String, dynamic> response) =>
      GetStorage().write(cacheKey, response);

  static Future<File> downloadJadualSolat(String zone) async {
    final year = DateTime.now().year;
    final month = DateTime.now().month;

    final fileSuffix = '$zone-$year-$month';
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/jadual_solat_$fileSuffix.pdf');

    // check if file is exist
    if (await file.exists()) return file;

    // If not exist, download from server
    final url =
        WaktuSolat.getJadualSolatDownloadUrl(zone, year: year, month: month);
    final data = await http.get(Uri.parse(url));

    return file.writeAsBytes(data.bodyBytes);
  }
}
