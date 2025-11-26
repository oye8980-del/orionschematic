import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orionschematic/pages/detail_item.dart';

class FindAllPage extends StatefulWidget {
  const FindAllPage({super.key});

  @override
  State<FindAllPage> createState() => _FindAllPageState();
}

class _FindAllPageState extends State<FindAllPage> {
  final TextEditingController _search = TextEditingController();

  /// Semua data gabungan dari JSON
  List<Map<String, String>> allItems = [];

  /// List hasil pencarian
  List<Map<String, String>> filtered = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadJson();
  }

  Future<void> loadJson() async {
    try {
      final raw = await rootBundle.loadString('assets/data/categories.json');
      final data = jsonDecode(raw);

      /// Flatten JSON → jadikan list untuk search
      List<Map<String, String>> temp = [];

      data.forEach((category, items) {
        for (var item in items) {
          temp.add({
            'name': item.toString(),
            'category': category.toString(),
          });
        }
      });

      setState(() {
        allItems = temp;
        filtered = temp; // default tampil semua
        loading = false;
      });
    } catch (e) {
      print("ERROR LOAD JSON: $e");
    }
  }

  void doSearch(String q) {
    q = q.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        filtered = allItems;
      } else {
        filtered = allItems
            .where((e) => e['name']!.toLowerCase().contains(q))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ORION SCHEMATIC - Search All'),
        automaticallyImplyLeading: false,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            // ====== SEARCH BAR ======
            TextField(
              controller: _search,
              onChanged: doSearch,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search anything...',
                suffixIcon: _search.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _search.clear();
                    doSearch('');
                  },
                )
                    : null,
                filled: true,
                fillColor: theme.cardColor.withOpacity(0.6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ====== LIST RESULTS ======
            Expanded(
              child: filtered.isEmpty
                  ? const Center(child: Text("Tidak ditemukan"))
                  : ListView.separated(
                itemCount: filtered.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 6),
                itemBuilder: (_, i) {
                  final item = filtered[i];

                  return Material(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(10),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      leading: const Icon(Icons.apps_rounded),
                      title: Text(item['name']!),
                      subtitle: Text(
                        "Kategori: ${item['category']}",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailItemPage(
                              title: item['name']!,
                            ),
                          ),
                        );
                      },
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
