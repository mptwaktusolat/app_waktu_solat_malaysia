import 'dart:convert';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:waktusolat_api_client/waktusolat_api_client.dart';

import '../shared/constants/constants.dart';
import '../shared/utils/debug_toast.dart';

class MptApiFetch {
  /// Attempt to read from cache first, if cache not available,
  /// fetch data from WaktuSolat's API
  static Future<MPTWaktuSolatV2> fetchMpt(String location) async {
    final year = DateTime.now().year;
    final month = DateTime.now().month;

    final requestCacheKey = 'waktusolat-v2-cache-$location-$year-$month';
    final cacheData = _readFromCache(requestCacheKey);
    if (cacheData != null) return cacheData;

    final MPTWaktuSolatV2 data =
        await WaktuSolat.getWaktuSolatV2(location, year: year, month: month);
    _saveToCache(requestCacheKey, data);

    return data;
  }

  static MPTWaktuSolatV2? _readFromCache(String cacheKey) {
    if (!GetStorage().hasData(cacheKey)) return null;

    final cachedData = GetStorage().read(cacheKey);

    DebugToast.show('Using cached response');
    FirebaseAnalytics.instance
        .logEvent(name: kEventFetch, parameters: {"type": "cached"});

    final parsedModel = MPTWaktuSolatV2.fromJson(jsonDecode(cachedData));
    return parsedModel;
  }

  /// Save to cache
  static void _saveToCache(String cacheKey, MPTWaktuSolatV2 response) =>
      GetStorage().write(cacheKey, jsonEncode(response.toJson()));

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
