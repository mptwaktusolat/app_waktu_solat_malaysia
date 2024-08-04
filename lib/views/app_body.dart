import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotspot/hotspot.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../components/ads_widget.dart';
import '../constants.dart';
import '../features/check_updates/services/update_checker_service.dart';
import '../features/check_updates/views/whats_new_update.dart';
import '../features/home/views/components/exact_alarm_permission_off_sheet.dart';
import '../features/home/views/components/notification_permission_off_sheet.dart';
import '../location_utils/location_database.dart';
import '../providers/location_provider.dart';
import '../providers/updater_provider.dart';
import '../utils/prayer_data_handler.dart';
import 'notif_prompt.dart';
import 'prayer_time_view.dart';
import 'zone_chooser.dart';

class AppBody extends StatefulWidget {
  const AppBody({super.key});

  @override
  State<AppBody> createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  @override
  void initState() {
    super.initState();

    _checkForUpdate();
    _showUpdateNotesAndNotFirstRun();
    _promptScheduleNotificationPermission();

    Future.delayed(const Duration(milliseconds: 550)).then((_) {
      _showOnboardingCoachmarks();
    });
  }

  void _checkForUpdate() async {
    try {
      final res = await UpdateCheckerService.updatesAvailable();
      if (!res) return;

      Provider.of<UpdaterProvider>(context, listen: false).needForUpdate = res;
    } on SocketException catch (e) {
      debugPrint('Error checking for update: $e');
      return;
    }
  }

  /// Show update dialog if app if recently updated
  void _showUpdateNotesAndNotFirstRun() async {
    final version =
        await PackageInfo.fromPlatform().then((value) => value.version);

    final bool shouldShowDialog = !GetStorage().read(kIsFirstRun) &&
        GetStorage().read<String>(version) == null;

    GetStorage()
        .write(kIsFirstRun, false); // app no longer consider as first run

    if (shouldShowDialog) {
      await showDialog(
          context: context, builder: (_) => const WhatsNewUpdateDialog());
    }
    GetStorage().write(version,
        DateTime.now().toString()); // write something to the version key
  }

  /// Request schedule notification permission. The permission already requested from the onboarding page,
  /// but for users that have their system upgraded, the permission will be requested here.
  void _promptScheduleNotificationPermission() async {
    // First, check is notification is enabled at all
    final isNotificationGranted = await Permission.notification.status;
    debugPrint('Notification permission status: $isNotificationGranted');

    // kalau user dah kata keep off, maka keep off je, takyah tnjuk any of this sheets
    if (GetStorage().read(kNotificationSheetKeepOff)) return;

    if (!isNotificationGranted.isGranted) {
      final PermissionStatus? status = await showModalBottomSheet(
        context: context,
        builder: (_) {
          return NotificationPermissionOffSheet(
            onTurnOnNotification: () async {
              final res = await Permission.notification.request();
              Navigator.pop(context, res);
            },
            onCancelModal: () {
              // mark that the user doesn't want to be notified
              GetStorage().write(kNotificationSheetKeepOff, true);
              Navigator.pop(context);
            },
          );
        },
      );

      if (status != PermissionStatus.granted) {
        // TODO: Show toast to tell this setting can be found in the settings
        return; // Will not trigger the next checking for exact alarm permission
      }
    }

    final isScheduleExactAlarmGranted =
        await Permission.scheduleExactAlarm.status;
    debugPrint(
        'Schedule exact alarm permission status: $isScheduleExactAlarmGranted');

    if (isScheduleExactAlarmGranted.isGranted) return;

    final PermissionStatus? exactAlarmStatus = await showModalBottomSheet(
      context: context,
      builder: (_) {
        return ExactAlarmPermissionOffSheet(
          onGrantPermission: () async {
            final res = await Permission.scheduleExactAlarm.request();
            Navigator.pop(context, res);
          },
          onCancelModal: () {
            Navigator.pop(context);
            // TODO: Show toast to tell this setting can be found in the settings
          },
        );
      },
    );

    if (exactAlarmStatus != PermissionStatus.granted) {
      // TODO: Show another modal says to open settings later
      return;
    }

    Fluttertoast.showToast(
        msg: 'Thank you for granting the permissions needed');
  }

