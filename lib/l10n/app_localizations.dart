// import 'package:flutter/material.dart';
//
// class AppLocalizations {
//   final Locale locale;
//
//   AppLocalizations(this.locale);
//
//   // Dummy lookup
//   static AppLocalizations of(BuildContext context) {
//     return Localizations.of<AppLocalizations>(context, AppLocalizations)
//         ?? AppLocalizations(const Locale('en'));
//   }
//
//   // DAFTAR TEXT YANG DIBACA DALAM APLIKASI
//   String get settings => "Settings";
//   String get appearance => "Appearance";
//   String get darkMode => "Dark Mode";
//   String get language => "Language";
//   String get general => "General";
//   String get clearCache => "Clear Cache";
//   String get resetApp => "Reset Application";
//   String get about => "About";
//   String get appVersion => "App Version";
//
// // Bisa ditambah sendiri nanti kalau perlu
// }
//
// class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
//   const AppLocalizationsDelegate();
//
//   @override
//   bool isSupported(Locale locale) => ['en', 'id'].contains(locale.languageCode);
//
//   @override
//   Future<AppLocalizations> load(Locale locale) async {
//     return AppLocalizations(locale);
//   }
//
//   @override
//   bool shouldReload(AppLocalizationsDelegate old) => false;
// }
