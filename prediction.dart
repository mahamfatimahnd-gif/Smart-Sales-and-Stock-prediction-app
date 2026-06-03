import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class PredictionPage extends StatefulWidget {
  const PredictionPage({super.key});

  @override
  State<PredictionPage> createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {

  // =========================================================
  // DATA
  // =========================================================

  List<double> historySales = [];
  List<double> historyUnits = [];
  List<String> historyMonths = [];

  List<String> categories = [];
  List<String> products = [];
  List<String> months = [];

  String? selectedCategory;
  String? selectedProduct;
  String? selectedMonth;

  bool loading = false;

  // =========================================================
  // ML RESULTS
  // =========================================================

  double predictedSales = 0;
  double predictedUnits = 0;
  double predictedProfit = 0;
  double latestUnits = 0;
  double rollingAvg = 0;
  double accuracy = 0;
  double priceUsed = 0;
  double costUsed = 0;
  double profitMargin = 0;
  double totalCost = 0;
  double profitRate = 0;

  final TextEditingController priceController = TextEditingController(text: "500");
  final TextEditingController costController = TextEditingController(text: "325");

  final String baseUrl = "http://192.168.100.218:5000";
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Theme Colors
  final Color primaryColor = const Color(0xFF2563EB); 
  final Color secondaryColor = const Color(0xFFF59E0B); 
  final Color successColor = const Color(0xFF10B981); 
  final Color dangerColor = const Color(0xFFEF4444); 
  final Color purpleColor = const Color(0xFF8B5CF6); 
  final Color tealColor = const Color(0xFF14B8A6);
  final Color indigoColor = const Color(0xFF6366F1); 

  // =========================================================
  // INIT
  // =========================================================

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    await loadCategories();
    await loadMonths();
  }

  // =========================================================
  // FETCH PRODUCT PRICE & COST FROM FLASK BACKEND (EXCEL)
  // =========================================================
  Future<Map<String, dynamic>> fetchProductPriceFromExcel(String product) async {
    try {
      final res = await http.get(
        Uri.parse("$baseUrl/product_price?product=$product"),
      );
      
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return {
          "price": (data["price"] ?? 500).toDouble(),
          "cost": (data["cost"] ?? 325).toDouble(),
          "profit_margin": (data["profit_margin"] ?? 0).toDouble(),
        };
      }
    } catch (e) {
      debugPrint("Error fetching price from Excel: $e");
    }
    
    return {"price": 500.0, "cost": 325.0, "profit_margin": 35.0};
  }

  // =========================================================
  // FETCH LIST
  // =========================================================

  Future<List<String>> fetchList(String endpoint, String key) async {
    try {
      final res = await http.get(Uri.parse("$baseUrl/$endpoint"));
      final data = jsonDecode(res.body);
      return List<String>.from(data[key] ?? []);
    } catch (_) {
      return [];
    }
  }

  Future<void> loadCategories() async {
    categories = await fetchList("categories", "categories");

    setState(() {
      selectedCategory = categories.isNotEmpty ? categories.first : null;
      selectedProduct = null;
      products = [];
    });

    if (selectedCategory != null) {
      await loadProducts(selectedCategory!);
    }
  }

  Future<void> loadProducts(String category) async {
    try {
      final res = await http.get(
        Uri.parse("$baseUrl/products?category=$category"),
      );

      final data = jsonDecode(res.body);

      setState(() {
        products = List<String>.from(data["products"] ?? []);
        selectedProduct = products.isNotEmpty ? products.first : null;
      });
      
      // Fetch price & cost from Excel for the first product
      if (selectedProduct != null) {
        final priceData = await fetchProductPriceFromExcel(selectedProduct!);
        priceController.text = priceData["price"].toStringAsFixed(0);
        costController.text = priceData["cost"].toStringAsFixed(0);
      }
    } catch (_) {
      setState(() {
        products = [];
        selectedProduct = null;
      });
    }
  }

  Future<void> loadMonths() async {
    months = await fetchList("months", "months");

    setState(() {
      selectedMonth = months.isNotEmpty ? months.last : null;
    });
  }

  int getMonthIndex(String month) {
    const monthOrder = [
      "jan","feb","mar","apr","may","jun",
      "jul","aug","sep","oct","nov","dec",
    ];

    String shortMonth = month.toLowerCase().substring(0, 3);
    return monthOrder.indexOf(shortMonth);
  }

  // =========================================================
  // HELPER: GET CURRENT MONTH NAME
  // =========================================================
  String getCurrentMonth() {
    const monthNames = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    final now = DateTime.now();
    return monthNames[now.month - 1];
  }

  // =========================================================
  // HELPER: GET NEXT MONTH NAME
  // =========================================================
  String getNextMonth() {
    const monthNames = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    final now = DateTime.now();
    final nextMonthIndex = now.month % 12;
    return monthNames[nextMonthIndex];
  }

  // =========================================================
  // HELPER: GET CURRENT YEAR
  // =========================================================
  int getCurrentYear() {
    return DateTime.now().year;
  }

  // =========================================================
  // HELPER: GET NEXT MONTH YEAR (handles December -> January rollover)
  // =========================================================
  int getNextMonthYear() {
    final now = DateTime.now();
    if (now.month == 12) {
      return now.year + 1;
    }
    return now.year;
  }

  // =========================================================
  // PREDICT + FIRESTORE SAVE + CURRENT DEMAND COLLECTION
  // =========================================================
  Future<void> predict() async {
    if (selectedCategory == null || selectedProduct == null || selectedMonth == null) {
      return;
    }

    setState(() => loading = true);

    try {
      final res = await http.post(
        Uri.parse("$baseUrl/predict"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "category": selectedCategory,
          "product": selectedProduct,
          "month": selectedMonth,
          "price": double.tryParse(priceController.text) ?? 0,
        }),
      );

      final data = jsonDecode(res.body);

      if (data.containsKey("error")) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["error"]), backgroundColor: dangerColor),
        );
        setState(() => loading = false);
        return;
      }

      List<String> rawMonths = List<String>.from(data["history_months"] ?? []);
      List<double> rawSales = List<double>.from((data["history_sales"] ?? [])
          .map((e) => (e as num).toDouble()));
      List<double> rawUnits = List<double>.from((data["history_units"] ?? [])
          .map((e) => (e as num).toDouble()));

      List<Map<String, dynamic>> combined = [];

      for (int i = 0; i < rawMonths.length; i++) {
        combined.add({
          "month": rawMonths[i],
          "sales": i < rawSales.length ? rawSales[i] : 0,
          "units": i < rawUnits.length ? rawUnits[i] : 0,
        });
      }

      combined.sort((a, b) {
        try {
          final aParts = a["month"].toString().split("-");
          final bParts = b["month"].toString().split("-");

          int aYear = int.parse(aParts[0]);
          int bYear = int.parse(bParts[0]);

          int aMonth = getMonthIndex(aParts[1]);
          int bMonth = getMonthIndex(bParts[1]);

          if (aYear != bYear) {
            return aYear.compareTo(bYear);
          }
          return aMonth.compareTo(bMonth);
        } catch (_) {
          return 0;
        }
      });

      setState(() {
        historyMonths = combined.map((e) => e["month"].toString()).toList();
        historySales = combined.map((e) => (e["sales"] as num).toDouble()).toList();
        historyUnits = combined.map((e) => (e["units"] as num).toDouble()).toList();
        
        predictedUnits = (data["predicted_units"] ?? 0).toDouble();
        predictedSales = (data["predicted_sales"] ?? 0).toDouble();
        predictedProfit = (data["predicted_profit"] ?? 0).toDouble();
        latestUnits = (data["latest_units"] ?? 0).toDouble();
        rollingAvg = (data["rolling_avg"] ?? 0).toDouble();
        accuracy = (data["accuracy"] ?? 0).toDouble();
        priceUsed = (data["price_used"] ?? 0).toDouble();
        costUsed = (data["cost_used"] ?? 0).toDouble();
        profitMargin = (data["profit_margin"] ?? 0).toDouble();
        
        // Calculate additional metrics
        totalCost = predictedUnits * costUsed;
        profitRate = (predictedProfit / predictedSales) * 100;
        
        loading = false;
      });

      // Update controllers
      priceController.text = priceUsed.toStringAsFixed(0);
      costController.text = costUsed.toStringAsFixed(0);

      // =========================================================
      // ORIGINAL PREDICTION HISTORY COLLECTION (KEPT AS IS)
      // =========================================================
      await firestore.collection("prediction_history").add({
        "category": selectedCategory,
        "product": selectedProduct,
        "month": selectedMonth,
        "price": priceUsed,
        "cost": costUsed,
        "predicted_sales": predictedSales,
        "predicted_units": predictedUnits,
        "predicted_profit": predictedProfit,
        "total_cost": totalCost,
        "profit_rate": profitRate,
        "created_at": FieldValue.serverTimestamp(),
      });

      // =========================================================
      // ORIGINAL INVENTORY PREDICTIONS COLLECTION (KEPT AS IS)
      // =========================================================
      final docId = "${selectedProduct}_${selectedCategory}".replaceAll(" ", "_");

      await firestore
          .collection("inventory_predictions")
          .doc(docId)
          .set({
        "product": selectedProduct,
        "category": selectedCategory,
        "month": selectedMonth,
        "predicted_units": predictedUnits,
        "predicted_sales": predictedSales,
        "predicted_profit": predictedProfit,
        "price_used": priceUsed,
        "cost_used": costUsed,
        "total_cost": totalCost,
        "profit_rate": profitRate,
        "updated_at": FieldValue.serverTimestamp(),
      });

      // =========================================================
      // NEW: CURRENT DEMAND COLLECTION (SAVE PREDICTIONS FOR NEXT MONTH ONLY)
      // =========================================================
      final String nextMonth = getNextMonth();
      final int nextMonthYear = getNextMonthYear();
      
      // Only save if the selected month is the NEXT month (not current month)
      if (selectedMonth == nextMonth) {
        final String nextMonthDemandDocId = "${selectedProduct}_${nextMonthYear}_${nextMonth}".replaceAll(" ", "_");
        
        await firestore
            .collection("current_demand")
            .doc(nextMonthDemandDocId)
            .set({
          "product": selectedProduct,
          "category": selectedCategory,
          "month": nextMonth,
          "year": nextMonthYear,
          "predicted_units": predictedUnits,
          "predicted_sales": predictedSales,
          "predicted_profit": predictedProfit,
          "price_used": priceUsed,
          "cost_used": costUsed,
          "total_cost": totalCost,
          "profit_rate": profitRate,
          "accuracy": accuracy,
          "created_at": FieldValue.serverTimestamp(),
          "updated_at": FieldValue.serverTimestamp(),
          "is_next_month": true,
        });
        
        debugPrint("✅ Saved to current_demand collection for NEXT MONTH: $nextMonth $nextMonthYear");
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("🎯 Next month ($nextMonth) demand saved to Current Demand collection!"),
              backgroundColor: tealColor,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        debugPrint("⚠️ Prediction for $selectedMonth (not next month: $nextMonth) - not saved to current_demand");
      }
      
      // =========================================================
      // AGGREGATED CURRENT DEMAND COLLECTION (FOR NEXT MONTH ONLY)
      // =========================================================
      final String monthYearKey = "${nextMonthYear}_${nextMonth}";
      final DocumentReference monthDemandRef = firestore
          .collection("monthly_current_demand")
          .doc(monthYearKey);
      
      // Get the document snapshot first
      final DocumentSnapshot snapshot = await monthDemandRef.get();
      
      if (snapshot.exists) {
        // Properly cast data to Map<String, dynamic>
        final Map<String, dynamic>? snapshotData = snapshot.data() as Map<String, dynamic>?;
        
        if (snapshotData != null) {
          // Get existing products map or create new one
          Map<String, dynamic> existingProducts = 
              (snapshotData["products"] as Map<String, dynamic>?) ?? {};
          
          // Add/update current product
          existingProducts[selectedProduct!] = {
            "category": selectedCategory,
            "predicted_units": predictedUnits,
            "predicted_sales": predictedSales,
            "predicted_profit": predictedProfit,
            "price_used": priceUsed,
            "cost_used": costUsed,
            "total_cost": totalCost,
            "profit_rate": profitRate,
            "updated_at": FieldValue.serverTimestamp(),
          };
          
          // Calculate new totals
          double currentTotalUnits = (snapshotData["total_units"] as num?)?.toDouble() ?? 0;
          double currentTotalSales = (snapshotData["total_sales"] as num?)?.toDouble() ?? 0;
          double currentTotalProfit = (snapshotData["total_profit"] as num?)?.toDouble() ?? 0;
          
          // Update the document
          await monthDemandRef.update({
            "products": existingProducts,
            "total_products": existingProducts.length,
            "total_units": currentTotalUnits + predictedUnits,
            "total_sales": currentTotalSales + predictedSales,
            "total_profit": currentTotalProfit + predictedProfit,
            "updated_at": FieldValue.serverTimestamp(),
          });
        } else {
          // Handle case where data exists but is null (shouldn't happen, but safe)
          if (selectedMonth == nextMonth) {
            await monthDemandRef.set({
              "year": nextMonthYear,
              "month": nextMonth,
              "products": {
                selectedProduct!: {
                  "category": selectedCategory,
                  "predicted_units": predictedUnits,
                  "predicted_sales": predictedSales,
                  "predicted_profit": predictedProfit,
                  "price_used": priceUsed,
                  "cost_used": costUsed,
                  "total_cost": totalCost,
                  "profit_rate": profitRate,
                  "created_at": FieldValue.serverTimestamp(),
                }
              },
              "total_products": 1,
              "total_units": predictedUnits,
              "total_sales": predictedSales,
              "total_profit": predictedProfit,
              "created_at": FieldValue.serverTimestamp(),
              "updated_at": FieldValue.serverTimestamp(),
            });
          }
        }
      } else {
        // Document doesn't exist - create new one (only for next month)
        if (selectedMonth == nextMonth) {
          await monthDemandRef.set({
            "year": nextMonthYear,
            "month": nextMonth,
            "products": {
              selectedProduct!: {
                "category": selectedCategory,
                "predicted_units": predictedUnits,
                "predicted_sales": predictedSales,
                "predicted_profit": predictedProfit,
                "price_used": priceUsed,
                "cost_used": costUsed,
                "total_cost": totalCost,
                "profit_rate": profitRate,
                "created_at": FieldValue.serverTimestamp(),
              }
            },
            "total_products": 1,
            "total_units": predictedUnits,
            "total_sales": predictedSales,
            "total_profit": predictedProfit,
            "created_at": FieldValue.serverTimestamp(),
            "updated_at": FieldValue.serverTimestamp(),
          });
        }
      }
      
      if (selectedMonth == nextMonth) {
        debugPrint("✅ Saved to monthly_current_demand collection for $monthYearKey");
      }
      
      // Final success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(" Prediction complete! ${accuracy.toStringAsFixed(1)}% accuracy"),
          backgroundColor: successColor,
          duration: const Duration(seconds: 2),
        ),
      );
      
    } catch (e) {
      setState(() => loading = false);
      debugPrint(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: dangerColor),
      );
    }
  }

  // =========================================================
  // CONTROL CARD WITH PRICE & COST
  // =========================================================
  Widget _controlCard() {
    final String nextMonth = getNextMonth();
    
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: _box(),
      child: Column(
        children: [
          _dropdown(
            "Category",
            categories,
            selectedCategory,
            (v) async {
              setState(() {
                selectedCategory = v;
                selectedProduct = null;
                products = [];
              });
              if (v != null) {
                await loadProducts(v);
              }
            },
          ),

          _dropdown(
            "Product",
            products,
            selectedProduct,
            (v) async {
              setState(() {
                selectedProduct = v;
              });
              
              if (v != null) {
                final priceData = await fetchProductPriceFromExcel(v);
                priceController.text = priceData["price"].toStringAsFixed(0);
                costController.text = priceData["cost"].toStringAsFixed(0);
                
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Price: ₹${priceData["price"].toStringAsFixed(0)} | Cost: ₹${priceData["cost"].toStringAsFixed(0)}"),
                      backgroundColor: primaryColor,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              }
            },
          ),

          _dropdown(
            "Forecast Month",
            months,
            selectedMonth,
            (v) {
              setState(() {
                selectedMonth = v;
              });
            },
          ),

          const SizedBox(height: 12),
          
          // Show indicator if selected month is next month
          if (selectedMonth == nextMonth)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: tealColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_month, size: 14, color: tealColor),
                  const SizedBox(width: 6),
                  Text(
                    "Next Month: $nextMonth - Will be saved to Current Demand",
                    style: TextStyle(fontSize: 11, color: tealColor, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          
          if (selectedMonth != null && selectedMonth != nextMonth && selectedMonth == getCurrentMonth())
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info, size: 14, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    "Current Month: ${getCurrentMonth()} - Will NOT be saved (only next month)",
                    style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Selling Price (₹)",
                    prefixIcon: const Icon(Icons.currency_rupee, size: 18),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: costController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Cost Price (₹)",
                    prefixIcon: const Icon(Icons.shopping_bag, size: 18),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: loading ? null : predict,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "RUN AI FORECAST",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _refreshButton() {
    return IconButton(
      icon: const Icon(Icons.refresh),
      onPressed: () async {
        if (selectedCategory != null) {
          await loadProducts(selectedCategory!);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Data refreshed from Excel")),
            );
          }
        }
      },
      tooltip: "Refresh from Excel",
    );
  }

  // =========================================================
  // SALES CHART
  // =========================================================
  Widget _salesChart({required bool isSmallScreen}) {
    const int maxPoints = 12;

    List<double> sales = List.from(historySales);
    List<String> monthsList = List.from(historyMonths);

    if (sales.length > maxPoints) {
      sales = sales.sublist(sales.length - maxPoints);
      monthsList = monthsList.sublist(monthsList.length - maxPoints);
    }

    if (sales.isEmpty) {
      return Container(
        height: isSmallScreen ? 350 : 420,
        padding: const EdgeInsets.all(20),
        decoration: _box(),
        child: const Center(child: Text("Run prediction to see chart")),
      );
    }

    List<FlSpot> actualSpots = [];

    for (int i = 0; i < sales.length; i++) {
      double v = sales[i];
      if (v.isNaN || v.isInfinite) v = 0;
      actualSpots.add(FlSpot(i.toDouble(), v));
    }

    double safePrediction = predictedSales;
    if (safePrediction.isNaN || safePrediction.isInfinite || safePrediction <= 0) {
      safePrediction = sales.last;
    }

    final predictionSpot = FlSpot(sales.length.toDouble(), safePrediction);
    List<FlSpot> forecastSpots = [
      actualSpots.last,
      predictionSpot,
    ];

    double maxY = sales.reduce((a, b) => a > b ? a : b);
    if (safePrediction > maxY) maxY = safePrediction;
    if (maxY <= 0) maxY = 100;

    double interval = maxY / 5;
    if (interval.isNaN || interval.isInfinite || interval <= 0) {
      interval = 20;
    }

    return Container(
      height: isSmallScreen ? 350 : 420,
      padding: const EdgeInsets.all(20),
      decoration: _box(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Actual Sales vs Forecast",
            style: TextStyle(fontSize: isSmallScreen ? 16 : 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: maxY * 1.2,
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: interval,
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 45),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      getTitlesWidget: (value, meta) {
                        int i = value.toInt();
                        if (i >= 0 && i < monthsList.length) {
                          String m = monthsList[i];
                          if (m.contains("-")) {
                            m = m.split("-")[1];
                          }
                          return Text(m.substring(0, 3),
                              style: const TextStyle(fontSize: 10));
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: actualSpots,
                    isCurved: true,
                    color: primaryColor,
                    barWidth: 4,
                    dotData: const FlDotData(show: false),
                  ),
                  LineChartBarData(
                    spots: forecastSpots,
                    isCurved: true,
                    color: successColor,
                    barWidth: 4,
                    dashArray: [6, 4],
                    dotData: const FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 20,
            runSpacing: 8,
            children: [
              _legend(primaryColor, "Actual Sales"),
              _legend(successColor, "Forecast"),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================
  // UNITS BAR CHART
  // =========================================================
  Widget _unitsChart({required bool isSmallScreen}) {
    const int maxPoints = 12;

    List<double> units = List.from(historyUnits);
    List<String> monthsList = List.from(historyMonths);

    if (units.length > maxPoints) {
      units = units.sublist(units.length - maxPoints);
      monthsList = monthsList.sublist(monthsList.length - maxPoints);
    }

    if (units.isEmpty) {
      return Container(
        height: isSmallScreen ? 350 : 420,
        padding: const EdgeInsets.all(20),
        decoration: _box(),
        child: const Center(child: Text("Run prediction to see chart")),
      );
    }

    List<BarChartGroupData> bars = [];
    double maxY = 0;

    for (int i = 0; i < units.length; i++) {
      double value = units[i];
      if (value.isNaN || value.isInfinite) value = 0;
      if (value > maxY) maxY = value;

      bars.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: value,
              width: 14,
              borderRadius: BorderRadius.circular(6),
              gradient: LinearGradient(
                colors: [
                  secondaryColor,
                  secondaryColor.withOpacity(0.7),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ],
        ),
      );
    }

    if (maxY <= 0) maxY = 100;

    double interval = maxY / 5;
    if (interval.isNaN || interval.isInfinite || interval <= 0) {
      interval = 20;
    }

    return Container(
      height: isSmallScreen ? 350 : 420,
      padding: const EdgeInsets.all(20),
      decoration: _box(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Units Sold History",
            style: TextStyle(fontSize: isSmallScreen ? 16 : 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            "Last ${units.length} months trend",
            style: TextStyle(fontSize: isSmallScreen ? 11 : 13, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: BarChart(
              BarChartData(
                minY: 0,
                maxY: maxY * 1.2,
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: interval,
                ),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 35),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index >= 0 && index < monthsList.length) {
                          String label = monthsList[index];
                          if (label.contains("-")) {
                            label = label.split("-")[1];
                          }
                          label = label.substring(0, 3);
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(label, style: const TextStyle(fontSize: 10)),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                barGroups: bars,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // METRICS ROW
  // =========================================================
  Widget _metricsRow({required bool isSmallScreen}) {
    if (isSmallScreen) {
      // Small screens: 2 rows of 3 cards
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: _analyticsCard("Revenue", "₹ ${predictedSales.toStringAsFixed(0)}", Icons.currency_rupee, primaryColor)),
              const SizedBox(width: 8),
              Expanded(child: _analyticsCard("Cost", "₹ ${totalCost.toStringAsFixed(0)}", Icons.shopping_cart, secondaryColor)),
              const SizedBox(width: 8),
              Expanded(child: _analyticsCard("Profit", "₹ ${predictedProfit.toStringAsFixed(0)}", Icons.trending_up, successColor)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _analyticsCard("Profit Rate", "${profitRate.toStringAsFixed(1)}%", Icons.percent, purpleColor)),
              const SizedBox(width: 8),
              Expanded(child: _analyticsCard("Last Month Units", latestUnits.toStringAsFixed(0), Icons.inventory_2, tealColor)),
              const SizedBox(width: 8),
              Expanded(child: _analyticsCard("Avg Units Sold", rollingAvg.toStringAsFixed(0), Icons.show_chart, indigoColor)),
            ],
          ),
        ],
      );
    } else {
      // Large screens: 1 row of 6 cards
      return Row(
        children: [
          Expanded(child: _analyticsCard("Revenue", "₹ ${predictedSales.toStringAsFixed(0)}", Icons.currency_rupee, primaryColor)),
          const SizedBox(width: 10),
          Expanded(child: _analyticsCard("Cost", "₹ ${totalCost.toStringAsFixed(0)}", Icons.shopping_cart, secondaryColor)),
          const SizedBox(width: 10),
          Expanded(child: _analyticsCard("Profit", "₹ ${predictedProfit.toStringAsFixed(0)}", Icons.trending_up, successColor)),
          const SizedBox(width: 10),
          Expanded(child: _analyticsCard("Profit Rate", "${profitRate.toStringAsFixed(1)}%", Icons.percent, purpleColor)),
          const SizedBox(width: 10),
          Expanded(child: _analyticsCard("Last Month Units", latestUnits.toStringAsFixed(0), Icons.inventory_2, tealColor)),
          const SizedBox(width: 10),
          Expanded(child: _analyticsCard("Avg Units Sold", rollingAvg.toStringAsFixed(0), Icons.show_chart, indigoColor)),
        ],
      );
    }
  }

  // =========================================================
  // COMPARISON SECTION
  // =========================================================
  Widget _comparisonSection({required bool isSmallScreen}) {
    double lastActual = historySales.isNotEmpty ? historySales.last : 0;
    double change = predictedSales - lastActual;
    double percent = lastActual == 0 ? 0 : (change / lastActual) * 100;
    bool growth = change >= 0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
      decoration: _box(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Financial Analysis",
            style: TextStyle(fontSize: isSmallScreen ? 18 : 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _comparisonTile("Last Revenue", "₹ ${lastActual.toStringAsFixed(0)}", primaryColor)),
              const SizedBox(width: 10),
              Expanded(child: _comparisonTile("Forecast Revenue", "₹ ${predictedSales.toStringAsFixed(0)}", successColor)),
              const SizedBox(width: 10),
              Expanded(child: _comparisonTile("Growth", "${percent.toStringAsFixed(1)}%", growth ? successColor : dangerColor)),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade200),
        ],
      ),
    );
  }

  // =========================================================
  // INSIGHT CARD
  // =========================================================
  Widget _insightCard({required bool isSmallScreen}) {
    double lastActual = historySales.isNotEmpty ? historySales.last : 0;
    double change = predictedSales - lastActual;
    double percent = lastActual == 0 ? 0 : (change / lastActual) * 100;
    bool growth = change >= 0;

    String insightMessage = growth
        ? "📈 AI predicts ${percent.toStringAsFixed(1)}% revenue growth. "
          "Expected profit: ₹${predictedProfit.toStringAsFixed(0)} at ${profitRate.toStringAsFixed(1)}% margin."
        : "📉 AI predicts ${percent.abs().toStringAsFixed(1)}% revenue decline. "
          "Review pricing strategy. Current margin: ${profitRate.toStringAsFixed(1)}%";

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 16 : 22),
      decoration: BoxDecoration(
        color: growth ? successColor.withOpacity(0.1) : dangerColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: growth ? successColor.withOpacity(0.2) : dangerColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              growth ? Icons.trending_up : Icons.trending_down,
              color: growth ? successColor : dangerColor,
              size: isSmallScreen ? 24 : 28,
            ),
          ),
          SizedBox(width: isSmallScreen ? 12 : 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  growth ? "Positive Growth Forecast" : "Sales Decline Warning",
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 18,
                    fontWeight: FontWeight.bold,
                    color: growth ? successColor : dangerColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  insightMessage,
                  style: TextStyle(fontSize: isSmallScreen ? 11 : 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // ANALYTICS CARD
  // =========================================================
  Widget _analyticsCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _box(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 10)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  // =========================================================
  // HEADER STATS
  // =========================================================
  Widget _topStat(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(title, textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 10)),
        ],
      ),
    );
  }

  // =========================================================
  // COMPARISON TILE
  // =========================================================
  Widget _comparisonTile(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11)),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // =========================================================
  // LEGEND
  // =========================================================
  Widget _legend(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  // =========================================================
  // DROPDOWN
  // =========================================================
  Widget _dropdown(String label, List<String> items, String? value, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<String>(
        value: items.contains(value) ? value : null,
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  // =========================================================
  // COMMON BOX
  // =========================================================
  BoxDecoration _box() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // =========================================================
  // BUILD
  // =========================================================
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final padding = isSmallScreen ? 12.0 : 16.0;

    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(
          isSmallScreen ? "AI Forecast" : "AI Forecast Dashboard",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          _refreshButton(),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Gradient Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, primaryColor.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(isSmallScreen ? 20 : 24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isSmallScreen ? "AI Analytics" : "AI Retail Analytics",
                    style: TextStyle(color: Colors.white, fontSize: isSmallScreen ? 20 : 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isSmallScreen ? "ML forecasting for inventory" : "Advanced ML forecasting for inventory intelligence",
                    style: TextStyle(color: Colors.white.withOpacity(0.92), fontSize: isSmallScreen ? 11 : 13),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _topStat("Accuracy", "${accuracy.toStringAsFixed(1)}%", Icons.analytics)),
                      const SizedBox(width: 10),
                      Expanded(child: _topStat("Forecast Units", predictedUnits.toStringAsFixed(0), Icons.inventory_2)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Control Card
            _controlCard(),
            
            const SizedBox(height: 16),
            
            // Show results only after prediction
            if (historySales.isNotEmpty) ...[
              // Metrics Row
              _metricsRow(isSmallScreen: isSmallScreen),
              const SizedBox(height: 16),
              
              // CHARTS SECTION
              // SMALL SCREEN: Stacked vertically (one above the other)
              // LARGE SCREEN: Side by side
              // if (isSmallScreen) ...[
              //   // Stacked vertically for small screens
              //   _salesChart(isSmallScreen: true),
              //   const SizedBox(height: 16),
              //   _unitsChart(isSmallScreen: true),
              // ] else ...[
              //   // Side by side for large screens
              //   Row(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Expanded(flex: 2, child: _salesChart(isSmallScreen: false)),
              //       const SizedBox(width: 16),
              //       Expanded(child: _unitsChart(isSmallScreen: false)),
              //     ],
              //   ),
              // ],
              isSmallScreen
    ? Column(
        children: [
          _salesChart(isSmallScreen: isSmallScreen),
          const SizedBox(height: 16),
          _unitsChart(isSmallScreen: isSmallScreen),
        ],
      )
    : Row(
        children: [
          Expanded(child: _salesChart(isSmallScreen: isSmallScreen)),
          const SizedBox(width: 16),
          Expanded(child: _unitsChart(isSmallScreen: isSmallScreen)),
        ],
      ),
               SizedBox(height: 16),
              
              // Comparison Section
              _comparisonSection(isSmallScreen: isSmallScreen),
              const SizedBox(height: 16),
              
              // Insight Card
              _insightCard(isSmallScreen: isSmallScreen),
            ],
          ],
        ),
      ),
    );
  }
}
