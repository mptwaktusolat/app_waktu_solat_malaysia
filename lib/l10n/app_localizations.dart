import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ms.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ms')
  ];

  /// app title material app
  ///
  /// In en, this message translates to:
  /// **'🇲🇾 Prayer Time'**
  String get appbarTitle;

  /// Will show on RECENT (Android)
  ///
  /// In en, this message translates to:
  /// **'Malaysia Prayer Time'**
  String get appTitle;

  /// No description provided for @imsakName.
  ///
  /// In en, this message translates to:
  /// **'Imsak'**
  String get imsakName;

  /// No description provided for @imsakDescription.
  ///
  /// In en, this message translates to:
  /// **'10 minutes before Subuh'**
  String get imsakDescription;

  /// No description provided for @fajrName.
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get fajrName;

  /// No description provided for @sunriseName.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get sunriseName;

  /// No description provided for @sunriseDescription.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get sunriseDescription;

  /// No description provided for @dhuhaName.
  ///
  /// In en, this message translates to:
  /// **'Dhuha'**
  String get dhuhaName;

  /// No description provided for @dhuhaDescription.
  ///
  /// In en, this message translates to:
  /// **'28 minutes after Sunrise'**
  String get dhuhaDescription;

  /// No description provided for @dhuhrName.
  ///
  /// In en, this message translates to:
  /// **'Dhuhr'**
  String get dhuhrName;

  /// No description provided for @asrName.
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get asrName;

  /// No description provided for @maghribName.
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get maghribName;

  /// No description provided for @ishaName.
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get ishaName;

  /// No description provided for @genericShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get genericShare;

  /// No description provided for @getPtFetch.
  ///
  /// In en, this message translates to:
  /// **'Fetching prayer time. Please wait.'**
  String get getPtFetch;

  /// No description provided for @getPtError.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error. Please retry'**
  String get getPtError;

  /// No description provided for @getPtRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get getPtRetry;

  /// No description provided for @getPtTimeAt.
  ///
  /// In en, this message translates to:
  /// **'{name} at {time}'**
  String getPtTimeAt(String name, String time);

  /// No description provided for @getPtCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get getPtCopied;

  /// No description provided for @appBodyNotifPrompt.
  ///
  /// In en, this message translates to:
  /// **'Did notification(s) from this app shows at prayer time?'**
  String get appBodyNotifPrompt;

  /// No description provided for @appBodyNotifPromptYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get appBodyNotifPromptYes;

  /// No description provided for @appBodyNotifPromptNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get appBodyNotifPromptNo;

  /// No description provided for @appBodyNotifPromptDissm.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get appBodyNotifPromptDissm;

  /// No description provided for @appBodyNotifPromptResponse.
  ///
  /// In en, this message translates to:
  /// **'Cool. Glad to hear that!'**
  String get appBodyNotifPromptResponse;

  /// No description provided for @appBodyCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Currently set to {daerah} in {negeri}'**
  String appBodyCurrentLocation(String daerah, String negeri);

  /// No description provided for @appBodyChangeLocation.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get appBodyChangeLocation;

  /// No description provided for @appBodyLocSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'A button to change location'**
  String get appBodyLocSemanticLabel;

  /// No description provided for @appBodyWrongDeviceTimezone.
  ///
  /// In en, this message translates to:
  /// **'Your device timezone is different than the date & time shown here. Please set your timezone to Malaysia (UTC+08:00).'**
  String get appBodyWrongDeviceTimezone;

  /// No description provided for @onboardingCoachmarkLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer time location'**
  String get onboardingCoachmarkLocationTitle;

  /// No description provided for @onboardingCoachmarkLocationContent.
  ///
  /// In en, this message translates to:
  /// **'Set or change your prayer time location here'**
  String get onboardingCoachmarkLocationContent;

  /// No description provided for @onboardingCoachmarkUtilitiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Additional utilities at your fingertips'**
  String get onboardingCoachmarkUtilitiesTitle;

  /// No description provided for @onboardingCoachmarkUtilitiesContent.
  ///
  /// In en, this message translates to:
  /// **'Find the monthly timetable, compass, and digital tasbih here'**
  String get onboardingCoachmarkUtilitiesContent;

  /// No description provided for @onboardingCoachmarkSettingTitle.
  ///
  /// In en, this message translates to:
  /// **'Customize the app to suit your style'**
  String get onboardingCoachmarkSettingTitle;

  /// No description provided for @onboardingCoachmarkSettingContent.
  ///
  /// In en, this message translates to:
  /// **'You can enable Dhuha time, time format, language, font size and theme settings here'**
  String get onboardingCoachmarkSettingContent;

  /// No description provided for @menuThemes.
  ///
  /// In en, this message translates to:
  /// **'Themes'**
  String get menuThemes;

  /// No description provided for @menuSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get menuSettings;

  /// No description provided for @menuRate.
  ///
  /// In en, this message translates to:
  /// **'Rate and review'**
  String get menuRate;

  /// No description provided for @menuWeb.
  ///
  /// In en, this message translates to:
  /// **'MPT on Web'**
  String get menuWeb;

  /// No description provided for @menuFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get menuFeedback;

  /// No description provided for @menuUpdateAvailable.
  ///
  /// In en, this message translates to:
  /// **'Updates available'**
  String get menuUpdateAvailable;

  /// No description provided for @menuTooltip.
  ///
  /// In en, this message translates to:
  /// **'Open menu'**
  String get menuTooltip;

  /// No description provided for @menuTimetableTooltip.
  ///
  /// In en, this message translates to:
  /// **'Monthly Timetable'**
  String get menuTimetableTooltip;

  /// Title in SliverAppBar
  ///
  /// In en, this message translates to:
  /// **'{month} timetable'**
  String timetableTitle(String month);

  /// No description provided for @timetableDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get timetableDate;

  /// No description provided for @timetableExportTooltip.
  ///
  /// In en, this message translates to:
  /// **'Export timetable as PDF'**
  String get timetableExportTooltip;

  /// No description provided for @timetableExportExporting.
  ///
  /// In en, this message translates to:
  /// **'Exporting'**
  String get timetableExportExporting;

  /// No description provided for @timetableExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Prayer timetable PDF file is ready'**
  String get timetableExportSuccess;

  /// No description provided for @timetableExportOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get timetableExportOpen;

  /// No description provided for @timetableExportError.
  ///
  /// In en, this message translates to:
  /// **'Sorry. Error occurred when exporting timetable. Please try again. {error}'**
  String timetableExportError(String error);

  /// No description provided for @timetableExportFileShareSubject.
  ///
  /// In en, this message translates to:
  /// **'Prayer Timetable. {link}'**
  String timetableExportFileShareSubject(String link);

  /// No description provided for @timetableOneThird.
  ///
  /// In en, this message translates to:
  /// **'Last 1/3 night'**
  String get timetableOneThird;

  /// No description provided for @timetableSettingTitle.
  ///
  /// In en, this message translates to:
  /// **'Timetable setting'**
  String get timetableSettingTitle;

  /// No description provided for @timetableSettingHijri.
  ///
  /// In en, this message translates to:
  /// **'Show Hijri column'**
  String get timetableSettingHijri;

  /// No description provided for @timetableSettingHijriStyle.
  ///
  /// In en, this message translates to:
  /// **'Hijri month style'**
  String get timetableSettingHijriStyle;

  /// No description provided for @timetableSettingOneThird.
  ///
  /// In en, this message translates to:
  /// **'Show last one third of the night'**
  String get timetableSettingOneThird;

  /// No description provided for @timetableSettingOneThirdSub.
  ///
  /// In en, this message translates to:
  /// **'Calculation method based on Mufti of Federal Territory Office'**
  String get timetableSettingOneThirdSub;

  /// No description provided for @timetableSettingShortform.
  ///
  /// In en, this message translates to:
  /// **'Shortform'**
  String get timetableSettingShortform;

  /// No description provided for @timetableSettingLongform.
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get timetableSettingLongform;

  /// No description provided for @themeTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeTitle;

  /// No description provided for @themeOptionSystem.
  ///
  /// In en, this message translates to:
  /// **'System Theme'**
  String get themeOptionSystem;

  /// No description provided for @themeOptionLight.
  ///
  /// In en, this message translates to:
  /// **'Light Theme'**
  String get themeOptionLight;

  /// No description provided for @themeOptionDark.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get themeOptionDark;

  /// No description provided for @themeSupportedDevice.
  ///
  /// In en, this message translates to:
  /// **'On supported device only'**
  String get themeSupportedDevice;

  /// Copyright info
  ///
  /// In en, this message translates to:
  /// **'Copyright © {year} Fareez Iqmal'**
  String aboutLegalese(String year);

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutTitle;

  /// App version
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String aboutVersion(String version);

  /// No description provided for @aboutVersionCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied version info'**
  String get aboutVersionCopied;

  /// No description provided for @aboutJakim.
  ///
  /// In en, this message translates to:
  /// **'Prayer times data are from [Department of Islamic Development Malaysia (JAKIM)](https://www.e-solat.gov.my/)'**
  String get aboutJakim;

  /// No description provided for @aboutContribution.
  ///
  /// In en, this message translates to:
  /// **'Contribution and Support'**
  String get aboutContribution;

  /// No description provided for @aboutReleaseNotes.
  ///
  /// In en, this message translates to:
  /// **'Release Notes'**
  String get aboutReleaseNotes;

  /// No description provided for @aboutLicense.
  ///
  /// In en, this message translates to:
  /// **'Open Source Licenses'**
  String get aboutLicense;

  /// No description provided for @aboutPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get aboutPrivacy;

  /// No description provided for @aboutFaq.
  ///
  /// In en, this message translates to:
  /// **'Documentation'**
  String get aboutFaq;

  /// No description provided for @aboutMoreApps.
  ///
  /// In en, this message translates to:
  /// **'More apps'**
  String get aboutMoreApps;

  /// No description provided for @shareTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer timetable today'**
  String get shareTitle;

  /// Link in share message
  ///
  /// In en, this message translates to:
  /// **'Get the app: {link}'**
  String shareGetApp(String link);

  /// No description provided for @shareTooltip.
  ///
  /// In en, this message translates to:
  /// **'Share solat time'**
  String get shareTooltip;

  /// No description provided for @sharePlainTitle.
  ///
  /// In en, this message translates to:
  /// **'Share as plain text'**
  String get sharePlainTitle;

  /// No description provided for @sharePlainDesc.
  ///
  /// In en, this message translates to:
  /// **'Compatible to all apps'**
  String get sharePlainDesc;

  /// No description provided for @shareWhatsappTitle.
  ///
  /// In en, this message translates to:
  /// **'Share to WhatsApp'**
  String get shareWhatsappTitle;

  /// No description provided for @shareWhatsappDesc.
  ///
  /// In en, this message translates to:
  /// **'Using WhatsApp formatting'**
  String get shareWhatsappDesc;

  /// No description provided for @shareCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy to clipboard'**
  String get shareCopy;

  /// No description provided for @shareImage.
  ///
  /// In en, this message translates to:
  /// **'Share as Image'**
  String get shareImage;

  /// No description provided for @shareImageFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to share image'**
  String get shareImageFailed;

  /// No description provided for @shareSubject.
  ///
  /// In en, this message translates to:
  /// **'Malaysia prayer time for today'**
  String get shareSubject;

  /// No description provided for @shareTimetableCopied.
  ///
  /// In en, this message translates to:
  /// **'Timetable copied'**
  String get shareTimetableCopied;

  /// No description provided for @settingTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingTitle;

  /// No description provided for @settingDisplay.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get settingDisplay;

  /// No description provided for @settingTimeFormat.
  ///
  /// In en, this message translates to:
  /// **'Time format'**
  String get settingTimeFormat;

  /// No description provided for @settingTimeFormatDropdown.
  ///
  /// In en, this message translates to:
  /// **'{time} hour'**
  String settingTimeFormatDropdown(String time);

  /// No description provided for @settingOtherPrayer.
  ///
  /// In en, this message translates to:
  /// **'Show other times'**
  String get settingOtherPrayer;

  /// No description provided for @settingFontSize.
  ///
  /// In en, this message translates to:
  /// **'Font size'**
  String get settingFontSize;

  /// No description provided for @settingLocaleTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingLocaleTitle;

  /// No description provided for @settingNotification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get settingNotification;

  /// No description provided for @settingNotification2.
  ///
  /// In en, this message translates to:
  /// **'Notification settings'**
  String get settingNotification2;

  /// No description provided for @settingMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get settingMore;

  /// No description provided for @settingAbout.
  ///
  /// In en, this message translates to:
  /// **'About app (Ver. {version})'**
  String settingAbout(String version);

  /// No description provided for @settingMoreDesc.
  ///
  /// In en, this message translates to:
  /// **'Release Notes, Contribution, Twitter etc.'**
  String get settingMoreDesc;

  /// No description provided for @qiblaWarnBody.
  ///
  /// In en, this message translates to:
  /// **'- Users must understand that Qibla Compass feature utilises the sensors of the user\'s device and does not use any data from JAKIM. Therefore, users should **wisely evaluate** the information obtained.\n- MPT app provides this function as a **guide** only. MPT app is not responsible if the information obtained is inaccurate. Please refer to the recommended way to get the exact Qibla direction.\n- To improve the accuracy, make sure the internet and GPS connection are stable and perform the calibration by rotating your device in an **8** or **infinity** shape as below:'**
  String get qiblaWarnBody;

  /// No description provided for @qiblaWarnProceed.
  ///
  /// In en, this message translates to:
  /// **'I understood'**
  String get qiblaWarnProceed;

  /// No description provided for @qiblaTitle.
  ///
  /// In en, this message translates to:
  /// **'Qibla Compass'**
  String get qiblaTitle;

  /// No description provided for @qiblaOverheadWarn.
  ///
  /// In en, this message translates to:
  /// **'Avoid placing the device close to metal object or electrical appliances.'**
  String get qiblaOverheadWarn;

  /// No description provided for @qiblaCopyUrl.
  ///
  /// In en, this message translates to:
  /// **'URL copied :)'**
  String get qiblaCopyUrl;

  /// No description provided for @qiblaCalibrationTip.
  ///
  /// In en, this message translates to:
  /// **'Calibration tip'**
  String get qiblaCalibrationTip;

  /// No description provided for @qiblaCalibrate.
  ///
  /// In en, this message translates to:
  /// **'Move your phone in \'figure 8 pattern\''**
  String get qiblaCalibrate;

  /// No description provided for @qiblaCalibrateDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get qiblaCalibrateDone;

  /// No description provided for @qiblaErrNoCompass.
  ///
  /// In en, this message translates to:
  /// **'Sorry. No compass sensor is available in this device.'**
  String get qiblaErrNoCompass;

  /// No description provided for @qiblaErrBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get qiblaErrBack;

  /// No description provided for @feedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedbackTitle;

  /// No description provided for @feedbackFieldEmpty.
  ///
  /// In en, this message translates to:
  /// **'Field can\'t be empty'**
  String get feedbackFieldEmpty;

  /// No description provided for @feedbackWriteHere.
  ///
  /// In en, this message translates to:
  /// **'Please leave your feedback/report here'**
  String get feedbackWriteHere;

  /// No description provided for @feedbackIncorrectEmail.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email format'**
  String get feedbackIncorrectEmail;

  /// No description provided for @feedbackEmailHere.
  ///
  /// In en, this message translates to:
  /// **'Your email address (optional)'**
  String get feedbackEmailHere;

  /// No description provided for @feedbackViewDeviceInfo.
  ///
  /// In en, this message translates to:
  /// **'View...'**
  String get feedbackViewDeviceInfo;

  /// No description provided for @feedbackDeviceInfoCopy.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get feedbackDeviceInfoCopy;

  /// No description provided for @feedbackDeviceInfoCopyAll.
  ///
  /// In en, this message translates to:
  /// **'Copy all'**
  String get feedbackDeviceInfoCopyAll;

  /// No description provided for @feedbackIncludeDeviceInfo.
  ///
  /// In en, this message translates to:
  /// **'Include device info'**
  String get feedbackIncludeDeviceInfo;

  /// No description provided for @feedbackDeviceInfoRecommended.
  ///
  /// In en, this message translates to:
  /// **'(Recommended)'**
  String get feedbackDeviceInfoRecommended;

  /// No description provided for @feedbackTroubleDeviceInfo.
  ///
  /// In en, this message translates to:
  /// **'Trouble getting device info'**
  String get feedbackTroubleDeviceInfo;

  /// No description provided for @feedbackGettingInfo.
  ///
  /// In en, this message translates to:
  /// **'Getting device info...'**
  String get feedbackGettingInfo;

  /// No description provided for @feedbackAppMetadata.
  ///
  /// In en, this message translates to:
  /// **'App metadata'**
  String get feedbackAppMetadata;

  /// No description provided for @feedbackAppMetadataSub.
  ///
  /// In en, this message translates to:
  /// **'(Always included)'**
  String get feedbackAppMetadataSub;

  /// No description provided for @feedbackSensitive.
  ///
  /// In en, this message translates to:
  /// **'User sensitive data'**
  String get feedbackSensitive;

  /// No description provided for @feedbackSensitiveSub.
  ///
  /// In en, this message translates to:
  /// **'Include whenever necessary'**
  String get feedbackSensitiveSub;

  /// No description provided for @feedbackMessageContainQ.
  ///
  /// In en, this message translates to:
  /// **'Looks like your message contain question(s). Please provide your email so we can get back to you.\n\nWould you like to add your email?'**
  String get feedbackMessageContainQ;

  /// No description provided for @feedbackSendAnyway.
  ///
  /// In en, this message translates to:
  /// **'Send anyway'**
  String get feedbackSendAnyway;

  /// No description provided for @feedbackAddEmail.
  ///
  /// In en, this message translates to:
  /// **'Add email'**
  String get feedbackAddEmail;

  /// No description provided for @feedbackSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get feedbackSend;

  /// No description provided for @feedbackAlsoDo.
  ///
  /// In en, this message translates to:
  /// **'You can also do'**
  String get feedbackAlsoDo;

  /// No description provided for @feedbackReadFaq.
  ///
  /// In en, this message translates to:
  /// **'Read Frequently Asked Questions (FAQ)'**
  String get feedbackReadFaq;

  /// No description provided for @feedbackReportGithub.
  ///
  /// In en, this message translates to:
  /// **'Report / Follow issues on GitHub'**
  String get feedbackReportGithub;

  /// No description provided for @feedbackThanks.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your valuable feedback.'**
  String get feedbackThanks;

  /// No description provided for @onboardingChooseLang.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get onboardingChooseLang;

  /// No description provided for @onboardingSetLocation.
  ///
  /// In en, this message translates to:
  /// **'Set your location'**
  String get onboardingSetLocation;

  /// No description provided for @onboardingLocationDesc.
  ///
  /// In en, this message translates to:
  /// **'Make sure the location services are turned on so the app can determine the best location'**
  String get onboardingLocationDesc;

  /// No description provided for @onboardingLocationToast.
  ///
  /// In en, this message translates to:
  /// **'Location set. You can change location anytime by tapping the location code at upper right corner.'**
  String get onboardingLocationToast;

  /// No description provided for @onboardingLocationSet.
  ///
  /// In en, this message translates to:
  /// **'Set location'**
  String get onboardingLocationSet;

  /// No description provided for @onboardingThemeFav.
  ///
  /// In en, this message translates to:
  /// **'Set your favourite theme'**
  String get onboardingThemeFav;

  /// No description provided for @onboardingNotifOption.
  ///
  /// In en, this message translates to:
  /// **'Select notification preferences'**
  String get onboardingNotifOption;

  /// No description provided for @onboardingNotifDefault.
  ///
  /// In en, this message translates to:
  /// **'Default notification'**
  String get onboardingNotifDefault;

  /// No description provided for @onboardingNotifAzan.
  ///
  /// In en, this message translates to:
  /// **'Azan (full)'**
  String get onboardingNotifAzan;

  /// No description provided for @onboardingNotifShortAzan.
  ///
  /// In en, this message translates to:
  /// **'Azan (short)'**
  String get onboardingNotifShortAzan;

  /// No description provided for @onboardingNotifAutostart.
  ///
  /// In en, this message translates to:
  /// **'**Autostart** need to be enabled for the app to send notifications. [Learn more...]({link})'**
  String onboardingNotifAutostart(String link);

  /// No description provided for @onboardingNotifAutostartSetting.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get onboardingNotifAutostartSetting;

  /// No description provided for @onboardingFinish.
  ///
  /// In en, this message translates to:
  /// **'Alhamdulillah. All set'**
  String get onboardingFinish;

  /// No description provided for @onboardingFinishDesc.
  ///
  /// In en, this message translates to:
  /// **'Welcome aboard. Do explore other features and tweak other settings as well.'**
  String get onboardingFinishDesc;

  /// No description provided for @onboardingDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get onboardingDone;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @coachmarkDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get coachmarkDone;

  /// No description provided for @coachmarkNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get coachmarkNext;

  /// No description provided for @coachmarkPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get coachmarkPrevious;

  /// No description provided for @coachmarkEnd.
  ///
  /// In en, this message translates to:
  /// **'End tour'**
  String get coachmarkEnd;

  /// No description provided for @permissionDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Permission required'**
  String get permissionDialogTitle;

  /// No description provided for @permissionDialogSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get permissionDialogSkip;

  /// No description provided for @permissionDialogGrant.
  ///
  /// In en, this message translates to:
  /// **'Grant'**
  String get permissionDialogGrant;

  /// No description provided for @autostartDialogPermissionContent.
  ///
  /// In en, this message translates to:
  /// **'Please allow app to Autostart to keep receive notifications even if the device restarts'**
  String get autostartDialogPermissionContent;

  /// No description provided for @notifDialogPermissionContent.
  ///
  /// In en, this message translates to:
  /// **'Please grant the notification permission to allow this app to show notifications'**
  String get notifDialogPermissionContent;

  /// No description provided for @notifExactAlarmDialogPermissionContent.
  ///
  /// In en, this message translates to:
  /// **'Please grant the app permission to schedule notifications at exact time'**
  String get notifExactAlarmDialogPermissionContent;

  /// No description provided for @zoneUpdatedToast.
  ///
  /// In en, this message translates to:
  /// **'Location updated'**
  String get zoneUpdatedToast;

  /// No description provided for @zoneYourLocation.
  ///
  /// In en, this message translates to:
  /// **'Your location'**
  String get zoneYourLocation;

  /// No description provided for @zoneSetManually.
  ///
  /// In en, this message translates to:
  /// **'Set manually'**
  String get zoneSetManually;

  /// No description provided for @zoneSetThis.
  ///
  /// In en, this message translates to:
  /// **'Set this location'**
  String get zoneSetThis;

  /// No description provided for @zoneError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get zoneError;

  /// No description provided for @zoneErrorPara1.
  ///
  /// In en, this message translates to:
  /// **'Check your **internet connection** or **location services**.'**
  String get zoneErrorPara1;

  /// No description provided for @zoneErrorPara2.
  ///
  /// In en, this message translates to:
  /// **'Please **retry** or choose location **manually**.'**
  String get zoneErrorPara2;

  /// No description provided for @zoneOpenLocationSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Location Settings'**
  String get zoneOpenLocationSettings;

  /// No description provided for @zoneLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get zoneLoading;

  /// No description provided for @zoneManualSelectZone.
  ///
  /// In en, this message translates to:
  /// **'Select zone'**
  String get zoneManualSelectZone;

  /// No description provided for @zoneUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Prayer zone set to {zone}'**
  String zoneUpdatedSuccess(String zone);

  /// No description provided for @notifSettingBasic.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get notifSettingBasic;

  /// No description provided for @notifSettingChangesDetect.
  ///
  /// In en, this message translates to:
  /// **'Changes will take effect after restarting the app'**
  String get notifSettingChangesDetect;

  /// No description provided for @notifSettingRestartApp.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get notifSettingRestartApp;

  /// No description provided for @notificationSettingPlayNotifTooltip.
  ///
  /// In en, this message translates to:
  /// **'Play test notification'**
  String get notificationSettingPlayNotifTooltip;

  /// No description provided for @notifSettingSysSetting.
  ///
  /// In en, this message translates to:
  /// **'App notification System Setting'**
  String get notifSettingSysSetting;

  /// No description provided for @notifSettingSysSettingDesc.
  ///
  /// In en, this message translates to:
  /// **'Customize sound, toggle channel of prayer notification etc.'**
  String get notifSettingSysSettingDesc;

  /// No description provided for @notifSettingTroubleshoot.
  ///
  /// In en, this message translates to:
  /// **'Troubleshooting'**
  String get notifSettingTroubleshoot;

  /// No description provided for @notifSettingTroubleshootDesc.
  ///
  /// In en, this message translates to:
  /// **'Fix notification not working on some devices'**
  String get notifSettingTroubleshootDesc;

  /// No description provided for @notifSettingTroubleshootExample.
  ///
  /// In en, this message translates to:
  /// **'Example: {phonesModel} etc.'**
  String notifSettingTroubleshootExample(String phonesModel);

  /// No description provided for @notifSettingAdvancedTroubleshoot.
  ///
  /// In en, this message translates to:
  /// **'Advanced troubleshooting'**
  String get notifSettingAdvancedTroubleshoot;

  /// No description provided for @notifSettingLimitNotif.
  ///
  /// In en, this message translates to:
  /// **'Limit notification scheduling'**
  String get notifSettingLimitNotif;

  /// No description provided for @notifSettingLimitNotifDesc.
  ///
  /// In en, this message translates to:
  /// **'Enable if you experience an extreme slowdown in app. Notification will schedule weekly basis. Default is OFF (monthly).'**
  String get notifSettingLimitNotifDesc;

  /// No description provided for @notifSettingForceReschedule.
  ///
  /// In en, this message translates to:
  /// **'Force rescheduling notification...'**
  String get notifSettingForceReschedule;

  /// No description provided for @notifSettingForceRescheduleDesc.
  ///
  /// In en, this message translates to:
  /// **'By default, notification will not reschedule if the last scheduler ran is less than two days.\n\nTap proceed to start an immediate notification scheduling. The app will be restarted.'**
  String get notifSettingForceRescheduleDesc;

  /// No description provided for @notifSettingCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get notifSettingCancel;

  /// No description provided for @notifSettingProceed.
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get notifSettingProceed;

  /// No description provided for @notifSettingNotifDemo.
  ///
  /// In en, this message translates to:
  /// **'This is how the notification/azan will sound like'**
  String get notifSettingNotifDemo;

  /// No description provided for @notifSettingsExactAlarmPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification scheduling permission'**
  String get notifSettingsExactAlarmPermissionTitle;

  /// No description provided for @notifSettingsExactAlarmPermissionGrantedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Permission granted. The app can send azan notification on prayer times'**
  String get notifSettingsExactAlarmPermissionGrantedSubtitle;

  /// No description provided for @notifSettingsExactAlarmPermissionNotGrantedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Permission not granted. The app cannot send the azan notification. Tap here to grant permission'**
  String get notifSettingsExactAlarmPermissionNotGrantedSubtitle;

  /// No description provided for @notifSheetExactAlarmTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable setting exact notifications permission'**
  String get notifSheetExactAlarmTitle;

  /// No description provided for @notifSheetExactAlarmDescription.
  ///
  /// In en, this message translates to:
  /// **'Grant now so the app can send timely notifications/azans. Without it, delivery might be delayed.'**
  String get notifSheetExactAlarmDescription;

  /// No description provided for @notifSheetExactAlarmPrimaryButton.
  ///
  /// In en, this message translates to:
  /// **'Grant now'**
  String get notifSheetExactAlarmPrimaryButton;

  /// No description provided for @notifSheetExactAlarmCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get notifSheetExactAlarmCancel;

  /// No description provided for @notifSheetNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification/Azan is turned off'**
  String get notifSheetNotificationTitle;

  /// No description provided for @notifSheetNotificationDescription.
  ///
  /// In en, this message translates to:
  /// **'We may require some permissions to be able to play the notification/azan'**
  String get notifSheetNotificationDescription;

  /// No description provided for @notifSheetNotificationPrimaryButton.
  ///
  /// In en, this message translates to:
  /// **'Turn On Notification'**
  String get notifSheetNotificationPrimaryButton;

  /// No description provided for @notifSheetNotificationCancel.
  ///
  /// In en, this message translates to:
  /// **'Keep it off for now'**
  String get notifSheetNotificationCancel;

  /// No description provided for @contributeShare.
  ///
  /// In en, this message translates to:
  /// **'Share this app'**
  String get contributeShare;

  /// No description provided for @contributeShareContent.
  ///
  /// In en, this message translates to:
  /// **'Hi. I\'m using the Malaysia Prayer Time app. It\'s fast and free.\n\nTry it now:\n{playStoreShortLink} (Google Play)\n{webAppLink} (Web app)'**
  String contributeShareContent(String playStoreShortLink, String webAppLink);

  /// No description provided for @contributeShareSubject.
  ///
  /// In en, this message translates to:
  /// **'Sharing MPT App'**
  String get contributeShareSubject;

  /// No description provided for @contributeCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get contributeCopy;

  /// No description provided for @contributeOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get contributeOpen;

  /// No description provided for @contributeCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get contributeCopied;

  /// No description provided for @notifTsAdmonition.
  ///
  /// In en, this message translates to:
  /// **'Your device may not be affected with this particular issue.'**
  String get notifTsAdmonition;

  /// No description provided for @notifTsPara1.
  ///
  /// In en, this message translates to:
  /// **'Some apps installed from the **Google Play Store** will disable **Autostart** by default. Due to this behaviour, prayer notification (sometimes) will not appear on your phone.'**
  String get notifTsPara1;

  /// No description provided for @notifTsPara2.
  ///
  /// In en, this message translates to:
  /// **'The solution is to enable **Autostart** for this app. Tap the button below to open App Setting, then find the Autostart option there to enable it.'**
  String get notifTsPara2;

  /// No description provided for @notifTsPara3.
  ///
  /// In en, this message translates to:
  /// **'To learn more, kindly read [this article]({link}).'**
  String notifTsPara3(String link);

  /// No description provided for @notifTsOpenSetting.
  ///
  /// In en, this message translates to:
  /// **'Open App Setting'**
  String get notifTsOpenSetting;

  /// No description provided for @notifMonthlyReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly refresh reminder'**
  String get notifMonthlyReminderTitle;

  /// No description provided for @notifMonthlyReminderDesc.
  ///
  /// In en, this message translates to:
  /// **'To continue receive prayer notification, open app at least once every month.'**
  String get notifMonthlyReminderDesc;

  /// No description provided for @notifItsTime.
  ///
  /// In en, this message translates to:
  /// **'It\'s {name}'**
  String notifItsTime(String name);

  /// No description provided for @notifIn.
  ///
  /// In en, this message translates to:
  /// **'in {location}'**
  String notifIn(String location);

  /// No description provided for @notifEndSubh.
  ///
  /// In en, this message translates to:
  /// **'Ends of Fajr'**
  String get notifEndSubh;

  /// No description provided for @whatsUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'Just updated to the latest version.'**
  String get whatsUpdateTitle;

  /// No description provided for @whatsUpdateContent.
  ///
  /// In en, this message translates to:
  /// **'What\'s new in this update? Read the release notes [here]({releaseNotesLink}).'**
  String whatsUpdateContent(String releaseNotesLink);

  /// No description provided for @whatsUpdateChangelog.
  ///
  /// In en, this message translates to:
  /// **'Release notes'**
  String get whatsUpdateChangelog;

  /// No description provided for @updatePageError.
  ///
  /// In en, this message translates to:
  /// **'Sorry. Error occurred when checking for update'**
  String get updatePageError;

  /// No description provided for @updatePageTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Please try again'**
  String get updatePageTryAgain;

  /// No description provided for @updatePageAvailable.
  ///
  /// In en, this message translates to:
  /// **'Updates available'**
  String get updatePageAvailable;

  /// No description provided for @updatePageReleased.
  ///
  /// In en, this message translates to:
  /// **'Released {day} days ago'**
  String updatePageReleased(int day);

  /// No description provided for @updatePageReleasedToday.
  ///
  /// In en, this message translates to:
  /// **'Released today'**
  String get updatePageReleasedToday;

  /// No description provided for @updatePageCurrentVer.
  ///
  /// In en, this message translates to:
  /// **'You have: **{version}**'**
  String updatePageCurrentVer(String version);

  /// No description provided for @updatePageLatestVer.
  ///
  /// In en, this message translates to:
  /// **'Latest available: **{version}**'**
  String updatePageLatestVer(String version);

  /// No description provided for @updatePageGPlay.
  ///
  /// In en, this message translates to:
  /// **'Get updates on Google Play'**
  String get updatePageGPlay;

  /// No description provided for @tasbihResetDialog.
  ///
  /// In en, this message translates to:
  /// **'Confirm reset ?'**
  String get tasbihResetDialog;

  /// No description provided for @tasbihReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get tasbihReset;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ms'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ms':
      return AppLocalizationsMs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
