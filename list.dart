
// // // // import 'package:flutter/material.dart';
// // // // import 'package:cloud_firestore/cloud_firestore.dart';

// // // // class InventoryPage extends StatefulWidget {
// // // //   const InventoryPage({super.key});

// // // //   @override
// // // //   State<InventoryPage> createState() => _InventoryPageState();
// // // // }

// // // // class _InventoryPageState extends State<InventoryPage> {
// // // //   final FirebaseFirestore firestore = FirebaseFirestore.instance;

// // // //   // =========================
// // // //   // CREATE UNIQUE KEY
// // // //   // =========================
// // // //   String key(String product, String category) {
// // // //     return "$product-$category";
// // // //   }

// // // //   // =========================
// // // //   // BUILD TILE
// // // //   // =========================
// // // // Widget buildTile({
// // // //   required Map<String, dynamic> inventoryData,
// // // //   required double predicted,
// // // // }) {
// // // //   final int stock = (inventoryData["stock"] ?? 0) as int;
// // // //   final String product = inventoryData["product"] ?? "Unknown Product";
// // // //   final String category = inventoryData["category"] ?? "Uncategorized";

// // // //   // More accurate risk calculation
// // // //   final bool isLowStock = predicted > stock;
// // // //   final double shortageRatio = (predicted - stock) / predicted;
  
// // // //   // Risk level: 0.0 (safe) to 1.0 (critical)
// // // //   double riskLevel;
// // // //   if (stock == 0) {
// // // //     riskLevel = 1.0;
// // // //   } else if (predicted <= stock) {
// // // //     riskLevel = 0.0;
// // // //   } else {
// // // //     riskLevel = (predicted - stock) / predicted;
// // // //     riskLevel = riskLevel.clamp(0.0, 1.0);
// // // //   }

// // // //   // Professional color scheme
// // // //   final Color statusColor = isLowStock ? Colors.red.shade700 : Colors.green.shade700;
// // // //   final Color progressColor = isLowStock
// // // //       ? Colors.red.shade400
// // // //       : (predicted > stock * 0.7 ? Colors.orange.shade400 : Colors.green.shade400);

// // // //   // Coverage percentage
// // // //   final double coveragePercent = stock == 0 ? 0 : ((stock / predicted) * 100).clamp(0.0, 200.0);
// // // //   final double progressValue = (stock / predicted).clamp(0.0, 1.0);

// // // //   return Card(
// // // //     margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// // // //     elevation: 2,
// // // //     shape: RoundedRectangleBorder(
// // // //       borderRadius: BorderRadius.circular(16),
// // // //     ),
// // // //     child: Container(
// // // //       decoration: BoxDecoration(
// // // //         borderRadius: BorderRadius.circular(16),
// // // //         border: Border.all(
// // // //           color: statusColor.withOpacity(isLowStock ? 0.5 : 0.2),
// // // //           width: 1.5,
// // // //         ),
// // // //       ),
// // // //       child: Padding(
// // // //         padding: const EdgeInsets.all(16),
// // // //         child: Column(
// // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // //           children: [
// // // //             // Header row with product name and status badge
// // // //             Row(
// // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // //               children: [
// // // //                 Expanded(
// // // //                   child: Column(
// // // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // // //                     children: [
// // // //                       Text(
// // // //                         product,
// // // //                         style: const TextStyle(
// // // //                           fontSize: 18,
// // // //                           fontWeight: FontWeight.w600,
// // // //                           letterSpacing: -0.3,
// // // //                         ),
// // // //                         maxLines: 2,
// // // //                         overflow: TextOverflow.ellipsis,
// // // //                       ),
// // // //                       const SizedBox(height: 4),
// // // //                       Container(
// // // //                         padding: const EdgeInsets.symmetric(
// // // //                           horizontal: 8,
// // // //                           vertical: 2,
// // // //                         ),
// // // //                         decoration: BoxDecoration(
// // // //                           color: Colors.grey.shade100,
// // // //                           borderRadius: BorderRadius.circular(12),
// // // //                         ),
// // // //                         child: Text(
// // // //                           category,
// // // //                           style: TextStyle(
// // // //                             fontSize: 12,
// // // //                             color: Colors.grey.shade700,
// // // //                             fontWeight: FontWeight.w500,
// // // //                           ),
// // // //                         ),
// // // //                       ),
// // // //                     ],
// // // //                   ),
// // // //                 ),
// // // //                 const SizedBox(width: 12),
// // // //                 // Status badge
// // // //                 Container(
// // // //                   padding: const EdgeInsets.symmetric(
// // // //                     horizontal: 14,
// // // //                     vertical: 6,
// // // //                   ),
// // // //                   decoration: BoxDecoration(
// // // //                     color: statusColor,
// // // //                     borderRadius: BorderRadius.circular(20),
// // // //                     boxShadow: isLowStock
// // // //                         ? [
// // // //                             BoxShadow(
// // // //                               color: statusColor.withOpacity(0.3),
// // // //                               blurRadius: 4,
// // // //                               offset: const Offset(0, 2),
// // // //                             ),
// // // //                           ]
// // // //                         : null,
// // // //                   ),
// // // //                   child: Text(
// // // //                     isLowStock ? "CRITICAL" : "ADEQUATE",
// // // //                     style: const TextStyle(
// // // //                       color: Colors.white,
// // // //                       fontSize: 12,
// // // //                       fontWeight: FontWeight.bold,
// // // //                       letterSpacing: 0.5,
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //               ],
// // // //             ),

// // // //             const SizedBox(height: 16),

// // // //             // Metrics grid
// // // //             Row(
// // // //               children: [
// // // //                 Expanded(
// // // //                   child: _buildMetricCard(
// // // //                     label: "Current Stock",
// // // //                     value: stock.toString(),
// // // //                     unit: "units",
// // // //                     icon: Icons.inventory_2_outlined,
// // // //                     color: Colors.blue.shade600,
// // // //                   ),
// // // //                 ),
// // // //                 const SizedBox(width: 12),
// // // //                 Expanded(
// // // //                   child: _buildMetricCard(
// // // //                     label: "Predicted Demand",
// // // //                     value: predicted.toStringAsFixed(0),
// // // //                     unit: "units",
// // // //                     icon: Icons.trending_up_outlined,
// // // //                     color: Colors.purple.shade600,
// // // //                   ),
// // // //                 ),
// // // //                 const SizedBox(width: 12),
// // // //                 Expanded(
// // // //                   child: _buildMetricCard(
// // // //                     label: "Coverage",
// // // //                     value: coveragePercent.toStringAsFixed(0),
// // // //                     unit: "%",
// // // //                     icon: Icons.pie_chart_outline,
// // // //                     color: isLowStock ? Colors.red.shade600 : Colors.green.shade600,
// // // //                   ),
// // // //                 ),
// // // //               ],
// // // //             ),

// // // //             const SizedBox(height: 20),

// // // //             // Risk indicator with professional styling
// // // //             Column(
// // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // //               children: [
// // // //                 Row(
// // // //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // //                   children: [
// // // //                     Text(
// // // //                       "Stock Coverage",
// // // //                       style: TextStyle(
// // // //                         fontSize: 12,
// // // //                         fontWeight: FontWeight.w500,
// // // //                         color: Colors.grey.shade600,
// // // //                       ),
// // // //                     ),
// // // //                     Text(
// // // //                       isLowStock
// // // //                           ? "${(-shortageRatio * 100).toStringAsFixed(0)}% deficit"
// // // //                           : "${coveragePercent.toStringAsFixed(0)}% covered",
// // // //                       style: TextStyle(
// // // //                         fontSize: 12,
// // // //                         fontWeight: FontWeight.w600,
// // // //                         color: statusColor,
// // // //                       ),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //                 const SizedBox(height: 8),
// // // //                 ClipRRect(
// // // //                   borderRadius: BorderRadius.circular(8),
// // // //                   child: LinearProgressIndicator(
// // // //                     value: progressValue,
// // // //                     minHeight: 8,
// // // //                     backgroundColor: Colors.grey.shade200,
// // // //                     valueColor: AlwaysStoppedAnimation<Color>(progressColor),
// // // //                   ),
// // // //                 ),
// // // //               ],
// // // //             ),

// // // //             if (isLowStock) ...[
// // // //               const SizedBox(height: 12),
// // // //               Container(
// // // //                 padding: const EdgeInsets.all(12),
// // // //                 decoration: BoxDecoration(
// // // //                   color: Colors.red.shade50,
// // // //                   borderRadius: BorderRadius.circular(12),
// // // //                   border: Border.all(
// // // //                     color: Colors.red.shade200,
// // // //                     width: 1,
// // // //                   ),
// // // //                 ),
// // // //                 child: Row(
// // // //                   children: [
// // // //                     Icon(Icons.warning_amber_rounded, size: 20, color: Colors.red.shade700),
// // // //                     const SizedBox(width: 8),
// // // //                     Expanded(
// // // //                       child: Text(
// // // //                         "Order ${(predicted - stock).ceil()} units to meet predicted demand",
// // // //                         style: TextStyle(
// // // //                           fontSize: 13,
// // // //                           fontWeight: FontWeight.w500,
// // // //                           color: Colors.red.shade800,
// // // //                         ),
// // // //                       ),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     ),
// // // //   );
// // // // }

// // // // // Helper widget for metric cards
// // // // Widget _buildMetricCard({
// // // //   required String label,
// // // //   required String value,
// // // //   required String unit,
// // // //   required IconData icon,
// // // //   required Color color,
// // // // }) {
// // // //   return Container(
// // // //     padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
// // // //     decoration: BoxDecoration(
// // // //       color: color.withOpacity(0.08),
// // // //       borderRadius: BorderRadius.circular(12),
// // // //     ),
// // // //     child: Column(
// // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // //       children: [
// // // //         Row(
// // // //           children: [
// // // //             Icon(icon, size: 14, color: color),
// // // //             const SizedBox(width: 4),
// // // //             Text(
// // // //               label,
// // // //               style: TextStyle(
// // // //                 fontSize: 11,
// // // //                 fontWeight: FontWeight.w500,
// // // //                 color: Colors.grey.shade600,
// // // //               ),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //         const SizedBox(height: 6),
// // // //         Row(
// // // //           crossAxisAlignment: CrossAxisAlignment.baseline,
// // // //           textBaseline: TextBaseline.alphabetic,
// // // //           children: [
// // // //             Text(
// // // //               value,
// // // //               style: TextStyle(
// // // //                 fontSize: 20,
// // // //                 fontWeight: FontWeight.bold,
// // // //                 color: color,
// // // //               ),
// // // //             ),
// // // //             const SizedBox(width: 2),
// // // //             Text(
// // // //               unit,
// // // //               style: TextStyle(
// // // //                 fontSize: 10,
// // // //                 color: Colors.grey.shade500,
// // // //                 fontWeight: FontWeight.w500,
// // // //               ),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ],
// // // //     ),
// // // //   );
// // // // }
// // // // // Widget buildTile({
// // // // //   required Map<String, dynamic> inventoryData,
// // // // //   required double predicted,
// // // // // }) {
// // // // //   int stock = (inventoryData["stock"] ?? 0);

// // // // //   String product = inventoryData["product"] ?? "";
// // // // //   String category = inventoryData["category"] ?? "";

// // // // //   // TRUE low stock condition (IMPORTANT FIX)
// // // // //   bool lowStock = predicted > stock;

// // // // //   // Heat intensity (0.0 - 1.0)
// // // // //   double ratio = stock == 0 ? 1 : (predicted / stock);
// // // // //   if (ratio > 2) ratio = 2;
// // // // //   ratio = ratio / 2;

// // // // //   Color heatColor = Color.lerp(
// // // // //     Colors.green,
// // // // //     Colors.red,
// // // // //     ratio,
// // // // //   )!;

// // // // //   return Card(
// // // // //     margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// // // // //     elevation: 4,
// // // // //     child: Container(
// // // // //       decoration: BoxDecoration(
// // // // //         borderRadius: BorderRadius.circular(12),
// // // // //         border: Border.all(
// // // // //           color: heatColor.withOpacity(0.7),
// // // // //           width: 2,
// // // // //         ),
// // // // //       ),
// // // // //       child: ListTile(
// // // // //         title: Text(
// // // // //           product,
// // // // //           style: const TextStyle(
// // // // //             fontWeight: FontWeight.bold,
// // // // //           ),
// // // // //         ),

