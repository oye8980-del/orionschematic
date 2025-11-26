import 'package:flutter/material.dart';
import 'package:orionschematic/pages/detail_item.dart';


/* ---------------- Find IC Page ---------------- */
class FindICPage extends StatefulWidget {
  const FindICPage({super.key});

  @override
  State<FindICPage> createState() => _FindICPageState();
}

class _FindICPageState extends State<FindICPage> {
  final TextEditingController _q = TextEditingController();
  final List<String> all = List.generate(120, (i) => 'IC-${1000 + i}');

  @override
  Widget build(BuildContext context) {
    final query = _q.text.trim().toLowerCase();
    final results = query.isEmpty
        ? all.take(30).toList()
        : all.where((e) => e.toLowerCase().contains(query)).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('ORION SCHEMATIC - Find IC'),
        automaticallyImplyLeading: false,
      ), // ✅ Branding konsisten
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _q,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search IC, e.g. IC-1010',
                suffixIcon: _q.text.isEmpty
                    ? null
                    : IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => setState(() => _q.clear()),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: results.isEmpty
                  ? const Center(child: Text('Tidak ditemukan'))
                  : ListView.separated(
                itemCount: results.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final it = results[i];
                  return ListTile(
                    tileColor: Theme.of(context).cardColor,
                    leading: const Icon(Icons.memory),
                    title: Text(it),
                    subtitle: const Text('Package | Value | Notes'),
                    trailing: IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailItemPage(title: it),
                        ),
                      ),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailItemPage(title: it),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}