  void _showOnboardingCoachmarks() async {
    final coachmarkOnboardingShown =
        GetStorage().read(kCoachmarkOnboardingShown) ?? false;

    if (!coachmarkOnboardingShown) {
      HotspotProvider.of(context).startFlow(kOnboardingCoachmarkFlow);
      GetStorage().write(kCoachmarkOnboardingShown, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (_, value, __) {
        return FutureBuilder<String>(
          future: PrayDataHandler.init(value.currentLocationCode),
          builder: (_, snapshot) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceTint,
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(40)),
                  ),
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: DateWidget(hijriDate: snapshot.data ?? "..."),
                      ),
                      Expanded(
                        child: const ZoneWidget().withHotspot(
                          order: 1,
                          title: AppLocalizations.of(context)!
                              .onboardingCoachmarkLocationTitle,
                          text: AppLocalizations.of(context)!
                              .onboardingCoachmarkLocationContent,
                          flow: kOnboardingCoachmarkFlow,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 3),
                const AdsWidget(),
                const NotifPrompt(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26),
                  child: Builder(builder: (_) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Loading();
                    }
                    if (snapshot.hasError) {
                      return ErrorWidget(
                          errorMessage: snapshot.error.toString(),
                          onRetryPressed: () => setState(() {}));
                    }

                    // display the list of prayer timee
                    return const PrayTimeList();
                  }),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class ZoneWidget extends StatelessWidget {
  const ZoneWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (_, value, __) {
        final String shortCode = value.currentLocationCode;
        return Container(
          margin: const EdgeInsets.all(5.0),
          padding: const EdgeInsets.all(18.0),
          // alignment: Alignment.center,
          child: Semantics(
            button: true,
            label: AppLocalizations.of(context)!.appBodyLocSemanticLabel,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              onPressed: () {
                LocationChooser.showLocationChooser(context);
              },
              onLongPress: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!
                        .appBodyCurrentLocation(
                            LocationDatabase.daerah(value.currentLocationCode),
                            LocationDatabase.negeri(
                                value.currentLocationCode))),
                    behavior: SnackBarBehavior.floating,
                    action: SnackBarAction(
                      label:
                          AppLocalizations.of(context)!.appBodyChangeLocation,
                      onPressed: () {
                        LocationChooser.openManualZoneSelector(context);
                      },
                    ),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(FontAwesomeIcons.locationDot,
                      color: Theme.of(context).colorScheme.onPrimary, size: 15),
                  Text(
                    '  ${shortCode.substring(0, 3).toUpperCase()}  ${shortCode.substring(3, 5)}',
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class DateWidget extends StatelessWidget {
  const DateWidget({super.key, required this.hijriDate});

  final String hijriDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary.withAlpha(70),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            children: [
              Text(
                DateFormat('EEEE', AppLocalizations.of(context)?.localeName)
                    .format(DateTime.now()),
                style: GoogleFonts.leagueSpartan(
                    color: Theme.of(context).colorScheme.onPrimary),
                // style: GoogleFonts.leagueSpartan(),
              ),
              Text(
                hijriDate,
                style: GoogleFonts.acme(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 17),
                // style: GoogleFonts.acme(),
              ),
              Text(
                DateFormat(
                        'd MMM yyyy', AppLocalizations.of(context)?.localeName)
                    .format(DateTime.now()),
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({super.key, this.errorMessage, this.onRetryPressed});

  final String? errorMessage;
  final Function? onRetryPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 15),
        Text(
          errorMessage!.isEmpty
              ? AppLocalizations.of(context)!.getPtError
              : errorMessage!,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: onRetryPressed as void Function()?,
          child: Text(
            AppLocalizations.of(context)!.getPtRetry,
          ),
        ),
        const SizedBox(height: 350),
      ],
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        Text(
          AppLocalizations.of(context)!.getPtFetch,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 200),
          child: SpinKitChasingDots(
            size: 35,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
