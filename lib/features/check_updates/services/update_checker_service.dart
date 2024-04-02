import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import '../model/check_version_response.dart';

/// Compare app version with GitHub releases version
class UpdateCheckerService {
  /// Check if installed app has lower version number than remote version
  /// Will return `false` if device running lower than unsupported version.
  static Future<bool> updatesAvailable() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    final int deviceSdk = androidInfo.version.sdkInt;
    const int minSdk = 21;
    if (deviceSdk < minSdk) return false;

    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    final response =
        await http.get(Uri.parse('https://waktusolat.app/api/check_version'));

    final remoteRelease =
        CheckVersionResponse.fromJson(jsonDecode(response.body));

    final int appBuildNumber = int.parse(packageInfo.buildNumber);

    return (appBuildNumber < remoteRelease.buildNumber);
  }

  static Future<CheckVersionResponse> getUpdateInfo() async {
    final response =
        await http.get(Uri.parse('https://waktusolat.app/api/check_version'));

    final remoteRelease =
        CheckVersionResponse.fromJson(jsonDecode(response.body));
    return remoteRelease;
  }
}
