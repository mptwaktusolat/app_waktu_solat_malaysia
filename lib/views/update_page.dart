import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../CONSTANTS.dart';
import '../networking/update_checker.dart';
import '../utils/launch_url.dart';

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

  Future<_UpdateInfo> _fetchUpdateInfo() async {
    var githubReleases = await AppUpdateChecker.getUpdateInfo();
    var packageInfo = await PackageInfo.fromPlatform();

    return _UpdateInfo(
      updateName: githubReleases.name!,
      latestVersion: githubReleases.tagName!.split('+').first,
      currentVersion: packageInfo.version,
      daySinceRelease: DateTime.parse(githubReleases.publishedAt!)
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
          future: _fetchUpdateInfo(),
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
                    AppLocalizations.of(context)!.updatePageError,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    snapshot.error.toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 20),
                  Text(AppLocalizations.of(context)!.updatePageTryAgain),
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
                    AppLocalizations.of(context)!.updatePageAvailable,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 30),
                  Text(snapshot.data!.updateName,
                      style: Theme.of(context).textTheme.headlineSmall!),
                  Text(
                    snapshot.data!.daySinceRelease == 0
                        ? AppLocalizations.of(context)!.updatePageReleasedToday
                        : AppLocalizations.of(context)!
                            .updatePageReleased(snapshot.data!.daySinceRelease),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 20),
                  MarkdownBody(
                      data: AppLocalizations.of(context)!
                          .updatePageCurrentVer(snapshot.data!.currentVersion)),
                  MarkdownBody(
                      data: AppLocalizations.of(context)!
                          .updatePageLatestVer(snapshot.data!.latestVersion)),
                  const SizedBox(height: 20),
                  const _CallToActions()
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CallToActions extends StatelessWidget {
  const _CallToActions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary),
              onPressed: () {
                LaunchUrl.normalLaunchUrl(url: kPlayStoreListingLink);
              },
              icon: const FaIcon(FontAwesomeIcons.googlePlay, size: 16),
              label: Text(AppLocalizations.of(context)!.updatePageGPlay)),
          OutlinedButton(
            onPressed: () {
              LaunchUrl.normalLaunchUrl(url: kReleaseNotesLink);
            },
            child: Text(AppLocalizations.of(context)!.whatsUpdateChangelog),
          ),
          const Divider(),
          OutlinedButton(
            onPressed: () {
              LaunchUrl.normalLaunchUrl(url: "$kGithubRepoLink/releases");
            },
            child: Text(AppLocalizations.of(context)!.updatePageBeta),
          ),
        ],
      ),
    );
  }
}