// // // // //         subtitle: Column(
// // // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // // //           children: [
// // // // //             const SizedBox(height: 6),

// // // // //             Text("Category: $category"),
// // // // //             Text("Current Stock: $stock"),
// // // // //             Text("Predicted Demand: ${predicted.toStringAsFixed(0)}"),

// // // // //             const SizedBox(height: 8),

// // // // //             // 🔥 HEATMAP BAR
// // // // //             ClipRRect(
// // // // //               borderRadius: BorderRadius.circular(6),
// // // // //               child: LinearProgressIndicator(
// // // // //                 value: ratio > 1 ? 1 : ratio,
// // // // //                 minHeight: 10,
// // // // //                 backgroundColor: Colors.grey.shade300,
// // // // //                 valueColor: AlwaysStoppedAnimation(heatColor),
// // // // //               ),
// // // // //             ),
// // // // //           ],
// // // // //         ),

// // // // //         trailing: Container(
// // // // //           padding: const EdgeInsets.symmetric(
// // // // //             horizontal: 12,
// // // // //             vertical: 8,
// // // // //           ),
// // // // //           decoration: BoxDecoration(
// // // // //             color: lowStock ? Colors.red : Colors.green,
// // // // //             borderRadius: BorderRadius.circular(8),
// // // // //           ),
// // // // //           child: Text(
// // // // //             lowStock ? "LOW STOCK" : "OK",
// // // // //             style: const TextStyle(
// // // // //               color: Colors.white,
// // // // //               fontWeight: FontWeight.bold,
// // // // //             ),
// // // // //           ),
// // // // //         ),
// // // // //       ),
// // // // //     ),
// // // // //   );
// // // // // }
// // // //   // =========================
// // // //   // UI
// // // //   // =========================
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(
// // // //         title: const Text("Inventory Sync Dashboard"),
// // // //         backgroundColor: Colors.blue,
// // // //       ),

// // // //       body: StreamBuilder<QuerySnapshot>(
// // // //         stream: firestore.collection("inventory").snapshots(),

// // // //         builder: (context, inventorySnapshot) {
// // // //           if (!inventorySnapshot.hasData) {
// // // //             return const Center(
// // // //               child: CircularProgressIndicator(),
// // // //             );
// // // //           }

// // // //           final inventoryDocs = inventorySnapshot.data!.docs;

// // // //           if (inventoryDocs.isEmpty) {
// // // //             return const Center(
// // // //               child: Text("No Inventory Found"),
// // // //             );
// // // //           }

// // // //           // =========================
// // // //           // LOAD PREDICTIONS
// // // //           // =========================
// // // //           return StreamBuilder<QuerySnapshot>(
// // // //             stream: firestore
// // // //                 .collection("inventory_predictions")
// // // //                 .snapshots(),

// // // //             builder: (context, predictionSnapshot) {
// // // //               if (!predictionSnapshot.hasData) {
// // // //                 return const Center(
// // // //                   child: CircularProgressIndicator(),
// // // //                 );
// // // //               }

// // // //               final predictionDocs = predictionSnapshot.data!.docs;

// // // //               // =========================
// // // //               // CREATE PREDICTION MAP
// // // //               // =========================
// // // //               Map<String, double> predictionMap = {};

// // // //               for (var doc in predictionDocs) {
// // // //                 final data = doc.data() as Map<String, dynamic>;

// // // //                 String product = data["product"] ?? "";
// // // //                 String category = data["category"] ?? "";

// // // //                 double predicted =
// // // //                     (data["predicted_units"] ?? 0).toDouble();

// // // //                 predictionMap[
// // // //                     key(product, category)] = predicted;
// // // //               }

// // // //               // =========================
// // // //               // BUILD LIST
// // // //               // =========================
// // // //               return ListView.builder(
// // // //                 itemCount: inventoryDocs.length,

// // // //                 itemBuilder: (context, index) {
// // // //                   final inventoryData =
// // // //                       inventoryDocs[index].data()
// // // //                           as Map<String, dynamic>;

// // // //                   String product =
// // // //                       inventoryData["product"] ?? "";

// // // //                   String category =
// // // //                       inventoryData["category"] ?? "";

// // // //                   double predicted = predictionMap[
// // // //                           key(product, category)] ??
// // // //                       0;

// // // //                   return buildTile(
// // // //                     inventoryData: inventoryData,
// // // //                     predicted: predicted,
// // // //                   );
// // // //                 },
// // // //               );
// // // //             },
// // // //           );
// // // //         },
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // // // 
// // // import 'package:flutter/material.dart';
// // // import 'package:cloud_firestore/cloud_firestore.dart';

// // // class InventoryPage extends StatefulWidget {
// // //   const InventoryPage({super.key});

// // //   @override
// // //   State<InventoryPage> createState() => _InventoryPageState();
// // // }

// // // class _InventoryPageState extends State<InventoryPage> {
// // //   final FirebaseFirestore firestore = FirebaseFirestore.instance;
// // //   String? _lastSavedSnapshotKey;

// // //   String key(String product, String category) {
// // //     return "$product-$category";
// // //   }

// // //   Future<void> saveLiveStockStatus(
// // //     List<QueryDocumentSnapshot> inventoryDocs,
// // //     Map<String, double> predictionMap,
// // //   ) async {
// // //     final batch = FirebaseFirestore.instance.batch();

// // //     for (var doc in inventoryDocs) {
// // //       final data = doc.data() as Map<String, dynamic>;

// // //       String product = data["product"] ?? "";
// // //       String category = data["category"] ?? "";

// // //       double stock = (data["stock"] ?? 0).toDouble();
// // //       double predicted = predictionMap[key(product, category)] ?? 0;

// // //       double deficit = predicted - stock;
// // //       bool lowStock = predicted > stock;

// // //       final ref = FirebaseFirestore.instance
// // //           .collection("inventory_status")
// // //           .doc(key(product, category));

// // //       batch.set(ref, {
// // //         "product": product,
// // //         "category": category,
// // //         "stock": stock,
// // //         "predicted": predicted,
// // //         "deficit": deficit,
// // //         "lowStock": lowStock,
// // //         "updatedAt": FieldValue.serverTimestamp(),
// // //       });
// // //     }

// // //     await batch.commit();
// // //   }

// // //   // =========================
// // //   // IMPROVED TILE UI
// // //   // =========================
// // //   Widget buildTile({
// // //     required Map<String, dynamic> inventoryData,
// // //     required double predicted,
// // //   }) {
// // //     final int stock = (inventoryData["stock"] ?? 0);
// // //     final String product = inventoryData["product"] ?? "Unknown";
// // //     final String category = inventoryData["category"] ?? "General";

// // //     final bool isLowStock = predicted > stock;
// // //     final double coverage = stock == 0 || predicted == 0 
// // //         ? 0 
// // //         : ((stock / predicted) * 100).clamp(0, 200);
// // //     final double progress = predicted == 0 ? 0 : (stock / predicted).clamp(0.0, 1.0);
// // //     final Color statusColor = isLowStock ? Colors.red : Colors.green;
// // //     final int neededUnits = (predicted - stock).ceil();

// // //     return TweenAnimationBuilder<double>(
// // //       tween: Tween(begin: 0, end: progress),
// // //       duration: const Duration(milliseconds: 800),
// // //       builder: (context, value, child) {
// // //         return Card(
// // //           margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// // //           elevation: 0,
// // //           shape: RoundedRectangleBorder(
// // //             borderRadius: BorderRadius.circular(20),
// // //             side: BorderSide(
// // //               color: statusColor.withOpacity(0.3),
// // //               width: 1,
// // //             ),
// // //           ),
// // //           child: ClipRRect(
// // //             borderRadius: BorderRadius.circular(20),
// // //             child: Material(
// // //               color: Colors.white,
// // //               child: InkWell(
// // //                 onLongPress: () => _showDetailsDialog(product, stock, predicted, coverage),
// // //                 splashColor: statusColor.withOpacity(0.05),
// // //                 child: Padding(
// // //                   padding: const EdgeInsets.all(18),
// // //                   child: Column(
// // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // //                     children: [
// // //                       // Header Row with Status Badge
// // //                       Row(
// // //                         children: [
// // //                           // Status Icon
// // //                           Container(
// // //                             width: 40,
// // //                             height: 40,
// // //                             decoration: BoxDecoration(
// // //                               color: statusColor.withOpacity(0.1),
// // //                               borderRadius: BorderRadius.circular(12),
// // //                             ),
// // //                             child: Icon(
// // //                               isLowStock ? Icons.warning_amber_rounded : Icons.check_circle_rounded,
// // //                               color: statusColor,
// // //                               size: 22,
// // //                             ),
// // //                           ),
// // //                           const SizedBox(width: 12),
// // //                           // Product Info
// // //                           Expanded(
// // //                             child: Column(
// // //                               crossAxisAlignment: CrossAxisAlignment.start,
// // //                               children: [
// // //                                 Text(
// // //                                   product,
// // //                                   style: const TextStyle(
// // //                                     fontSize: 17,
// // //                                     fontWeight: FontWeight.w700,
// // //                                     letterSpacing: -0.3,
// // //                                   ),
// // //                                   maxLines: 1,
// // //                                   overflow: TextOverflow.ellipsis,
// // //                                 ),
// // //                                 const SizedBox(height: 4),
// // //                                 Container(
// // //                                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
// // //                                   decoration: BoxDecoration(
// // //                                     color: Colors.grey.shade100,
// // //                                     borderRadius: BorderRadius.circular(8),
// // //                                   ),
// // //                                   child: Text(
// // //                                     category,
// // //                                     style: TextStyle(
// // //                                       fontSize: 11,
// // //                                       color: Colors.grey.shade600,
// // //                                       fontWeight: FontWeight.w500,
// // //                                     ),
// // //                                   ),
// // //                                 ),
// // //                               ],
// // //                             ),
// // //                           ),
// // //                           // Status Badge
// // //                           Container(
// // //                             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// // //                             decoration: BoxDecoration(
// // //                               gradient: LinearGradient(
// // //                                 colors: isLowStock 
// // //                                     ? [Colors.red.shade600, Colors.red.shade800]
// // //                                     : [Colors.green.shade500, Colors.green.shade700],
// // //                                 begin: Alignment.topLeft,
// // //                                 end: Alignment.bottomRight,
// // //                               ),
// // //                               borderRadius: BorderRadius.circular(20),
// // //                               boxShadow: [
// // //                                 BoxShadow(
// // //                                   color: statusColor.withOpacity(0.3),
// // //                                   blurRadius: 4,
// // //                                   offset: const Offset(0, 2),
// // //                                 ),
// // //                               ],
// // //                             ),
// // //                             child: Row(
// // //                               mainAxisSize: MainAxisSize.min,
// // //                               children: [
// // //                                 Icon(
// // //                                   isLowStock ? Icons.arrow_downward : Icons.arrow_upward,
// // //                                   size: 12,
// // //                                   color: Colors.white,
// // //                                 ),
// // //                                 const SizedBox(width: 4),
// // //                                 Text(
// // //                                   isLowStock ? "CRITICAL" : "HEALTHY",
// // //                                   style: const TextStyle(
// // //                                     color: Colors.white,
// // //                                     fontSize: 10,
// // //                                     fontWeight: FontWeight.bold,
// // //                                     letterSpacing: 0.5,
// // //                                   ),
// // //                                 ),
// // //                               ],
// // //                             ),
// // //                           ),
// // //                         ],
// // //                       ),

// // //                       const SizedBox(height: 20),

// // //                       // Metrics Row
// // //                       Row(
// // //                         children: [
// // //                           Expanded(
// // //                             child: _buildMetricChip(
// // //                               "Stock",
// // //                               stock.toString(),
// // //                               Icons.inventory_2_rounded,
// // //                               Colors.blue,
// // //                             ),
// // //                           ),
// // //                           const SizedBox(width: 10),
// // //                           Expanded(
// // //                             child: _buildMetricChip(
// // //                               "Demand",
// // //                               predicted.toStringAsFixed(0),
// // //                               Icons.trending_up_rounded,
// // //                               Colors.purple,
// // //                             ),
// // //                           ),
// // //                           const SizedBox(width: 10),
// // //                           Expanded(
// // //                             child: _buildMetricChip(
// // //                               "Coverage",
// // //                               "${coverage.toStringAsFixed(0)}%",
// // //                               Icons.pie_chart_rounded,
// // //                               statusColor,
// // //                             ),
// // //                           ),
// // //                         ],
// // //                       ),

// // //                       const SizedBox(height: 18),

// // //                       // Progress Section
// // //                       Column(
// // //                         crossAxisAlignment: CrossAxisAlignment.start,
// // //                         children: [
// // //                           Row(
// // //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                             children: [
// // //                               Text(
// // //                                 "Stock Coverage",
// // //                                 style: TextStyle(
// // //                                   fontSize: 11,
// // //                                   fontWeight: FontWeight.w600,
// // //                                   color: Colors.grey.shade500,
// // //                                   letterSpacing: 0.4,
// // //                                 ),
// // //                               ),
// // //                               Container(
// // //                                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
// // //                                 decoration: BoxDecoration(
// // //                                   color: statusColor.withOpacity(0.1),
// // //                                   borderRadius: BorderRadius.circular(10),
// // //                                 ),
// // //                                 child: Text(
// // //                                   isLowStock 
// // //                                       ? "${(100 - coverage).toStringAsFixed(0)}% DEFICIT"
// // //                                       : "${coverage.toStringAsFixed(0)}% COVERED",
// // //                                   style: TextStyle(
// // //                                     fontSize: 9,
// // //                                     fontWeight: FontWeight.w700,
// // //                                     color: statusColor,
// // //                                     letterSpacing: 0.3,
// // //                                   ),
// // //                                 ),
// // //                               ),
// // //                             ],
// // //                           ),
// // //                           const SizedBox(height: 8),
// // //                           ClipRRect(
// // //                             borderRadius: BorderRadius.circular(8),
// // //                             child: LinearProgressIndicator(
// // //                               value: value,
// // //                               minHeight: 8,
// // //                               backgroundColor: Colors.grey.shade100,
// // //                               valueColor: AlwaysStoppedAnimation<Color>(
// // //                                 isLowStock ? Colors.red : Colors.green,
// // //                               ),
// // //                             ),
// // //                           ),
// // //                         ],
// // //                       ),

// // //                       // Alert Message for Low Stock
// // //                       if (isLowStock) ...[
// // //                         const SizedBox(height: 16),
// // //                         AnimatedContainer(
// // //                           duration: const Duration(milliseconds: 300),
// // //                           padding: const EdgeInsets.all(12),
// // //                           decoration: BoxDecoration(
// // //                             color: Colors.red.shade50,
// // //                             borderRadius: BorderRadius.circular(12),
// // //                             border: Border.all(color: Colors.red.shade200),
// // //                           ),
// // //                           child: Row(
// // //                             children: [
// // //                               Container(
// // //                                 padding: const EdgeInsets.all(6),
// // //                                 decoration: BoxDecoration(
// // //                                   color: Colors.red.shade100,
// // //                                   borderRadius: BorderRadius.circular(8),
// // //                                 ),
// // //                                 child: Icon(
// // //                                   Icons.shopping_cart_rounded,
// // //                                   size: 18,
// // //                                   color: Colors.red.shade700,
// // //                                 ),
// // //                               ),
// // //                               const SizedBox(width: 12),
// // //                               Expanded(
// // //                                 child: Column(
// // //                                   crossAxisAlignment: CrossAxisAlignment.start,
// // //                                   children: [
// // //                                     Text(
// // //                                       "Reorder Recommended",
// // //                                       style: TextStyle(
// // //                                         fontSize: 12,
// // //                                         fontWeight: FontWeight.w700,
// // //                                         color: Colors.red.shade800,
// // //                                       ),
// // //                                     ),
// // //                                     Text(
// // //                                       "Order $neededUnits units to meet predicted demand",
// // //                                       style: TextStyle(
// // //                                         fontSize: 11,
// // //                                         color: Colors.red.shade700,
// // //                                       ),
// // //                                     ),
// // //                                   ],
// // //                                 ),
// // //                               ),
// // //                             ],
// // //                           ),
// // //                         ),
// // //                       ],

// // //                       // Last Updated Timestamp
// // //                       const SizedBox(height: 12),
// // //                       Row(
// // //                         children: [
// // //                           Icon(Icons.access_time, size: 10, color: Colors.grey.shade400),
// // //                           const SizedBox(width: 4),
// // //                           Text(
// // //                             "Updated just now",
// // //                             style: TextStyle(fontSize: 9, color: Colors.grey.shade400),
// // //                           ),
// // //                         ],
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //               ),
// // //             ),
// // //           ),
// // //         );
// // //       },
// // //     );
// // //   }

// // //   Widget _buildMetricChip(String label, String value, IconData icon, Color color) {
// // //     return Container(
// // //       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
// // //       decoration: BoxDecoration(
// // //         color: color.withOpacity(0.05),
// // //         borderRadius: BorderRadius.circular(12),
// // //         border: Border.all(color: color.withOpacity(0.15)),
// // //       ),
// // //       child: Column(
// // //         children: [
// // //           Icon(icon, size: 16, color: color),
// // //           const SizedBox(height: 6),
// // //           Text(
// // //             value,
// // //             style: TextStyle(
// // //               fontSize: 16,
// // //               fontWeight: FontWeight.bold,
// // //               color: color,
// // //             ),
// // //           ),
// // //           Text(
// // //             label,
// // //             style: TextStyle(fontSize: 9, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   void _showDetailsDialog(String product, int stock, double predicted, double coverage) {
// // //     showModalBottomSheet(
// // //       context: context,
// // //       shape: const RoundedRectangleBorder(
// // //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
// // //       ),
// // //       builder: (context) => Container(
// // //         padding: const EdgeInsets.all(24),
// // //         child: Column(
// // //           mainAxisSize: MainAxisSize.min,
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             Center(
// // //               child: Container(
// // //                 width: 40,
// // //                 height: 4,
// // //                 decoration: BoxDecoration(
// // //                   color: Colors.grey.shade300,
// // //                   borderRadius: BorderRadius.circular(2),
// // //                 ),
// // //               ),
// // //             ),
// // //             const SizedBox(height: 20),
// // //             Text(
// // //               product,
// // //               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// // //             ),
// // //             const SizedBox(height: 16),
// // //             _buildDetailRow("Current Stock", "$stock units", Icons.inventory),
// // //             _buildDetailRow("Predicted Demand", "${predicted.toStringAsFixed(0)} units", Icons.trending_up),
// // //             _buildDetailRow("Coverage Ratio", "${coverage.toStringAsFixed(0)}%", Icons.pie_chart),
// // //             _buildDetailRow(
// // //               "Status",
// // //               predicted > stock ? "Low Stock - Reorder Required" : "Stock Adequate",
// // //               predicted > stock ? Icons.warning : Icons.check_circle,
// // //               predicted > stock ? Colors.red : Colors.green,
// // //             ),
// // //             const SizedBox(height: 20),
// // //             SizedBox(
// // //               width: double.infinity,
// // //               child: ElevatedButton(
// // //                 onPressed: () => Navigator.pop(context),
// // //                 style: ElevatedButton.styleFrom(
// // //                   backgroundColor: Colors.blue.shade700,
// // //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // //                 ),
// // //                 child: const Text("Close"),
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildDetailRow(String label, String value, IconData icon, [Color? color]) {
// // //     return Padding(
// // //       padding: const EdgeInsets.symmetric(vertical: 8),
// // //       child: Row(
// // //         children: [
// // //           Icon(icon, size: 20, color: color ?? Colors.grey.shade600),
// // //           const SizedBox(width: 12),
// // //           Expanded(
// // //             child: Text(label, style: TextStyle(color: Colors.grey.shade600)),
// // //           ),
// // //           Text(
// // //             value,
// // //             style: TextStyle(
// // //               fontWeight: FontWeight.w600,
// // //               color: color ?? Colors.black87,
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   // =========================
// // //   // MAIN UI WITH SUMMARY BAR
// // //   // =========================
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: const Color(0xffF5F7FA),
// // //       appBar: AppBar(
// // //         title: const Text(
// // //           "Inventory Dashboard",
// // //           style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
// // //         ),
// // //         backgroundColor: Colors.white,
// // //         foregroundColor: Colors.black87,
// // //         elevation: 0,
// // //         centerTitle: false,
// // //         actions: [
// // //           IconButton(
// // //             icon: const Icon(Icons.refresh_rounded),
// // //             onPressed: () => setState(() {}),
// // //             tooltip: "Refresh",
// // //           ),
// // //         ],
// // //       ),
// // //       body: StreamBuilder<QuerySnapshot>(
// // //         stream: firestore.collection("inventory").snapshots(),
// // //         builder: (context, inventorySnapshot) {
// // //           if (!inventorySnapshot.hasData) {
// // //             return const Center(
// // //               child: CircularProgressIndicator(),
// // //             );
// // //           }

// // //           final inventoryDocs = inventorySnapshot.data!.docs;

// // //           return StreamBuilder<QuerySnapshot>(
// // //             stream: firestore.collection("inventory_predictions").snapshots(),
// // //             builder: (context, predictionSnapshot) {
// // //               if (!predictionSnapshot.hasData) {
// // //                 return const Center(
// // //                   child: CircularProgressIndicator(),
// // //                 );
// // //               }

// // //               final predictionDocs = predictionSnapshot.data!.docs;

// // //               Map<String, double> predictionMap = {};

// // //               for (var doc in predictionDocs) {
// // //                 final data = doc.data() as Map<String, dynamic>;
// // //                 String product = data["product"] ?? "";
// // //                 String category = data["category"] ?? "";
// // //                 double predicted = (data["predicted_units"] ?? 0).toDouble();
// // //                 predictionMap[key(product, category)] = predicted;
// // //               }

// // //               final snapshotKey = "${inventoryDocs.length}_${predictionDocs.length}";
// // //               if (_lastSavedSnapshotKey != snapshotKey) {
// // //                 _lastSavedSnapshotKey = snapshotKey;
// // //                 WidgetsBinding.instance.addPostFrameCallback((_) {
// // //                   saveLiveStockStatus(inventoryDocs, predictionMap);
// // //                 });
// // //               }

// // //               // Calculate summary stats
// // //               int lowStockCount = 0;
// // //               int totalStock = 0;
// // //               for (var doc in inventoryDocs) {
// // //                 final data = doc.data() as Map<String, dynamic>;
// // //                 String product = data["product"] ?? "";
// // //                 String category = data["category"] ?? "";
// // //                 double predicted = predictionMap[key(product, category)] ?? 0;
// // //                 int stock = data["stock"] ?? 0;
// // //                 totalStock += stock;
// // //                 if (predicted > stock) lowStockCount++;
// // //               }

// // //               return Column(
// // //                 children: [
// // //                   // Summary Bar
// // //                   Container(
// // //                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// // //                     decoration: BoxDecoration(
// // //                       color: Colors.white,
// // //                       boxShadow: [
// // //                         BoxShadow(
// // //                           color: Colors.black.withOpacity(0.02),
// // //                           blurRadius: 4,
// // //                           offset: const Offset(0, 2),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                     child: Row(
// // //                       mainAxisAlignment: MainAxisAlignment.spaceAround,
// // //                       children: [
// // //                         _summaryChip("Total Items", inventoryDocs.length.toString(), Icons.inventory, Colors.blue),
// // //                         _summaryChip("Low Stock", lowStockCount.toString(), Icons.warning, Colors.red),
// // //                         _summaryChip("Total Units", totalStock.toString(), Icons.add_box_outlined, Colors.green),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                   Expanded(
// // //                     child: ListView.builder(
// // //                       padding: const EdgeInsets.symmetric(vertical: 8),
// // //                       itemCount: inventoryDocs.length,
// // //                       itemBuilder: (context, index) {
// // //                         final data = inventoryDocs[index].data() as Map<String, dynamic>;
// // //                         String product = data["product"] ?? "";
// // //                         String category = data["category"] ?? "";
// // //                         double predicted = predictionMap[key(product, category)] ?? 0;
// // //                         return buildTile(inventoryData: data, predicted: predicted);
// // //                       },
// // //                     ),
// // //                   ),
// // //                 ],
// // //               );
// // //             },
// // //           );
// // //         },
// // //       ),
// // //     );
// // //   }

// // //   Widget _summaryChip(String label, String value, IconData icon, Color color) {
// // //     return Container(
// // //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// // //       decoration: BoxDecoration(
// // //         color: color.withOpacity(0.05),
// // //         borderRadius: BorderRadius.circular(30),
// // //       ),
// // //       child: Row(
// // //         children: [
// // //           Icon(icon, size: 16, color: color),
// // //           const SizedBox(width: 6),
// // //           Text(
// // //             label,
// // //             style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
// // //           ),
// // //           const SizedBox(width: 4),
// // //           Text(
// // //             value,
// // //             style: TextStyle(
// // //               fontWeight: FontWeight.bold,
// // //               color: color,
// // //               fontSize: 14,
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }
// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';

// // class InventoryPage extends StatefulWidget {
// //   const InventoryPage({super.key});

// //   @override
// //   State<InventoryPage> createState() => _InventoryPageState();
// // }

// // class _InventoryPageState extends State<InventoryPage> {
// //   final FirebaseFirestore firestore = FirebaseFirestore.instance;
// //   String? _lastSavedSnapshotKey;
  
// //   // Search Controller
// //   final TextEditingController _searchController = TextEditingController();
// //   String _searchQuery = "";
  
// //   // Filter options
// //   String _statusFilter = "All"; // All, Low Stock, Healthy
  
// //   // Safety stock gap (15%)
// //   static const double safetyGap = 1.15;

// //   String key(String product, String category) {
// //     return "$product-$category";
// //   }

// //   Future<void> saveLiveStockStatus(
// //     List<QueryDocumentSnapshot> inventoryDocs,
// //     Map<String, double> predictionMap,
// //   ) async {
// //     final batch = FirebaseFirestore.instance.batch();

// //     for (var doc in inventoryDocs) {
// //       final data = doc.data() as Map<String, dynamic>;

// //       String product = data["product"] ?? "";
// //       String category = data["category"] ?? "";

// //       double stock = (data["stock"] ?? 0).toDouble();
// //       double predicted = predictionMap[key(product, category)] ?? 0;
      
// //       double predictedWithGap = predicted * safetyGap;
// //       double deficit = predictedWithGap - stock;
// //       bool lowStock = predictedWithGap > stock;

// //       final ref = FirebaseFirestore.instance
// //           .collection("inventory_status")
// //           .doc(key(product, category));

// //       batch.set(ref, {
// //         "product": product,
// //         "category": category,
// //         "stock": stock,
// //         "predicted": predicted,
// //         "predictedWithGap": predictedWithGap,
// //         "safetyGap": 0.15,
// //         "deficit": deficit,
// //         "lowStock": lowStock,
// //         "updatedAt": FieldValue.serverTimestamp(),
// //       });
// //     }

// //     await batch.commit();
// //   }

// //   // =========================
// //   // IMPROVED TILE UI WITH PASTEL COLORS
// //   // =========================
// //   Widget buildTile({
// //     required Map<String, dynamic> inventoryData,
// //     required double predicted,
// //   }) {
// //     final int stock = (inventoryData["stock"] ?? 0);
// //     final String product = inventoryData["product"] ?? "Unknown";
// //     final String category = inventoryData["category"] ?? "General";

// //     final double predictedWithGap = predicted * safetyGap;
// //     final bool isLowStock = predictedWithGap > stock;
// //     final double coverage = stock == 0 || predictedWithGap == 0 
// //         ? 0 
// //         : ((stock / predictedWithGap) * 100).clamp(0, 200);
// //     final double progress = predictedWithGap == 0 ? 0 : (stock / predictedWithGap).clamp(0.0, 1.0);
    
// //     // Pastel colors from Material (built-in)
// //     final Color statusColor = isLowStock ? Colors.red.shade300 : Colors.green.shade300;
// //     final Color cardBgColor = isLowStock ? Colors.red.shade50 : Colors.green.shade50;
// //     final Color accentColor = isLowStock ? Colors.red.shade400 : Colors.green.shade400;
    
// //     final int neededUnits = (predictedWithGap - stock).ceil();

// //     return TweenAnimationBuilder<double>(
// //       tween: Tween(begin: 0, end: progress),
// //       duration: const Duration(milliseconds: 800),
// //       builder: (context, value, child) {
// //         return Card(
// //           margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //           elevation: 0,
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(24),
// //           ),
// //           child: ClipRRect(
// //             borderRadius: BorderRadius.circular(24),
// //             child: Material(
// //               color: Colors.white,
// //               child: InkWell(
// //                 onLongPress: () => _showDetailsDialog(
// //                   product, stock, predicted, predictedWithGap, coverage
// //                 ),
// //                 splashColor: statusColor.withOpacity(0.1),
// //                 child: Container(
// //                   decoration: BoxDecoration(
// //                     border: Border(
// //                       left: BorderSide(
// //                         color: accentColor,
// //                         width: 6,
// //                       ),
// //                     ),
// //                   ),
// //                   child: Padding(
// //                     padding: const EdgeInsets.all(18),
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         // Header Row
// //                         Row(
// //                           children: [
// //                             // Status Icon with Pastel Background
// //                             Container(
// //                               width: 44,
// //                               height: 44,
// //                               decoration: BoxDecoration(
// //                                 color: cardBgColor,
// //                                 borderRadius: BorderRadius.circular(14),
// //                               ),
// //                               child: Icon(
// //                                 isLowStock ? Icons.warning_amber_rounded : Icons.check_circle_rounded,
// //                                 color: accentColor,
// //                                 size: 24,
// //                               ),
// //                             ),
// //                             const SizedBox(width: 14),
// //                             // Product Info
// //                             Expanded(
// //                               child: Column(
// //                                 crossAxisAlignment: CrossAxisAlignment.start,
// //                                 children: [
// //                                   Text(
// //                                     product,
// //                                     style: const TextStyle(
// //                                       fontSize: 16,
// //                                       fontWeight: FontWeight.w700,
// //                                       letterSpacing: -0.3,
// //                                     ),
// //                                     maxLines: 1,
// //                                     overflow: TextOverflow.ellipsis,
// //                                   ),
// //                                   const SizedBox(height: 6),
// //                                   Row(
// //                                     children: [
// //                                       Container(
// //                                         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
// //                                         decoration: BoxDecoration(
// //                                           color: Colors.grey.shade100,
// //                                           borderRadius: BorderRadius.circular(12),
// //                                         ),
// //                                         child: Text(
// //                                           category,
// //                                           style: TextStyle(
// //                                             fontSize: 11,
// //                                             color: Colors.grey.shade700,
// //                                             fontWeight: FontWeight.w500,
// //                                           ),
// //                                         ),
// //                                       ),
// //                                       const SizedBox(width: 8),
// //                                       Container(
// //                                         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
// //                                         decoration: BoxDecoration(
// //                                           color: Colors.amber.shade50,
// //                                           borderRadius: BorderRadius.circular(8),
// //                                         ),
// //                                         child: const Row(
// //                                           mainAxisSize: MainAxisSize.min,
// //                                           children: [
// //                                             Icon(Icons.shield, size: 10, color: Colors.amber),
// //                                             SizedBox(width: 2),
// //                                             Text(
// //                                               "+15% Gap",
// //                                               style: TextStyle(
// //                                                 fontSize: 8,
// //                                                 fontWeight: FontWeight.w600,
// //                                                 color: Colors.amber,
// //                                               ),
// //                                             ),
// //                                           ],
// //                                         ),
// //                                       ),
// //                                     ],
// //                                   ),
// //                                 ],
// //                               ),
// //                             ),
// //                             // Status Badge
// //                             Container(
// //                               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
// //                               decoration: BoxDecoration(
// //                                 color: cardBgColor,
// //                                 borderRadius: BorderRadius.circular(24),
// //                               ),
// //                               child: Text(
// //                                 isLowStock ? "LOW STOCK" : "OK",
// //                                 style: TextStyle(
// //                                   color: accentColor,
// //                                   fontSize: 12,
// //                                   fontWeight: FontWeight.bold,
// //                                   letterSpacing: 0.5,
// //                                 ),
// //                               ),
// //                             ),
// //                           ],
// //                         ),

// //                         const SizedBox(height: 20),

// //                         // Metrics Row with Pastel Colors
// //                         Row(
// //                           children: [
// //                             Expanded(
// //                               child: _buildMetricChip(
// //                                 "Stock",
// //                                 stock.toString(),
// //                                 Icons.inventory_2_rounded,
// //                                 Colors.blue.shade300,
// //                                 Colors.blue.shade50,
// //                               ),
// //                             ),
// //                             const SizedBox(width: 10),
// //                             Expanded(
// //                               child: _buildMetricChip(
// //                                 "Demand",
// //                                 "${predictedWithGap.toStringAsFixed(0)}",
// //                                 Icons.trending_up_rounded,
// //                                 Colors.purple.shade300,
// //                                 Colors.purple.shade50,
// //                               ),
// //                             ),
// //                             const SizedBox(width: 10),
// //                             Expanded(
// //                               child: _buildMetricChip(
// //                                 "Coverage",
// //                                 "${coverage.toStringAsFixed(0)}%",
// //                                 Icons.pie_chart_rounded,
// //                                 isLowStock ? Colors.red.shade300 : Colors.green.shade300,
// //                                 isLowStock ? Colors.red.shade50 : Colors.green.shade50,
// //                               ),
// //                             ),
// //                           ],
// //                         ),

// //                         const SizedBox(height: 16),

// //                         // Progress Section
// //                         Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Row(
// //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                               children: [
// //                                 Text(
// //                                   "Stock Coverage",
// //                                   style: TextStyle(
// //                                     fontSize: 11,
// //                                     fontWeight: FontWeight.w600,
// //                                     color: Colors.grey.shade500,
// //                                   ),
// //                                 ),
// //                                 Container(
// //                                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
// //                                   decoration: BoxDecoration(
// //                                     color: cardBgColor,
// //                                     borderRadius: BorderRadius.circular(12),
// //                                   ),
// //                                   child: Text(
// //                                     isLowStock 
// //                                         ? "${(100 - coverage).toStringAsFixed(0)}% Needed"
// //                                         : "${coverage.toStringAsFixed(0)}% Covered",
// //                                     style: TextStyle(
// //                                       fontSize: 10,
// //                                       fontWeight: FontWeight.w600,
// //                                       color: accentColor,
// //                                     ),
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                             const SizedBox(height: 10),
// //                             ClipRRect(
// //                               borderRadius: BorderRadius.circular(10),
// //                               child: LinearProgressIndicator(
// //                                 value: value,
// //                                 minHeight: 10,
// //                                 backgroundColor: cardBgColor,
// //                                 valueColor: AlwaysStoppedAnimation<Color>(accentColor),
// //                               ),
// //                             ),
// //                           ],
// //                         ),

// //                         // Alert Message for Low Stock
// //                         if (isLowStock) ...[
// //                           const SizedBox(height: 16),
// //                           Container(
// //                             padding: const EdgeInsets.all(14),
// //                             decoration: BoxDecoration(
// //                               color: Colors.red.shade50,
// //                               borderRadius: BorderRadius.circular(16),
// //                               border: Border.all(color: Colors.red.shade100),
// //                             ),
// //                             child: Row(
// //                               children: [
// //                                 Container(
// //                                   padding: const EdgeInsets.all(8),
// //                                   decoration: BoxDecoration(
// //                                     color: Colors.red.shade100,
// //                                     borderRadius: BorderRadius.circular(12),
// //                                   ),
// //                                   child: Icon(
// //                                     Icons.shopping_cart_rounded,
// //                                     size: 20,
// //                                     color: Colors.red.shade700,
// //                                   ),
// //                                 ),
// //                                 const SizedBox(width: 14),
// //                                 Expanded(
// //                                   child: Column(
// //                                     crossAxisAlignment: CrossAxisAlignment.start,
// //                                     children: [
// //                                       Text(
// //                                         "Reorder Required",
// //                                         style: TextStyle(
// //                                           fontSize: 13,
// //                                           fontWeight: FontWeight.w700,
// //                                           color: Colors.red.shade800,
// //                                         ),
// //                                       ),
// //                                       Text(
// //                                         "Order $neededUnits units now",
// //                                         style: TextStyle(
// //                                           fontSize: 12,
// //                                           color: Colors.red.shade700,
// //                                         ),
// //                                       ),
// //                                     ],
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         ],

// //                         const SizedBox(height: 10),
// //                         Row(
// //                           children: [
// //                             Icon(Icons.access_time, size: 10, color: Colors.grey.shade400),
// //                             const SizedBox(width: 4),
// //                             Text(
// //                               "Updated just now",
// //                               style: TextStyle(fontSize: 9, color: Colors.grey.shade400),
// //                             ),
// //                           ],
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   Widget _buildMetricChip(String label, String value, IconData icon, Color color, Color bgColor) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
// //       decoration: BoxDecoration(
// //         color: bgColor,
// //         borderRadius: BorderRadius.circular(14),
// //       ),
// //       child: Column(
// //         children: [
// //           Icon(icon, size: 18, color: color),
// //           const SizedBox(height: 8),
// //           Text(
// //             value,
// //             style: TextStyle(
// //               fontSize: 16,
// //               fontWeight: FontWeight.bold,
// //               color: color,
// //             ),
// //           ),
// //           Text(
// //             label,
// //             style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   void _showDetailsDialog(
// //     String product, 
// //     int stock, 
// //     double predicted, 
// //     double predictedWithGap,
// //     double coverage,
// //   ) {
// //     showModalBottomSheet(
// //       context: context,
// //       shape: const RoundedRectangleBorder(
// //         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
// //       ),
// //       builder: (context) => Container(
// //         padding: const EdgeInsets.all(24),
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Center(
// //               child: Container(
// //                 width: 50,
// //                 height: 4,
// //                 decoration: BoxDecoration(
// //                   color: Colors.grey.shade300,
// //                   borderRadius: BorderRadius.circular(2),
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 20),
// //             Text(
// //               product,
// //               style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
// //             ),
// //             const SizedBox(height: 20),
// //             _buildDetailRow("Current Stock", "$stock units", Icons.inventory_rounded),
// //             _buildDetailRow("ML Prediction", "${predicted.toStringAsFixed(0)} units", Icons.analytics),
// //             _buildDetailRow("With 15% Gap", "${predictedWithGap.toStringAsFixed(0)} units", Icons.shield, Colors.amber),
// //             _buildDetailRow("Coverage", "${coverage.toStringAsFixed(0)}%", Icons.pie_chart),
// //             const Divider(height: 24),
// //             _buildDetailRow(
// //               "Status",
// //               predictedWithGap > stock ? "⚠️ Low Stock - Reorder Required" : "✅ Stock Adequate",
// //               predictedWithGap > stock ? Icons.warning : Icons.check_circle,
// //               predictedWithGap > stock ? Colors.red : Colors.green,
// //             ),
// //             const SizedBox(height: 20),
// //             SizedBox(
// //               width: double.infinity,
// //               child: ElevatedButton(
// //                 onPressed: () => Navigator.pop(context),
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: Colors.blue.shade400,
// //                   foregroundColor: Colors.white,
// //                   padding: const EdgeInsets.symmetric(vertical: 14),
// //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// //                 ),
// //                 child: const Text("Close", style: TextStyle(fontWeight: FontWeight.w600)),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildDetailRow(String label, String value, IconData icon, [Color? color]) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 8),
// //       child: Row(
// //         children: [
// //           Icon(icon, size: 20, color: color ?? Colors.grey.shade600),
// //           const SizedBox(width: 12),
// //           Expanded(
// //             child: Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
// //           ),
// //           Text(
// //             value,
// //             style: TextStyle(
// //               fontWeight: FontWeight.w600,
// //               color: color ?? Colors.black87,
// //               fontSize: 14,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _summaryChip(String label, String value, IconData icon, Color color, Color bgColor) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
// //       decoration: BoxDecoration(
// //         color: bgColor,
// //         borderRadius: BorderRadius.circular(30),
// //       ),
// //       child: Row(
// //         children: [
// //           Icon(icon, size: 16, color: color),
// //           const SizedBox(width: 8),
// //           Text(
// //             label,
// //             style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500),
// //           ),
// //           const SizedBox(width: 4),
// //           Text(
// //             value,
// //             style: TextStyle(
// //               fontWeight: FontWeight.bold,
// //               color: color,
// //               fontSize: 14,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // Clear search
// //   void _clearSearch() {
// //     setState(() {
// //       _searchQuery = "";
// //       _searchController.clear();
// //     });
// //   }

// //   // Filter items based on search and status
// //   List<QueryDocumentSnapshot> _filterItems(
// //     List<QueryDocumentSnapshot> items,
// //     Map<String, double> predictionMap,
// //   ) {
// //     return items.where((doc) {
// //       final data = doc.data() as Map<String, dynamic>;
// //       final product = (data["product"] ?? "").toLowerCase();
// //       final category = (data["category"] ?? "").toLowerCase();
// //       final stock = (data["stock"] ?? 0);
// //       final predicted = predictionMap[key(product, category)] ?? 0;
// //       final predictedWithGap = predicted * safetyGap;
// //       final isLowStock = predictedWithGap > stock;
      
// //       // Apply status filter
// //       if (_statusFilter == "Low Stock" && !isLowStock) return false;
// //       if (_statusFilter == "Healthy" && isLowStock) return false;
      
// //       // Apply search filter
// //       if (_searchQuery.isNotEmpty) {
// //         return product.contains(_searchQuery.toLowerCase()) || 
// //                category.contains(_searchQuery.toLowerCase());
// //       }
      
// //       return true;
// //     }).toList();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xffF8F9FA),
// //       appBar: AppBar(
// //         title: const Text(
// //           "Inventory Dashboard",
// //           style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
// //         ),
// //         backgroundColor: Colors.white,
// //         foregroundColor: Colors.black87,
// //         elevation: 0,
// //         centerTitle: false,
// //         actions: [
// //           // Safety Gap Indicator
// //           Container(
// //             margin: const EdgeInsets.only(right: 8),
// //             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //             decoration: BoxDecoration(
// //               color: Colors.amber.shade50,
// //               borderRadius: BorderRadius.circular(24),
// //             ),
// //             child: Row(
// //               children: [
// //                 Icon(Icons.shield, size: 14, color: Colors.amber.shade700),
// //                 const SizedBox(width: 4),
// //                 Text(
// //                   "15% Gap",
// //                   style: TextStyle(
// //                     fontSize: 11,
// //                     fontWeight: FontWeight.w600,
// //                     color: Colors.amber.shade800,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           IconButton(
// //             icon: const Icon(Icons.refresh_rounded),
// //             onPressed: () => setState(() {}),
// //             tooltip: "Refresh",
// //           ),
// //         ],
// //         bottom: PreferredSize(
// //           preferredSize: const Size.fromHeight(100),
// //           child: Padding(
// //             padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
// //             child: Column(
// //               children: [
// //                 // Search Bar
// //                 Container(
// //                   decoration: BoxDecoration(
// //                     color: Colors.grey.shade50,
// //                     borderRadius: BorderRadius.circular(16),
// //                     border: Border.all(color: Colors.grey.shade200),
// //                   ),
// //                   child: TextField(
// //                     controller: _searchController,
// //                     onChanged: (value) {
// //                       setState(() {
// //                         _searchQuery = value;
// //                       });
// //                     },
// //                     decoration: InputDecoration(
// //                       hintText: "Search by product or category...",
// //                       hintStyle: TextStyle(color: Colors.grey.shade400),
// //                       prefixIcon: Icon(Icons.search_rounded, color: Colors.grey.shade500, size: 20),
// //                       suffixIcon: _searchQuery.isNotEmpty
// //                           ? IconButton(
// //                               icon: Icon(Icons.clear, size: 18, color: Colors.grey.shade500),
// //                               onPressed: _clearSearch,
// //                             )
// //                           : null,
// //                       border: InputBorder.none,
// //                       contentPadding: const EdgeInsets.symmetric(vertical: 14),
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 12),
// //                 // Filter Chips
// //                 SingleChildScrollView(
// //                   scrollDirection: Axis.horizontal,
// //                   child: Row(
// //                     children: [
// //                       _buildFilterChip("All", Icons.all_inclusive, Colors.grey),
// //                       const SizedBox(width: 8),
// //                       _buildFilterChip("Low Stock", Icons.warning_amber_rounded, Colors.red),
// //                       const SizedBox(width: 8),
// //                       _buildFilterChip("Healthy", Icons.check_circle_rounded, Colors.green),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //       body: StreamBuilder<QuerySnapshot>(
// //         stream: firestore.collection("inventory").snapshots(),
// //         builder: (context, inventorySnapshot) {
// //           if (!inventorySnapshot.hasData) {
// //             return const Center(
// //               child: CircularProgressIndicator(),
// //             );
// //           }

