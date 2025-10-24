// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

  @override
  String get appbarTitle => 'Waktu Solat 🇲🇾';

  @override
  String get appTitle => 'Waktu Solat Malaysia';

  @override
  String get imsakName => 'Imsak';

  @override
  String get imsakDescription => '10 minit sebelum Subuh';

  @override
  String get fajrName => 'Subuh';

  @override
  String get sunriseName => 'Syuruk';

  @override
  String get sunriseDescription => 'Matahari terbit';

  @override
  String get dhuhaName => 'Dhuha';

  @override
  String get dhuhaDescription => '28 minit selepas Syuruk';

  @override
  String get dhuhrName => 'Zohor';

  @override
  String get asrName => 'Asar';

  @override
  String get maghribName => 'Maghrib';

  @override
  String get ishaName => 'Isyak';

  @override
  String get genericShare => 'Kongsi';

  @override
  String get getPtFetch => 'Mendapatkan waktu solat. Tunggu sat.';

  @override
  String get getPtError => 'Alamak, terdapat ralat. Sila cuba semula.';

  @override
  String get getPtRetry => 'Cuba semula';

  @override
  String getPtTimeAt(String name, String time) {
    return '$name pada $time';
  }

  @override
  String get getPtCopied => 'Disalin';

  @override
  String get appBodyNotifPrompt =>
      'Adakah pemberitahuan daripada apl ini dipaparkan pada waktu solat?';

  @override
  String get appBodyNotifPromptYes => 'Ya';

  @override
  String get appBodyNotifPromptNo => 'Tidak';

  @override
  String get appBodyNotifPromptDissm => 'Abaikan';

  @override
  String get appBodyNotifPromptResponse => 'Alhamdulillah';

  @override
  String appBodyCurrentLocation(String daerah, String negeri) {
    return 'Lokasi ditetapkan di $daerah di $negeri';
  }

  @override
  String get appBodyChangeLocation => 'Ubah';

  @override
  String get appBodyLocSemanticLabel => 'Butang untuk mengubah lokasi';

  @override
  String get appBodyWrongDeviceTimezone =>
      'Zon waktu peranti anda berbeza dengan tarikh dan masa yang ditunjukkan di sini. Sila tetapkan zon waktu anda ke Malaysia (UTC+08:00).';

  @override
  String get onboardingCoachmarkLocationTitle => 'Zon waktu solat anda';

  @override
  String get onboardingCoachmarkLocationContent =>
      'Tetapan atau tukar zon waktu solat anda di sini';

  @override
  String get onboardingCoachmarkUtilitiesTitle =>
      'Utiliti tambahan di hujung jari';

  @override
  String get onboardingCoachmarkUtilitiesContent =>
      'Cari jadual bulananan, arab kiblat, dan tasbih digital di sini';

  @override
  String get onboardingCoachmarkSettingTitle =>
      'Sesuaikan aplikasi ikut cita rasa anda';

  @override
  String get onboardingCoachmarkSettingContent =>
      'Anda boleh hidupkan paparan waktu Dhuha, format masa, bahasa, saiz fon dan tema di sini';

  @override
  String get menuThemes => 'Tema';

  @override
  String get menuSettings => 'Tetapan';

  @override
  String get menuRate => 'Penilaian dan Ulasan';

  @override
  String get menuWeb => 'MPT di Web';

  @override
  String get menuFeedback => 'Hantar maklumbalas';

  @override
  String get menuUpdateAvailable => 'Kemaskini tersedia';

  @override
  String get menuTooltip => 'Buka menu';

  @override
  String get menuTimetableTooltip => 'Jadual Bulanan';

  @override
  String timetableTitle(String month) {
    return 'Jadual $month';
  }

  @override
  String get timetableDate => 'Tarikh';

  @override
  String get timetableExportTooltip => 'Eksport jadual sebagai PDF';

  @override
  String get timetableExportExporting => 'Sedang dieksport';

  @override
  String get timetableExportSuccess => 'Fail PDF jadual solat sudah dijana.';

  @override
  String get timetableExportOpen => 'Buka';

  @override
  String timetableExportError(String error) {
    return 'Maaf. Ralat berlaku semasa eksport jadual. Sila cuba lagi. $error';
  }

  @override
  String timetableExportFileShareSubject(String link) {
    return 'Jadual Waktu Solat. $link';
  }

  @override
  String get timetableOneThird => 'Sepertiga akhir malam';

  @override
  String get timetableSettingTitle => 'Tetapan jadual';

  @override
  String get timetableSettingHijri => 'Tunjukkan lajur Hijri';

  @override
  String get timetableSettingHijriStyle => 'Gaya bulan Hijri';

  @override
  String get timetableSettingOneThird => 'Tunjukkan sepertiga akhir malam';

  @override
  String get timetableSettingOneThirdSub =>
      'Pengiraan berdasarkan Pejabat Mufti Wilayah Persekutuan';

  @override
  String get timetableSettingShortform => 'Pendek';

  @override
  String get timetableSettingLongform => 'Penuh';

  @override
  String get themeTitle => 'Tema';

  @override
  String get themeOptionSystem => 'Tema Sistem';

  @override
  String get themeOptionLight => 'Tema Terang';

  @override
  String get themeOptionDark => 'Tema Gelap';

  @override
  String get themeSupportedDevice => 'Untuk peranti yang disokong sahaja';

  @override
  String aboutLegalese(String year) {
    return 'Hak Cipta Terpelihara © $year Fareez Iqmal';
  }

  @override
  String get aboutTitle => 'Perihal apl';

  @override
  String aboutVersion(String version) {
    return 'Versi $version';
  }

  @override
  String get aboutVersionCopied => 'Versi aplikasi disalin';

  @override
  String get aboutJakim =>
      'Maklumat waktu solat adalah daripada [Jabatan Kemajuan Islam Malaysia (JAKIM)](https://www.e-solat.gov.my/)';

  @override
  String get aboutContribution => 'Sumbangan dan Sokongan';

  @override
  String get aboutReleaseNotes => 'Nota Keluaran';

  @override
  String get aboutLicense => 'Lesen Sumber Terbuka';

  @override
  String get aboutPrivacy => 'Notis Privasi';

  @override
  String get aboutFaq => 'Dokumentasi';

  @override
  String get aboutMoreApps => 'Lebih apl.';

  @override
  String get shareTitle => 'Jadual waktu solat hari ini';

  @override
  String shareGetApp(String link) {
    return 'Dapatkan aplikasi di: $link';
  }

  @override
  String get shareTooltip => 'Kongsi waktu solat';

  @override
  String get sharePlainTitle => 'Kongsi sebagai teks biasa';

  @override
  String get sharePlainDesc => 'Serasi dengan semua apl';

  @override
  String get shareWhatsappTitle => 'Kongsi ke WhatsApp';

  @override
  String get shareWhatsappDesc => 'Menggunakan pemformatan WhatsApp';

  @override
  String get shareCopy => 'Salin ke papan keratan';

  @override
  String get shareImage => 'Kongsi sebagai Gambar';

  @override
  String get shareImageFailed => 'Gagal berkongsi gambar';

  @override
  String get shareSubject => 'Waktu Solat Malaysia untuk hari ini';

  @override
  String get shareTimetableCopied => 'Jadual disalin';

  @override
  String get settingTitle => 'Tetapan';

  @override
  String get settingDisplay => 'Paparan';

  @override
  String get settingTimeFormat => 'Format masa';

  @override
  String settingTimeFormatDropdown(String time) {
    return '$time jam';
  }

  @override
  String get settingOtherPrayer => 'Tunjukkan waktu lain';

  @override
  String get settingFontSize => 'Saiz fon';

  @override
  String get settingLocaleTitle => 'Bahasa';

  @override
  String get settingNotification => 'Pemberitahuan';

  @override
  String get settingNotification2 => 'Tetapan pemberitahuan';

  @override
  String get settingMore => 'Lain-lain';

  @override
  String settingAbout(String version) {
    return 'Perihal apl. (Ver. $version)';
  }

  @override
  String get settingMoreDesc => 'Nota keluaran, Sokongan, Twitter etc.';

  @override
  String get qiblaWarnBody =>
      '- Pengguna harus faham yang fungsi ini menggunakan penderia peranti pengguna sepenuhnya dan tidak menggunakan apa apa data atau maklumat dari JAKIM. Jadi, pengguna seharusnya **arif menilai** maklumat yang diperolehi.\n- Apl MPT menyediakan fungsi ini sebagai **panduan** sahaja. Apl MPT tidak bertanggungjawab sekiranya maklumat yang diperolehi tidak tepat. Sila rujuk cara yang disyorkan untuk mendapatkan arah Qiblat yang tepat.\n- Untuk meningkatkan ketepatan fungsi ini, sila pastikan sambungan internet dan GPS yang stabil dan laksanakan kalibrasi dengan memusingkan peranti anda dalam bentuk **8** atau **infiniti** seperti di bawah.';

  @override
  String get qiblaWarnProceed => 'Saya faham';

  @override
  String get qiblaTitle => 'Kompas Kiblat';

  @override
  String get qiblaOverheadWarn =>
      'Elakkan meletakkan peranti berdekatan dengan objek logam atau peralatan elektrik.';

  @override
  String get qiblaCopyUrl => 'Pautan disalin :)';

  @override
  String get qiblaCalibrationTip => 'Tip kalibrasi';

  @override
  String get qiblaCalibrate => 'Gerakkan telefon anda dalam \'corak angka 8\'';

  @override
  String get qiblaCalibrateDone => 'Selesai';

  @override
  String get qiblaErrNoCompass =>
      'Maaf. Tiada penderia kompas terdapat dalam peranti ini.';

  @override
  String get qiblaErrBack => 'Kembali';

  @override
  String get feedbackTitle => 'Maklum Balas';

  @override
  String get feedbackFieldEmpty => 'Ruang tidak boleh kosong';

  @override
  String get feedbackWriteHere =>
      'Sila tinggalkan maklum balas/laporan anda di sini';

  @override
  String get feedbackIncorrectEmail => 'Format e-mel salah';

  @override
  String get feedbackEmailHere => 'Alamat e-mel anda (tak wajib)';

  @override
  String get feedbackViewDeviceInfo => 'Lihat...';

  @override
  String get feedbackDeviceInfoCopy => 'Disalin';

  @override
  String get feedbackDeviceInfoCopyAll => 'Salin semua';

  @override
  String get feedbackIncludeDeviceInfo => 'Sertakan maklumat peranti';

  @override
  String get feedbackDeviceInfoRecommended => '(Disyorkan)';

  @override
  String get feedbackTroubleDeviceInfo =>
      'Masalah mendapatkan maklumat peranti';

  @override
  String get feedbackGettingInfo => 'Sedang mendapatkan maklumat peranti...';

  @override
  String get feedbackAppMetadata => 'Metadata apl';

  @override
  String get feedbackAppMetadataSub => '(Sentiasa dihantar)';

  @override
  String get feedbackSensitive => 'Maklumat sensitif pengguna';

  @override
  String get feedbackSensitiveSub => 'Jika diperlukan sahaja';

  @override
  String get feedbackMessageContainQ =>
      'Nampak seperi mesej anda mengandungi soalan. Sila sertakan email anda supaya kami dapat menghubungi anda kembali.\n\nAdakah anda ingin menambah email?';

  @override
  String get feedbackSendAnyway => 'Hantar sahaja';

  @override
  String get feedbackAddEmail => 'Tambah email';

  @override
  String get feedbackSend => 'Hantar';

  @override
  String get feedbackAlsoDo => 'Anda juga boleh lakukan';

  @override
  String get feedbackReadFaq => 'Baca Soalan Lazim (FAQ)';

  @override
  String get feedbackReportGithub => 'Lapor / Ikuti isu-isu di GitHub';

  @override
  String get feedbackThanks =>
      'Terima kasih atas maklum balas anda yang berharga.';

  @override
  String get onboardingChooseLang => 'Pilih bahasa';

  @override
  String get onboardingSetLocation => 'Tetapkan lokasi anda';

  @override
  String get onboardingLocationDesc =>
      'Pastikan perkhidmatan lokasi dihidupkan supaya apl boleh menentukan lokasi terbaik';

  @override
  String get onboardingLocationToast =>
      'Lokasi ditetapkan. Anda boleh menukar lokasi pada bila-bila masa dengan mengetik kod lokasi di penjuru kanan sebelah atas.';

  @override
  String get onboardingLocationSet => 'Tetapkan lokasi';

  @override
  String get onboardingThemeFav => 'Tetapkan tema kegemaran anda';

  @override
  String get onboardingNotifOption => 'Pilih jenis pemberitahuan';

  @override
  String get onboardingNotifDefault => 'Pemberitahuan lalai';

  @override
  String get onboardingNotifAzan => 'Azan (penuh)';

  @override
  String get onboardingNotifShortAzan => 'Azan (pendek)';

  @override
  String onboardingNotifAutostart(String link) {
    return '**Autostart** perlu dihidupkan untuk apl menghantar pemberitahuan. [Ketahui lebih lanjut..]($link)';
  }

  @override
  String get onboardingNotifAutostartSetting => 'Buka Settings';

  @override
  String get onboardingFinish => 'Alhamdulillah. Selesai tetapan.';

  @override
  String get onboardingFinishDesc =>
      'Selamat datang. Terokai ciri dan ubah suai tetapan lain mengikut citarasa anda.';

  @override
  String get onboardingDone => 'Selesai';

  @override
  String get onboardingNext => 'Seterusnya';

  @override
  String get coachmarkDone => 'Selesai';

  @override
  String get coachmarkNext => 'Seterusnya';

  @override
  String get coachmarkPrevious => 'Sebelumnya';

  @override
  String get coachmarkEnd => 'Akhir panduan';

  @override
  String get permissionDialogTitle => 'Kebenaran diperlukan';

  @override
  String get permissionDialogSkip => 'Langkau';

  @override
  String get permissionDialogGrant => 'Berikan';

  @override
  String get autostartDialogPermissionContent =>
      'Sila benarkan aplikasi untuk Autostart agar dapat menerima pemberitahuan walaupun peranti dihidupkan semula';

  @override
  String get notifDialogPermissionContent =>
      'Sila berikan kebenaran pemberitahuan untuk membolehkan aplikasi ini menunjukkan pemberitahuan';

  @override
  String get notifExactAlarmDialogPermissionContent =>
      'Sila berikan kebenaran aplikasi untuk menjadual pemberitahuan pada masa yang tepat';

  @override
  String get zoneUpdatedToast => 'Lokasi dikemaskini';

  @override
  String get zoneYourLocation => 'Lokasi anda';

  @override
  String get zoneSetManually => 'Pilih sendiri';

  @override
  String get zoneSetThis => 'Tetapkan lokasi ini';

  @override
  String get zoneError => 'Ralat';

  @override
  String get zoneErrorPara1 =>
      'Sila semak **sambungan internet** dan **Perkhidmatan Lokasi (GPS)**.';

  @override
  String get zoneErrorPara2 =>
      'Sila **cuba semula** atau pilih untuk **menetapkan lokasi sendiri**.';

  @override
  String get zoneOpenLocationSettings => 'Buka Tetapan Lokasi';

  @override
  String get zoneLoading => 'Memuatkan';

  @override
  String get zoneManualSelectZone => 'Pilih zon';

  @override
  String zoneUpdatedSuccess(String zone) {
    return 'Zon waktu solat ditetapkan kepada $zone';
  }

  @override
  String get notifSettingBasic => 'Asas';

  @override
  String get notifSettingChangesDetect =>
      'Perubahan akan berkesan selepas memulakan semula aplikasi.';

  @override
  String get notifSettingRestartApp => 'Mulakan semula';

  @override
  String get notificationSettingPlayNotifTooltip =>
      'Bunyikan notifikasi percubaan';

  @override
  String get notifSettingSysSetting => 'Pemberitahuan apl Tetapan Sistem';

  @override
  String get notifSettingSysSettingDesc =>
      'Sesuaikan bunyi, ubah saluran pemberitahuan dll.';

  @override
  String get notifSettingTroubleshoot => 'Penyelesaian masalah';

  @override
  String get notifSettingTroubleshootDesc =>
      'Betulkan pemberitahuan tidak berfungsi pada sesetengah peranti';

  @override
  String notifSettingTroubleshootExample(String phonesModel) {
    return 'Contoh: $phonesModel dsb.';
  }

  @override
  String get notifSettingAdvancedTroubleshoot =>
      'Penyelesaian masalah lanjutan';

  @override
  String get notifSettingLimitNotif => 'Hadkan penjadualan pemberitahuan';

  @override
  String get notifSettingLimitNotifDesc =>
      'Hidupkan jika anda mengalami kelembapan yang melampau dalam apl. Pemberitahuan akan dijadualkan setiap minggu. Lalai adalah MATI (bulanan).';

  @override
  String get notifSettingForceReschedule =>
      'Paksa penjadualan pemberitahuan semula...';

  @override
  String get notifSettingForceRescheduleDesc =>
      'Secara lalai, pemberitahuan tidak akan dijadualkan semula jika penjadual terakhir dijalankan kurang daripada dua hari.\n\nKetik teruskan untuk memulakan penjadualan pemberitahuan segera. Apl akan dimulakan semula.';

  @override
  String get notifSettingCancel => 'Batal';

  @override
  String get notifSettingProceed => 'Teruskan';

  @override
  String get notifSettingNotifDemo =>
      'Notifikasi/azan akan berbunyi seperti ini';

  @override
  String get notifSettingsExactAlarmPermissionTitle =>
      'Kebenaran Penjadualan Pemberitahuan';

  @override
  String get notifSettingsExactAlarmPermissionGrantedSubtitle =>
      'Kebenaran diberikan. Aplikasi boleh menghantar pemberitahuan azan pada waktu solat';

  @override
  String get notifSettingsExactAlarmPermissionNotGrantedSubtitle =>
      'Kebenaran tidak diberikan. Aplikasi tidak dapat menghantar pemberitahuan azan. Ketik di sini untuk memberikan kebenaran';

  @override
  String get notifSheetExactAlarmTitle =>
      'Hidupkan kebenaran set notifikasi tepat waktu';

  @override
  String get notifSheetExactAlarmDescription =>
      'Hidupkan supaya kami dapat untuk menghantar pemberitahuan tepat waktu. Jika ditolak, penghantaran mungkin terlewat.';

  @override
  String get notifSheetExactAlarmPrimaryButton => 'Hidupkan sekarang';

  @override
  String get notifSheetExactAlarmCancel => 'Batal';

  @override
  String get notifSheetNotificationTitle => 'Pemberitahuan/Azan dimatikan';

  @override
  String get notifSheetNotificationDescription =>
      'Kami mungkin memerlukan beberapa kebenaran untuk dapat memainkan pemberitahuan/azan';

  @override
  String get notifSheetNotificationPrimaryButton => 'Hidupkan Pemberitahuan';

  @override
  String get notifSheetNotificationCancel => 'Biar dimatikan untuk masa ini';

  @override
  String get contributeShare => 'Kongsi aplikasi ini';

  @override
  String contributeShareContent(String playStoreShortLink, String webAppLink) {
    return 'Hi. Saya menggunakan aplikasi Waktu Solat Malaysia. Ia pantas dan percuma.\n\nCuba sekarang:\n$playStoreShortLink (Google Play)\n$webAppLink (Apl web)';
  }

  @override
  String get contributeShareSubject => 'Berkongsi Aplikasi Waktu Solat';

  @override
  String get contributeCopy => 'Salin';

  @override
  String get contributeOpen => 'Buka';

  @override
  String get contributeCopied => 'Disalin ke papan keratan';

  @override
  String get notifTsAdmonition =>
      'Peranti anda mungkin tidak terjejas dengan isu khusus ini.';

  @override
  String get notifTsPara1 =>
      'Sesetengah apl yang dipasang daripada **Gedung Google Play**, **Autostart** akan dilumpuhkan secara lalai. Disebabkan hal ini, pemberitahuan (kadang-kadang) tidak akan keluar pada telefon anda.';

  @override
  String get notifTsPara2 =>
      'Penyelesaiannya adalah untuk menghidupkan **Autostart** untuk apl ini. Ketik butang di bawah untuk membuka Tetapan Apl, kemudian cari pilihan Autostart untuk menghidupkannya.';

  @override
  String notifTsPara3(String link) {
    return 'Untuk ketahui lebih lanjut, sila ikuti [artikel ini]($link).';
  }

  @override
  String get notifTsOpenSetting => 'Buka Tetapan Apl';

  @override
  String get notifMonthlyReminderTitle => 'Peringatan bulanan segar semula';

  @override
  String get notifMonthlyReminderDesc =>
      'Untuk terus menerima pemberitahuan, buka aplikasi sekurang-kurangnya sekali setiap bulan.';

  @override
  String notifItsTime(String name) {
    return 'Telah masuk waktu $name';
  }

  @override
  String notifIn(String location) {
    return 'di $location';
  }

  @override
  String get notifEndSubh => 'Tamat waktu Subuh';

  @override
  String get whatsUpdateTitle =>
      'Baru sahaja dikemas kini kepada versi terkini.';

  @override
  String whatsUpdateContent(String releaseNotesLink) {
    return 'Apa yang baharu dalam kemaskini ini, baca lanjut di [sini]($releaseNotesLink).';
  }

  @override
  String get whatsUpdateChangelog => 'Nota keluaran';

  @override
  String get updatePageError => 'Ralat berlaku semasa menyemak kemas kini';

  @override
  String get updatePageTryAgain => 'Sila cuba lagi';

  @override
  String get updatePageAvailable => 'Kemas kini tersedia';

  @override
  String updatePageReleased(int day) {
    return 'Dikeluarkan $day hari lepas';
  }

  @override
  String get updatePageReleasedToday => 'Dikeluarkan hari ini';

  @override
  String updatePageCurrentVer(String version) {
    return 'Anda ada: **$version**';
  }

  @override
  String updatePageLatestVer(String version) {
    return 'Terkini tersedia: **$version**';
  }

  @override
  String get updatePageGPlay => 'Dapatkan kemas kini di Google Play';

  @override
  String get tasbihResetDialog => 'Pastikan set semula ?';

  @override
  String get tasbihReset => 'Set semula';
}
