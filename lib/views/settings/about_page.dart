import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../constants.dart';
import '../../env.dart';
import '../../providers/setting_provider.dart';
import '../../utils/launch_url.dart';
import '../debug_dialog.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key, this.packageInfo});
  final PackageInfo? packageInfo;

  @override
  Widget build(BuildContext context) {
    bool isFirstTry = true;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.aboutTitle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8.0),
          child: Consumer<SettingProvider>(
            builder: (_, setting, __) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Hack to make the app icon in the center
                      // The value is just I come up with by just eyeballing the logo to be in the center
                      // I tried with Stack and Positioned, but the IconButton's gesture didn't work
                      SizedBox(width: 42),
                      GestureDetector(
                        onLongPress: () {
                          if (isFirstTry && !setting.isDeveloperOption) {
                            Fluttertoast.showToast(msg: '(⌐■_■)');
                            isFirstTry = false;
                          } else {
                            if (!setting.isDeveloperOption) {
                              Fluttertoast.showToast(
                                  msg: 'Developer mode discovered',
                                  toastLength: Toast.LENGTH_LONG,
                                  backgroundColor: Colors.teal);

                              setting.isDeveloperOption = true;
                            }
                            // Show the debug dialog
                            showDialog(
                              context: context,
                              builder: (context) => const DebugDialog(),
                            );
                          }
                        },
                        child: Hero(
                          tag: kAppIconTag,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: CachedNetworkImage(
                              width: 70,
                              height: 70,
                              fit: BoxFit.scaleDown,
                              imageUrl: kAppIconUrl,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: CircularProgressIndicator(
                                    value: downloadProgress.progress),
                              ),
                              errorWidget: (context, url, error) =>
                                  const FaIcon(FontAwesomeIcons.exclamation),
                            ),
                          ),
                        ),
                      ),
                      // Share App Button
                      IconButton(
                        tooltip: AppLocalizations.of(context)!.contributeShare,
                        onPressed: () {
                          Share.share(
                              AppLocalizations.of(context)!
                                  .contributeShareContent(
                                      envPlayStoreListingShortLink,
                                      envWebappUrl),
                              subject: AppLocalizations.of(context)!
                                  .contributeShareSubject);
                        },
                        icon: Icon(Icons.adaptive.share),
                      )
                    ],
                  ),
                  const Text(
                    '\nMalaysia Prayer Time',
                    textAlign: TextAlign.center,
                  ),
                  GestureDetector(
                    onLongPress: () {
                      Clipboard.setData(
                              ClipboardData(text: packageInfo!.version))
                          .then((value) => Fluttertoast.showToast(
                              msg: AppLocalizations.of(context)!
                                  .aboutVersionCopied));
                    },
                    child: Text(
                      AppLocalizations.of(context)!
                          .aboutVersion(packageInfo!.version),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(10)),
                    child: MarkdownBody(
                      data: AppLocalizations.of(context)!.aboutJakim,
                      styleSheet:
                          MarkdownStyleSheet(textAlign: WrapAlignment.center),
                      onTapLink: (_, href, __) =>
                          LaunchUrl.normalLaunchUrl(url: href!),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    clipBehavior: Clip.hardEdge,
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      title: Text(
                        AppLocalizations.of(context)!.aboutReleaseNotes,
                        textAlign: TextAlign.center,
                      ),
                      onTap: () => LaunchUrl.normalLaunchUrl(
                          url: envReleaseNotesLink, useCustomTabs: true),
                    ),
                  ),
                  Card(
                    clipBehavior: Clip.hardEdge,
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      title: Text(
                        AppLocalizations.of(context)!.aboutFaq,
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        final helpPageUrl = Uri.parse(envAppSupportWebsite)
                            .resolve('/docs/intro')
                            .toString();
                        LaunchUrl.normalLaunchUrl(url: helpPageUrl);
                      },
                    ),
                  ),
                  Card(
                    clipBehavior: Clip.hardEdge,
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      title: Text(
                        AppLocalizations.of(context)!.aboutLicense,
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        showLicensePage(
                            context: context,
                            applicationName: packageInfo!.appName,
                            applicationVersion: packageInfo!.version,
                            applicationIcon: Hero(
                              tag: kAppIconTag,
                              child: CachedNetworkImage(
                                width: 70,
                                imageUrl: kAppIconUrl,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ));
                      },
                    ),
                  ),
                  Card(
                    clipBehavior: Clip.hardEdge,
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      title: Text(
                        AppLocalizations.of(context)!.aboutPrivacy,
                        textAlign: TextAlign.center,
                      ),
                      onTap: () => LaunchUrl.normalLaunchUrl(
                          url: envPrivacyPolicyLink, useCustomTabs: true),
                    ),
                  ),
                  const Divider(height: 16),
                  Card(
                    clipBehavior: Clip.hardEdge,
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      title: Text(
                        AppLocalizations.of(context)!.aboutMoreApps,
                        textAlign: TextAlign.center,
                      ),
                      onTap: () =>
                          LaunchUrl.normalLaunchUrl(url: envPlayStoreDevLink),
                    ),
                  ),
                  Card(
                    clipBehavior: Clip.hardEdge,
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      title: const Text('Twitter', textAlign: TextAlign.center),
                      onTap: () =>
                          LaunchUrl.normalLaunchUrl(url: envDevTwitter),
                    ),
                  ),
                  Card(
                    clipBehavior: Clip.hardEdge,
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      title: const Text(
                        'Dev logs',
                        textAlign: TextAlign.center,
                      ),
                      onTap: () =>
                          LaunchUrl.normalLaunchUrl(url: envInstaStoryDevlog),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Opacity(
                      opacity: 0.58,
                      child: TextButton(
                        onPressed: () => LaunchUrl.normalLaunchUrl(
                            url: 'https://iqfareez.com'),
                        child: Text(
                          AppLocalizations.of(context)!
                              .aboutLegalese("2020-2025"),
                          style: Theme.of(context).textTheme.labelMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