// //           final inventoryDocs = inventorySnapshot.data!.docs;

// //           return StreamBuilder<QuerySnapshot>(
// //             stream: firestore.collection("inventory_predictions").snapshots(),
// //             builder: (context, predictionSnapshot) {
// //               if (!predictionSnapshot.hasData) {
// //                 return const Center(
// //                   child: CircularProgressIndicator(),
// //                 );
// //               }

// //               final predictionDocs = predictionSnapshot.data!.docs;

// //               Map<String, double> predictionMap = {};

// //               for (var doc in predictionDocs) {
// //                 final data = doc.data() as Map<String, dynamic>;
// //                 String product = data["product"] ?? "";
// //                 String category = data["category"] ?? "";
// //                 double predicted = (data["predicted_units"] ?? 0).toDouble();
// //                 predictionMap[key(product, category)] = predicted;
// //               }

// //               final snapshotKey = "${inventoryDocs.length}_${predictionDocs.length}";
// //               if (_lastSavedSnapshotKey != snapshotKey) {
// //                 _lastSavedSnapshotKey = snapshotKey;
// //                 WidgetsBinding.instance.addPostFrameCallback((_) {
// //                   saveLiveStockStatus(inventoryDocs, predictionMap);
// //                 });
// //               }

// //               // Filter items
// //               final filteredItems = _filterItems(inventoryDocs, predictionMap);
              
