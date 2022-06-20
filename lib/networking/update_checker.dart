import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import '../models/github_releases_model.dart';

/// Compare app version with GitHub releases version
class AppUpdateChecker {
  /// Check if installed app has lower version number than remote version
  /// Will return `false` if device running lower than unsupported version.
  static Future<bool> updatesAvailable() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    int deviceSdk = androidInfo.version.sdkInt!;
    const int minSdk = 20;
    if (deviceSdk < minSdk) return false;

    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    var response = await http.get(Uri.parse(
        'https://api.github.com/repos/iqfareez/app_waktu_solat_malaysia/releases/latest'));

    var remoteRelease = GithubReleasesModel.fromJson(jsonDecode(response.body));

    var remoteVersion = remoteRelease.tagName!.split('+');
    int remoteBuildNumber = int.parse(remoteVersion.last);
    int appBuildNumber = int.parse(packageInfo.buildNumber);

    return (appBuildNumber < remoteBuildNumber);
  }

  static Future<GithubReleasesModel> getUpdateInfo() async {
    var response = await http.get(Uri.parse(
        'https://api.github.com/repos/iqfareez/app_waktu_solat_malaysia/releases/latest'));

    var remoteRelease = GithubReleasesModel.fromJson(jsonDecode(response.body));

    return remoteRelease;
  }
}
