import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../CONSTANTS.dart';
import '../locationUtil/locationDatabase.dart';
import '../locationUtil/location_provider.dart';
import '../utils/sizeconfig.dart';
import 'Settings%20part/NotificationSettingPage.dart';
import 'GetPrayerTime.dart';
import 'ZoneChooser.dart';
import 'debug_widgets.dart';

class AppBody extends StatefulWidget {
  const AppBody({Key? key}) : super(key: key);

  @override
  State<AppBody> createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  late BannerAd _ad;
  bool _isAdLoaded = false;
  bool showFirstChild = true;
  late bool _showNotifPrompt;

  @override
  void initState() {
    super.initState();
    _showNotifPrompt = GetStorage().read(kShowNotifPrompt) &&
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
  }

  Future<RemoteConfig> fetchRemoteConfig() async {
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
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (GetStorage().read(kHaventIntroducedToNotifType) ?? true) {
        GetStorage().write(kHaventIntroducedToNotifType, false);
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(18),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Image.asset('assets/bam/Clock.png', width: 150),
                  Text('Azan notification is now available.\nTry it out today!',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6),
                  const SizedBox(height: 15),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) =>
                                const NotificationPageSetting()));
                      },
                      child: const Text('Open settings'))
                ]),
              );
            });
      }
    });
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
                                future: fetchRemoteConfig(),
                                builder: (context,
                                    AsyncSnapshot<RemoteConfig> snapshot) {
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
                      child: Consumer<LocationProvider>(
                        builder: (context, value, child) {
                          String shortCode = LocationDatabase.getJakimCode(
                              value.currentLocationIndex!);
                          return Container(
                            margin: const EdgeInsets.all(5.0),
                            padding: const EdgeInsets.all(18.0),
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
                                    content: Text(
                                        'Currently set to ${LocationDatabase.getDaerah(value.currentLocationIndex!)} in ${LocationDatabase.getNegeri(value.currentLocationIndex!)}'),
                                    behavior: SnackBarBehavior.floating,
                                    action: SnackBarAction(
                                      label: 'Change',
                                      onPressed: () {
                                        LocationChooser.openLocationBottomSheet(
                                            context);
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
                                    '  ${shortCode.substring(0, 3).toUpperCase()}  ${shortCode.substring(3, 5)}',
                                    style: GoogleFonts.montserrat(
                                      textStyle: const TextStyle(
                                          color: Colors.white, fontSize: 13),
                                    ),
                                  ),
                                ],
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
          Builder(builder: (context) {
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
    return Builder(builder: (builder) {
      if (_showNotifPrompt) {
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: Opacity(
                  opacity: 0.8,
                  child: Text(
                    'Did notification(s) from this app shows at prayer time?',
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
                        setState(() {
                          showFirstChild = false;
                        });
                        Future.delayed(const Duration(seconds: 3))
                            .then((value) => setState(() {
                                  _showNotifPrompt = false;
                                  GetStorage().write(kShowNotifPrompt, false);
                                }));
                      },
                      child: const Text('Yes')),
                  TextButton(
                      style: TextButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const NotificationPageSetting()));
                      },
                      child: const Text('No'))
                ],
              )
            ],
          ),
          secondChild: const Padding(
            padding: EdgeInsets.all(4.0),
            child: Opacity(
              opacity: 0.8,
              child: Text(
                'Cool. Glad to hear that!',
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
          DateFormat('EEEE').format(DateTime.now()),
          style: GoogleFonts.spartan(color: Colors.white),
        ),
        AutoSizeText(
          HijriCalendar.fromDate(DateTime.now().add(_hijriOffset))
              .toFormat("dd MMMM yyyy"),
          style: GoogleFonts.acme(color: Colors.white, fontSize: 17),
          stepGranularity: 1,
        ),
        Text(
          DateFormat('dd MMM yyyy').format(DateTime.now()),
          style: TextStyle(color: Colors.teal.shade100, fontSize: 12),
        ),
      ],
    );
  }
}
