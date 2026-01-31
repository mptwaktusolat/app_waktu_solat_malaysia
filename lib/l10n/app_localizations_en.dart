// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appbarTitle => '🇲🇾 Prayer Time';

  @override
  String get appTitle => 'Malaysia Prayer Time';

  @override
  String get imsakName => 'Imsak';

  @override
  String get imsakDescription => '10 minutes before Subuh';

  @override
  String get fajrName => 'Fajr';

  @override
  String get sunriseName => 'Sunrise';

  @override
  String get sunriseDescription => 'Sunrise';

  @override
  String get dhuhaName => 'Dhuha';

  @override
  String get dhuhaDescription => '28 minutes after Sunrise';

  @override
  String get dhuhrName => 'Dhuhr';

  @override
  String get asrName => 'Asr';

  @override
  String get maghribName => 'Maghrib';

  @override
  String get ishaName => 'Isha';

  @override
  String get genericShare => 'Share';

  @override
  String get getPtFetch => 'Fetching prayer time. Please wait.';

  @override
  String get getPtError => 'Unexpected error. Please retry';

  @override
  String get getPtRetry => 'Retry';

  @override
  String getPtTimeAt(String name, String time) {
    return '$name at $time';
  }

  @override
  String get getPtCopied => 'Copied';

  @override
  String get appBodyNotifPrompt =>
      'Did notification(s) from this app shows at prayer time?';

  @override
  String get appBodyNotifPromptYes => 'Yes';

  @override
  String get appBodyNotifPromptNo => 'No';

  @override
  String get appBodyNotifPromptDissm => 'Dismiss';

  @override
  String get appBodyNotifPromptResponse => 'Cool. Glad to hear that!';

  @override
  String appBodyCurrentLocation(String daerah, String negeri) {
    return 'Currently set to $daerah in $negeri';
  }

  @override
  String get appBodyChangeLocation => 'Change';

  @override
  String get appBodyLocSemanticLabel => 'A button to change location';

  @override
  String get appBodyWrongDeviceTimezone =>
      'Your device timezone is different than the date & time shown here. Please set your timezone to Malaysia (UTC+08:00).';

  @override
  String get onboardingCoachmarkLocationTitle => 'Prayer time location';

  @override
  String get onboardingCoachmarkLocationContent =>
      'Set or change your prayer time location here';

  @override
  String get onboardingCoachmarkUtilitiesTitle =>
      'Additional utilities at your fingertips';

  @override
  String get onboardingCoachmarkUtilitiesContent =>
      'Find the monthly timetable, compass, and digital tasbih here';

  @override
  String get onboardingCoachmarkSettingTitle =>
      'Customize the app to suit your style';

  @override
  String get onboardingCoachmarkSettingContent =>
      'You can enable Dhuha time, time format, language, font size and theme settings here';

  @override
  String get menuThemes => 'Themes';

  @override
  String get menuSettings => 'Settings';

  @override
  String get menuRate => 'Rate and review';

  @override
  String get menuWeb => 'MPT on Web';

  @override
  String get menuFeedback => 'Send feedback';

  @override
  String get menuUpdateAvailable => 'Updates available';

  @override
  String get menuTooltip => 'Open menu';

  @override
  String get menuTimetableTooltip => 'Monthly Timetable';

  @override
  String timetableTitle(String month) {
    return '$month timetable';
  }

  @override
  String get timetableDate => 'Date';

  @override
  String get timetableExportTooltip => 'Export timetable as PDF';

  @override
  String get timetableExportExporting => 'Exporting';

  @override
  String get timetableExportSuccess => 'Prayer timetable PDF file is ready.';

  @override
  String get timetableExportOpen => 'Open';

  @override
  String timetableExportError(String error) {
    return 'Sorry. Error occurred when exporting timetable. Please try again. $error';
  }

  @override
  String timetableExportFileShareSubject(String link) {
    return 'Prayer Timetable. $link';
  }

  @override
  String get timetableOneThird => 'Last 1/3 night';

  @override
  String get timetableSettingTitle => 'Timetable setting';

  @override
  String get timetableSettingHijri => 'Show Hijri column';

  @override
  String get timetableSettingHijriStyle => 'Hijri month style';

  @override
  String get timetableSettingOneThird => 'Show last one third of the night';

  @override
  String get timetableSettingOneThirdSub =>
      'Calculation method based on Mufti of Federal Territory Office';

  @override
  String get timetableSettingShortform => 'Shortform';

  @override
  String get timetableSettingLongform => 'Full';

  @override
  String get themeTitle => 'Theme';

  @override
  String get themeOptionSystem => 'System Theme';

  @override
  String get themeOptionLight => 'Light Theme';

  @override
  String get themeOptionDark => 'Dark Theme';

  @override
  String get themeSupportedDevice => 'On supported device only';

  @override
  String aboutLegalese(String year) {
    return 'Copyright © $year Fareez Iqmal';
  }

  @override
  String get aboutTitle => 'About App';

  @override
  String aboutVersion(String version) {
    return 'Version $version';
  }

  @override
  String get aboutVersionCopied => 'Copied version info';

  @override
  String get aboutJakim =>
      'Prayer times data are from [Department of Islamic Development Malaysia (JAKIM)](https://www.e-solat.gov.my/)';

  @override
  String get aboutContribution => 'Contribution and Support';

  @override
  String get aboutReleaseNotes => 'Release Notes';

  @override
  String get aboutLicense => 'Open Source Licenses';

  @override
  String get aboutPrivacy => 'Privacy Policy';

  @override
  String get aboutRestartOnboardingPage => 'Restart Onboarding Page';

  @override
  String get aboutFaq => 'Documentation';

  @override
  String get aboutMoreApps => 'More apps';

  @override
  String get shareTitle => 'Prayer timetable today';

  @override
  String shareGetApp(String link) {
    return 'Get the app: $link';
  }

  @override
  String get shareTooltip => 'Share solat time';

  @override
  String get sharePlainTitle => 'Share as plain text';

  @override
  String get sharePlainDesc => 'Compatible to all apps';

  @override
  String get shareWhatsappTitle => 'Share to WhatsApp';

  @override
  String get shareWhatsappDesc => 'Using WhatsApp formatting';

  @override
  String get shareCopy => 'Copy to clipboard';

  @override
  String get shareImage => 'Share as Image';

  @override
  String get shareImageFailed => 'Failed to share image';

  @override
  String get shareSubject => 'Malaysia prayer time for today';

  @override
  String get shareTimetableCopied => 'Timetable copied';

  @override
  String get settingTitle => 'Settings';

  @override
  String get settingDisplay => 'Display';

  @override
  String get settingTimeFormat => 'Time format';

  @override
  String settingTimeFormatDropdown(String time) {
    return '$time hour';
  }

  @override
  String get settingOtherPrayer => 'Show other times';

  @override
  String get settingFontSize => 'Font size';

  @override
  String get settingLocaleTitle => 'Language';

  @override
  String get settingNotification => 'Notification';

  @override
  String get settingNotification2 => 'Notification settings';

  @override
  String get settingMore => 'More';

  @override
  String settingAbout(String version) {
    return 'About app (Ver. $version)';
  }

  @override
  String get settingMoreDesc => 'Release Notes, Contribution, Twitter etc.';

  @override
  String get qiblaWarnBody =>
      '- Users must understand that Qibla Compass feature utilises the sensors of the user\'s device and does not use any data from JAKIM. Therefore, users should **wisely evaluate** the information obtained.\n- MPT app provides this function as a **guide** only. MPT app is not responsible if the information obtained is inaccurate. Please refer to the recommended way to get the exact Qibla direction.\n- To improve the accuracy, make sure the internet and GPS connection are stable and perform the calibration by rotating your device in an **8** or **infinity** shape as below:';

  @override
  String get qiblaWarnProceed => 'I understood';

  @override
  String get qiblaTitle => 'Qibla Compass';

  @override
  String get qiblaOverheadWarn =>
      'Avoid placing the device close to metal object or electrical appliances.';

  @override
  String get qiblaCopyUrl => 'URL copied :)';

  @override
  String get qiblaCalibrationTip => 'Calibration tip';

  @override
  String get qiblaCalibrate => 'Move your phone in \'figure 8 pattern\'';

  @override
  String get qiblaCalibrateDone => 'Done';

  @override
  String get qiblaErrNoCompass =>
      'Sorry. No compass sensor is available in this device.';

  @override
  String get qiblaErrBack => 'Go back';

  @override
  String get feedbackTitle => 'Feedback';

  @override
  String get feedbackFieldEmpty => 'Field can\'t be empty';

  @override
  String get feedbackWriteHere => 'Please leave your feedback/report here';

  @override
  String get feedbackIncorrectEmail => 'Incorrect email format';

  @override
  String get feedbackEmailHere => 'Your email address (optional)';

  @override
  String get feedbackViewDeviceInfo => 'View...';

  @override
  String get feedbackDeviceInfoCopy => 'Copied';

  @override
  String get feedbackDeviceInfoCopyAll => 'Copy all';

  @override
  String get feedbackIncludeDeviceInfo => 'Include device info';

  @override
  String get feedbackDeviceInfoRecommended => '(Recommended)';

  @override
  String get feedbackTroubleDeviceInfo => 'Trouble getting device info';

  @override
  String get feedbackGettingInfo => 'Getting device info...';

  @override
  String get feedbackAppMetadata => 'App metadata';

  @override
  String get feedbackAppMetadataSub => '(Always included)';

  @override
  String get feedbackSensitive => 'User sensitive data';

  @override
  String get feedbackSensitiveSub => 'Include whenever necessary';

  @override
  String get feedbackMessageContainQ =>
      'Looks like your message contain question(s). Please provide your email so we can get back to you.\n\nWould you like to add your email?';

  @override
  String get feedbackSendAnyway => 'Send anyway';

  @override
  String get feedbackAddEmail => 'Add email';

  @override
  String get feedbackSend => 'Send';

  @override
  String get feedbackAlsoDo => 'You can also do';

  @override
  String get feedbackReadFaq => 'Read Frequently Asked Questions (FAQ)';

  @override
  String get feedbackReportGithub => 'Report / Follow issues on GitHub';

  @override
  String get feedbackThanks => 'Thank you for your valuable feedback.';

  @override
  String get onboardingChooseLang => 'Choose language';

  @override
  String get onboardingSetLocation => 'Set your location';

  @override
  String get onboardingLocationDesc =>
      'Make sure the location services are turned on so the app can determine the best location';

  @override
  String get onboardingLocationToast =>
      'Location set. You can change location anytime by tapping the location code at upper right corner.';

  @override
  String get onboardingLocationSet => 'Set location';

  @override
  String get onboardingThemeFav => 'Set your favourite theme';

  @override
  String get onboardingNotifOption => 'Select notification preferences';

  @override
  String get onboardingNotifDefault => 'Default notification';

  @override
  String get onboardingNotifAzan => 'Azan (full)';

  @override
  String get onboardingNotifShortAzan => 'Azan (short)';

  @override
  String onboardingNotifAutostart(String link) {
    return '**Autostart** need to be enabled for the app to send notifications. [Learn more...]($link)';
  }

  @override
  String get onboardingNotifAutostartSetting => 'Open Settings';

  @override
  String get onboardingFinish => 'Alhamdulillah. All set';

  @override
  String get onboardingFinishDesc =>
      'Welcome aboard. Do explore other features and tweak other settings as well.';

  @override
  String get onboardingDone => 'Done';

  @override
  String get onboardingNext => 'Next';

  @override
  String get coachmarkDone => 'Done';

  @override
  String get coachmarkNext => 'Next';

  @override
  String get coachmarkPrevious => 'Previous';

  @override
  String get coachmarkEnd => 'End tour';

  @override
  String get permissionDialogTitle => 'Permission required';

  @override
  String get permissionDialogSkip => 'Skip';

  @override
  String get permissionDialogGrant => 'Grant';

  @override
  String get autostartDialogPermissionContent =>
      'Please allow app to Autostart to keep receive notifications even if the device restarts';

  @override
  String get notifDialogPermissionContent =>
      'Please grant the notification permission to allow this app to show notifications';

  @override
  String get notifExactAlarmDialogPermissionContent =>
      'Please grant the app permission to schedule notifications at exact time';

  @override
  String get zoneUpdatedToast => 'Location updated';

  @override
  String get zoneYourLocation => 'Your location';

  @override
  String get zoneSetManually => 'Set manually';

  @override
  String get zoneSetThis => 'Set this location';

  @override
  String get zoneError => 'Error';

  @override
  String get zoneErrorPara1 =>
      'Check your **internet connection** or **location services**.';

  @override
  String get zoneErrorPara2 =>
      'Please **retry** or choose location **manually**.';

  @override
  String get zoneOpenLocationSettings => 'Open Location Settings';

  @override
  String get zoneLoading => 'Loading';

  @override
  String get zoneManualSelectZone => 'Select zone';

  @override
  String zoneUpdatedSuccess(String zone) {
    return 'Prayer zone set to $zone';
  }

  @override
  String get notifSettingBasic => 'Basic';

  @override
  String get notifSettingChangesDetect =>
      'Changes will take effect after restarting the app';

  @override
  String get notifSettingRestartApp => 'Restart';

  @override
  String get notificationSettingPlayNotifTooltip => 'Play test notification';

  @override
  String get notifSettingSysSetting => 'App notification System Setting';

  @override
  String get notifSettingSysSettingDesc =>
      'Customize sound, toggle channel of prayer notification etc.';

  @override
  String get notifSettingTroubleshoot => 'Troubleshooting';

  @override
  String get notifSettingTroubleshootDesc =>
      'Fix notification not working on some devices';

  @override
  String notifSettingTroubleshootExample(String phonesModel) {
    return 'Example: $phonesModel etc.';
  }

  @override
  String get notifSettingAdvancedTroubleshoot => 'Advanced troubleshooting';

  @override
  String get notifSettingLimitNotif => 'Limit notification scheduling';

  @override
  String get notifSettingLimitNotifDesc =>
      'Enable if you experience an extreme slowdown in app. Notification will schedule weekly basis. Default is OFF (monthly).';

  @override
  String get notifSettingForceReschedule =>
      'Force rescheduling notification...';

  @override
  String get notifSettingForceRescheduleDesc =>
      'By default, notification will not reschedule if the last scheduler ran is less than two days.\n\nTap proceed to start an immediate notification scheduling. The app will be restarted.';

  @override
  String get notifSettingCancel => 'Cancel';

  @override
  String get notifSettingProceed => 'Proceed';

  @override
  String get notifSettingNotifDemo =>
      'This is how the notification/azan will sound like';

  @override
  String get notifSettingsExactAlarmPermissionTitle =>
      'Notification scheduling permission';

  @override
  String get notifSettingsExactAlarmPermissionGrantedSubtitle =>
      'Permission granted. The app can send azan notification on prayer times';

  @override
  String get notifSettingsExactAlarmPermissionNotGrantedSubtitle =>
      'Permission not granted. The app cannot send the azan notification. Tap here to grant permission';

  @override
  String get notifSheetExactAlarmTitle =>
      'Enable setting exact notifications permission';

  @override
  String get notifSheetExactAlarmDescription =>
      'Grant now so the app can send timely notifications/azans. Without it, delivery might be delayed.';

  @override
  String get notifSheetExactAlarmPrimaryButton => 'Grant now';

  @override
  String get notifSheetExactAlarmCancel => 'Cancel';

  @override
  String get notifSheetNotificationTitle => 'Notification/Azan is turned off';

  @override
  String get notifSheetNotificationDescription =>
      'We may require some permissions to be able to play the notification/azan';

  @override
  String get notifSheetNotificationPrimaryButton => 'Turn On Notification';

  @override
  String get notifSheetNotificationCancel => 'Keep it off for now';

  @override
  String get contributeShare => 'Share this app';

  @override
  String contributeShareContent(String playStoreShortLink, String webAppLink) {
    return 'Hi. I\'m using the Malaysia Prayer Time app. It\'s fast and free.\n\nTry it now:\n$playStoreShortLink (Google Play)\n$webAppLink (Web app)';
  }

  @override
  String get contributeShareSubject => 'Sharing MPT App';

  @override
  String get contributeCopy => 'Copy';

  @override
  String get contributeOpen => 'Open';

  @override
  String get contributeCopied => 'Copied to clipboard';

  @override
  String get notifTsAdmonition =>
      'Your device may not be affected with this particular issue.';

  @override
  String get notifTsPara1 =>
      'Some apps installed from the **Google Play Store** will disable **Autostart** by default. Due to this behaviour, prayer notification (sometimes) will not appear on your phone.';

  @override
  String get notifTsPara2 =>
      'The solution is to enable **Autostart** for this app. Tap the button below to open App Setting, then find the Autostart option there to enable it.';

  @override
  String notifTsPara3(String link) {
    return 'To learn more, kindly read [this article]($link).';
  }

  @override
  String get notifTsOpenSetting => 'Open App Setting';

  @override
  String get notifMonthlyReminderTitle => 'Monthly refresh reminder';

  @override
  String get notifMonthlyReminderDesc =>
      'To continue receive prayer notification, open app at least once every month.';

  @override
  String notifItsTime(String name) {
    return 'It\'s $name';
  }

  @override
  String notifIn(String location) {
    return 'in $location';
  }

  @override
  String get notifEndSubh => 'Ends of Fajr';

  @override
  String get whatsUpdateTitle => 'App updated to the latest version';

  @override
  String whatsUpdateContent(String releaseNotesLink) {
    return 'What\'s new in this update? Read the [release notes]($releaseNotesLink) for information.';
  }

  @override
  String get whatsUpdateChangelog => 'Release notes';

  @override
  String get updatePageError =>
      'Sorry. Error occurred when checking for update';

  @override
  String get updatePageTryAgain => 'Please try again';

  @override
  String get updatePageAvailable => 'Updates available';

  @override
  String updatePageReleased(int day) {
    return 'Released $day days ago';
  }

  @override
  String get updatePageReleasedToday => 'Released today';

  @override
  String updatePageCurrentVer(String version) {
    return 'You have: **$version**';
  }

  @override
  String updatePageLatestVer(String version) {
    return 'Latest available: **$version**';
  }

  @override
  String get updatePageGPlay => 'Get updates on Google Play';

  @override
  String get tasbihResetDialog => 'Confirm reset ?';

  @override
  String get tasbihReset => 'Reset';

  @override
  String get tasbihResetTooltip => 'Reset tasbih counter';

  @override
  String get tasbihColorPickerTooltip => 'Choose tasbih bead color';
}