// //               // Calculate summary stats
// //               int lowStockCount = 0;
// //               int totalStock = 0;
// //               int totalItems = 0;
              
// //               for (var doc in filteredItems) {
// //                 final data = doc.data() as Map<String, dynamic>;
// //                 String product = data["product"] ?? "";
// //                 String category = data["category"] ?? "";
// //                 double predicted = predictionMap[key(product, category)] ?? 0;
// //                 int stock = data["stock"] ?? 0;
// //                 totalStock += stock;
// //                 totalItems++;
// //                 double predictedWithGap = predicted * safetyGap;
// //                 if (predictedWithGap > stock) lowStockCount++;
// //               }

// //               return Column(
// //                 children: [
// //                   // Summary Bar with Pastel Colors
// //                   Container(
// //                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //                     decoration: BoxDecoration(
// //                       color: Colors.white,
// //                       boxShadow: [
// //                         BoxShadow(
// //                           color: Colors.black.withOpacity(0.02),
// //                           blurRadius: 4,
// //                           offset: const Offset(0, 2),
// //                         ),
// //                       ],
// //                     ),
// //                     child: Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceAround,
// //                       children: [
// //                         _summaryChip("Items", totalItems.toString(), Icons.inventory_rounded, Colors.blue.shade600, Colors.blue.shade50),
// //                         _summaryChip("Low Stock", lowStockCount.toString(), Icons.warning_rounded, Colors.red.shade600, Colors.red.shade50),
// //                         _summaryChip("Total Units", totalStock.toString(), Icons.add_box_outlined, Colors.green.shade600, Colors.green.shade50),
// //                       ],
// //                     ),
// //                   ),
// //                   Expanded(
// //                     child: filteredItems.isEmpty
// //                         ? Center(
// //                             child: Column(
// //                               mainAxisAlignment: MainAxisAlignment.center,
// //                               children: [
// //                                 Icon(Icons.search_off_rounded, size: 64, color: Colors.grey.shade300),
// //                                 const SizedBox(height: 16),
// //                                 Text(
// //                                   _searchQuery.isNotEmpty 
// //                                       ? "No results for '$_searchQuery'"
// //                                       : "No items found",
// //                                   style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
// //                                 ),
// //                                 if (_searchQuery.isNotEmpty) ...[
// //                                   const SizedBox(height: 8),
// //                                   TextButton.icon(
// //                                     onPressed: _clearSearch,
// //                                     icon: const Icon(Icons.clear),
// //                                     label: const Text("Clear Search"),
// //                                   ),
// //                                 ],
// //                               ],
// //                             ),
// //                           )
// //                         : ListView.builder(
// //                             padding: const EdgeInsets.symmetric(vertical: 8),
// //                             itemCount: filteredItems.length,
// //                             itemBuilder: (context, index) {
// //                               final data = filteredItems[index].data() as Map<String, dynamic>;
// //                               String product = data["product"] ?? "";
// //                               String category = data["category"] ?? "";
// //                               double predicted = predictionMap[key(product, category)] ?? 0;
// //                               return buildTile(inventoryData: data, predicted: predicted);
// //                             },
// //                           ),
// //                   ),
// //                 ],
// //               );
// //             },
// //           );
// //         },
// //       ),
// //     );
// //   }

