import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:waktusolat_api_client/waktusolat_api_client.dart';

import '../../../shared/constants/constants.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/services/notification_services/notification_scheduler.dart';
import '../../../shared/services/notification_services/prevent_update_notifs.dart';
import '../../../providers/setting_provider.dart';
import '../../../shared/extensions/date_time_extensions.dart';
import '../providers/prayer_time_provider.dart';

/// Widget that displays the list of prayer times for today.
/// This widget is purely UI-focused and delegates all business logic
/// to the PrayerTimeProvider.
class PrayerTimeListWidget extends StatefulWidget {
  const PrayerTimeListWidget({super.key});

  @override
  State<PrayerTimeListWidget> createState() => _PrayerTimeListWidgetState();
}

class _PrayerTimeListWidgetState extends State<PrayerTimeListWidget> {
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(onStateChange: _onStateChanged);
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  void _onStateChanged(AppLifecycleState state) {
    // When app resumes from background, refresh UI so that
    // the highlighted current prayer time can be updated
    if (state == AppLifecycleState.resumed) setState(() {});
  }

  /// Schedules prayer notifications if needed
  void _scheduleNotificationsIfNeeded(BuildContext context) {
    if (PreventUpdatingNotifs.shouldUpdate()) {
      final prayerProvider = context.read<PrayerTimeProvider>();
      final prayers = prayerProvider.getPrayersForNotification();

      if (prayers != null) {
        MyNotifScheduler.schedulePrayNotification(
          AppLocalizations.of(context)!,
          prayers,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Schedule notifications if needed (only when conditions are met)
    _scheduleNotificationsIfNeeded(context);

    return Consumer<PrayerTimeProvider>(
      builder: (context, prayerProvider, _) {
        final today = prayerProvider.getTodayPrayer();

        if (today == null) {
          return const SizedBox.shrink();
        }

        return Consumer<SettingProvider>(
          builder: (_, setting, __) {
            final bool showOtherPrayerTime = setting.showOtherPrayerTime;
            final now = DateTime.now();

            // Determine which prayer time is currently active
            final currentPrayer = _determineCurrentPrayer(now, today);

            return LayoutBuilder(
              builder: (context, constraints) {
                final prayerCards = _buildPrayerCards(
                  context,
                  today,
                  showOtherPrayerTime,
                  currentPrayer,
                );

                if (constraints.maxWidth < kTabletBreakpoint) {
                  return _buildMobileLayout(prayerCards);
                } else {
                  return _buildTabletLayout(prayerCards);
                }
              },
            );
          },
        );
      },
    );
  }

  /// Determines which prayer is currently active based on the current time
  CurrentPrayer _determineCurrentPrayer(DateTime now, MptPrayer today) {
    if (now.isAfter(today.fajr) && now.isBefore(today.syuruk)) {
      return CurrentPrayer.fajr;
    } else if (now.isAfter(today.dhuhr) && now.isBefore(today.asr)) {
      return CurrentPrayer.dhuhr;
    } else if (now.isAfter(today.asr) && now.isBefore(today.maghrib)) {
      return CurrentPrayer.asr;
    } else if (now.isAfter(today.maghrib) && now.isBefore(today.isha)) {
      return CurrentPrayer.maghrib;
    } else if (now.isAfter(today.isha) &&
        now.isBefore(today.fajr.add(const Duration(days: 1)))) {
      return CurrentPrayer.isha;
    }
    return CurrentPrayer.none;
  }

  /// Builds the list of prayer time cards
  List<Widget> _buildPrayerCards(
    BuildContext context,
    MptPrayer today,
    bool showOtherPrayerTime,
    CurrentPrayer currentPrayer,
  ) {
    final l10n = AppLocalizations.of(context)!;

    return [
      if (showOtherPrayerTime)
        PrayerTimeCard(
          time: today.imsak,
          name: l10n.imsakName,
          isOptional: true,
        ),
      PrayerTimeCard(
        time: today.fajr,
        name: l10n.fajrName,
        isOptional: false,
        isCurrentPrayer: currentPrayer == CurrentPrayer.fajr,
      ),
      if (showOtherPrayerTime)
        PrayerTimeCard(
          time: today.syuruk,
          name: l10n.sunriseName,
          isOptional: true,
        ),
      if (showOtherPrayerTime)
        PrayerTimeCard(
          time: today.dhuha,
          name: l10n.dhuhaName,
          isOptional: true,
        ),
      PrayerTimeCard(
        time: today.dhuhr,
        name: l10n.dhuhrName,
        isOptional: false,
        isCurrentPrayer: currentPrayer == CurrentPrayer.dhuhr,
      ),
      PrayerTimeCard(
        time: today.asr,
        name: l10n.asrName,
        isOptional: false,
        isCurrentPrayer: currentPrayer == CurrentPrayer.asr,
      ),
      PrayerTimeCard(
        time: today.maghrib,
        name: l10n.maghribName,
        isOptional: false,
        isCurrentPrayer: currentPrayer == CurrentPrayer.maghrib,
      ),
      PrayerTimeCard(
        time: today.isha,
        name: l10n.ishaName,
        isOptional: false,
        isCurrentPrayer: currentPrayer == CurrentPrayer.isha,
      ),
      const SizedBox(height: 10), // Bottom spacing
    ];
  }

  /// Builds the mobile layout (Column)
  Widget _buildMobileLayout(List<Widget> prayerCards) {
    return AnimationLimiter(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: AnimationConfiguration.toStaggeredList(
          childAnimationBuilder: (widget) {
            return SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(child: widget),
            );
          },
          children: prayerCards,
        ),
      ),
    );
  }

  /// Builds the tablet layout (Wrap)
  Widget _buildTabletLayout(List<Widget> prayerCards) {
    return AnimationLimiter(
      child: Wrap(
        children: AnimationConfiguration.toStaggeredList(
          childAnimationBuilder: (widget) {
            return SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(child: widget),
            );
          },
          children: prayerCards,
        ),
      ),
    );
  }
}

