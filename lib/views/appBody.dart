import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../CONSTANTS.dart';
import '../locationUtil/locationDatabase.dart';
import '../providers/location_provider.dart';
import '../providers/updater_provider.dart';
import '../utils/sizeconfig.dart';
import '../utils/update_checker.dart';
import 'GetPrayerTime.dart';
import 'Settings%20part/NotificationSettingPage.dart';
import 'ZoneChooser.dart';
import 'debug_widgets.dart';
import 'whats_new_update.dart';

class AppBody extends StatefulWidget {
  const AppBody({Key? key}) : super(key: key);

  @override
  State<AppBody> createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  late BannerAd _ad;
  bool _isAdLoaded = false;
  bool showFirstChild = true;
  late bool _shouldShowNotifPrompt;

  @override
  void initState() {
    super.initState();
    _shouldShowNotifPrompt = GetStorage().read(kShowNotifPrompt) &&
        GetStorage().read(kAppLaunchCount) > 5;

    MobileAds.instance.updateRequestConfiguration(RequestConfiguration(
        testDeviceIds: [
          'DF693493239FEF390746FE861B201FC3',
          'EB458550DFD9A5B6EF3D8FD1A0705EFA'
        ]));

    _ad = BannerAd(
        size: AdSize.banner,
        adUnitId: 'ca-app-pub-1896379146653594/2885992250',
        listener: BannerAdListener(
          onAdLoaded: (_) {
            setState(() {
              _isAdLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            // Releases an ad resource when it fails to load
            ad.dispose();
            throw error;
          },
        ),
        request: const AdRequest());
    _ad.load();

    _checkForUpdate();
    _showUpdateNotes();
  }

  void _checkForUpdate() async {
    var res = await AppUpdateChecker.updatesAvailable();
    if (!res) return;

    Provider.of<UpdaterProvider>(context, listen: false).needForUpdate = res;
  }

  /// Show update dialog if app if recently updated
  void _showUpdateNotes() async {
    var version =
        await PackageInfo.fromPlatform().then((value) => value.version);

    bool _shouldShowDialog = !GetStorage().read(kIsFirstRun) &&
        GetStorage().read<String>(version) == null;

    GetStorage()
        .write(kIsFirstRun, false); // app no longer consider as first run

    if (_shouldShowDialog) {
      await showDialog(
          context: context, builder: (_) => const WhatsNewUpdateDialog());
    }
    GetStorage().write(version,
        DateTime.now().toString()); // write something to the version key
  }

  /// fetch offset value of hijri date
  Future<RemoteConfig> _fetchRemoteConfig() async {
    final RemoteConfig remoteConfig = RemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 15),
      minimumFetchInterval: const Duration(hours: 8),
    ));
    // RemoteConfigValue(null, ValueSource.valueStatic);
    await remoteConfig.fetchAndActivate();
    return remoteConfig;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).appBarTheme.backgroundColor,
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(40)),
            ),
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: [
                          GestureDetector(
                            onLongPress: () {
                              // open to read current hijri offset
                              if (GetStorage()
                                  .read(kDiscoveredDeveloperOption)) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return DebugWidgets.hijriDialog();
                                    });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(70),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: FutureBuilder<RemoteConfig>(
                                future: _fetchRemoteConfig(),
                                builder:
                                    (_, AsyncSnapshot<RemoteConfig> snapshot) {
                                  /// Fetch data from server whenever possible
                                  if (snapshot.hasData) {
                                    int _offset =
                                        snapshot.data!.getInt('hijri_offset');
                                    GetStorage().write(kHijriOffset, _offset);
                                    return DateWidget(
                                      hijriOffset: Duration(days: _offset),
                                    );
                                  } else {
                                    return DateWidget(
                                      hijriOffset: Duration(
                                        days: GetStorage().read(kHijriOffset),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      // TODO: Maybe we can extract this widget
                      // to another file/stless widget
                      child: Consumer<LocationProvider>(
                        builder: (_, value, __) {
                          String _shortCode = value.currentLocationCode;
                          return Container(
                            margin: const EdgeInsets.all(5.0),
                            padding: const EdgeInsets.all(18.0),
                            child: Semantics(
                              button: true,
                              label: AppLocalizations.of(context)!
                                  .appBodyLocSemanticLabel,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(-5.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    side: const BorderSide(color: Colors.white),
                                  ),
                                ),
                                onPressed: () {
                                  LocationChooser.showLocationChooser(context);
                                },
                                onLongPress: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(AppLocalizations.of(
                                              context)!
                                          .appBodyCurrentLocation(
                                              LocationDatabase.daerah(
                                                  value.currentLocationCode),
                                              LocationDatabase.negeri(
                                                  value.currentLocationCode))),
                                      behavior: SnackBarBehavior.floating,
                                      action: SnackBarAction(
                                        label: AppLocalizations.of(context)!
                                            .appBodyChangeLocation,
                                        onPressed: () {
                                          LocationChooser
                                              .openLocationBottomSheet(context);
                                        },
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    FaIcon(FontAwesomeIcons.mapMarkerAlt,
                                        color: Colors.teal.shade50, size: 15),
                                    Text(
                                      '  ${_shortCode.substring(0, 3).toUpperCase()}  ${_shortCode.substring(3, 5)}',
                                      style: GoogleFonts.montserrat(
                                        textStyle: const TextStyle(
                                            color: Colors.white, fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          showNotifPrompt(context),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 26),
            child: GetPrayerTime(),
          ),
          Builder(builder: (_) {
            if (_isAdLoaded) {
              return Container(
                  child: AdWidget(ad: _ad),
                  width: _ad.size.width.toDouble(),
                  height: _ad.size.height.toDouble() + 30,
                  alignment: Alignment.center);
            } else {
              return const SizedBox.shrink();
            }
          })
        ],
      ),
    );
  }

  Builder showNotifPrompt(BuildContext context) {
    return Builder(builder: (_) {
      if (_shouldShowNotifPrompt) {
        return AnimatedCrossFade(
          layoutBuilder: (topChild, topChildKey, bottomChild, bottomChildKey) {
            return Stack(
              clipBehavior: Clip.antiAlias,
              alignment: Alignment.center,
              children: [
                Positioned(
                  child: bottomChild,
                  top: 0,
                  key: bottomChildKey,
                ),
                Positioned(
                  child: topChild,
                  key: topChildKey,
                )
              ],
            );
          },
          duration: const Duration(milliseconds: 200),
          crossFadeState: showFirstChild
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Opacity(
                  opacity: 0.8,
                  child: Text(
                    AppLocalizations.of(context)!.appBodyNotifPrompt,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                      style: TextButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        setState(() => showFirstChild = false);
                        Future.delayed(const Duration(seconds: 3))
                            .then((value) => setState(() {
                                  _shouldShowNotifPrompt = false;
                                  GetStorage().write(kShowNotifPrompt, false);
                                }));
                      },
                      child: Text(
                          AppLocalizations.of(context)!.appBodyNotifPromptYes)),
                  TextButton(
                    style: TextButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const NotificationPageSetting()));
                    },
                    child: Text(
                        AppLocalizations.of(context)!.appBodyNotifPromptNo),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      setState(() {
                        _shouldShowNotifPrompt = false;
                        GetStorage().write(kShowNotifPrompt, false);
                      });
                    },
                    child: Text(
                        AppLocalizations.of(context)!.appBodyNotifPromptDissm),
                  )
                ],
              )
            ],
          ),
          secondChild: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Opacity(
              opacity: 0.8,
              child: Text(
                AppLocalizations.of(context)!.appBodyNotifPromptResponse,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      } else {
        return const SizedBox(height: 10);
      }
    });
  }
}

class DateWidget extends StatelessWidget {
  const DateWidget({
    Key? key,
    required Duration hijriOffset,
  })  : _hijriOffset = hijriOffset,
        super(key: key);

  final Duration _hijriOffset;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          DateFormat('EEEE', AppLocalizations.of(context)?.localeName)
              .format(DateTime.now()),
          style: GoogleFonts.spartan(color: Colors.white),
        ),
        Text(
          HijriCalendar.fromDate(DateTime.now().add(_hijriOffset))
              .toFormat("dd MMMM yyyy"),
          style: GoogleFonts.acme(color: Colors.white, fontSize: 17),
        ),
        Text(
          DateFormat('dd MMM yyyy', AppLocalizations.of(context)?.localeName)
              .format(DateTime.now()),
          style: TextStyle(color: Colors.teal.shade100, fontSize: 12),
        ),
      ],
    );
  }
}
