// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class LanguageController extends ChangeNotifier {
//   Locale _locale = const Locale('en');
//
//   Locale get locale => _locale;
//
//   LanguageController() {
//     _loadLanguage();
//   }
//
//   Future<void> changeLanguage(String code) async {
//     _locale = Locale(code);
//     notifyListeners();
//
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setString("languageCode", code);
//   }
//
//   void _loadLanguage() async {
//     final prefs = await SharedPreferences.getInstance();
//     String code = prefs.getString("languageCode") ?? "en";
//     _locale = Locale(code);
//     notifyListeners();
//   }
// }