// //   Widget _buildFilterChip(String label, IconData icon, MaterialColor color) {
// //     final isSelected = _statusFilter == label;
// //     return FilterChip(
// //       selected: isSelected,
// //       onSelected: (selected) {
// //         setState(() {
// //           _statusFilter = selected ? label : "All";
// //         });
// //       },
// //       label: Text(label),
// //       avatar: Icon(icon, size: 16),
// //       backgroundColor: Colors.grey.shade50,
// //       selectedColor: color.shade50,
// //       checkmarkColor: color.shade700,
// //       labelStyle: TextStyle(
// //         color: isSelected ? color.shade700 : Colors.grey.shade600,
// //         fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
// //       ),
// //       shape: StadiumBorder(
// //         side: BorderSide(
// //           color: isSelected ? color.shade200 : Colors.grey.shade200,
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class InventoryPage extends StatefulWidget {
//   const InventoryPage({super.key});

//   @override
//   State<InventoryPage> createState() => _InventoryPageState();
// }

// class _InventoryPageState extends State<InventoryPage> {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   String? _lastSavedSnapshotKey;
  
//   // Search Controller
//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = "";
  
//   // Filter options
//   String _statusFilter = "All"; // All, Low Stock, Healthy
  
//   // Safety stock gap (15%)
//   static const double safetyGap = 1.15;

//   String makeKey(String product, String category) {
//     return "$product-$category";
//   }

//   Future<void> saveLiveStockStatus(
//     List<QueryDocumentSnapshot> inventoryDocs,
//     Map<String, double> predictionMap,
//   ) async {
//     final batch = FirebaseFirestore.instance.batch();

//     for (var doc in inventoryDocs) {
//       final data = doc.data() as Map<String, dynamic>;

//       String product = data["product"] ?? "";
//       String category = data["category"] ?? "";

//       double stock = (data["stock"] ?? 0).toDouble();
//       double predicted = predictionMap[makeKey(product, category)] ?? 0;
      
//       double predictedWithGap = predicted * safetyGap;
//       double deficit = predictedWithGap - stock;
//       bool lowStock = predictedWithGap > stock;

//       final ref = FirebaseFirestore.instance
//           .collection("inventory_status")
//           .doc(makeKey(product, category));

//       batch.set(ref, {
//         "product": product,
//         "category": category,
//         "stock": stock,
//         "predicted": predicted,
//         "predictedWithGap": predictedWithGap,
//         "safetyGap": 0.15,
//         "deficit": deficit,
//         "lowStock": lowStock,
//         "updatedAt": FieldValue.serverTimestamp(),
//       });
//     }

//     await batch.commit();
//   }

//   // =========================
//   // CHECK IF ITEM IS LOW STOCK
//   // =========================
//   bool isItemLowStock(Map<String, dynamic> data, Map<String, double> predictionMap) {
//     final String product = data["product"] ?? "";
//     final String category = data["category"] ?? "";
//     final int stock = (data["stock"] ?? 0);
//     final double predicted = predictionMap[makeKey(product, category)] ?? 0;
//     final double predictedWithGap = predicted * safetyGap;
//     return predictedWithGap > stock;
//   }

//   // =========================
//   // IMPROVED TILE UI
//   // =========================
//   Widget buildTile({
//     required Map<String, dynamic> inventoryData,
//     required double predicted,
//   }) {
//     final int stock = (inventoryData["stock"] ?? 0);
//     final String product = inventoryData["product"] ?? "Unknown";
//     final String category = inventoryData["category"] ?? "General";

//     final double predictedWithGap = predicted * safetyGap;
//     final bool isLowStock = predictedWithGap > stock;
//     final double coverage = stock == 0 || predictedWithGap == 0 
//         ? 0 
//         : ((stock / predictedWithGap) * 100).clamp(0, 200);
//     final double progress = predictedWithGap == 0 ? 0 : (stock / predictedWithGap).clamp(0.0, 1.0);
    
//     final Color statusColor = isLowStock ? Colors.red.shade300 : Colors.green.shade300;
//     final Color cardBgColor = isLowStock ? Colors.red.shade50 : Colors.green.shade50;
//     final Color accentColor = isLowStock ? Colors.red.shade400 : Colors.green.shade400;
    
//     final int neededUnits = (predictedWithGap - stock).ceil();

//     return TweenAnimationBuilder<double>(
//       tween: Tween(begin: 0, end: progress),
//       duration: const Duration(milliseconds: 800),
//       builder: (context, value, child) {
//         return Card(
//           margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           elevation: 0,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(24),
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(24),
//             child: Material(
//               color: Colors.white,
//               child: InkWell(
//                 onLongPress: () => _showDetailsDialog(
//                   product, stock, predicted, predictedWithGap, coverage
//                 ),
//                 splashColor: statusColor.withOpacity(0.1),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     border: Border(
//                       left: BorderSide(
//                         color: accentColor,
//                         width: 6,
//                       ),
//                     ),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(18),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Header Row
//                         Row(
//                           children: [
//                             Container(
//                               width: 44,
//                               height: 44,
//                               decoration: BoxDecoration(
//                                 color: cardBgColor,
//                                 borderRadius: BorderRadius.circular(14),
//                               ),
//                               child: Icon(
//                                 isLowStock ? Icons.warning_amber_rounded : Icons.check_circle_rounded,
//                                 color: accentColor,
//                                 size: 24,
//                               ),
//                             ),
//                             const SizedBox(width: 14),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     product,
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w700,
//                                       letterSpacing: -0.3,
//                                     ),
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                   const SizedBox(height: 6),
//                                   Row(
//                                     children: [
//                                       Container(
//                                         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                                         decoration: BoxDecoration(
//                                           color: Colors.grey.shade100,
//                                           borderRadius: BorderRadius.circular(12),
//                                         ),
//                                         child: Text(
//                                           category,
//                                           style: TextStyle(
//                                             fontSize: 11,
//                                             color: Colors.grey.shade700,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 8),
//                                       Container(
//                                         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                                         decoration: BoxDecoration(
//                                           color: Colors.amber.shade50,
//                                           borderRadius: BorderRadius.circular(8),
//                                         ),
//                                         child: const Row(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             Icon(Icons.shield, size: 10, color: Colors.amber),
//                                             SizedBox(width: 2),
//                                             Text(
//                                               "+15% Gap",
//                                               style: TextStyle(
//                                                 fontSize: 8,
//                                                 fontWeight: FontWeight.w600,
//                                                 color: Colors.amber,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                               decoration: BoxDecoration(
//                                 color: cardBgColor,
//                                 borderRadius: BorderRadius.circular(24),
//                               ),
//                               child: Text(
//                                 isLowStock ? "LOW STOCK" : "OK",
//                                 style: TextStyle(
//                                   color: accentColor,
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.bold,
//                                   letterSpacing: 0.5,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 20),

//                         Row(
//                           children: [
//                             Expanded(
//                               child: _buildMetricChip(
//                                 "Stock",
//                                 stock.toString(),
//                                 Icons.inventory_2_rounded,
//                                 Colors.blue.shade300,
//                                 Colors.blue.shade50,
//                               ),
//                             ),
//                             const SizedBox(width: 10),
//                             Expanded(
//                               child: _buildMetricChip(
//                                 "Demand",
//                                 "${predictedWithGap.toStringAsFixed(0)}",
//                                 Icons.trending_up_rounded,
//                                 Colors.purple.shade300,
//                                 Colors.purple.shade50,
//                               ),
//                             ),
//                             const SizedBox(width: 10),
//                             Expanded(
//                               child: _buildMetricChip(
//                                 "Coverage",
//                                 "${coverage.toStringAsFixed(0)}%",
//                                 Icons.pie_chart_rounded,
//                                 isLowStock ? Colors.red.shade300 : Colors.green.shade300,
//                                 isLowStock ? Colors.red.shade50 : Colors.green.shade50,
//                               ),
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 16),

