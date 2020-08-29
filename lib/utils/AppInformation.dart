import 'package:package_info/package_info.dart';

class AppInfo {
  AppInfo() {
    getAppInfo();
    print('appinfo is constructed');
  }
  String appName = "";
  String packageName = "";
  String version = "";
  String buildNumber = "";
  void getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
  }

  String getAppName() {
    return appName;
  }

  void debugTest() {
    print('Called here on debug tets');
  }
}
