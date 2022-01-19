import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../CONSTANTS.dart';
import '../utils/launchUrl.dart';
import '../utils/update_checker.dart';

class _UpdateInfo {
  String updateName;
  String latestVersion;
  String currentVersion;
  int daySinceRelease;

  _UpdateInfo({
    required this.updateName,
    required this.latestVersion,
    required this.currentVersion,
    required this.daySinceRelease,
  });
}

class UpdatePage extends StatelessWidget {
  const UpdatePage({Key? key}) : super(key: key);

  Future<_UpdateInfo> fetchUpdateInfo() async {
    var _githubReleases = await AppUpdateChecker.getUpdateInfo();
    var _packageInfo = await PackageInfo.fromPlatform();

    return _UpdateInfo(
      updateName: _githubReleases.name!,
      latestVersion: _githubReleases.tagName!.split('+').first,
      currentVersion: _packageInfo.version,
      daySinceRelease: DateTime.parse(_githubReleases.publishedAt!)
          .difference(DateTime.now())
          .inDays
          .abs(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: fetchUpdateInfo(),
          builder: (context, AsyncSnapshot<_UpdateInfo> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LinearProgressIndicator(
                color: Theme.of(context).primaryColor,
              );
            }

            if (snapshot.hasError) {
              return Center(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Error occured when checking for update",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Text(
                    snapshot.error.toString(),
                    style: Theme.of(context).textTheme.caption,
                  ),
                  const SizedBox(height: 20),
                  const Text("Please try again"),
                ],
              ));
            }

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Updates available",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    snapshot.data!.updateName,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Text(
                    "Released ${snapshot.data!.daySinceRelease} days ago",
                    style: Theme.of(context).textTheme.caption,
                  ),
                  const SizedBox(height: 20),
                  Text('You have: ${snapshot.data?.currentVersion}'),
                  Text("Latest available: ${snapshot.data?.latestVersion}"),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(primary: Colors.teal),
                      onPressed: () {
                        LaunchUrl.normalLaunchUrl(url: kPlayStoreListingLink);
                      },
                      icon: const FaIcon(FontAwesomeIcons.googlePlay, size: 16),
                      label: const Text("Get updates on Google Play")),
                  TextButton(
                      onPressed: () {
                        LaunchUrl.normalLaunchUrl(
                            url: "https://bit.ly/mptchanges");
                      },
                      child: const Text("Read release notes"))
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