//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   "Stock Coverage",
//                                   style: TextStyle(
//                                     fontSize: 11,
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.grey.shade500,
//                                   ),
//                                 ),
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
//                                   decoration: BoxDecoration(
//                                     color: cardBgColor,
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   child: Text(
//                                     isLowStock 
//                                         ? "${(100 - coverage).toStringAsFixed(0)}% Needed"
//                                         : "${coverage.toStringAsFixed(0)}% Covered",
//                                     style: TextStyle(
//                                       fontSize: 10,
//                                       fontWeight: FontWeight.w600,
//                                       color: accentColor,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 10),
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(10),
//                               child: LinearProgressIndicator(
//                                 value: value,
//                                 minHeight: 10,
//                                 backgroundColor: cardBgColor,
//                                 valueColor: AlwaysStoppedAnimation<Color>(accentColor),
//                               ),
//                             ),
//                           ],
//                         ),

//                         if (isLowStock) ...[
//                           const SizedBox(height: 16),
//                           Container(
//                             padding: const EdgeInsets.all(14),
//                             decoration: BoxDecoration(
//                               color: Colors.red.shade50,
//                               borderRadius: BorderRadius.circular(16),
//                               border: Border.all(color: Colors.red.shade100),
//                             ),
//                             child: Row(
//                               children: [
//                                 Container(
//                                   padding: const EdgeInsets.all(8),
//                                   decoration: BoxDecoration(
//                                     color: Colors.red.shade100,
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   child: Icon(
//                                     Icons.shopping_cart_rounded,
//                                     size: 20,
//                                     color: Colors.red.shade700,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 14),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         "Reorder Required",
//                                         style: TextStyle(
//                                           fontSize: 13,
//                                           fontWeight: FontWeight.w700,
//                                           color: Colors.red.shade800,
//                                         ),
//                                       ),
//                                       Text(
//                                         "Order $neededUnits units now",
//                                         style: TextStyle(
//                                           fontSize: 12,
//                                           color: Colors.red.shade700,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],

//                         const SizedBox(height: 10),
//                         Row(
//                           children: [
//                             Icon(Icons.access_time, size: 10, color: Colors.grey.shade400),
//                             const SizedBox(width: 4),
//                             Text(
//                               "Updated just now",
//                               style: TextStyle(fontSize: 9, color: Colors.grey.shade400),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildMetricChip(String label, String value, IconData icon, Color color, Color bgColor) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
//       decoration: BoxDecoration(
//         color: bgColor,
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: Column(
//         children: [
//           Icon(icon, size: 18, color: color),
//           const SizedBox(height: 8),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//           Text(
//             label,
//             style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showDetailsDialog(
//     String product, 
//     int stock, 
//     double predicted, 
//     double predictedWithGap,
//     double coverage,
//   ) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       builder: (context) => Container(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Container(
//                 width: 50,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade300,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               product,
//               style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             _buildDetailRow("Current Stock", "$stock units", Icons.inventory_rounded),
//             _buildDetailRow("ML Prediction", "${predicted.toStringAsFixed(0)} units", Icons.analytics),
//             _buildDetailRow("With 15% Gap", "${predictedWithGap.toStringAsFixed(0)} units", Icons.shield, Colors.amber),
//             _buildDetailRow("Coverage", "${coverage.toStringAsFixed(0)}%", Icons.pie_chart),
//             const Divider(height: 24),
//             _buildDetailRow(
//               "Status",
//               predictedWithGap > stock ? "⚠️ Low Stock - Reorder Required" : "✅ Stock Adequate",
//               predictedWithGap > stock ? Icons.warning : Icons.check_circle,
//               predictedWithGap > stock ? Colors.red : Colors.green,
//             ),
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () => Navigator.pop(context),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue.shade400,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                 ),
//                 child: const Text("Close", style: TextStyle(fontWeight: FontWeight.w600)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value, IconData icon, [Color? color]) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           Icon(icon, size: 20, color: color ?? Colors.grey.shade600),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
//           ),
//           Text(
//             value,
//             style: TextStyle(
//               fontWeight: FontWeight.w600,
//               color: color ?? Colors.black87,
//               fontSize: 14,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _summaryChip(String label, String value, IconData icon, Color color, Color bgColor) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//       decoration: BoxDecoration(
//         color: bgColor,
//         borderRadius: BorderRadius.circular(30),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, size: 16, color: color),
//           const SizedBox(width: 8),
//           Text(
//             label,
//             style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500),
//           ),
//           const SizedBox(width: 4),
//           Text(
//             value,
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: color,
//               fontSize: 14,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _clearSearch() {
//     setState(() {
//       _searchQuery = "";
//       _searchController.clear();
//     });
//   }

//   // =========================
//   // FIXED FILTER FUNCTION
//   // =========================
//   List<QueryDocumentSnapshot> _filterItems(
//     List<QueryDocumentSnapshot> items,
//     Map<String, double> predictionMap,
//   ) {
//     return items.where((doc) {
//       final data = doc.data() as Map<String, dynamic>;
//       final product = (data["product"] ?? "").toLowerCase();
//       final category = (data["category"] ?? "").toLowerCase();
      
//       // Check low stock status
//       final isLow = isItemLowStock(data, predictionMap);
      
//       // Apply status filter
//       if (_statusFilter == "Low Stock" && !isLow) return false;
//       if (_statusFilter == "Healthy" && isLow) return false;
      
//       // Apply search filter
//       if (_searchQuery.isNotEmpty) {
//         return product.contains(_searchQuery.toLowerCase()) || 
//                category.contains(_searchQuery.toLowerCase());
//       }
      
//       return true;
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF8F9FA),
//       appBar: AppBar(
//         title: const Text(
//           "Inventory Dashboard",
//           style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
//         ),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black87,
//         elevation: 0,
//         centerTitle: false,
//         actions: [
//           Container(
//             margin: const EdgeInsets.only(right: 8),
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: Colors.amber.shade50,
//               borderRadius: BorderRadius.circular(24),
//             ),
//             child: Row(
//               children: [
//                 Icon(Icons.shield, size: 14, color: Colors.amber.shade700),
//                 const SizedBox(width: 4),
//                 Text(
//                   "15% Gap",
//                   style: TextStyle(
//                     fontSize: 11,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.amber.shade800,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.refresh_rounded),
//             onPressed: () => setState(() {}),
//             tooltip: "Refresh",
//           ),
//         ],
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(100),
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
//             child: Column(
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade50,
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(color: Colors.grey.shade200),
//                   ),
//                   child: TextField(
//                     controller: _searchController,
//                     onChanged: (value) {
//                       setState(() {
//                         _searchQuery = value;
//                       });
//                     },
//                     decoration: InputDecoration(
//                       hintText: "Search by product or category...",
//                       hintStyle: TextStyle(color: Colors.grey.shade400),
//                       prefixIcon: Icon(Icons.search_rounded, color: Colors.grey.shade500, size: 20),
//                       suffixIcon: _searchQuery.isNotEmpty
//                           ? IconButton(
//                               icon: Icon(Icons.clear, size: 18, color: Colors.grey.shade500),
//                               onPressed: _clearSearch,
//                             )
//                           : null,
//                       border: InputBorder.none,
//                       contentPadding: const EdgeInsets.symmetric(vertical: 14),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     children: [
//                       _buildFilterChip("All", Icons.all_inclusive, Colors.grey),
//                       const SizedBox(width: 8),
//                       _buildFilterChip("Low Stock", Icons.warning_amber_rounded, Colors.red),
//                       const SizedBox(width: 8),
//                       _buildFilterChip("Healthy", Icons.check_circle_rounded, Colors.green),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: firestore.collection("inventory").snapshots(),
//         builder: (context, inventorySnapshot) {
//           if (!inventorySnapshot.hasData) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }

//           final inventoryDocs = inventorySnapshot.data!.docs;

//           return StreamBuilder<QuerySnapshot>(
//             stream: firestore.collection("inventory_predictions").snapshots(),
//             builder: (context, predictionSnapshot) {
//               if (!predictionSnapshot.hasData) {
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }

