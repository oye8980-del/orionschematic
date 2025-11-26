import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;
  String selectedLanguage = "English";

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Cache cleared successfully")),
    );
  }

  void resetApp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("App has been reset")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Appearance",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
            child: SwitchListTile(
              title: const Text("Dark Mode"),
              secondary: const Icon(Icons.dark_mode),
              value: isDarkMode,
              onChanged: (v) {
                setState(() => isDarkMode = v);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Theme changed to ${v ? "Dark" : "Light"}",
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            "General",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
            child: ListTile(
              leading: const Icon(Icons.language),
              title: const Text("Language"),
              subtitle: Text(selectedLanguage),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(18)),
                  ),
                  builder: (_) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: const Text("English"),
                        onTap: () {
                          setState(() => selectedLanguage = "English");
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text("Indonesia"),
                        onTap: () {
                          setState(() => selectedLanguage = "Indonesia");
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
            child: ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text("Clear Cache"),
              onTap: clearCache,
            ),
          ),

          const SizedBox(height: 12),

          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
            child: ListTile(
              leading: const Icon(Icons.warning_amber),
              title: const Text("Reset Application"),
              onTap: () => resetApp(),
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            "About",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
            child: ListTile(
              leading: const Icon(Icons.phone_android),
              title: const Text("Device Info"),
              subtitle: Text("Model, OS Version, etc (static demo)"),
            ),
          ),

          const SizedBox(height: 12),

          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
            child: const ListTile(
              leading: Icon(Icons.update),
              title: Text("App Version"),
              subtitle: Text("ORION SCHEMATIC v1.0.0"),
            ),
          ),
        ],
      ),
    );
  }
}
