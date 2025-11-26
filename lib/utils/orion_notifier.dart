import 'package:shared_preferences/shared_preferences.dart';

class ORIONNotifier {
  static Future<List<String>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('notifications') ?? [];
  }

  static Future<void> addNotification(String message) async {
    final prefs = await SharedPreferences.getInstance();
    final notifications = prefs.getStringList('notifications') ?? [];
    notifications.insert(0, message); // yang baru muncul di atas
    await prefs.setStringList('notifications', notifications);
  }

  static Future<void> clearNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('notifications');
  }
}