//               final predictionDocs = predictionSnapshot.data!.docs;

//               Map<String, double> predictionMap = {};

//               for (var doc in predictionDocs) {
//                 final data = doc.data() as Map<String, dynamic>;
//                 String product = data["product"] ?? "";
//                 String category = data["category"] ?? "";
//                 double predicted = (data["predicted_units"] ?? 0).toDouble();
//                 predictionMap[makeKey(product, category)] = predicted;
//               }

//               final snapshotKey = "${inventoryDocs.length}_${predictionDocs.length}";
//               if (_lastSavedSnapshotKey != snapshotKey) {
//                 _lastSavedSnapshotKey = snapshotKey;
//                 WidgetsBinding.instance.addPostFrameCallback((_) {
//                   saveLiveStockStatus(inventoryDocs, predictionMap);
//                 });
//               }

//               // Apply filters
//               final filteredItems = _filterItems(inventoryDocs, predictionMap);
              
//               // Calculate summary stats based on filtered items
//               int lowStockCount = 0;
//               int totalStock = 0;
              
//               for (var doc in filteredItems) {
//                 final data = doc.data() as Map<String, dynamic>;
//                 int stock = data["stock"] ?? 0;
//                 totalStock += stock;
//                 if (isItemLowStock(data, predictionMap)) {
//                   lowStockCount++;
//                 }
//               }

