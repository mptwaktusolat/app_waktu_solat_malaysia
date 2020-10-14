import 'package:package_info/package_info.dart';

class AppInfo {
  AppInfo() {
    getAppInfo();
  }

  String appName = "";
  String packageName = "";
  String version = "";
  String buildNumber = "";
  Future getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
  }
}
