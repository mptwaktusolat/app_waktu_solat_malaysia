//constants
const kPayloadMonthly = 'monthlyRefresh';
const kPayloadDebug = 'payloadDebug';

//GetStorage
const kStoredGlobalIndex = "storedGlobalIndex";
const kStoredFirstRun = "storedFirstRunApp";
const kStoredTimeIs12 = "storedTimeFormat";
const kStoredLocationLocality = "storedLocationLocality";
const kStoredShowOtherPrayerTime = "storedshowothertime";
const kStoredApiPrayerCall = "storedApiPrayCall";
const kStoredShouldUpdateNotif = "storedShouldUpdateNotif";
const kStoredLastUpdateNotif = "storedLastUpdateNotif";
const kStoredNotificationLimit = "storedNotificationLimit";
const kNumberOfNotifsScheduled = "numnotifscheduled";
const kIsDebugMode = "debugModeSet";
const kForceUpdateNotif = "storedForceUpdateNotif";
const kDiscoveredDeveloperOption = "storedDevDiscovered";
const kSharingFormat = "storedSharingFormat";
const kFontSize = "storedFontSize";
const kHijriOffset = "storedHijriOffset";

//Network image
const kAppIconUrl =
    'https://firebasestorage.googleapis.com/v0/b/malaysia-waktu-solat.appspot.com/o/icon%20(Custom).png?alt=media&token=9efb706e-4bf3-4e60-af8e-9a88ee6db60c';
const kThemeUiUrl =
    'https://firebasestorage.googleapis.com/v0/b/malaysia-waktu-solat.appspot.com/o/In%20app%2Fmpt%20themes.png?alt=media&token=978ba572-9f14-459a-a8e7-3e316774c2d2';
const kDeveloperActivityImage =
    'https://firebasestorage.googleapis.com/v0/b/malaysia-waktu-solat.appspot.com/o/In%20app%2Fundraw_developer_activity_bv83.svg?alt=media&token=e787419a-fb75-4484-860d-512b4b634c97';

//Network Image (Scenery time images)
const kWaktuSubuhImage =
    'https://firebasestorage.googleapis.com/v0/b/malaysia-waktu-solat.appspot.com/o/Scenery%2FtimeDay1%20(Custom).jpg?alt=media&token=293ecf62-033a-4925-802b-9c8e3167c2c0';
const kWaktuZohorImage =
    'https://firebasestorage.googleapis.com/v0/b/malaysia-waktu-solat.appspot.com/o/Scenery%2FtimeDay2%20(Custom).jpg?alt=media&token=f5c189a1-b5a6-4dc5-818b-912bc8ea2925';
const kWaktuAsarImage =
    'https://firebasestorage.googleapis.com/v0/b/malaysia-waktu-solat.appspot.com/o/Scenery%2FtimeDay3%20(Custom).jpg?alt=media&token=0816267c-5c27-4aa0-a395-782536f83d43';
const kWaktuMaghribImage =
    'https://firebasestorage.googleapis.com/v0/b/malaysia-waktu-solat.appspot.com/o/Scenery%2FtimeDay1%20(Custom).png?alt=media&token=b3a669f1-1403-42f4-bd94-675b1a8ba81c';
const kWaktuIsyakImage =
    'https://firebasestorage.googleapis.com/v0/b/malaysia-waktu-solat.appspot.com/o/Scenery%2FtimeDay4%20(Custom).jpg?alt=media&token=429b449c-6573-40df-acef-aaf0a67a8695';

//App info
const kPlayStoreListingLink =
    'https://play.google.com/store/apps/details?id=live.iqfareez.waktusolatmalaysia';
const kPlayStoreListingShortLink = 'http://bit.ly/MPTdl';
const kPrivacyPolicyLink = 'https://telegra.ph/MPT-Privacy-Policy-07-24';
const kPrivacyPolicyShortLink = 'http://bit.ly/mpt-pp';
const kReleaseNotesLink =
    'https://telegra.ph/MPT-Changelogs---Malaysia-Prayer-Time-Flutter-07-20';
const kReleaseNotesShortLink = 'http://bit.ly/mpt-clog';
const kGithubRepoLink = 'https://github.com/iqfareez/app_waktu_solat_malaysia';
const kSolatJakimLink = 'https://www.e-solat.gov.my/';
const kWebappUrl = 'https://waktusolat.web.app';

//Developer info
const kDevEmail = 'foxtrotiqmal3@gmail.com';
const kDevTwitter = 'https://twitter.com/iqfareez2';
const kDevInstagram = 'https://www.instagram.com/iqfareez/';
const kInstaStoryDevlog =
    'https://www.instagram.com/s/aGlnaGxpZ2h0OjE3ODcyMTc0ODcwODEzNjM1?igshid=3jwa3e1iy3u7&story_media_id=2342912100646673991_32997533904';
const kGithubLink = 'https://github.com/iqfareez';
const kPlayStoreDevLink =
    'https://play.google.com/store/apps/dev?id=9200064795631584674';

//Contribution page
const kBuyMeACoffeeLink = 'https://www.buymeacoffee.com/iqfareez';
const kBankAccountNum = '162348620850'; //maybank
const kPaypalDonateShortLink = 'paypal.me/iqfareez';
const kPaypalDonateFullLink = 'https://www.paypal.com/paypalme/iqfareez';
const kMaybankAccNo = '162348620850';

//azan audio link
//https://www.onlineconverter.com/compress-mp3
//(mishary) kurd-2208, lamy-2205, bayati-2014
const azansAudioFajr = [
  'https://firebasestorage.googleapis.com/v0/b/malaysia-waktu-solat.appspot.com/o/Azan%2FFajr%2FKurd2008-FAJR.mp3?alt=media&token=587c9b4d-3427-42cc-956a-1a3ea44296ce',
  'https://firebasestorage.googleapis.com/v0/b/malaysia-waktu-solat.appspot.com/o/Azan%2FFajr%2FLamy2005-FAJR.mp3?alt=media&token=3868ed15-05d1-458e-80c4-5c31ee3030dd',
  'https://firebasestorage.googleapis.com/v0/b/malaysia-waktu-solat.appspot.com/o/Azan%2FFajr%2Fbayati2014-FAJR.mp3?alt=media&token=2ca1dcdd-5e4d-4d46-b781-44bcc46b7b2e'
];
const azansAudioNormal = [
  'https://firebasestorage.googleapis.com/v0/b/malaysia-waktu-solat.appspot.com/o/Azan%2FNormal%2FKurd2008.mp3?alt=media&token=7020643d-dcfd-4caa-9702-4c76d0d10c4b',
  'https://firebasestorage.googleapis.com/v0/b/malaysia-waktu-solat.appspot.com/o/Azan%2FNormal%2FLamy2005.mp3?alt=media&token=0d718dfe-3c94-4938-b571-b4777714a85d',
  'https://firebasestorage.googleapis.com/v0/b/malaysia-waktu-solat.appspot.com/o/Azan%2FNormal%2Fbayaty2014.mp3?alt=media&token=cf1fcb38-2a23-4902-95e9-9d2c34432c5c'
];

//hero tag
const kAppIconTag = 'appIconTag';