//               return Column(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.02),
//                           blurRadius: 4,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         _summaryChip("Items", filteredItems.length.toString(), Icons.inventory_rounded, Colors.blue.shade600, Colors.blue.shade50),
//                         _summaryChip("Low Stock", lowStockCount.toString(), Icons.warning_rounded, Colors.red.shade600, Colors.red.shade50),
//                         _summaryChip("Total Units", totalStock.toString(), Icons.add_box_outlined, Colors.green.shade600, Colors.green.shade50),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     child: filteredItems.isEmpty
//                         ? Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(Icons.search_off_rounded, size: 64, color: Colors.grey.shade300),
//                                 const SizedBox(height: 16),
//                                 Text(
//                                   _searchQuery.isNotEmpty 
//                                       ? "No results for '$_searchQuery'"
//                                       : "No items found",
//                                   style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
//                                 ),
//                                 if (_searchQuery.isNotEmpty) ...[
//                                   const SizedBox(height: 8),
//                                   TextButton.icon(
//                                     onPressed: _clearSearch,
//                                     icon: const Icon(Icons.clear),
//                                     label: const Text("Clear Search"),
//                                   ),
//                                 ],
//                               ],
//                             ),
//                           )
//                         : ListView.builder(
//                             padding: const EdgeInsets.symmetric(vertical: 8),
//                             itemCount: filteredItems.length,
//                             itemBuilder: (context, index) {
//                               final data = filteredItems[index].data() as Map<String, dynamic>;
//                               String product = data["product"] ?? "";
//                               String category = data["category"] ?? "";
//                               double predicted = predictionMap[makeKey(product, category)] ?? 0;
//                               return buildTile(inventoryData: data, predicted: predicted);
//                             },
//                           ),
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildFilterChip(String label, IconData icon, MaterialColor color) {
//     final isSelected = _statusFilter == label;
//     return FilterChip(
//       selected: isSelected,
//       onSelected: (selected) {
//         setState(() {
//           _statusFilter = selected ? label : "All";
//         });
//       },
//       label: Text(label),
//       avatar: Icon(icon, size: 16),
//       backgroundColor: Colors.grey.shade50,
//       selectedColor: color.shade50,
//       checkmarkColor: color.shade700,
//       labelStyle: TextStyle(
//         color: isSelected ? color.shade700 : Colors.grey.shade600,
//         fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
//       ),
//       shape: StadiumBorder(
//         side: BorderSide(
//           color: isSelected ? color.shade200 : Colors.grey.shade200,
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? _lastSavedSnapshotKey;
  
  // Search Controller
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  
  // Filter options
  String _statusFilter = "All"; // All, Low Stock, Healthy
  
  // Safety stock gap (15%)
  static const double safetyGap = 1.15;

  String makeKey(String product, String category) {
    return "$product-$category";
  }

  // =========================
  // UPDATE STOCK FUNCTION
  // =========================
  Future<void> updateStock(String product, String category, int newStock) async {
    try {
      final snapshot = await firestore
          .collection("inventory")
          .where("product", isEqualTo: product)
          .where("category", isEqualTo: category)
          .get();

      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs.first.reference.update({
          "stock": newStock,
          "last_updated": FieldValue.serverTimestamp(),
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("✓ Stock updated to $newStock units"),
              backgroundColor: Colors.green.shade400,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red.shade400),
        );
      }
    }
  }

  // =========================
  // DELETE ITEM FUNCTION
  // =========================
  Future<void> deleteItem(String product, String category, String docId) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Item"),
        content: Text("Are you sure you want to delete '$product'?"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      try {
        // Delete from inventory
        await firestore.collection("inventory").doc(docId).delete();
        
        // Also delete predictions for this item
        final predSnapshot = await firestore
            .collection("inventory_predictions")
            .where("product", isEqualTo: product)
            .where("category", isEqualTo: category)
            .get();
        
        for (var doc in predSnapshot.docs) {
          await doc.reference.delete();
        }
        
        // Also delete from inventory_status
        final statusSnapshot = await firestore
            .collection("inventory_status")
            .doc(makeKey(product, category))
            .get();
        
        if (statusSnapshot.exists) {
          await firestore.collection("inventory_status").doc(makeKey(product, category)).delete();
        }
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("✓ '$product' deleted successfully"),
              backgroundColor: Colors.green.shade400,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error deleting: $e"), backgroundColor: Colors.red.shade400),
          );
        }
      }
    }
  }

  // =========================
  // EDIT STOCK DIALOG
  // =========================
  void _showEditDialog(String product, String category, int currentStock) {
    final TextEditingController stockController = TextEditingController(
      text: currentStock.toString(),
    );
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(Icons.edit, color: Colors.blue.shade400, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Edit Stock",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        Text(
                          product,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Category chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.folder_outlined, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 6),
                    Text(
                      category,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Quick adjust label
              Text(
                "QUICK ADJUST",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade500,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 12),
              
              // Quick adjust buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        int current = int.tryParse(stockController.text) ?? 0;
                        if (current > 0) {
                          stockController.text = (current - 1).toString();
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Colors.red.shade300),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Icon(Icons.remove, color: Colors.red.shade400),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        int current = int.tryParse(stockController.text) ?? 0;
                        stockController.text = (current + 1).toString();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Colors.green.shade300),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Icon(Icons.add, color: Colors.green.shade400),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        stockController.text = "0";
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Colors.orange.shade300),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Icon(Icons.cleaning_services, color: Colors.orange.shade400),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Manual input
              TextFormField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Stock Quantity",
                  prefixIcon: Icon(Icons.numbers, color: Colors.blue.shade400),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  suffixText: "units",
                  suffixStyle: TextStyle(color: Colors.grey.shade500),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        int newStock = int.tryParse(stockController.text) ?? 0;
                        if (newStock >= 0) {
                          updateStock(product, category, newStock);
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please enter a valid stock quantity")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.blue.shade400,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text("Update Stock", style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // SAVE LIVE STATUS
  // =========================
  Future<void> saveLiveStockStatus(
    List<QueryDocumentSnapshot> inventoryDocs,
    Map<String, double> predictionMap,
  ) async {
    final batch = FirebaseFirestore.instance.batch();

    for (var doc in inventoryDocs) {
      final data = doc.data() as Map<String, dynamic>;

      String product = data["product"] ?? "";
      String category = data["category"] ?? "";

      double stock = (data["stock"] ?? 0).toDouble();
      double predicted = predictionMap[makeKey(product, category)] ?? 0;
      
      double predictedWithGap = predicted * safetyGap;
      double deficit = predictedWithGap - stock;
      bool lowStock = predictedWithGap > stock;

      final ref = FirebaseFirestore.instance
          .collection("inventory_status")
          .doc(makeKey(product, category));

      batch.set(ref, {
        "product": product,
        "category": category,
        "stock": stock,
        "predicted": predicted,
        "predictedWithGap": predictedWithGap,
        "safetyGap": 0.15,
        "deficit": deficit,
        "lowStock": lowStock,
        "updatedAt": FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }

  // =========================
  // CHECK IF ITEM IS LOW STOCK
  // =========================
  bool isItemLowStock(Map<String, dynamic> data, Map<String, double> predictionMap) {
    final String product = data["product"] ?? "";
    final String category = data["category"] ?? "";
    final int stock = (data["stock"] ?? 0);
    final double predicted = predictionMap[makeKey(product, category)] ?? 0;
    final double predictedWithGap = predicted * safetyGap;
    return predictedWithGap > stock;
  }

  // =========================
  // BUILD TILE WITH EDIT & DELETE
  // =========================
  Widget buildTile({
    required Map<String, dynamic> inventoryData,
    required double predicted,
    required String docId,
  }) {
    final int stock = (inventoryData["stock"] ?? 0);
    final String product = inventoryData["product"] ?? "Unknown";
    final String category = inventoryData["category"] ?? "General";

    final double predictedWithGap = predicted * safetyGap;
    final bool isLowStock = predictedWithGap > stock;
    final double coverage = stock == 0 || predictedWithGap == 0 
        ? 0 
        : ((stock / predictedWithGap) * 100).clamp(0, 200);
    final double progress = predictedWithGap == 0 ? 0 : (stock / predictedWithGap).clamp(0.0, 1.0);
    
    final Color statusColor = isLowStock ? Colors.red.shade300 : Colors.green.shade300;
    final Color cardBgColor = isLowStock ? Colors.red.shade50 : Colors.green.shade50;
    final Color accentColor = isLowStock ? Colors.red.shade400 : Colors.green.shade400;
    
    final int neededUnits = (predictedWithGap - stock).ceil();

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress),
      duration: const Duration(milliseconds: 800),
      builder: (context, value, child) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Material(
              color: Colors.white,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: accentColor,
                      width: 6,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row with Edit/Delete Buttons
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: cardBgColor,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              isLowStock ? Icons.warning_amber_rounded : Icons.check_circle_rounded,
                              color: accentColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.3,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        category,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade700,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.amber.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.shield, size: 10, color: Colors.amber),
                                          SizedBox(width: 2),
                                          Text(
                                            "+15% Gap",
                                            style: TextStyle(
                                              fontSize: 8,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.amber,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Edit Button
                          Container(
                            margin: const EdgeInsets.only(right: 4),
                            child: IconButton(
                              icon: Icon(Icons.edit_outlined, color: Colors.blue.shade400, size: 20),
                              onPressed: () => _showEditDialog(product, category, stock),
                              tooltip: "Edit Stock",
                            ),
                          ),
                          // Delete Button
                          IconButton(
                            icon: Icon(Icons.delete_outline, color: Colors.red.shade400, size: 20),
                            onPressed: () => deleteItem(product, category, docId),
                            tooltip: "Delete Item",
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Metrics Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricChip(
                              "Stock",
                              stock.toString(),
                              Icons.inventory_2_rounded,
                              Colors.blue.shade300,
                              Colors.blue.shade50,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildMetricChip(
                              "Demand",
                              "${predictedWithGap.toStringAsFixed(0)}",
                              Icons.trending_up_rounded,
                              Colors.purple.shade300,
                              Colors.purple.shade50,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildMetricChip(
                              "Coverage",
                              "${coverage.toStringAsFixed(0)}%",
                              Icons.pie_chart_rounded,
                              isLowStock ? Colors.red.shade300 : Colors.green.shade300,
                              isLowStock ? Colors.red.shade50 : Colors.green.shade50,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Progress Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Stock Coverage",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: cardBgColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  isLowStock 
                                      ? "${(100 - coverage).toStringAsFixed(0)}% Needed"
                                      : "${coverage.toStringAsFixed(0)}% Covered",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: accentColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: value,
                              minHeight: 10,
                              backgroundColor: cardBgColor,
                              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                            ),
                          ),
                        ],
                      ),

                      // Alert Message for Low Stock
                      if (isLowStock) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.red.shade100),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.shopping_cart_rounded,
                                  size: 20,
                                  color: Colors.red.shade700,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Reorder Required",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.red.shade800,
                                      ),
                                    ),
                                    Text(
                                      "Order $neededUnits units now",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.red.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 10, color: Colors.grey.shade400),
                          const SizedBox(width: 4),
                          Text(
                            "Updated just now",
                            style: TextStyle(fontSize: 9, color: Colors.grey.shade400),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetricChip(String label, String value, IconData icon, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  void _showDetailsDialog(
    String product, 
    int stock, 
    double predicted, 
    double predictedWithGap,
    double coverage,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              product,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildDetailRow("Current Stock", "$stock units", Icons.inventory_rounded),
            _buildDetailRow("ML Prediction", "${predicted.toStringAsFixed(0)} units", Icons.analytics),
            _buildDetailRow("With 15% Gap", "${predictedWithGap.toStringAsFixed(0)} units", Icons.shield, Colors.amber),
            _buildDetailRow("Coverage", "${coverage.toStringAsFixed(0)}%", Icons.pie_chart),
            const Divider(height: 24),
            _buildDetailRow(
              "Status",
              predictedWithGap > stock ? "⚠️ Low Stock - Reorder Required" : "✅ Stock Adequate",
              predictedWithGap > stock ? Icons.warning : Icons.check_circle,
              predictedWithGap > stock ? Colors.red : Colors.green,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade400,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text("Close", style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon, [Color? color]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color ?? Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: color ?? Colors.black87,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryChip(String label, String value, IconData icon, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = "";
      _searchController.clear();
    });
  }

  // =========================
  // FILTER FUNCTION
  // =========================
  List<QueryDocumentSnapshot> _filterItems(
    List<QueryDocumentSnapshot> items,
    Map<String, double> predictionMap,
  ) {
    return items.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final product = (data["product"] ?? "").toLowerCase();
      final category = (data["category"] ?? "").toLowerCase();
      
      final isLow = isItemLowStock(data, predictionMap);
      
      if (_statusFilter == "Low Stock" && !isLow) return false;
      if (_statusFilter == "Healthy" && isLow) return false;
      
      if (_searchQuery.isNotEmpty) {
        return product.contains(_searchQuery.toLowerCase()) || 
               category.contains(_searchQuery.toLowerCase());
      }
      
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Inventory Dashboard",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: false,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Icon(Icons.shield, size: 14, color: Colors.amber.shade700),
                const SizedBox(width: 4),
                Text(
                  "15% Gap",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.amber.shade800,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => setState(() {}),
            tooltip: "Refresh",
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Search by product or category...",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      prefixIcon: Icon(Icons.search_rounded, color: Colors.grey.shade500, size: 20),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, size: 18, color: Colors.grey.shade500),
                              onPressed: _clearSearch,
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip("All", Icons.all_inclusive, Colors.grey),
                      const SizedBox(width: 8),
                      _buildFilterChip("Low Stock", Icons.warning_amber_rounded, Colors.red),
                      const SizedBox(width: 8),
                      _buildFilterChip("Healthy", Icons.check_circle_rounded, Colors.green),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection("inventory").snapshots(),
        builder: (context, inventorySnapshot) {
          if (!inventorySnapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final inventoryDocs = inventorySnapshot.data!.docs;

          return StreamBuilder<QuerySnapshot>(
            stream: firestore.collection("inventory_predictions").snapshots(),
            builder: (context, predictionSnapshot) {
              if (!predictionSnapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final predictionDocs = predictionSnapshot.data!.docs;

              Map<String, double> predictionMap = {};

              for (var doc in predictionDocs) {
                final data = doc.data() as Map<String, dynamic>;
                String product = data["product"] ?? "";
                String category = data["category"] ?? "";
                double predicted = (data["predicted_units"] ?? 0).toDouble();
                predictionMap[makeKey(product, category)] = predicted;
              }

              final snapshotKey = "${inventoryDocs.length}_${predictionDocs.length}";
              if (_lastSavedSnapshotKey != snapshotKey) {
                _lastSavedSnapshotKey = snapshotKey;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  saveLiveStockStatus(inventoryDocs, predictionMap);
                });
              }

              final filteredItems = _filterItems(inventoryDocs, predictionMap);
              
              int lowStockCount = 0;
              int totalStock = 0;
              
              for (var doc in filteredItems) {
                final data = doc.data() as Map<String, dynamic>;
                int stock = data["stock"] ?? 0;
                totalStock += stock;
                if (isItemLowStock(data, predictionMap)) {
                  lowStockCount++;
                }
              }

              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _summaryChip("Items", filteredItems.length.toString(), Icons.inventory_rounded, Colors.blue.shade600, Colors.blue.shade50),
                        _summaryChip("Low Stock", lowStockCount.toString(), Icons.warning_rounded, Colors.red.shade600, Colors.red.shade50),
                        _summaryChip("Total Units", totalStock.toString(), Icons.add_box_outlined, Colors.green.shade600, Colors.green.shade50),
                      ]
                    ),
                  ),
                  Expanded(
                    child: filteredItems.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search_off_rounded, size: 64, color: Colors.grey.shade300),
                                const SizedBox(height: 16),
                                Text(
                                  _searchQuery.isNotEmpty 
                                      ? "No results for '$_searchQuery'"
                                      : "No items found",
                                  style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                                ),
                                if (_searchQuery.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  TextButton.icon(
                                    onPressed: _clearSearch,
                                    icon: const Icon(Icons.clear),
                                    label: const Text("Clear Search"),
                                  ),
                                ],
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final data = filteredItems[index].data() as Map<String, dynamic>;
                              final docId = filteredItems[index].id;
                              String product = data["product"] ?? "";
                              String category = data["category"] ?? "";
                              double predicted = predictionMap[makeKey(product, category)] ?? 0;
                              return buildTile(
                                inventoryData: data, 
                                predicted: predicted,
                                docId: docId,
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon, MaterialColor color) {
    final isSelected = _statusFilter == label;
    return FilterChip(
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _statusFilter = selected ? label : "All";
        });
      },
      label: Text(label),
      avatar: Icon(icon, size: 16),
      backgroundColor: Colors.grey.shade50,
      selectedColor: color.shade50,
      checkmarkColor: color.shade700,
      labelStyle: TextStyle(
        color: isSelected ? color.shade700 : Colors.grey.shade600,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      shape: StadiumBorder(
        side: BorderSide(
          color: isSelected ? color.shade200 : Colors.grey.shade200,
        ),
      ),
    );
  }
}