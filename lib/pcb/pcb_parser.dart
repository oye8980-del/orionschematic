// class PcbComponent {
//   String footprint = "";
//   List<List<String>> blocks = [];
// }
//
// List<PcbComponent> parsePcb(String text) {
//   final lines = text.split('\n');
//   final components = <PcbComponent>[];
//
//   PcbComponent? current;
//   List<String> currentBlock = [];
//
//   for (var raw in lines) {
//     final line = raw.trim();
//     if (line.isEmpty) continue;
//
//     if (line == "COMP") {
//       // mulai blok baru
//       current = PcbComponent();
//       currentBlock = [];
//       continue;
//     }
//
//     if (line.startsWith("FPAD_")) {
//       if (current != null) current!.footprint = line;
//       currentBlock = [line];
//       continue;
//     }
//
//     if (line == "ENDCOMP") {
//       if (current != null) {
//         if (currentBlock.isNotEmpty) {
//           current!.blocks.add(List.from(currentBlock));
//         }
//         components.add(current!);
//       }
//       current = null;
//       continue;
//     }
//
//     // Jika baris bagian dari footprint
//     if (current != null) {
//       currentBlock.add(line);
//
//       if (line == "1") {
//         // tanda akhir sub-block
//         current!.blocks.add(List.from(currentBlock));
//         currentBlock = [];
//       }
//     }
//   }
//
//   return components;
// }
