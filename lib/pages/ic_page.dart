import 'package:flutter/material.dart';
import 'package:orionschematic/data_loader.dart';
import 'package:orionschematic/pages/home_page.dart';
import 'package:orionschematic/pages/detail_item.dart';




class FindICPage extends StatefulWidget {
  const FindICPage({super.key});

  @override
  State<FindICPage> createState() => _FindICPageState();
}

class _FindICPageState extends State<FindICPage> {
  final TextEditingController _q = TextEditingController();
  List<String> all = [];
  bool loading = true;

  String? _openedItem;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    await Future.delayed(const Duration(milliseconds: 200));

    List<String> result = [];
    for (final category in allTypeData.entries) {
      for (final brand in category.value.entries) {
        for (final model in brand.value) {
          result.add("${brand.key} $model");
        }
      }
    }

    setState(() {
      all = result;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find IC / Model / Brand'),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isDesktop = constraints.maxWidth > 750;

          final double horizontalPadding = isDesktop ? constraints.maxWidth * 0.15 : 12;
          final double cardPadding = isDesktop ? 18 : 14;
          final double cardFont = isDesktop ? 18 : 16;

          final query = _q.text.trim().toLowerCase();
          final results = query.isEmpty
              ? all.take(40).toList()
              : all.where((e) => e.toLowerCase().contains(query)).toList();

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 12),
            child: Column(
              children: [
                // SEARCH BAR
                TextField(
                  controller: _q,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Contoh: Samsung J2 Prime, iPhone 4s...',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.08),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    suffixIcon: _q.text.isEmpty
                        ? null
                        : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() => _q.clear()),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                Expanded(
                  child: results.isEmpty
                      ? const Center(child: Text('Tidak ditemukan'))
                      : ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, i) {
                      final item = results[i];
                      final isOpen = _openedItem == item;

                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _openedItem = isOpen ? null : item;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: EdgeInsets.symmetric(
                                horizontal: cardPadding,
                                vertical: cardPadding,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(
                                    Theme.of(context).brightness == Brightness.dark ? 0.08 : 1),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 8,
                                    offset: const Offset(2, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: cardFont,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    isOpen
                                        ? Icons.keyboard_arrow_up_rounded
                                        : Icons.keyboard_arrow_down_rounded,
                                    size: isDesktop ? 30 : 26,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // DROPDOWN DETAIL
                          AnimatedCrossFade(
                            duration: const Duration(milliseconds: 230),
                            crossFadeState: isOpen
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            firstChild: Padding(
                              padding: EdgeInsets.only(left: isDesktop ? 24 : 12, bottom: 8),
                              child: Column(
                                children: [
                                  _buildOption(
                                    icon: Icons.grid_view_rounded,
                                    text: "Layout",
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => TypeDetailPage(
                                            brandName: item,
                                            componentName: "$item - Layout",
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  _buildOption(
                                    icon: Icons.bolt_rounded,
                                    text: "Schematic",
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => TypeDetailPage(
                                            brandName: item,
                                            componentName: "$item - Schematic",
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            secondChild: const SizedBox.shrink(),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOption({required IconData icon, required String text, required VoidCallback onTap}) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Icon(icon, size: 22),
      title: Text(text),
      minLeadingWidth: 0,
      onTap: onTap,
    );
  }
}