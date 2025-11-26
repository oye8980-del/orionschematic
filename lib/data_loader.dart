import 'dart:convert';
import 'package:flutter/services.dart';

Map<String, dynamic> allTypeData = {};

Future<void> loadAllTypeData() async {
  final jsonString = await rootBundle.loadString('assets/data/categories.json');
  allTypeData = jsonDecode(jsonString);
}