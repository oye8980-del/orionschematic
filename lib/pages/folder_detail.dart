import 'package:flutter/material.dart';
import 'package:orionschematic/pages/detail_item.dart';


/* ---------------- Folder Detail & Item ---------------- */
class FolderDetailPage extends StatelessWidget {
  final String folder;

  const FolderDetailPage({required this.folder, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ORION SCHEMATIC - $folder')),
      // ✅ Branding konsisten
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: 6,
        itemBuilder: (context, i) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(child: Text('${i + 1}')),
              title: Text('$folder - Item ${i + 1}'),
              subtitle: const Text('Description here'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      DetailItemPage(title: '$folder - Item ${i + 1}'),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}