/// Enum to track which prayer is currently active
enum CurrentPrayer {
  none,
  fajr,
  dhuhr,
  asr,
  maghrib,
  isha,
}

/// Individual prayer time card widget
class PrayerTimeCard extends StatelessWidget {
  const PrayerTimeCard({
    super.key,
    required this.time,
    required this.name,
    required this.isOptional,
    this.isCurrentPrayer = false,
  });

  final DateTime time;
  final String name;

  /// Whether this is an optional prayer time (Imsak, Syuruk, Dhuha)
  final bool isOptional;

  /// Whether this is the current active prayer time
  final bool isCurrentPrayer;

  @override
  Widget build(BuildContext context) {
    // Check if the time is not in Malaysia timezone (GMT+8)
    final isOtherTimezone =
        time.timeZoneOffset.compareTo(const Duration(hours: 8)) != 0;

    return Consumer<SettingProvider>(
      builder: (_, settings, __) => Container(
        constraints: const BoxConstraints(maxWidth: 320),
        margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 320,
        ),
        height: isOptional ? 55 : 80,
        child: Card(
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            splashColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            onLongPress: () => _copyToClipboard(context, settings.use12hour),
            child: Center(
              child: Text(
                _formatTimeDisplay(
                  context,
                  settings.use12hour,
                  isOtherTimezone,
                ),
                style: TextStyle(
                  fontSize: settings.prayerFontSize,
                  fontWeight:
                      isCurrentPrayer ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Formats the time display with name and timezone info if needed
  String _formatTimeDisplay(
    BuildContext context,
    bool use12hour,
    bool isOtherTimezone,
  ) {
    final timeString = time.readable(use12hour);
    final timezoneInfo = isOtherTimezone ? ' (${time.timeZoneName})' : '';
    return AppLocalizations.of(context)!
        .getPtTimeAt(name, timeString + timezoneInfo);
  }

  /// Copies the prayer time to clipboard
  void _copyToClipboard(BuildContext context, bool use12hour) {
    final timeString = time.readable(use12hour);
    Clipboard.setData(ClipboardData(text: '$name: $timeString')).then((_) {
      Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.getPtCopied,
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.grey.shade700,
        textColor: Colors.white,
      );
    });
  }
}
