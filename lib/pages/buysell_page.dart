// import 'package:flutter/material.dart';
// import 'package:orionschematic/pages/product_page.dart';
//
//
// /* ----------------- Buy & Sell Page ---------------- */
// class BuySellPage extends StatelessWidget {
//   const BuySellPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final items = List.generate(12, (i) => 'Part ${i + 1}');
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('ORION SCHEMATIC - Buy & Sell'),
//         automaticallyImplyLeading: false,
//       ), // ✅ Branding
//       body: GridView.builder(
//         padding: const EdgeInsets.all(12),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           mainAxisSpacing: 12,
//           crossAxisSpacing: 12,
//           childAspectRatio: 0.88,
//         ),
//         itemCount: items.length,
//         itemBuilder: (context, i) {
//           return GestureDetector(
//             onTap: () => Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => ProductPage(name: items[i])),
//             ),
//             child: Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               elevation: 8,
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: const BorderRadius.vertical(
//                           top: Radius.circular(12),
//                         ),
//                         color: Colors.grey.shade300,
//                       ),
//                       child: const Center(
//                         child: Icon(Icons.build_circle_rounded, size: 40),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           items[i],
//                           style: const TextStyle(fontWeight: FontWeight.w600),
//                         ),
//                         const SizedBox(height: 6),
//                         Text('Rp ${(i + 1) * 15000}'),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }