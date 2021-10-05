/// Compare app version with GitHub releases version

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import '../models/github_releases_model.dart';

class AppUpdateChecker {
  static Future<bool> check() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    var response = await http.get(Uri.parse(
        'https://api.github.com/repos/iqfareez/app_waktu_solat_malaysia/releases/latest'));

    var remoteRelease = GithubReleasesModel.fromJson(jsonDecode(response.body));

    var remoteVersion = remoteRelease.tagName!.split('+');
    int remoteBuildNumber = int.parse(remoteVersion.last);
    int appBuildNumber = int.parse(packageInfo.buildNumber);

    return (appBuildNumber < remoteBuildNumber);
  }
}
