import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class OppoPage extends StatelessWidget {
  final String oppo;
  const OppoPage({required this.oppo, super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'icon': Icons.phone_android,
        'title': '$oppo A1k Schematic',
        'subtitle': 'Mainboard, Charging, Display Circuit',
        'description':
        'Skematik lengkap untuk Oppo A1k, mencakup jalur mainboard, charging IC, dan LCD connector.',
        'pdfPath': 'assets/pdf/Ariel a1k.pdf',
      },
      {
        'icon': Icons.bolt,
        'title': '$oppo A3s Power Section',
        'subtitle': 'IC Power, PMIC, VBAT flow',
        'description':
        'Menjelaskan diagram arus daya dan komponen IC PMIC pada Oppo A3s.',
        'pdfPath': 'assets/pdf/Ariel a3s.pdf',
      },
      {
        'icon': Icons.wifi,
        'title': '$oppo A5 Network Diagram',
        'subtitle': 'Antenna, SIM, RF Signal Layout',
        'description':
        'Jalur sinyal antena dan koneksi RF untuk modul jaringan Oppo A5.',
        'pdfPath': 'assets/pdf/Ariel a5.pdf',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: Text('ORION SCHEMATIC - $oppo')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: items.length,
        itemBuilder: (context, i) {
          final item = items[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.deepPurple.shade100,
                child: Icon(item['icon'] as IconData, color: Colors.deepPurple),
              ),
              title: Text(item['title'] as String),
              subtitle: Text(item['subtitle'] as String),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailItemPage(item: item),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/* ---------------- DETAIL ITEM PAGE ---------------- */
class DetailItemPage extends StatelessWidget {
  final Map<String, dynamic> item;
  const DetailItemPage({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    final title = item['title'] as String;
    final subtitle = item['subtitle'] as String;
    final description = item['description'] as String;
    final icon = item['icon'] as IconData;
    final pdfPath = item['pdfPath'] as String;

    return Scaffold(
      appBar: AppBar(title: Text('ORION SCHEMATIC - $title')),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.grey.shade300,
              ),
              child: Center(
                child: Icon(icon, size: 72, color: Colors.deepPurple),
              ),
            ),
            const SizedBox(height: 20),
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(subtitle,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.grey)),
            const SizedBox(height: 16),
            Text(
              description,
              textAlign: TextAlign.justify,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.visibility_outlined),
                    label: const Text('Preview'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PDFViewerPage(
                            title: title,
                            pdfPath: pdfPath,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.download),
                    label: const Text('Download'),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Downloading: $title')),
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

/* ---------------- PDF VIEWER PAGE ---------------- */
class PDFViewerPage extends StatelessWidget {
  final String title;
  final String pdfPath;
  const PDFViewerPage({required this.title, required this.pdfPath, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SfPdfViewer.asset(pdfPath),
    );
  }
}