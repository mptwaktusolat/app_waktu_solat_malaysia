import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotspot/hotspot.dart';
import 'package:provider/provider.dart';

import 'shared/constants/constants.dart';
import 'features/bottom_menus/views/bottom_menu_bar.dart';
import 'features/home/views/home_page.dart';
import 'features/prayer_time/providers/prayer_time_provider.dart';
import 'features/sharing/views/share_floating_action_button.dart';
import 'l10n/app_localizations.dart';
import 'providers/locale_provider.dart';
import 'providers/location_provider.dart';
import 'providers/setting_provider.dart';
import 'providers/theme_controller.dart';
import 'providers/timetable_provider.dart';
import 'providers/updater_provider.dart';
import 'shared/utils/app_launch_counter.dart';
import 'shared/utils/quick_action_registrar.dart';
import 'shared/utils/startup_routine.dart';
import 'views/onboarding_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StartupRoutine.initialize();

  runApp(const MyApp());

  StartupRoutine.showReviewPrompt();

  /// Increment app launch counter
  AppLaunchCounter.incrementAppLaunches();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // default colour seed for devices that didn't support dynamic colour
  final _primaryColour = Colors.teal;

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => PrayerTimeProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UpdaterProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => TimetableProvider()),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (_, themeValue, localeValue, __) {
          return DynamicColorBuilder(
              builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
            return MaterialApp(
              onGenerateTitle: (context) =>
                  AppLocalizations.of(context)!.appTitle,
              navigatorObservers: <NavigatorObserver>[observer],
              theme: ThemeData(
                colorScheme: lightDynamic ??
                    ColorScheme.fromSeed(seedColor: _primaryColour),
                useMaterial3: true,
              ),
              darkTheme: ThemeData.dark().copyWith(
                colorScheme: darkDynamic ??
                    ColorScheme.fromSeed(
                      seedColor: _primaryColour,
                      brightness: Brightness.dark,
                    ),
              ),
              themeMode: themeValue.themeMode,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: Locale(localeValue.appLocale),
              home: GetStorage().read(kIsFirstRun)
                  ? const OnboardingPage()
                  : const MyHomePage(),
            );
          });
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    QuickActionRegistrar.registerQuickActions(context);
    return HotspotProvider(
      actionBuilder: (context, controller) {
        return HotspotActionBuilder(
          controller,
          doneText: AppLocalizations.of(context)!.coachmarkDone,
          nextText: AppLocalizations.of(context)!.coachmarkNext,
          previousText: AppLocalizations.of(context)!.coachmarkPrevious,
          endText: AppLocalizations.of(context)!.coachmarkEnd,
        );
      },
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
          title: Text(AppLocalizations.of(context)!.appbarTitle,
              style: GoogleFonts.balooTamma2(fontWeight: FontWeight.bold)),
          elevation: 0.0,
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.surface,
          centerTitle: true,
          toolbarHeight: 50,
        ),
        // known issue that causes white line appear between appbar and widget below
        // https://github.com/flutter/flutter/issues/14288
        bottomNavigationBar: const BottomMenuBar(),
        floatingActionButton: const ShareFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        body: const SingleChildScrollView(
          child: HomePage(),
        ),
      ),
    );
  }
}
