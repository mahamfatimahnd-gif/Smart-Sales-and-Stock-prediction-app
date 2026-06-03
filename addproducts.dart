import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class AddInventoryPage extends StatefulWidget {
  const AddInventoryPage({super.key});

  @override
  State<AddInventoryPage> createState() => _AddInventoryPageState();
}

class _AddInventoryPageState extends State<AddInventoryPage> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController productController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController reorderController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool loading = false;
  bool aiLoading = false;

  // Modern Color Palette
  static const Color primaryDark = Color(0xFF1E293B); 
// Mint Green
  static const Color aiColor = Color(0xFF6366F1);     
  static const Color bgLight = Color(0xFFF8FAFC);     

  final String apiUrl = "http://192.168.18.7:5000/predict";

  @override
  void dispose() {
    productController.dispose();
    categoryController.dispose();
    stockController.dispose();
    reorderController.dispose();
    priceController.dispose();
    super.dispose();
  }

  void _showToast(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.w500)),
        backgroundColor: isError ? Colors.redAccent : primaryDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
      ),
    );
  }

  // =====================================================
  // CALL ML BACKEND
  // =====================================================
  Future<Map<String, dynamic>?> getPrediction() async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "category": categoryController.text.trim(),
          "product": productController.text.trim(),
          "month": "May",
          "price": double.tryParse(priceController.text) ?? 0,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      debugPrint("Prediction error: $e");
    }
    return null;
  }

  // =====================================================
  // AI INVENTORY GENERATION
  // =====================================================
  Future<void> generateAIInventory() async {
    if (productController.text.trim().isEmpty ||
        categoryController.text.trim().isEmpty ||
        priceController.text.trim().isEmpty) {
      _showToast("Fill Product, Category & Price to generate prediction", isError: true);
      return;
    }

    setState(() => aiLoading = true);
    final data = await getPrediction();
    if (!mounted) return;
    setState(() => aiLoading = false);

    if (data == null) {
      _showToast("AI Prediction Failed ❌ Check server connection", isError: true);
      return;
    }

    setState(() {
      final predictedUnits = data["predicted_units"] ?? 0;
      stockController.text = predictedUnits.toString();
      reorderController.text = (predictedUnits * 0.5).toStringAsFixed(0);
    });

    _showToast("AI Inventory Strategy Generated 🤖");
  }

  // =====================================================
  // SAVE TO FIRESTORE
  // =====================================================
  Future<void> addProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      await firestore.collection("inventory").add({
        "product": productController.text.trim(),
        "category": categoryController.text.trim(),
        "stock": int.tryParse(stockController.text) ?? 0,
        "reorder_level": int.tryParse(reorderController.text) ?? 0,
        "price": double.tryParse(priceController.text) ?? 0,
        "ai_generated": true,
        "created_at": FieldValue.serverTimestamp(),
      });

      _showToast("Product Added Successfully ");

      _formKey.currentState!.reset();
      productController.clear();
      categoryController.clear();
      stockController.clear();
      reorderController.clear();
      priceController.clear();
    } catch (e) {
      _showToast("Error saving product: $e", isError: true);
    }

    if (mounted) setState(() => loading = false);
  }

  // =====================================================
  // BEAUTIFIED INPUT WIDGET
  // =====================================================
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    bool isNumber = false,
    bool isAiField = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: const TextStyle(fontSize: 15, color: primaryDark),
        validator: (value) => (value == null || value.trim().isEmpty) ? "Required Field" : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: primaryDark.withOpacity(0.6), fontSize: 14),
          prefixIcon: Icon(prefixIcon, size: 20, color: isAiField ? aiColor : primaryDark.withOpacity(0.5)),
          filled: true,
          fillColor: isAiField ? aiColor.withOpacity(0.04) : Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: isAiField ? aiColor.withOpacity(0.3) : Colors.grey.shade200, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: isAiField ? aiColor : primaryDark, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 2),
          ),
        ),
      ),
    );
  }

  // =====================================================
  // UI BUILD
  // =====================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      appBar: AppBar(
        title: const Text(
          "Stock & Sync Intelligence", 
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 19)
        ),
        centerTitle: true,
        backgroundColor: primaryDark,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Item Properties",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryDark),
                ),
                const SizedBox(height: 12),
                _buildInputField(controller: productController, label: "Product Name", prefixIcon: Icons.shopping_bag_outlined),
                _buildInputField(controller: categoryController, label: "Category", prefixIcon: Icons.category_outlined),
                _buildInputField(controller: priceController, label: "Retail Price", prefixIcon: Icons.attach_money, isNumber: true),
                
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(height: 24, thickness: 1),
                ),
                
                const Text(
                  "Demand Forecasting",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryDark),
                ),
                const SizedBox(height: 12),
                _buildInputField(controller: stockController, label: "Target Stock Level", prefixIcon: Icons.analytics_outlined, isNumber: true, isAiField: true),
                _buildInputField(controller: reorderController, label: "Safety Reorder Limit", prefixIcon: Icons.lock_clock_outlined, isNumber: true, isAiField: true),

                const SizedBox(height: 16),

                // ================= AI BUTTON =================
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: aiLoading ? null : generateAIInventory,
                    icon: aiLoading 
                        ? const SizedBox.shrink() 
                        : const Icon(Icons.auto_awesome, size: 18, color: Colors.white),
                    label: aiLoading
                        ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)
                        : const Text("Run Smart Prediction", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: aiColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ================= SAVE BUTTON =================
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: loading ? null : addProduct,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: primaryDark, width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: loading
                        ? const CircularProgressIndicator(color: primaryDark, strokeWidth: 2.5)
                        : const Text("Commit to Inventory", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primaryDark)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
