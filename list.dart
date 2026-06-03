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
      // Update in inventory collection
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
      } else {
        // If not exists, create new inventory entry
        await firestore.collection("inventory").add({
          "product": product,
          "category": category,
          "stock": newStock,
          "last_updated": FieldValue.serverTimestamp(),
        });
      }
      
      // Also update the inventory_status collection immediately
      await updateInventoryStatus(product, category, newStock);
      
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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red.shade400),
        );
      }
    }
  }

  // =========================
  // UPDATE INVENTORY STATUS (SINGLE ITEM)
  // =========================
  Future<void> updateInventoryStatus(String product, String category, int stock) async {
    try {
      // Get predicted units from current_demand
      final demandSnapshot = await firestore
          .collection("current_demand")
          .where("product", isEqualTo: product)
          .where("category", isEqualTo: category)
          .get();
      
      double predictedUnits = 0;
      if (demandSnapshot.docs.isNotEmpty) {
        predictedUnits = (demandSnapshot.docs.first.data()["predicted_units"] ?? 0).toDouble();
      }
      
      double predictedWithGap = predictedUnits * safetyGap;
      double deficit = predictedWithGap - stock;
      bool lowStock = predictedWithGap > stock;
      
      final ref = firestore.collection("inventory_status").doc(makeKey(product, category));
      
      await ref.set({
        "product": product,
        "category": category,
        "stock": stock,
        "predicted_units": predictedUnits,
        "predictedWithGap": predictedWithGap,
        "safetyGap": 0.15,
        "deficit": deficit > 0 ? deficit : 0,
        "lowStock": lowStock,
        "coverage_percentage": stock == 0 || predictedWithGap == 0 
            ? 0 
            : ((stock / predictedWithGap) * 100).clamp(0, 200),
        "updatedAt": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error updating inventory status: $e");
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
        // Delete from inventory collection
        await firestore.collection("inventory").doc(docId).delete();
        
        // Update inventory_status to reflect stock = 0 instead of deleting
        final statusRef = firestore.collection("inventory_status").doc(makeKey(product, category));
        final statusDoc = await statusRef.get();
        
        if (statusDoc.exists) {
          // Update status with zero stock
          await updateInventoryStatus(product, category, 0);
        }
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("✓ '$product' removed from inventory (stock set to 0)"),
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
  // ADD NEW ITEM 
  // =========================
  Future<void> addNewItem(String product, String category, double predictedUnits) async {
    // Show dialog to set initial stock
    final TextEditingController stockController = TextEditingController(text: "0");
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(Icons.add_business, color: Colors.green.shade400, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Add to Inventory",
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
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.trending_up, color: Colors.blue.shade600, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Predicted Units",
                            style: TextStyle(fontSize: 11, color: Colors.blue.shade600),
                          ),
                          Text(
                            "${predictedUnits.toStringAsFixed(0)} units",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Initial Stock Quantity",
                  prefixIcon: Icon(Icons.inventory, color: Colors.green.shade400),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  suffixText: "units",
                  suffixStyle: TextStyle(color: Colors.grey.shade500),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
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
                        Navigator.pop(context, true);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.green.shade400,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text("Add to Inventory", style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    
    if (confirmed == true) {
      try {
        final int initialStock = int.tryParse(stockController.text) ?? 0;
        
        // Check if item already exists in inventory
        final existingSnapshot = await firestore
            .collection("inventory")
            .where("product", isEqualTo: product)
            .where("category", isEqualTo: category)
            .get();
        
        if (existingSnapshot.docs.isEmpty) {
          // Add to inventory collection
          await firestore.collection("inventory").add({
            "product": product,
            "category": category,
            "stock": initialStock,
            "last_updated": FieldValue.serverTimestamp(),
          });
          
          // Save to inventory_status
          await updateInventoryStatus(product, category, initialStock);
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("✓ '$product' added to inventory"),
                backgroundColor: Colors.green.shade400,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        } else {
          // Update existing inventory
          await updateStock(product, category, initialStock);
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("✓ '$product' stock updated to $initialStock units"),
                backgroundColor: Colors.blue.shade400,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error adding item: $e"), backgroundColor: Colors.red.shade400),
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
  // SAVE ALL INVENTORY STATUSES (BATCH)
  // =========================
  Future<void> saveAllInventoryStatuses(
    List<QueryDocumentSnapshot> demandDocs,
    Map<String, int> stockMap,
  ) async {
    final batch = FirebaseFirestore.instance.batch();

    for (var doc in demandDocs) {
      final data = doc.data() as Map<String, dynamic>;

      String product = data["product"] ?? "";
      String category = data["category"] ?? "";
      double predictedUnits = (data["predicted_units"] ?? 0).toDouble();
      
      int stock = stockMap[makeKey(product, category)] ?? 0;
      
      double predictedWithGap = predictedUnits * safetyGap;
      double deficit = predictedWithGap - stock;
      bool lowStock = predictedWithGap > stock;
      double coveragePercentage = stock == 0 || predictedWithGap == 0 
          ? 0 
          : ((stock / predictedWithGap) * 100).clamp(0, 200);

      final ref = FirebaseFirestore.instance
          .collection("inventory_status")
          .doc(makeKey(product, category));

      batch.set(ref, {
        "product": product,
        "category": category,
        "stock": stock,
        "predicted_units": predictedUnits,
        "predictedWithGap": predictedWithGap,
        "safetyGap": 0.15,
        "deficit": deficit > 0 ? deficit : 0,
        "lowStock": lowStock,
        "coverage_percentage": coveragePercentage,
        "needed_units": lowStock ? (predictedWithGap - stock).ceil() : 0,
        "updatedAt": FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
    print("✅ All inventory statuses saved to inventory_status collection");
  }

  // =========================
  // CHECK IF ITEM IS LOW STOCK
  // =========================
  bool isItemLowStock(Map<String, dynamic> demandData, Map<String, int> stockMap) {
    final String product = demandData["product"] ?? "";
    final String category = demandData["category"] ?? "";
    final int stock = stockMap[makeKey(product, category)] ?? 0;
    final double predictedUnits = (demandData["predicted_units"] ?? 0).toDouble();
    final double predictedWithGap = predictedUnits * safetyGap;
    return predictedWithGap > stock;
  }

  // =========================
  // BUILD TILE
  // =========================
  Widget buildTile({
    required Map<String, dynamic> demandData,
    required int stock,
    required String inventoryDocId,
  }) {
    final String product = demandData["product"] ?? "Unknown";
    final String category = demandData["category"] ?? "General";
    final double predictedUnits = (demandData["predicted_units"] ?? 0).toDouble();

    final double predictedWithGap = predictedUnits * safetyGap;
    final bool isLowStock = predictedWithGap > stock;
    final double coverage = stock == 0 || predictedWithGap == 0 
        ? 0 
        : ((stock / predictedWithGap) * 100).clamp(0, 200);
    final double progress = predictedWithGap == 0 ? 0 : (stock / predictedWithGap).clamp(0.0, 1.0);
    
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
                          if (inventoryDocId.isNotEmpty) ...[
                            Container(
                              margin: const EdgeInsets.only(right: 4),
                              child: IconButton(
                                icon: Icon(Icons.edit_outlined, color: Colors.blue.shade400, size: 20),
                                onPressed: () => _showEditDialog(product, category, stock),
                                tooltip: "Edit Stock",
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete_outline, color: Colors.red.shade400, size: 20),
                              onPressed: () => deleteItem(product, category, inventoryDocId),
                              tooltip: "Delete Item",
                            ),
                          ] else ...[
                            ElevatedButton.icon(
                              onPressed: () => addNewItem(product, category, predictedUnits),
                              icon: const Icon(Icons.add, size: 16),
                              label: const Text("Add Stock"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade500,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 20),
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
                      if (isLowStock && stock > 0) ...[
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
    Map<String, int> stockMap,
  ) {
    return items.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final product = (data["product"] ?? "").toLowerCase();
      final category = (data["category"] ?? "").toLowerCase();
      
      final isLow = isItemLowStock(data, stockMap);
      
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
        stream: firestore.collection("current_demand").snapshots(),
        builder: (context, demandSnapshot) {
          if (!demandSnapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final demandDocs = demandSnapshot.data!.docs;

          // Get stock information from inventory
          return StreamBuilder<QuerySnapshot>(
            stream: firestore.collection("inventory").snapshots(),
            builder: (context, inventorySnapshot) {
              // Build stock map from inventory
              Map<String, int> stockMap = {};
              Map<String, String> inventoryDocIds = {};
              
              if (inventorySnapshot.hasData) {
                for (var doc in inventorySnapshot.data!.docs) {
                  final data = doc.data() as Map<String, dynamic>;
                  String product = data["product"] ?? "";
                  String category = data["category"] ?? "";
                  int stock = (data["stock"] ?? 0);
                  String key = makeKey(product, category);
                  stockMap[key] = stock;
                  inventoryDocIds[key] = doc.id;
                }
              }

              final snapshotKey = "${demandDocs.length}_${stockMap.length}";
              if (_lastSavedSnapshotKey != snapshotKey) {
                _lastSavedSnapshotKey = snapshotKey;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  saveAllInventoryStatuses(demandDocs, stockMap);
                });
              }

              final filteredItems = _filterItems(demandDocs, stockMap);
              
              int lowStockCount = 0;
              int totalStock = 0;
              
              for (var doc in filteredItems) {
                final data = doc.data() as Map<String, dynamic>;
                String product = data["product"] ?? "";
                String category = data["category"] ?? "";
                int stock = stockMap[makeKey(product, category)] ?? 0;
                totalStock += stock;
                if (isItemLowStock(data, stockMap)) {
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
                      ],
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
                                      : "No products found",
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
                              final demandData = filteredItems[index].data() as Map<String, dynamic>;
                              final String product = demandData["product"] ?? "";
                              final String category = demandData["category"] ?? "";
                              final String key = makeKey(product, category);
                              final int stock = stockMap[key] ?? 0;
                              final String inventoryDocId = inventoryDocIds[key] ?? "";
                              
                              return buildTile(
                                demandData: demandData,
                                stock: stock,
                                inventoryDocId: inventoryDocId,
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
