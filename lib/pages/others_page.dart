import 'package:flutter/material.dart';
import 'package:orionschematic/pages/about_page.dart';
import 'package:orionschematic/pages/settings_page.dart';
import 'dart:ui';

class OthersPage extends StatelessWidget {
  const OthersPage({super.key});

  Widget buildSectionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04),
        border: Border.all(
          color: isDark ? Colors.white24 : Colors.black12,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.cyanAccent.withOpacity(0.08)
                : Colors.deepOrange.withOpacity(0.15),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: ListTile(
            leading: Icon(
              icon,
              size: 30,
              color: isDark ? Colors.cyanAccent : Colors.deepOrange,
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right_rounded,
              size: 26,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            onTap: onTap,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Others"),
        centerTitle: true,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // HEADER FUTURISTIK
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: isDark
                      ? [Colors.cyanAccent.withOpacity(0.25), Colors.transparent]
                      : [Colors.deepOrange.withOpacity(0.35), Colors.transparent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Text(
                "Control Panel",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.cyanAccent : Colors.deepOrange,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // LIST SECTION
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildSectionCard(
                      context: context,
                      icon: Icons.info_outline_rounded,
                      title: "About",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AboutPage()),
                        );
                      },
                    ),
                    buildSectionCard(
                      context: context,
                      icon: Icons.settings_rounded,
                      title: "Settings",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SettingsPage()),
                        );
                      },
                    ),
                    buildSectionCard(
                      context: context,
                      icon: Icons.support_agent_rounded,
                      title: "Support",
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Contact support")),
                        );
                      },
                    ),
                    buildSectionCard(
                      context: context,
                      icon: Icons.favorite_outline_rounded,
                      title: "Favorites",
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Favorites")),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
