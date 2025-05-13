import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../constants.dart';
import '../../../env.dart';
import '../../../shared/utils/launch_url.dart';
import '../model/check_version_response.dart';
import '../services/update_checker_service.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  late final Future<(CheckVersionResponse, PackageInfo)> updateInfo;

  @override
  void initState() {
    super.initState();
    updateInfo = _fetchUpdateInfo();
  }

  Future<(CheckVersionResponse, PackageInfo)> _fetchUpdateInfo() async {
    final githubReleases = await UpdateCheckerService.getUpdateInfo();
    final packageInfo = await PackageInfo.fromPlatform();

    return (githubReleases, packageInfo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<(CheckVersionResponse, PackageInfo)>(
          future: updateInfo,
          builder: (context, snapshot) {
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

            final latestVersion = snapshot.data!.$1;
            final currentVersion = snapshot.data!.$2;

            return LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth > kTabletBreakpoint) {
                return _WideLayout(
                    latestVersion: latestVersion,
                    currentVersion: currentVersion);
              }
              return _DefaultLayout(
                  latestVersion: latestVersion, currentVersion: currentVersion);
            });
          },
        ),
      ),
    );
  }
}

class _DefaultLayout extends StatelessWidget {
  const _DefaultLayout({
    required this.latestVersion,
    required this.currentVersion,
  });

  final CheckVersionResponse latestVersion;
  final PackageInfo currentVersion;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/upgrade-up-circle.svg',
            colorFilter: ColorFilter.mode(
                Theme.of(context).textTheme.displayLarge!.color!,
                BlendMode.srcIn),
            width: 110,
            height: 110,
          ),
          Gap(8),
          Text(
            AppLocalizations.of(context)!.updatePageAvailable,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Gap(35),
          const SizedBox(height: 30),
          Text(latestVersion.releaseTitle,
              style: Theme.of(context).textTheme.headlineLarge!),
          _ReleaseSinceWidget(latestVersion: latestVersion),
          Gap(35),
          MarkdownBody(
              data: AppLocalizations.of(context)!
                  .updatePageLatestVer(latestVersion.version)),
          MarkdownBody(
              data: AppLocalizations.of(context)!
                  .updatePageCurrentVer(currentVersion.version)),
          Gap(35),
          const _CallToActions()
        ],
      ),
    );
  }
}

class _WideLayout extends StatelessWidget {
  const _WideLayout({
    required this.latestVersion,
    required this.currentVersion,
  });

  final CheckVersionResponse latestVersion;
  final PackageInfo currentVersion;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/upgrade-up-circle.svg',
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).textTheme.displayLarge!.color!,
                      BlendMode.srcIn),
                  width: 110,
                  height: 110,
                ),
                Gap(8),
                Text(
                  AppLocalizations.of(context)!.updatePageAvailable,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gap(35),
                const SizedBox(height: 30),
                Text(latestVersion.releaseTitle,
                    style: Theme.of(context).textTheme.headlineLarge!),
                _ReleaseSinceWidget(latestVersion: latestVersion),
                Gap(35),
                MarkdownBody(
                    data: AppLocalizations.of(context)!
                        .updatePageLatestVer(latestVersion.version)),
                MarkdownBody(
                    data: AppLocalizations.of(context)!
                        .updatePageCurrentVer(currentVersion.version)),
                Gap(35),
                const _CallToActions()
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CallToActions extends StatelessWidget {
  const _CallToActions();

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
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () {
                LaunchUrl.normalLaunchUrl(url: envPlayStoreListingLink);
              },
              icon: const FaIcon(FontAwesomeIcons.googlePlay, size: 16),
              label: Text(AppLocalizations.of(context)!.updatePageGPlay)),
          TextButton(
            onPressed: () {
              LaunchUrl.normalLaunchUrl(url: envReleaseNotesLink);
            },
            child: Text(AppLocalizations.of(context)!.whatsUpdateChangelog),
          ),
        ],
      ),
    );
  }
}

class _ReleaseSinceWidget extends StatelessWidget {
  const _ReleaseSinceWidget({required this.latestVersion});

  final CheckVersionResponse latestVersion;

  int _daySinceRelease(DateTime releaseDate) {
    return releaseDate.difference(DateTime.now()).inDays.abs();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      switch (_daySinceRelease(latestVersion.publishedAt)) {
        0 => AppLocalizations.of(context)!.updatePageReleasedToday,
        _ => AppLocalizations.of(context)!
            .updatePageReleased(_daySinceRelease(latestVersion.publishedAt)),
      },
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontStyle: FontStyle.italic,
          ),
    );
  }
}
