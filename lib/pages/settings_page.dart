import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notifications = true;

  String appVersion = "";
  String deviceInfo = "";

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    notifications = prefs.getBool("notifications") ?? true;

    final info = await PackageInfo.fromPlatform();
    appVersion = "${info.version}+${info.buildNumber}";

    if (kIsWeb) {
      deviceInfo = "Platform: Web Browser";
    } else {
      deviceInfo =
      "OS: ${Platform.operatingSystem}\nVersion: ${Platform.operatingSystemVersion}";
    }

    setState(() {});
  }

  Future<void> save(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [


          const SizedBox(height: 20),
          section("About"),

          cardTile(
            title: "Device Info",
            icon: Icons.phone_android,
            value: deviceInfo,
          ),

          cardTile(
            title: "App Version",
            icon: Icons.info_outline,
            value: appVersion,
          ),

          cardTile(
            title: "Check for Updates",
            icon: Icons.system_update,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("You're using the latest version"),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // =============================================================================================

  Widget section(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
    );
  }

  Widget cardTile({
    required String title,
    required IconData icon,
    String? value,
    VoidCallback? onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: value != null ? Text(value) : null,
        trailing: onTap != null ? const Icon(Icons.chevron_right) : null,
        onTap: onTap,
      ),
    );
  }

  Widget cardSwitch({
    required String title,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Card(
      child: SwitchListTile(
        secondary: Icon(icon),
        title: Text(title),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
