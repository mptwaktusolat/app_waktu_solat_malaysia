import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';

import '../features/onboarding/controllers/onboarding_permissions_controller.dart';
import '../features/onboarding/views/components/permission_checklist.dart';
import '../features/theme_options/views/theme_options.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../providers/locale_provider.dart';
import '../shared/components/animated_moon.dart';
import '../shared/constants/constants.dart';
import 'settings/notification_page_setting.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});
  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  static const _permissionsPageIndex = 2;
  final _introScreenKey = GlobalKey<IntroductionScreenState>();
  final _pageDecoration = const PageDecoration(
    titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
    bodyTextStyle: TextStyle(fontSize: 19.0),
    bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
    imagePadding: EdgeInsets.all(8.0),
  );

  final _permissions = OnboardingPermissionsController();
  bool _finishing = false;
  AnimationController? _animController;

  // default to azan type. As defined in initGetStorage() in main.dart
  MyNotificationType _notificationType = MyNotificationType.values.elementAt(
    GetStorage().read(kNotificationType),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _permissions.refresh();
    _animController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _permissions.refresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _permissions.dispose();
    _animController?.dispose();
    super.dispose();
  }

  Future<void> _finishOnboarding() async {
    if (_finishing || _permissions.busy) return;
    setState(() => _finishing = true);
    try {
      await _permissions.refresh();
      if (!mounted) return;
      if (!_permissions.allComplete && !await PermissionChecklist.confirmContinue(context)) {
        if (mounted) _introScreenKey.currentState?.animateScroll(_permissionsPageIndex);
        return;
      }
      if (!mounted) return;
      // kIsFirstRun is cleared by the home page's update-note check.
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MyHomePage()));
    } finally {
      if (mounted) setState(() => _finishing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<PageViewModel> pages = [
      PageViewModel(
        title: AppLocalizations.of(context)!.onboardingChooseLang,
        image: Image.asset('assets/3d/chat-bubble-dynamic-color.png', width: 200),
        decoration: _pageDecoration,
        bodyWidget: Consumer<LocaleProvider>(
          builder: (_, value, _) {
            return RadioGroup(
              onChanged: (String? newValue) {
                value.appLocale = newValue!;
              },
              groupValue: value.appLocale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile(value: "en", title: const Text("English")),
                  RadioListTile(value: "ms", title: const Text("Bahasa Malaysia")),
                ],
              ),
            );
          },
        ),
      ),
      PageViewModel(
        image: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Builder(
            builder: (_) {
              final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
              if (isDarkMode) {
                _animController!.forward();
              } else {
                _animController!.reverse();
              }
              return AnimatedMoon(
                animationController: _animController,
                isDarkMode: isDarkMode,
                width: 305,
              );
            },
          ),
        ),
        bodyWidget: const ThemeOptions(),
        title: AppLocalizations.of(context)!.onboardingThemeFav,
        decoration: _pageDecoration,
      ),
      PageViewModel(
        title: AppLocalizations.of(context)!.onboardingPermissionsTitle,
        bodyWidget: PermissionChecklist(controller: _permissions),
        image: Image.asset('assets/3d/Light.png', width: 200),
        decoration: _pageDecoration,
      ),
      PageViewModel(
        image: Image.asset('assets/3d/Clock-1.png', width: 200),
        title: AppLocalizations.of(context)!.onboardingNotifOption,
        decoration: _pageDecoration,
        bodyWidget: RadioGroup(
          onChanged: (MyNotificationType? type) {
            GetStorage().write(kNotificationType, type?.index);
            setState(() => _notificationType = type!);
          },
          groupValue: _notificationType,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile(
                value: MyNotificationType.noazan,
                title: Text(AppLocalizations.of(context)!.onboardingNotifDefault),
              ),
              RadioListTile(
                value: MyNotificationType.shortAzan,
                title: Text(AppLocalizations.of(context)!.onboardingNotifShortAzan),
              ),
              RadioListTile(
                value: MyNotificationType.azan,
                title: Text(AppLocalizations.of(context)!.onboardingNotifAzan),
              ),
            ],
          ),
        ),
      ),
      PageViewModel(
        title: AppLocalizations.of(context)!.onboardingFinish,
        body: AppLocalizations.of(context)!.onboardingFinishDesc,
        image: Image.asset('assets/3d/Succes.png', width: 200),
        decoration: _pageDecoration,
      ),
    ];
    return IntroductionScreen(
      key: _introScreenKey,
      // enable safe area at the bottom. https://github.com/mptwaktusolat/app_waktu_solat_malaysia/issues/258
      safeAreaList: [false, false, false, true],
      pages: pages,
      dotsDecorator: DotsDecorator(
        activeColor: Theme.of(context).colorScheme.primary,
        size: const Size.square(9.0),
        activeSize: const Size(18.0, 9.0),
        activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
      next: Text(
        AppLocalizations.of(context)!.onboardingNext,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      overrideDone: (context, onDone) => ListenableBuilder(
        listenable: _permissions,
        builder: (context, _) => TextButton(
          onPressed: _finishing || _permissions.busy ? null : onDone,
          child: Text(
            AppLocalizations.of(context)!.onboardingDone,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      doneSemantic: "Done button",
      nextSemantic: "Next button",
      curve: Curves.fastLinearToSlowEaseIn,
      onDone: _finishOnboarding,
    );
  }
}
