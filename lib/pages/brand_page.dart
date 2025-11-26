import 'package:flutter/material.dart';
import 'package:orionschematic/pages/detail_item.dart';
import 'package:orionschematic/pages/home_page.dart';


/* --------------- Brand Page ----------------- */
class BrandPage extends StatelessWidget {
  final String deviceCategory; // "Handphone", "Tablet", atau "Laptop"
  final List<Map<String, String>> brands;

  const BrandPage({
    required this.deviceCategory,
    required this.brands,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Brand $deviceCategory'),
        backgroundColor: theme.brightness == Brightness.dark
            ? const Color(0xFF0A192F)
            : Colors.deepOrange,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 1.1,
        ),
        itemCount: brands.length,
        itemBuilder: (context, index) {
          final brand = brands[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TypePage(
                    brandName: brand['name']!,
                    deviceCategory: deviceCategory, // ✅ Tambahkan ini
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? Colors.white10
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    brand['logo']!,
                    width: 70,
                    height: 70,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    brand['name']!,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}