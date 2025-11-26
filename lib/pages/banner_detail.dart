import 'package:flutter/material.dart';


/* ----------------- Banner Detail ------------------ */
class BannerDetailPage extends StatelessWidget {
  final String title;
  final String subtitle;

  const BannerDetailPage({
    required this.title,
    required this.subtitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ORION SCHEMATIC - $title')),
      // ✅ Branding konsisten
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            const Text('Detail banner, bisa isi tutorial, file PDF atau link.'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Open resource'))),
              child: const Text('Open Resource'),
            ),
          ],
        ),
      ),
    );
  }
}