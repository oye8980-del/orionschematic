// // lib/controllers/locale_controller.dart
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class LocaleController extends ChangeNotifier {
//   Locale _locale;
//
//   LocaleController(this._locale);
//
//   Locale get locale => _locale;
//
//   Future<void> setLocale(Locale loc) async {
//     _locale = loc;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('app_locale', loc.languageCode);
//     notifyListeners();
//   }
//
//   static Future<Locale> loadSaved() async {
//     final prefs = await SharedPreferences.getInstance();
//     final code = prefs.getString('app_locale') ?? 'en';
//     return Locale(code);
//   }
// }
