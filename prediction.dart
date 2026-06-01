
// // // // // // // // // import 'dart:convert';
// // // // // // // // // import 'package:fl_chart/fl_chart.dart';
// // // // // // // // // import 'package:flutter/material.dart';
// // // // // // // // // import 'package:http/http.dart' as http;
// // // // // // // // // import 'package:cloud_firestore/cloud_firestore.dart'; // ✅ ADDED

// // // // // // // // // class PredictionPage extends StatefulWidget {
// // // // // // // // //   const PredictionPage({super.key});

// // // // // // // // //   @override
// // // // // // // // //   State<PredictionPage> createState() => _PredictionPageState();
// // // // // // // // // }

// // // // // // // // // class _PredictionPageState extends State<PredictionPage> {

// // // // // // // // //   // =========================================================
// // // // // // // // //   // DATA
// // // // // // // // //   // =========================================================

// // // // // // // // //   List<double> historySales = [];
// // // // // // // // //   List<double> historyUnits = [];
// // // // // // // // //   List<String> historyMonths = [];

// // // // // // // // //   List<String> categories = [];
// // // // // // // // //   List<String> products = [];
// // // // // // // // //   List<String> months = [];

// // // // // // // // //   String? selectedCategory;
// // // // // // // // //   String? selectedProduct;
// // // // // // // // //   String? selectedMonth;

// // // // // // // // //   bool loading = false;

// // // // // // // // //   // =========================================================
// // // // // // // // //   // ML RESULTS
// // // // // // // // //   // =========================================================

// // // // // // // // //   double predictedSales = 0;
// // // // // // // // //   double predictedUnits = 0;
// // // // // // // // //   double latestUnits = 0;
// // // // // // // // //   double rollingAvg = 0;
// // // // // // // // //   double accuracy = 0;

// // // // // // // // //   final TextEditingController priceController =
// // // // // // // // //       TextEditingController(text: "500");

// // // // // // // // //   final String baseUrl = "http://192.168.100.218:5000";
  

// // // // // // // // //   final FirebaseFirestore firestore = FirebaseFirestore.instance; // ✅ ADDED

// // // // // // // // //   // =========================================================
// // // // // // // // //   // INIT
// // // // // // // // //   // =========================================================

// // // // // // // // //   @override
// // // // // // // // //   void initState() {
// // // // // // // // //     super.initState();
// // // // // // // // //     initialize();
// // // // // // // // //   }

// // // // // // // // //   Future<void> initialize() async {
// // // // // // // // //     await loadCategories();
// // // // // // // // //     await loadMonths();
// // // // // // // // //   }

// // // // // // // // //   // =========================================================
// // // // // // // // //   // FETCH LIST
// // // // // // // // //   // =========================================================

// // // // // // // // //   Future<List<String>> fetchList(String endpoint, String key) async {
// // // // // // // // //     try {
// // // // // // // // //       final res = await http.get(Uri.parse("$baseUrl/$endpoint"));
// // // // // // // // //       final data = jsonDecode(res.body);
// // // // // // // // //       return List<String>.from(data[key] ?? []);
// // // // // // // // //     } catch (_) {
// // // // // // // // //       return [];
// // // // // // // // //     }
// // // // // // // // //   }
// // // // // // // // // // Add this function to fetch product price
// // // // // // // // // Future<double> fetchProductPrice(String product, String category) async {
// // // // // // // // //   try {
// // // // // // // // //     final snapshot = await firestore
// // // // // // // // //         .collection("inventory")
// // // // // // // // //         .where("product", isEqualTo: product)
// // // // // // // // //         .where("category", isEqualTo: category)
// // // // // // // // //         .get();
    
// // // // // // // // //     if (snapshot.docs.isNotEmpty) {
// // // // // // // // //       final data = snapshot.docs.first.data();
// // // // // // // // //       final price = (data["price"] ?? 500).toDouble();
// // // // // // // // //       return price;
// // // // // // // // //     }
// // // // // // // // //     return 500; // Default price if not found
// // // // // // // // //   } catch (e) {
// // // // // // // // //     debugPrint("Error fetching price: $e");
// // // // // // // // //     return 500;
// // // // // // // // //   }
// // // // // // // // // }
// // // // // // // // //   Future<void> loadCategories() async {
// // // // // // // // //     categories = await fetchList("categories", "categories");

// // // // // // // // //     setState(() {
// // // // // // // // //       selectedCategory =
// // // // // // // // //           categories.isNotEmpty ? categories.first : null;

// // // // // // // // //       selectedProduct = null;
// // // // // // // // //       products = [];
// // // // // // // // //     });

// // // // // // // // //     if (selectedCategory != null) {
// // // // // // // // //       await loadProducts(selectedCategory!);
// // // // // // // // //     }
// // // // // // // // //   }

// // // // // // // // //   Future<void> loadProducts(String category) async {
// // // // // // // // //     try {
// // // // // // // // //       final res = await http.get(
// // // // // // // // //         Uri.parse("$baseUrl/products?category=$category"),
// // // // // // // // //       );

// // // // // // // // //       final data = jsonDecode(res.body);

// // // // // // // // //       setState(() {
// // // // // // // // //         products = List<String>.from(data["products"] ?? []);
// // // // // // // // //         selectedProduct =
// // // // // // // // //             products.isNotEmpty ? products.first : null;
// // // // // // // // //       });
// // // // // // // // //     } catch (_) {
// // // // // // // // //       setState(() {
// // // // // // // // //         products = [];
// // // // // // // // //         selectedProduct = null;
// // // // // // // // //       });
// // // // // // // // //     }
// // // // // // // // //   }

// // // // // // // // //   Future<void> loadMonths() async {
// // // // // // // // //     months = await fetchList("months", "months");

// // // // // // // // //     setState(() {
// // // // // // // // //       selectedMonth =
// // // // // // // // //           months.isNotEmpty ? months.last : null;
// // // // // // // // //     });
// // // // // // // // //   }

// // // // // // // // //   int getMonthIndex(String month) {
// // // // // // // // //     const monthOrder = [
// // // // // // // // //       "jan","feb","mar","apr","may","jun",
// // // // // // // // //       "jul","aug","sep","oct","nov","dec",
// // // // // // // // //     ];

// // // // // // // // //     String shortMonth = month.toLowerCase().substring(0, 3);
// // // // // // // // //     return monthOrder.indexOf(shortMonth);
// // // // // // // // //   }

// // // // // // // // //   // =========================================================
// // // // // // // // //   // PREDICT + FIRESTORE SAVE
// // // // // // // // //   // =========================================================
// // // // // // // // // Future<void> predict() async {
// // // // // // // // //   if (selectedCategory == null ||
// // // // // // // // //       selectedProduct == null ||
// // // // // // // // //       selectedMonth == null) {
// // // // // // // // //     return;
// // // // // // // // //   }
// // // // // // // // // // final docId =
// // // // // // // // // //     "${selectedProduct}_${selectedCategory}"
// // // // // // // // // //         .replaceAll(" ", "_");
// // // // // // // // // //   setState(() => loading = true);
// // // // // // // // // //   await firestore
// // // // // // // // // //     .collection("inventory_predictions")
// // // // // // // // // //     .doc(docId)
// // // // // // // // // //     .set({
// // // // // // // // // //   "product": selectedProduct,
// // // // // // // // // //   "category": selectedCategory,
// // // // // // // // // //   "predicted_units": predictedUnits,
// // // // // // // // // //   "month": selectedMonth,
// // // // // // // // // //   "updated_at": FieldValue.serverTimestamp(),
// // // // // // // // // // });
// // // // // // // // // //   //this is the line 
// // // // // // // // // // await firestore.collection("inventory_prediction").add({
// // // // // // // // // //   "product": selectedProduct,
// // // // // // // // // //   "category": selectedCategory,
// // // // // // // // // //   "month": selectedMonth,
// // // // // // // // // //   "predicted_units": predictedUnits,
// // // // // // // // // //   "created_at": FieldValue.serverTimestamp(),
// // // // // // // // // // });
// // // // // // // // // setState(() => loading = true);
// // // // // // // // // //till here
// // // // // // // // // // for inventory
// // // // // // // // //   try {
// // // // // // // // //     final res = await http.post(
// // // // // // // // //       Uri.parse("$baseUrl/predict"),
// // // // // // // // //       headers: {"Content-Type": "application/json"},
// // // // // // // // //       body: jsonEncode({
// // // // // // // // //         "category": selectedCategory,
// // // // // // // // //         "product": selectedProduct,
// // // // // // // // //         "month": selectedMonth,
// // // // // // // // //         "price": double.tryParse(priceController.text) ?? 0,
// // // // // // // // //       }),
// // // // // // // // //     );

// // // // // // // // //     final data = jsonDecode(res.body);

// // // // // // // // //     List<String> rawMonths =
// // // // // // // // //         List<String>.from(data["history_months"] ?? []);

// // // // // // // // //     List<double> rawSales =
// // // // // // // // //         List<double>.from((data["history_sales"] ?? [])
// // // // // // // // //             .map((e) => (e as num).toDouble()));

// // // // // // // // //     List<double> rawUnits =
// // // // // // // // //         List<double>.from((data["history_units"] ?? [])
// // // // // // // // //             .map((e) => (e as num).toDouble()));

// // // // // // // // //     List<Map<String, dynamic>> combined = [];

// // // // // // // // //     for (int i = 0; i < rawMonths.length; i++) {
// // // // // // // // //       combined.add({
// // // // // // // // //         "month": rawMonths[i],
// // // // // // // // //         "sales": i < rawSales.length ? rawSales[i] : 0,
// // // // // // // // //         "units": i < rawUnits.length ? rawUnits[i] : 0,
// // // // // // // // //       });
// // // // // // // // //     }
// // // // // // // // // const int maxPoints = 12;

// // // // // // // // // if (historySales.length > maxPoints) {
// // // // // // // // //   historySales = historySales.sublist(historySales.length - maxPoints);
// // // // // // // // //   historyUnits = historyUnits.sublist(historyUnits.length - maxPoints);
// // // // // // // // //   historyMonths = historyMonths.sublist(historyMonths.length - maxPoints);
// // // // // // // // // }
// // // // // // // // //     // =====================================================
// // // // // // // // //     // SAFE SORT (NO CRASH EVEN IF FORMAT CHANGES)
// // // // // // // // //     // =====================================================

// // // // // // // // //     combined.sort((a, b) {
// // // // // // // // //       try {
// // // // // // // // //         final aParts = a["month"].toString().split("-");
// // // // // // // // //         final bParts = b["month"].toString().split("-");

// // // // // // // // //         int aYear = int.parse(aParts[0]);
// // // // // // // // //         int bYear = int.parse(bParts[0]);

// // // // // // // // //         int aMonth = getMonthIndex(aParts[1]);
// // // // // // // // //         int bMonth = getMonthIndex(bParts[1]);

// // // // // // // // //         if (aYear != bYear) {
// // // // // // // // //           return aYear.compareTo(bYear);
// // // // // // // // //         }

// // // // // // // // //         return aMonth.compareTo(bMonth);
// // // // // // // // //       } catch (_) {
// // // // // // // // //         return 0;
// // // // // // // // //       }
// // // // // // // // //     });

// // // // // // // // //     historyMonths =
// // // // // // // // //         combined.map((e) => e["month"].toString()).toList();

// // // // // // // // //     historySales =
// // // // // // // // //         combined.map((e) => (e["sales"] as num).toDouble()).toList();

// // // // // // // // //     historyUnits =
// // // // // // // // //         combined.map((e) => (e["units"] as num).toDouble()).toList();

// // // // // // // // //     setState(() {
// // // // // // // // //       predictedSales =
// // // // // // // // //           (data["predicted_sales"] ?? 0).toDouble();

// // // // // // // // //       predictedUnits =
// // // // // // // // //           (data["predicted_units"] ?? 0).toDouble();

// // // // // // // // //       latestUnits =
// // // // // // // // //           (data["latest_units"] ??
// // // // // // // // //               data["latest_units_used"] ??
// // // // // // // // //               0).toDouble();

// // // // // // // // //       rollingAvg =
// // // // // // // // //           (data["rolling_avg"] ??
// // // // // // // // //               data["rolling_avg_used"] ??
// // // // // // // // //               0).toDouble();

// // // // // // // // //       accuracy =
// // // // // // // // //           ((data["accuracy"] ?? 0) * 100).toDouble();

// // // // // // // // //       loading = false;
// // // // // // // // //     });

// // // // // // // // //     await firestore.collection("prediction_history").add({
// // // // // // // // //       "category": selectedCategory,
// // // // // // // // //       "product": selectedProduct,
// // // // // // // // //       "month": selectedMonth,
// // // // // // // // //       "price": double.tryParse(priceController.text) ?? 0,
// // // // // // // // //       "predicted_sales": predictedSales,
// // // // // // // // //       "predicted_units": predictedUnits,
// // // // // // // // //       "created_at": FieldValue.serverTimestamp(),
// // // // // // // // //     });
// // // // // // // // // // SAVE LATEST INVENTORY PREDICTION

// // // // // // // // // final docId =
// // // // // // // // //     "${selectedProduct}_${selectedCategory}"
// // // // // // // // //         .replaceAll(" ", "_");

// // // // // // // // // await firestore
// // // // // // // // //     .collection("inventory_predictions")
// // // // // // // // //     .doc(docId)
// // // // // // // // //     .set({
// // // // // // // // //   "product": selectedProduct,
// // // // // // // // //   "category": selectedCategory,
// // // // // // // // //   "month": selectedMonth,

// // // // // // // // //   // latest values from API
// // // // // // // // //   "predicted_units": predictedUnits,
// // // // // // // // //   "predicted_sales": predictedSales,

// // // // // // // // //   "updated_at": FieldValue.serverTimestamp(),
// // // // // // // // // });
// // // // // // // // //   } catch (e) {
// // // // // // // // //     setState(() => loading = false);
// // // // // // // // //     debugPrint(e.toString());
// // // // // // // // //   }
// // // // // // // // // }


// // // // // // // // //   @override
// // // // // // // // //   Widget build(BuildContext context) {

// // // // // // // // //     return Scaffold(

// // // // // // // // //       backgroundColor: const Color(
// // // // // // // // //         0xffF4F7FC,
// // // // // // // // //       ),

// // // // // // // // //       appBar: AppBar(

// // // // // // // // //         elevation: 0,

// // // // // // // // //         backgroundColor: Colors.white,

// // // // // // // // //         foregroundColor: Colors.black,

// // // // // // // // //         title: const Text(

// // // // // // // // //           "AI Forecastttt Dashboard",

// // // // // // // // //           style: TextStyle(
// // // // // // // // //             fontWeight: FontWeight.bold,
// // // // // // // // //           ),
// // // // // // // // //         ),
// // // // // // // // //       ),

// // // // // // // // //       body: SingleChildScrollView(

// // // // // // // // //         padding: const EdgeInsets.all(20),

// // // // // // // // //         child: Column(

// // // // // // // // //           crossAxisAlignment:
// // // // // // // // //           CrossAxisAlignment.start,

// // // // // // // // //           children: [

// // // // // // // // //             // =================================================
// // // // // // // // //             // TOP HEADER
// // // // // // // // //             // =================================================

// // // // // // // // //             Container(

// // // // // // // // //               width: double.infinity,

// // // // // // // // //               padding: const EdgeInsets.all(24),

// // // // // // // // //               decoration: BoxDecoration(

// // // // // // // // //                 gradient: LinearGradient(

// // // // // // // // //                   colors: [

// // // // // // // // //                     Colors.blue.shade700,

// // // // // // // // //                     Colors.indigo.shade600,
// // // // // // // // //                   ],

// // // // // // // // //                   begin: Alignment.topLeft,

// // // // // // // // //                   end: Alignment.bottomRight,
// // // // // // // // //                 ),

// // // // // // // // //                 borderRadius:
// // // // // // // // //                 BorderRadius.circular(28),
// // // // // // // // //               ),

// // // // // // // // //               child: Column(

// // // // // // // // //                 crossAxisAlignment:
// // // // // // // // //                 CrossAxisAlignment.start,

// // // // // // // // //                 children: [

// // // // // // // // //                   const Text(

// // // // // // // // //                     "AI Retail Analytics",

// // // // // // // // //                     style: TextStyle(

// // // // // // // // //                       color: Colors.white,

// // // // // // // // //                       fontSize: 28,

// // // // // // // // //                       fontWeight:
// // // // // // // // //                       FontWeight.bold,
// // // // // // // // //                     ),
// // // // // // // // //                   ),

// // // // // // // // //                   const SizedBox(height: 12),

// // // // // // // // //                   Text(

// // // // // // // // //                     "1Advanced machine learning forecasting system for inventory intelligence and sales prediction.",

// // // // // // // // //                     style: TextStyle(

// // // // // // // // //                       color: Colors.white
// // // // // // // // //                           .withOpacity(0.92),

// // // // // // // // //                       height: 1.5,
// // // // // // // // //                     ),
// // // // // // // // //                   ),

// // // // // // // // //                   const SizedBox(height: 24),

// // // // // // // // //                   Row(

// // // // // // // // //                     children: [

// // // // // // // // //                       Expanded(
// // // // // // // // //                         child: _topStat(
// // // // // // // // //                           "Accuracy",
// // // // // // // // //                           "${accuracy.toStringAsFixed(1)}%",
// // // // // // // // //                           Icons.analytics,
// // // // // // // // //                         ),
// // // // // // // // //                       ),

// // // // // // // // //                       const SizedBox(width: 14),

// // // // // // // // //                       Expanded(
// // // // // // // // //                         child: _topStat(
// // // // // // // // //                           "Forecast Units",
// // // // // // // // //                           predictedUnits
// // // // // // // // //                               .toStringAsFixed(0),
// // // // // // // // //                           Icons.inventory_2,
// // // // // // // // //                         ),
// // // // // // // // //                       ),
// // // // // // // // //                     ],
// // // // // // // // //                   ),
// // // // // // // // //                 ],
// // // // // // // // //               ),
// // // // // // // // //             ),

// // // // // // // // //             const SizedBox(height: 24),

// // // // // // // // //             _controlCard(),

// // // // // // // // //             const SizedBox(height: 24),

// // // // // // // // //             if (historySales.isNotEmpty) ...[

// // // // // // // // //               Row(

// // // // // // // // //                 children: [

// // // // // // // // //                   Expanded(
// // // // // // // // //                     child: _analyticsCard(
// // // // // // // // //                       "Predicted Revenue",
// // // // // // // // //                       "Rs ${predictedSales.toStringAsFixed(0)}",
// // // // // // // // //                       Icons.currency_rupee,
// // // // // // // // //                       Colors.blue,
// // // // // // // // //                     ),
// // // // // // // // //                   ),

// // // // // // // // //                   const SizedBox(width: 14),

// // // // // // // // //                   Expanded(
// // // // // // // // //                     child: _analyticsCard(
// // // // // // // // //                       "Latest Units",
// // // // // // // // //                       latestUnits.toStringAsFixed(0),
// // // // // // // // //                       Icons.shopping_cart,
// // // // // // // // //                       Colors.orange,
// // // // // // // // //                     ),
// // // // // // // // //                   ),

// // // // // // // // //                   const SizedBox(width: 14),

// // // // // // // // //                   Expanded(
// // // // // // // // //                     child: _analyticsCard(
// // // // // // // // //                       "Rolling Average",
// // // // // // // // //                       rollingAvg.toStringAsFixed(0),
// // // // // // // // //                       Icons.show_chart,
// // // // // // // // //                       Colors.green,
// // // // // // // // //                     ),
// // // // // // // // //                   ),
// // // // // // // // //                 ],
// // // // // // // // //               ),

// // // // // // // // //               const SizedBox(height: 24),

// // // // // // // // //               Row(

// // // // // // // // //                 crossAxisAlignment:
// // // // // // // // //                 CrossAxisAlignment.start,

// // // // // // // // //                 children: [

// // // // // // // // //                   Expanded(
// // // // // // // // //                     flex: 2,
// // // // // // // // //                     child: _salesChart(),
// // // // // // // // //                   ),

// // // // // // // // //                   const SizedBox(width: 18),

// // // // // // // // //                   Expanded(
// // // // // // // // //                     child: _unitsChart(),
// // // // // // // // //                   ),
// // // // // // // // //                 ],
// // // // // // // // //               ),

// // // // // // // // //               const SizedBox(height: 24),

// // // // // // // // //               _comparisonSection(),

// // // // // // // // //               const SizedBox(height: 24),

// // // // // // // // //               _insightCard(),
// // // // // // // // //             ],
// // // // // // // // //           ],
// // // // // // // // //         ),
// // // // // // // // //       ),
// // // // // // // // //     );
// // // // // // // // //   }

// // // // // // // // //   // =========================================================
// // // // // // // // //   // SALES CHART
// // // // // // // // //   // =========================================================

// // // // // // // // //   // Widget _salesChart() {

// // // // // // // // //   //   List<FlSpot> actualSpots = [];

// // // // // // // // //   //   for (int i = 0;
// // // // // // // // //   //   i < historySales.length;
// // // // // // // // //   //   i++) {

// // // // // // // // //   //     actualSpots.add(
// // // // // // // // //   //       FlSpot(
// // // // // // // // //   //         i.toDouble(),
// // // // // // // // //   //         historySales[i],
// // // // // // // // //   //       ),
// // // // // // // // //   //     );
// // // // // // // // //   //   }

// // // // // // // // //   //   final predictionSpot = FlSpot(
// // // // // // // // //   //     historySales.length.toDouble(),
// // // // // // // // //   //     predictedSales,
// // // // // // // // //   //   );

// // // // // // // // //   //   List<FlSpot> forecastSpots = [];

// // // // // // // // //   //   if (actualSpots.isNotEmpty) {

// // // // // // // // //   //     forecastSpots = [

// // // // // // // // //   //       actualSpots.last,

// // // // // // // // //   //       predictionSpot,
// // // // // // // // //   //     ];
// // // // // // // // //   //   }

// // // // // // // // //   //   double maxY = 0;

// // // // // // // // //   //   for (double value in historySales) {

// // // // // // // // //   //     if (value > maxY) {
// // // // // // // // //   //       maxY = value;
// // // // // // // // //   //     }
// // // // // // // // //   //   }

// // // // // // // // //   //   if (predictedSales > maxY) {
// // // // // // // // //   //     maxY = predictedSales;
// // // // // // // // //   //   }

// // // // // // // // //   //   return Container(
// // // // // // // // //   //     height: 420,
// // // // // // // // //   //     padding: const EdgeInsets.all(20),
// // // // // // // // //   //     decoration: _box(),
// // // // // // // // //   //     child: Column(
// // // // // // // // //   //       crossAxisAlignment:
// // // // // // // // //   //       CrossAxisAlignment.start,
// // // // // // // // //   //       children: [

// // // // // // // // //   //         const Text(
// // // // // // // // //   //           "Actual Sales vs Forecast",
// // // // // // // // //   //           style: TextStyle(
// // // // // // // // //   //             fontSize: 20,
// // // // // // // // //   //             fontWeight: FontWeight.bold,
// // // // // // // // //   //           ),
// // // // // // // // //   //         ),

// // // // // // // // //   //         const SizedBox(height: 10),

// // // // // // // // //   //         Text(
// // // // // // // // //   //           "Blue line represents actual sales history and green dashed line shows future AI forecast.",
// // // // // // // // //   //           style: TextStyle(
// // // // // // // // //   //             color: Colors.grey.shade600,
// // // // // // // // //   //           ),
// // // // // // // // //   //         ),

// // // // // // // // //   //         const SizedBox(height: 20),

// // // // // // // // //   //         Expanded(
// // // // // // // // //   //           child: LineChart(
// // // // // // // // //   //             LineChartData(

// // // // // // // // //   //               minY: 0,
// // // // // // // // //   //               maxY: maxY * 1.2,

// // // // // // // // //   //               borderData:
// // // // // // // // //   //               FlBorderData(show: false),

// // // // // // // // //   //               gridData:
// // // // // // // // //   //               FlGridData(
// // // // // // // // //   //                 show: true,
// // // // // // // // //   //                 horizontalInterval:
// // // // // // // // //   //                 maxY / 5,
// // // // // // // // //   //               ),

// // // // // // // // //   //               titlesData: FlTitlesData(

// // // // // // // // //   //                 leftTitles: AxisTitles(
// // // // // // // // //   //                   sideTitles: SideTitles(
// // // // // // // // //   //                     showTitles: true,
// // // // // // // // //   //                     reservedSize: 45,
// // // // // // // // //   //                   ),
// // // // // // // // //   //                 ),

// // // // // // // // //   //                 bottomTitles: AxisTitles(
// // // // // // // // //   //                   sideTitles: SideTitles(

// // // // // // // // //   //                     showTitles: true,

// // // // // // // // //   //                     interval: 1,

// // // // // // // // //   //                     getTitlesWidget:
// // // // // // // // //   //                         (value, meta) {

// // // // // // // // //   //                       int index =
// // // // // // // // //   //                       value.toInt();

// // // // // // // // //   //                       if (index >= 0 &&
// // // // // // // // //   //                           index <
// // // // // // // // //   //                               historyMonths.length) {

// // // // // // // // //   //                         return Padding(
// // // // // // // // //   //                           padding:
// // // // // // // // //   //                           const EdgeInsets.only(
// // // // // // // // //   //                             top: 8,
// // // // // // // // //   //                           ),
// // // // // // // // //   //                           child: Text(
// // // // // // // // //   //                             // historyMonths[index],
// // // // // // // // //   //                             historyMonths[index].split("-")[1],
// // // // // // // // //   //                             style:
// // // // // // // // //   //                             const TextStyle(
// // // // // // // // //   //                               fontSize: 10,
// // // // // // // // //   //                             ),
// // // // // // // // //   //                           ),
// // // // // // // // //   //                         );
// // // // // // // // //   //                       }

// // // // // // // // //   //                       return const SizedBox();
// // // // // // // // //   //                     },
// // // // // // // // //   //                   ),
// // // // // // // // //   //                 ),

// // // // // // // // //   //                 topTitles:
// // // // // // // // //   //                 const AxisTitles(
// // // // // // // // //   //                   sideTitles:
// // // // // // // // //   //                   SideTitles(
// // // // // // // // //   //                     showTitles: false,
// // // // // // // // //   //                   ),
// // // // // // // // //   //                 ),

// // // // // // // // //   //                 rightTitles:
// // // // // // // // //   //                 const AxisTitles(
// // // // // // // // //   //                   sideTitles:
// // // // // // // // //   //                   SideTitles(
// // // // // // // // //   //                     showTitles: false,
// // // // // // // // //   //                   ),
// // // // // // // // //   //                 ),
// // // // // // // // //   //               ),

// // // // // // // // //   //               lineBarsData: [

// // // // // // // // //   //                 LineChartBarData(

// // // // // // // // //   //                   spots: actualSpots,

// // // // // // // // //   //                   isCurved: true,

// // // // // // // // //   //                   color: Colors.blue,

// // // // // // // // //   //                   barWidth: 4,

// // // // // // // // //   //                   dotData:
// // // // // // // // //   //                   const FlDotData(
// // // // // // // // //   //                     show: true,
// // // // // // // // //   //                   ),

// // // // // // // // //   //                   belowBarData:
// // // // // // // // //   //                   BarAreaData(

// // // // // // // // //   //                     show: true,

// // // // // // // // //   //                     gradient:
// // // // // // // // //   //                     LinearGradient(

// // // // // // // // //   //                       colors: [

// // // // // // // // //   //                         Colors.blue
// // // // // // // // //   //                             .withOpacity(
// // // // // // // // //   //                           0.25,
// // // // // // // // //   //                         ),

// // // // // // // // //   //                         Colors.transparent,
// // // // // // // // //   //                       ],

// // // // // // // // //   //                       begin:
// // // // // // // // //   //                       Alignment.topCenter,

// // // // // // // // //   //                       end:
// // // // // // // // //   //                       Alignment.bottomCenter,
// // // // // // // // //   //                     ),
// // // // // // // // //   //                   ),
// // // // // // // // //   //                 ),

// // // // // // // // //   //                 if (forecastSpots.isNotEmpty)

// // // // // // // // //   //                   LineChartBarData(

// // // // // // // // //   //                     spots: forecastSpots,

// // // // // // // // //   //                     isCurved: true,

// // // // // // // // //   //                     dashArray: [8, 4],

// // // // // // // // //   //                     color: Colors.green,

// // // // // // // // //   //                     barWidth: 4,

// // // // // // // // //   //                     dotData:
// // // // // // // // //   //                     const FlDotData(
// // // // // // // // //   //                       show: true,
// // // // // // // // //   //                     ),
// // // // // // // // //   //                   ),
// // // // // // // // //   //               ],
// // // // // // // // //   //             ),
// // // // // // // // //   //           ),
// // // // // // // // //   //         ),

// // // // // // // // //   //         const SizedBox(height: 16),

// // // // // // // // //   //         Row(
// // // // // // // // //   //           children: [

// // // // // // // // //   //             _legend(
// // // // // // // // //   //               Colors.blue,
// // // // // // // // //   //               "Actual Sales",
// // // // // // // // //   //             ),

// // // // // // // // //   //             const SizedBox(width: 24),

// // // // // // // // //   //             _legend(
// // // // // // // // //   //               Colors.green,
// // // // // // // // //   //               "AI Forecast",
// // // // // // // // //   //             ),
// // // // // // // // //   //           ],
// // // // // // // // //   //         ),
// // // // // // // // //   //       ],
// // // // // // // // //   //     ),
// // // // // // // // //   //   );
// // // // // // // // //   // }
// // // // // // // // // // Widget _salesChart() {

// // // // // // // // // //   List<FlSpot> actualSpots = [];

// // // // // // // // // //   for (int i = 0; i < historySales.length; i++) {

// // // // // // // // // //     double value = historySales[i];

// // // // // // // // // //     if (value.isNaN || value.isInfinite) {
// // // // // // // // // //       value = 0;
// // // // // // // // // //       }

// // // // // // // // // //     actualSpots.add(
// // // // // // // // // //       FlSpot(i.toDouble(), value),
// // // // // // // // // //     );
// // // // // // // // // //   }

// // // // // // // // // //   double safePrediction = predictedSales;

// // // // // // // // // //   if (safePrediction.isNaN || safePrediction.isInfinite) {
// // // // // // // // // //     safePrediction = 0;
// // // // // // // // // //   }

// // // // // // // // // //   final predictionSpot = FlSpot(
// // // // // // // // // //     historySales.length.toDouble(),
// // // // // // // // // //     safePrediction,
// // // // // // // // // //   );

// // // // // // // // // //   List<FlSpot> forecastSpots = [];

// // // // // // // // // //   if (actualSpots.isNotEmpty) {
// // // // // // // // // //     forecastSpots = [
// // // // // // // // // //       actualSpots.last,
// // // // // // // // // //       predictionSpot,
// // // // // // // // // //     ];
// // // // // // // // // //   }

// // // // // // // // // //   double maxY = 0;

// // // // // // // // // //   for (double value in historySales) {
// // // // // // // // // //     if (value > maxY) {
// // // // // // // // // //       maxY = value;
// // // // // // // // // //     }
// // // // // // // // // //   }

// // // // // // // // // //   if (safePrediction > maxY) {
// // // // // // // // // //     maxY = safePrediction;
// // // // // // // // // //   }

// // // // // // // // // //   // =====================================================
// // // // // // // // // //   // VERY IMPORTANT FIXES
// // // // // // // // // //   // =====================================================

// // // // // // // // // //   if (maxY <= 0) {
// // // // // // // // // //     maxY = 100;
// // // // // // // // // //   }

// // // // // // // // // //   double interval = maxY / 5;

// // // // // // // // // //   if (interval <= 0 || interval.isNaN || interval.isInfinite) {
// // // // // // // // // //     interval = 20;
// // // // // // // // // //   }

// // // // // // // // // //   return Container(

// // // // // // // // // //     height: 420,

// // // // // // // // // //     padding: const EdgeInsets.all(20),

// // // // // // // // // //     decoration: _box(),

// // // // // // // // // //     child: Column(

// // // // // // // // // //       crossAxisAlignment: CrossAxisAlignment.start,

// // // // // // // // // //       children: [

// // // // // // // // // //         const Text(

// // // // // // // // // //           "Actual Sales vs Forecast",

// // // // // // // // // //           style: TextStyle(
// // // // // // // // // //             fontSize: 20,
// // // // // // // // // //             fontWeight: FontWeight.bold,
// // // // // // // // // //           ),
// // // // // // // // // //         ),

// // // // // // // // // //         const SizedBox(height: 10),

// // // // // // // // // //         Text(

// // // // // // // // // //           "Blue line represents actual sales history and green dashed line shows future AI forecast.",

// // // // // // // // // //           style: TextStyle(
// // // // // // // // // //             color: Colors.grey.shade600,
// // // // // // // // // //           ),
// // // // // // // // // //         ),

// // // // // // // // // //         const SizedBox(height: 20),

// // // // // // // // // //         Expanded(

// // // // // // // // // //           child: LineChart(

// // // // // // // // // //             LineChartData(

// // // // // // // // // //               minY: 0,

// // // // // // // // // //               maxY: maxY * 1.2,

// // // // // // // // // //               borderData: FlBorderData(show: false),

// // // // // // // // // //               gridData: FlGridData(

// // // // // // // // // //                 show: true,

// // // // // // // // // //                 horizontalInterval: interval,
// // // // // // // // // //               ),

// // // // // // // // // //               titlesData: FlTitlesData(

// // // // // // // // // //                 leftTitles: AxisTitles(

// // // // // // // // // //                   sideTitles: SideTitles(
// // // // // // // // // //                     showTitles: true,
// // // // // // // // // //                     reservedSize: 45,
// // // // // // // // // //                   ),
// // // // // // // // // //                 ),

// // // // // // // // // //                 bottomTitles: AxisTitles(

// // // // // // // // // //                   sideTitles: SideTitles(

// // // // // // // // // //                     showTitles: true,

// // // // // // // // // //                     interval: 1,

// // // // // // // // // //                     getTitlesWidget: (value, meta) {

// // // // // // // // // //                       int index = value.toInt();

// // // // // // // // // //                       if (index >= 0 &&
// // // // // // // // // //                           index < historyMonths.length) {

// // // // // // // // // //                         String label =
// // // // // // // // // //                             historyMonths[index];

// // // // // // // // // //                         if (label.contains("-")) {
// // // // // // // // // //                           label = label.split("-")[1];
// // // // // // // // // //                         }

// // // // // // // // // //                         return Padding(

// // // // // // // // // //                           padding: const EdgeInsets.only(
// // // // // // // // // //                             top: 8,
// // // // // // // // // //                           ),

// // // // // // // // // //                           child: Text(

// // // // // // // // // //                             label,

// // // // // // // // // //                             style: const TextStyle(
// // // // // // // // // //                               fontSize: 10,
// // // // // // // // // //                             ),
// // // // // // // // // //                           ),
// // // // // // // // // //                         );
// // // // // // // // // //                       }

// // // // // // // // // //                       return const SizedBox();
// // // // // // // // // //                     },
// // // // // // // // // //                   ),
// // // // // // // // // //                 ),

// // // // // // // // // //                 topTitles: const AxisTitles(
// // // // // // // // // //                   sideTitles: SideTitles(
// // // // // // // // // //                     showTitles: false,
// // // // // // // // // //                   ),
// // // // // // // // // //                 ),

// // // // // // // // // //                 rightTitles: const AxisTitles(
// // // // // // // // // //                   sideTitles: SideTitles(
// // // // // // // // // //                     showTitles: false,
// // // // // // // // // //                   ),
// // // // // // // // // //                 ),
// // // // // // // // // //               ),

// // // // // // // // // //               lineBarsData: [

// // // // // // // // // //                 // =================================================
// // // // // // // // // //                 // ACTUAL SALES
// // // // // // // // // //                 // =================================================

// // // // // // // // // //                 LineChartBarData(

// // // // // // // // // //                   spots: actualSpots,

// // // // // // // // // //                   isCurved: true,

// // // // // // // // // //                   color: Colors.blue,

// // // // // // // // // //                   barWidth: 4,

// // // // // // // // // //                   isStrokeCapRound: true,

// // // // // // // // // //                   dotData: const FlDotData(
// // // // // // // // // //                     show: true,
// // // // // // // // // //                   ),

// // // // // // // // // //                   belowBarData: BarAreaData(

// // // // // // // // // //                     show: true,

// // // // // // // // // //                     gradient: LinearGradient(

// // // // // // // // // //                       colors: [

// // // // // // // // // //                         Colors.blue.withOpacity(0.25),

// // // // // // // // // //                         Colors.transparent,
// // // // // // // // // //                       ],

// // // // // // // // // //                       begin: Alignment.topCenter,

// // // // // // // // // //                       end: Alignment.bottomCenter,
// // // // // // // // // //                     ),
// // // // // // // // // //                   ),
// // // // // // // // // //                 ),

// // // // // // // // // //                 // =================================================
// // // // // // // // // //                 // FORECAST LINE
// // // // // // // // // //                 // =================================================

// // // // // // // // // //                 if (forecastSpots.isNotEmpty)

// // // // // // // // // //                   LineChartBarData(

// // // // // // // // // //                     spots: forecastSpots,

// // // // // // // // // //                     isCurved: true,

// // // // // // // // // //                     dashArray: [8, 4],

// // // // // // // // // //                     color: Colors.green,

// // // // // // // // // //                     barWidth: 4,

// // // // // // // // // //                     isStrokeCapRound: true,

// // // // // // // // // //                     dotData: const FlDotData(
// // // // // // // // // //                       show: true,
// // // // // // // // // //                     ),
// // // // // // // // // //                   ),
// // // // // // // // // //               ],
// // // // // // // // // //             ),
// // // // // // // // // //           ),
// // // // // // // // // //         ),

// // // // // // // // // //         const SizedBox(height: 16),

// // // // // // // // // //         Row(

// // // // // // // // // //           children: [

// // // // // // // // // //             _legend(
// // // // // // // // // //               Colors.blue,
// // // // // // // // // //               "Actual Sales",
// // // // // // // // // //             ),

// // // // // // // // // //             const SizedBox(width: 24),

// // // // // // // // // //             _legend(
// // // // // // // // // //               Colors.green,
// // // // // // // // // //               "AI Forecast",
// // // // // // // // // //             ),
// // // // // // // // // //           ],
// // // // // // // // // //         ),
// // // // // // // // // //       ],
// // // // // // // // // //     ),
// // // // // // // // // //   );
// // // // // // // // // // }
// // // // // // // // // Widget _salesChart() {
// // // // // // // // //   const int maxPoints = 12;

// // // // // // // // //   List<double> sales = List.from(historySales);
// // // // // // // // //   List<String> months = List.from(historyMonths);

// // // // // // // // //   if (sales.length > maxPoints) {
// // // // // // // // //     sales = sales.sublist(sales.length - maxPoints);
// // // // // // // // //     months = months.sublist(months.length - maxPoints);
// // // // // // // // //   }

// // // // // // // // //   if (sales.isEmpty) {
// // // // // // // // //     return const Center(child: Text("No data"));
// // // // // // // // //   }

// // // // // // // // //   // ================= ACTUAL SPOTS =================
// // // // // // // // //   List<FlSpot> actualSpots = [];

// // // // // // // // //   for (int i = 0; i < sales.length; i++) {
// // // // // // // // //     double v = sales[i];

// // // // // // // // //     if (v.isNaN || v.isInfinite) v = 0;

// // // // // // // // //     actualSpots.add(FlSpot(i.toDouble(), v));
// // // // // // // // //   }

// // // // // // // // //   // ================= SAFE PREDICTION =================
// // // // // // // // //   double safePrediction = predictedSales;

// // // // // // // // //   if (safePrediction.isNaN ||
// // // // // // // // //       safePrediction.isInfinite ||
// // // // // // // // //       safePrediction <= 0) {
// // // // // // // // //     safePrediction = sales.last;
// // // // // // // // //   }

// // // // // // // // //   final predictionSpot = FlSpot(
// // // // // // // // //     sales.length.toDouble(),
// // // // // // // // //     safePrediction,
// // // // // // // // //   );

// // // // // // // // //   List<FlSpot> forecastSpots = [
// // // // // // // // //     actualSpots.last,
// // // // // // // // //     predictionSpot,
// // // // // // // // //   ];

// // // // // // // // //   // ================= DYNAMIC MAX =================
// // // // // // // // //   double maxY = sales.reduce((a, b) => a > b ? a : b);

// // // // // // // // //   if (safePrediction > maxY) {
// // // // // // // // //     maxY = safePrediction;
// // // // // // // // //   }

// // // // // // // // //   if (maxY <= 0) maxY = 100;

// // // // // // // // // //double minY = 0;

// // // // // // // // //   double interval = maxY / 5;
// // // // // // // // //   if (interval.isNaN || interval.isInfinite || interval <= 0) {
// // // // // // // // //     interval = 20;
// // // // // // // // //   }

// // // // // // // // //   return Container(
// // // // // // // // //     height: 420,
// // // // // // // // //     padding: const EdgeInsets.all(20),
// // // // // // // // //     decoration: _box(),
// // // // // // // // //     child: Column(
// // // // // // // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // // //       children: [
// // // // // // // // //         const Text(
// // // // // // // // //           "Actual Sales vs Forecast",
// // // // // // // // //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// // // // // // // // //         ),

// // // // // // // // //         const SizedBox(height: 20),

// // // // // // // // //         Expanded(
// // // // // // // // //           child: LineChart(
// // // // // // // // //             LineChartData(
// // // // // // // // //               minY: 0,
// // // // // // // // //               maxY: maxY * 1.2, // 🔥 gives headroom for prediction

// // // // // // // // //               gridData: FlGridData(
// // // // // // // // //                 show: true,
// // // // // // // // //                 horizontalInterval: interval,
// // // // // // // // //               ),

// // // // // // // // //               borderData: FlBorderData(show: false),

// // // // // // // // //               titlesData: FlTitlesData(
// // // // // // // // //                 leftTitles: const AxisTitles(
// // // // // // // // //                   sideTitles: SideTitles(
// // // // // // // // //                     showTitles: true,
// // // // // // // // //                     reservedSize: 45,
// // // // // // // // //                   ),
// // // // // // // // //                 ),

// // // // // // // // //                 bottomTitles: AxisTitles(
// // // // // // // // //                   sideTitles: SideTitles(
// // // // // // // // //                     showTitles: true,
// // // // // // // // //                     interval: 2,
// // // // // // // // //                     getTitlesWidget: (value, meta) {
// // // // // // // // //                       int i = value.toInt();
// // // // // // // // //                       if (i >= 0 && i < months.length) {
// // // // // // // // //                         String m = months[i];
// // // // // // // // //                         if (m.contains("-")) {
// // // // // // // // //                           m = m.split("-")[1];
// // // // // // // // //                         }
// // // // // // // // //                         return Text(m.substring(0, 3),
// // // // // // // // //                             style: const TextStyle(fontSize: 10));
// // // // // // // // //                       }
// // // // // // // // //                       return const SizedBox();
// // // // // // // // //                     },
// // // // // // // // //                   ),
// // // // // // // // //                 ),

// // // // // // // // //                 topTitles: const AxisTitles(
// // // // // // // // //                   sideTitles: SideTitles(showTitles: false),
// // // // // // // // //                 ),

// // // // // // // // //                 rightTitles: const AxisTitles(
// // // // // // // // //                   sideTitles: SideTitles(showTitles: false),
// // // // // // // // //                 ),
// // // // // // // // //               ),

// // // // // // // // //               lineBarsData: [
// // // // // // // // //                 // ACTUAL
// // // // // // // // //                 LineChartBarData(
// // // // // // // // //                   spots: actualSpots,
// // // // // // // // //                   isCurved: true,
// // // // // // // // //                   color: Colors.blue,
// // // // // // // // //                   barWidth: 4,
// // // // // // // // //                   dotData: const FlDotData(show: false),
// // // // // // // // //                 ),

// // // // // // // // //                 // FORECAST
// // // // // // // // //                 LineChartBarData(
// // // // // // // // //                   spots: forecastSpots,
// // // // // // // // //                   isCurved: true,
// // // // // // // // //                   color: Colors.green,
// // // // // // // // //                   barWidth: 4,
// // // // // // // // //                   dashArray: [6, 4],
// // // // // // // // //                   dotData: const FlDotData(show: true),
// // // // // // // // //                 ),
// // // // // // // // //               ],
// // // // // // // // //             ),
// // // // // // // // //           ),
// // // // // // // // //         ),

// // // // // // // // //         const SizedBox(height: 12),

// // // // // // // // //         Row(
// // // // // // // // //           children: [
// // // // // // // // //             _legend(Colors.blue, "Actual Sales"),
// // // // // // // // //             const SizedBox(width: 20),
// // // // // // // // //             _legend(Colors.green, "Forecast"),
// // // // // // // // //           ],
// // // // // // // // //         ),
// // // // // // // // //       ],
// // // // // // // // //     ),
// // // // // // // // //   );
// // // // // // // // // }
// // // // // // // // //   // =========================================================
// // // // // // // // //   // KEEP ALL YOUR REMAINING METHODS SAME
// // // // // // // // //   // =========================================================
// // // // // // // // //   // =========================================================
// // // // // // // // // // UNITS BAR CHART
// // // // // // // // // // =========================================================
// // // // // // // // // Widget _unitsChart() {
// // // // // // // // //   const int maxPoints = 12;

// // // // // // // // //   // ================= LIMIT DATA =================
// // // // // // // // //   List<double> units = List.from(historyUnits);
// // // // // // // // //   List<String> months = List.from(historyMonths);

// // // // // // // // //   if (units.length > maxPoints) {
// // // // // // // // //     units = units.sublist(units.length - maxPoints);
// // // // // // // // //     months = months.sublist(months.length - maxPoints);
// // // // // // // // //   }

// // // // // // // // //   // ================= BUILD BARS =================
// // // // // // // // //   List<BarChartGroupData> bars = [];

// // // // // // // // //   double maxY = 0;

// // // // // // // // //   for (int i = 0; i < units.length; i++) {
// // // // // // // // //     double value = units[i];

// // // // // // // // //     if (value.isNaN || value.isInfinite) value = 0;

// // // // // // // // //     if (value > maxY) maxY = value;

// // // // // // // // //     bars.add(
// // // // // // // // //       BarChartGroupData(
// // // // // // // // //         x: i,
// // // // // // // // //         barRods: [
// // // // // // // // //           BarChartRodData(
// // // // // // // // //             toY: value,
// // // // // // // // //             width: 14, // 🔥 thinner bars = cleaner UI
// // // // // // // // //             borderRadius: BorderRadius.circular(6),
// // // // // // // // //             gradient: LinearGradient(
// // // // // // // // //               colors: [
// // // // // // // // //                 Colors.orange.shade300,
// // // // // // // // //                 Colors.deepOrange.shade400,
// // // // // // // // //               ],
// // // // // // // // //               begin: Alignment.bottomCenter,
// // // // // // // // //               end: Alignment.topCenter,
// // // // // // // // //             ),
// // // // // // // // //           ),
// // // // // // // // //         ],
// // // // // // // // //       ),
// // // // // // // // //     );
// // // // // // // // //   }

// // // // // // // // //   if (maxY <= 0) maxY = 100;

// // // // // // // // //   double interval = maxY / 5;
// // // // // // // // //   if (interval.isNaN || interval.isInfinite || interval <= 0) {
// // // // // // // // //     interval = 20;
// // // // // // // // //   }

// // // // // // // // //   return Container(
// // // // // // // // //     height: 420,
// // // // // // // // //     padding: const EdgeInsets.all(20),
// // // // // // // // //     decoration: _box(),
// // // // // // // // //     child: Column(
// // // // // // // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // // //       children: [
// // // // // // // // //         const Text(
// // // // // // // // //           "Units Sold History",
// // // // // // // // //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// // // // // // // // //         ),

// // // // // // // // //         const SizedBox(height: 10),

// // // // // // // // //         Text(
// // // // // // // // //           "Last 12 months trend (clean view)",
// // // // // // // // //           style: TextStyle(color: Colors.grey.shade600),
// // // // // // // // //         ),

// // // // // // // // //         const SizedBox(height: 20),
// // // // // // // // // _dropdown(
// // // // // // // // //   "Product",
// // // // // // // // //   products,
// // // // // // // // //   selectedProduct,
// // // // // // // // //   (v) async {
// // // // // // // // //     setState(() {
// // // // // // // // //       selectedProduct = v;
// // // // // // // // //     });
    
// // // // // // // // //     // Fetch price when product is selected
// // // // // // // // //     if (v != null && selectedCategory != null) {
// // // // // // // // //       final price = await fetchProductPrice(v, selectedCategory!);
// // // // // // // // //       priceController.text = price.toStringAsFixed(0);
// // // // // // // // //     }
// // // // // // // // //   },
// // // // // // // // // ),

// // // // // // // // //         Expanded(
// // // // // // // // //           child: BarChart(
// // // // // // // // //             BarChartData(
// // // // // // // // //               minY: 0,
// // // // // // // // //               maxY: maxY * 1.2,
// // // // // // // // //               borderData: FlBorderData(show: false),

// // // // // // // // //               gridData: FlGridData(
// // // // // // // // //                 show: true,
// // // // // // // // //                 horizontalInterval: interval,
// // // // // // // // //               ),

// // // // // // // // //               titlesData: FlTitlesData(
// // // // // // // // //                 leftTitles: const AxisTitles(
// // // // // // // // //                   sideTitles: SideTitles(
// // // // // // // // //                     showTitles: true,
// // // // // // // // //                     reservedSize: 35,
// // // // // // // // //                   ),
// // // // // // // // //                 ),

// // // // // // // // //                 bottomTitles: AxisTitles(
// // // // // // // // //                   sideTitles: SideTitles(
// // // // // // // // //                     showTitles: true,
// // // // // // // // //                     interval: 2, // 🔥 SHOW EVERY 2ND LABEL ONLY
// // // // // // // // //                     getTitlesWidget: (value, meta) {
// // // // // // // // //                       int index = value.toInt();

// // // // // // // // //                       if (index >= 0 && index < months.length) {
// // // // // // // // //                         String label = months[index];

// // // // // // // // //                         if (label.contains("-")) {
// // // // // // // // //                           label = label.split("-")[1];
// // // // // // // // //                         }

// // // // // // // // //                         // 🔥 SHORT MONTH NAME
// // // // // // // // //                         label = label.substring(0, 3);

// // // // // // // // //                         return Padding(
// // // // // // // // //                           padding: const EdgeInsets.only(top: 8),
// // // // // // // // //                           child: Text(
// // // // // // // // //                             label,
// // // // // // // // //                             style: const TextStyle(fontSize: 10),
// // // // // // // // //                           ),
// // // // // // // // //                         );
// // // // // // // // //                       }

// // // // // // // // //                       return const SizedBox();
// // // // // // // // //                     },
// // // // // // // // //                   ),
// // // // // // // // //                 ),

// // // // // // // // //                 topTitles: const AxisTitles(
// // // // // // // // //                   sideTitles: SideTitles(showTitles: false),
// // // // // // // // //                 ),

// // // // // // // // //                 rightTitles: const AxisTitles(
// // // // // // // // //                   sideTitles: SideTitles(showTitles: false),
// // // // // // // // //                 ),
// // // // // // // // //               ),

// // // // // // // // //               barGroups: bars,
// // // // // // // // //             ),
// // // // // // // // //           ),
// // // // // // // // //         ),
// // // // // // // // //       ],
// // // // // // // // //     ),
// // // // // // // // //   );
// // // // // // // // // }
// // // // // // // // // // Widget _unitsChart() {

// // // // // // // // // //   List<BarChartGroupData> bars = [];

// // // // // // // // // //   double maxY = 0;

// // // // // // // // // //   for (int i = 0;
// // // // // // // // // //   i < historyUnits.length;
// // // // // // // // // //   i++) {

// // // // // // // // // //     if (historyUnits[i] > maxY) {
// // // // // // // // // //       maxY = historyUnits[i];
// // // // // // // // // //     }

// // // // // // // // // //     bars.add(

// // // // // // // // // //       BarChartGroupData(

// // // // // // // // // //         x: i,

// // // // // // // // // //         barRods: [

// // // // // // // // // //           BarChartRodData(

// // // // // // // // // //             toY: historyUnits[i],

// // // // // // // // // //             width: 18,

// // // // // // // // // //             borderRadius:
// // // // // // // // // //             BorderRadius.circular(8),

// // // // // // // // // //             gradient: LinearGradient(

// // // // // // // // // //               colors: [

// // // // // // // // // //                 Colors.orange.shade400,

// // // // // // // // // //                 Colors.deepOrange.shade400,
// // // // // // // // // //               ],

// // // // // // // // // //               begin: Alignment.bottomCenter,

// // // // // // // // // //               end: Alignment.topCenter,
// // // // // // // // // //             ),
// // // // // // // // // //           ),
// // // // // // // // // //         ],
// // // // // // // // // //       ),
// // // // // // // // // //     );
// // // // // // // // // //   }

// // // // // // // // // //   return Container(

// // // // // // // // // //     height: 420,

// // // // // // // // // //     padding: const EdgeInsets.all(20),

// // // // // // // // // //     decoration: _box(),

// // // // // // // // // //     child: Column(

// // // // // // // // // //       crossAxisAlignment:
// // // // // // // // // //       CrossAxisAlignment.start,

// // // // // // // // // //       children: [

// // // // // // // // // //         const Text(

// // // // // // // // // //           "Units Sold History",

// // // // // // // // // //           style: TextStyle(

// // // // // // // // // //             fontSize: 20,

// // // // // // // // // //             fontWeight: FontWeight.bold,
// // // // // // // // // //           ),
// // // // // // // // // //         ),

// // // // // // // // // //         const SizedBox(height: 10),

// // // // // // // // // //         Text(

// // // // // // // // // //           "Historical unit demand trends for selected product.",

// // // // // // // // // //           style: TextStyle(
// // // // // // // // // //             color: Colors.grey.shade600,
// // // // // // // // // //           ),
// // // // // // // // // //         ),

// // // // // // // // // //         const SizedBox(height: 20),

// // // // // // // // // //         Expanded(

// // // // // // // // // //           child: BarChart(

// // // // // // // // // //             BarChartData(

// // // // // // // // // //               minY: 0,

// // // // // // // // // //               maxY: maxY * 1.3,

// // // // // // // // // //               borderData:
// // // // // // // // // //               FlBorderData(show: false),

// // // // // // // // // //               gridData:
// // // // // // // // // //               const FlGridData(show: true),

// // // // // // // // // //               titlesData: FlTitlesData(

// // // // // // // // // //                 leftTitles: AxisTitles(
// // // // // // // // // //                   sideTitles: SideTitles(
// // // // // // // // // //                     showTitles: true,
// // // // // // // // // //                     reservedSize: 35,
// // // // // // // // // //                   ),
// // // // // // // // // //                 ),

// // // // // // // // // //                 bottomTitles: AxisTitles(

// // // // // // // // // //                   sideTitles: SideTitles(

// // // // // // // // // //                     showTitles: true,

// // // // // // // // // //                     interval: 1,

// // // // // // // // // //                     getTitlesWidget:
// // // // // // // // // //                         (value, meta) {

// // // // // // // // // //                       int index =
// // // // // // // // // //                       value.toInt();

// // // // // // // // // //                       if (index >= 0 &&
// // // // // // // // // //                           index <
// // // // // // // // // //                               historyMonths.length) {

// // // // // // // // // //                         return Padding(

// // // // // // // // // //                           padding:
// // // // // // // // // //                           const EdgeInsets.only(
// // // // // // // // // //                             top: 8,
// // // // // // // // // //                           ),

// // // // // // // // // //                           child: RotatedBox(

// // // // // // // // // //                             quarterTurns: 1,

// // // // // // // // // //                             child: Text(

// // // // // // // // // //                               historyMonths[index],

// // // // // // // // // //                               style: const TextStyle(
// // // // // // // // // //                                 fontSize: 10,
// // // // // // // // // //                               ),
// // // // // // // // // //                             ),
// // // // // // // // // //                           ),
// // // // // // // // // //                         );
// // // // // // // // // //                       }

// // // // // // // // // //                       return const SizedBox();
// // // // // // // // // //                     },
// // // // // // // // // //                   ),
// // // // // // // // // //                 ),

// // // // // // // // // //                 topTitles: const AxisTitles(
// // // // // // // // // //                   sideTitles:
// // // // // // // // // //                   SideTitles(showTitles: false),
// // // // // // // // // //                 ),

// // // // // // // // // //                 rightTitles: const AxisTitles(
// // // // // // // // // //                   sideTitles:
// // // // // // // // // //                   SideTitles(showTitles: false),
// // // // // // // // // //                 ),
// // // // // // // // // //               ),

// // // // // // // // // //               barGroups: bars,
// // // // // // // // // //             ),
// // // // // // // // // //           ),
// // // // // // // // // //         ),
// // // // // // // // // //       ],
// // // // // // // // // //     ),
// // // // // // // // // //   );
// // // // // // // // // // }

// // // // // // // // // // =========================================================
// // // // // // // // // // COMPARISON
// // // // // // // // // // =========================================================

// // // // // // // // // Widget _comparisonSection() {

// // // // // // // // //   double lastActual =
// // // // // // // // //   historySales.isNotEmpty
// // // // // // // // //       ? historySales.last
// // // // // // // // //       : 0;

// // // // // // // // //   double change =
// // // // // // // // //       predictedSales - lastActual;

// // // // // // // // //   double percent =
// // // // // // // // //   lastActual == 0
// // // // // // // // //       ? 0
// // // // // // // // //       : (change / lastActual) * 100;

// // // // // // // // //   bool growth = change >= 0;

// // // // // // // // //   return Container(

// // // // // // // // //     width: double.infinity,

// // // // // // // // //     padding: const EdgeInsets.all(24),

// // // // // // // // //     decoration: _box(),

// // // // // // // // //     child: Column(

// // // // // // // // //       crossAxisAlignment:
// // // // // // // // //       CrossAxisAlignment.start,

// // // // // // // // //       children: [

// // // // // // // // //         const Text(

// // // // // // // // //           "Actual vs Predicted Analysis",

// // // // // // // // //           style: TextStyle(

// // // // // // // // //             fontSize: 22,

// // // // // // // // //             fontWeight: FontWeight.bold,
// // // // // // // // //           ),
// // // // // // // // //         ),

// // // // // // // // //         const SizedBox(height: 24),

// // // // // // // // //         Row(

// // // // // // // // //           children: [

// // // // // // // // //             Expanded(
// // // // // // // // //               child: _comparisonTile(
// // // // // // // // //                 "Last Actual",
// // // // // // // // //                 "Rs ${lastActual.toStringAsFixed(0)}",
// // // // // // // // //                 Colors.blue,
// // // // // // // // //               ),
// // // // // // // // //             ),

// // // // // // // // //             const SizedBox(width: 14),

// // // // // // // // //             Expanded(
// // // // // // // // //               child: _comparisonTile(
// // // // // // // // //                 "Forecast",
// // // // // // // // //                 "Rs ${predictedSales.toStringAsFixed(0)}",
// // // // // // // // //                 Colors.green,
// // // // // // // // //               ),
// // // // // // // // //             ),

// // // // // // // // //             const SizedBox(width: 14),

// // // // // // // // //             Expanded(
// // // // // // // // //               child: _comparisonTile(
// // // // // // // // //                 "Growth",
// // // // // // // // //                 "${percent.toStringAsFixed(1)}%",
// // // // // // // // //                 growth
// // // // // // // // //                     ? Colors.green
// // // // // // // // //                     : Colors.red,
// // // // // // // // //               ),
// // // // // // // // //             ),
// // // // // // // // //           ],
// // // // // // // // //         ),
// // // // // // // // //       ],
// // // // // // // // //     ),
// // // // // // // // //   );
// // // // // // // // // }

// // // // // // // // // // =========================================================
// // // // // // // // // // INSIGHT CARD
// // // // // // // // // // =========================================================

// // // // // // // // // Widget _insightCard() {

// // // // // // // // //   double lastActual =
// // // // // // // // //   historySales.isNotEmpty
// // // // // // // // //       ? historySales.last
// // // // // // // // //       : 0;

// // // // // // // // //   double change =
// // // // // // // // //       predictedSales - lastActual;

// // // // // // // // //   double percent =
// // // // // // // // //   lastActual == 0
// // // // // // // // //       ? 0
// // // // // // // // //       : (change / lastActual) * 100;

// // // // // // // // //   bool growth = change >= 0;

// // // // // // // // //   return Container(

// // // // // // // // //     width: double.infinity,

// // // // // // // // //     padding: const EdgeInsets.all(22),

// // // // // // // // //     decoration: BoxDecoration(

// // // // // // // // //       color: growth
// // // // // // // // //           ? Colors.green.shade50
// // // // // // // // //           : Colors.red.shade50,

// // // // // // // // //       borderRadius:
// // // // // // // // //       BorderRadius.circular(22),
// // // // // // // // //     ),

// // // // // // // // //     child: Row(

// // // // // // // // //       children: [

// // // // // // // // //         Container(

// // // // // // // // //           padding: const EdgeInsets.all(14),

// // // // // // // // //           decoration: BoxDecoration(

// // // // // // // // //             color:
// // // // // // // // //             growth
// // // // // // // // //                 ? Colors.green.shade100
// // // // // // // // //                 : Colors.red.shade100,

// // // // // // // // //             shape: BoxShape.circle,
// // // // // // // // //           ),

// // // // // // // // //           child: Icon(

// // // // // // // // //             growth
// // // // // // // // //                 ? Icons.trending_up
// // // // // // // // //                 : Icons.trending_down,

// // // // // // // // //             color:
// // // // // // // // //             growth
// // // // // // // // //                 ? Colors.green
// // // // // // // // //                 : Colors.red,
// // // // // // // // //           ),
// // // // // // // // //         ),

// // // // // // // // //         const SizedBox(width: 18),

// // // // // // // // //         Expanded(

// // // // // // // // //           child: Column(

// // // // // // // // //             crossAxisAlignment:
// // // // // // // // //             CrossAxisAlignment.start,

// // // // // // // // //             children: [

// // // // // // // // //               Text(

// // // // // // // // //                 growth
// // // // // // // // //                     ? "Positive Sales Forecast"
// // // // // // // // //                     : "Sales Decline Risk",

// // // // // // // // //                 style: TextStyle(

// // // // // // // // //                   fontSize: 18,

// // // // // // // // //                   fontWeight: FontWeight.bold,

// // // // // // // // //                   color:
// // // // // // // // //                   growth
// // // // // // // // //                       ? Colors.green
// // // // // // // // //                       : Colors.red,
// // // // // // // // //                 ),
// // // // // // // // //               ),

// // // // // // // // //               const SizedBox(height: 8),

// // // // // // // // //               Text(

// // // // // // // // //                 growth

// // // // // // // // //                     ? "AI predicts approximately ${percent.toStringAsFixed(1)}% growth compared to the latest actual sales performance."

// // // // // // // // //                     : "AI predicts approximately ${percent.abs().toStringAsFixed(1)}% decline compared to historical sales performance.",
// // // // // // // // //               ),
// // // // // // // // //             ],
// // // // // // // // //           ),
// // // // // // // // //         ),
// // // // // // // // //       ],
// // // // // // // // //     ),
// // // // // // // // //   );
// // // // // // // // // }

// // // // // // // // // // =========================================================
// // // // // // // // // // ANALYTICS CARD
// // // // // // // // // // =========================================================

// // // // // // // // // Widget _analyticsCard(
// // // // // // // // //     String title,
// // // // // // // // //     String value,
// // // // // // // // //     IconData icon,
// // // // // // // // //     Color color,
// // // // // // // // //     ) {

// // // // // // // // //   return Container(

// // // // // // // // //     padding: const EdgeInsets.all(18),

// // // // // // // // //     decoration: _box(),

// // // // // // // // //     child: Column(

// // // // // // // // //       crossAxisAlignment:
// // // // // // // // //       CrossAxisAlignment.start,

// // // // // // // // //       children: [

// // // // // // // // //         Container(

// // // // // // // // //           padding: const EdgeInsets.all(10),

// // // // // // // // //           decoration: BoxDecoration(

// // // // // // // // //             color: color.withOpacity(0.1),

// // // // // // // // //             borderRadius:
// // // // // // // // //             BorderRadius.circular(14),
// // // // // // // // //           ),

// // // // // // // // //           child: Icon(
// // // // // // // // //             icon,
// // // // // // // // //             color: color,
// // // // // // // // //           ),
// // // // // // // // //         ),

// // // // // // // // //         const SizedBox(height: 18),

// // // // // // // // //         Text(
// // // // // // // // //           title,
// // // // // // // // //           style: TextStyle(
// // // // // // // // //             color: Colors.grey.shade700,
// // // // // // // // //           ),
// // // // // // // // //         ),

// // // // // // // // //         const SizedBox(height: 8),

// // // // // // // // //         Text(

// // // // // // // // //           value,

// // // // // // // // //           style: const TextStyle(

// // // // // // // // //             fontSize: 22,

// // // // // // // // //             fontWeight: FontWeight.bold,
// // // // // // // // //           ),
// // // // // // // // //         ),
// // // // // // // // //       ],
// // // // // // // // //     ),
// // // // // // // // //   );
// // // // // // // // // }

// // // // // // // // // // =========================================================
// // // // // // // // // // HEADER STATS
// // // // // // // // // // =========================================================

// // // // // // // // // Widget _topStat(
// // // // // // // // //     String title,
// // // // // // // // //     String value,
// // // // // // // // //     IconData icon,
// // // // // // // // //     ) {

// // // // // // // // //   return Container(

// // // // // // // // //     padding: const EdgeInsets.all(16),

// // // // // // // // //     decoration: BoxDecoration(

// // // // // // // // //       color: Colors.white.withOpacity(0.15),

// // // // // // // // //       borderRadius:
// // // // // // // // //       BorderRadius.circular(18),
// // // // // // // // //     ),

// // // // // // // // //     child: Column(

// // // // // // // // //       children: [

// // // // // // // // //         Icon(
// // // // // // // // //           icon,
// // // // // // // // //           color: Colors.white,
// // // // // // // // //         ),

// // // // // // // // //         const SizedBox(height: 10),

// // // // // // // // //         Text(

// // // // // // // // //           value,

// // // // // // // // //           style: const TextStyle(

// // // // // // // // //             color: Colors.white,

// // // // // // // // //             fontSize: 20,

// // // // // // // // //             fontWeight: FontWeight.bold,
// // // // // // // // //           ),
// // // // // // // // //         ),

// // // // // // // // //         const SizedBox(height: 4),

// // // // // // // // //         Text(

// // // // // // // // //           title,

// // // // // // // // //           textAlign: TextAlign.center,

// // // // // // // // //           style: TextStyle(

// // // // // // // // //             color: Colors.white.withOpacity(
// // // // // // // // //               0.9,
// // // // // // // // //             ),
// // // // // // // // //           ),
// // // // // // // // //         ),
// // // // // // // // //       ],
// // // // // // // // //     ),
// // // // // // // // //   );
// // // // // // // // // }

// // // // // // // // // // =========================================================
// // // // // // // // // // COMPARISON TILE
// // // // // // // // // // =========================================================

// // // // // // // // // Widget _comparisonTile(
// // // // // // // // //     String title,
// // // // // // // // //     String value,
// // // // // // // // //     Color color,
// // // // // // // // //     ) {

// // // // // // // // //   return Container(

// // // // // // // // //     padding: const EdgeInsets.all(18),

// // // // // // // // //     decoration: BoxDecoration(

// // // // // // // // //       color: color.withOpacity(0.08),

// // // // // // // // //       borderRadius:
// // // // // // // // //       BorderRadius.circular(18),
// // // // // // // // //     ),

// // // // // // // // //     child: Column(

// // // // // // // // //       children: [

// // // // // // // // //         Text(

// // // // // // // // //           title,

// // // // // // // // //           style: TextStyle(
// // // // // // // // //             color: color,
// // // // // // // // //             fontWeight: FontWeight.bold,
// // // // // // // // //           ),
// // // // // // // // //         ),

// // // // // // // // //         const SizedBox(height: 10),

// // // // // // // // //         Text(

// // // // // // // // //           value,

// // // // // // // // //           style: const TextStyle(

// // // // // // // // //             fontSize: 20,

// // // // // // // // //             fontWeight: FontWeight.bold,
// // // // // // // // //           ),
// // // // // // // // //         ),
// // // // // // // // //       ],
// // // // // // // // //     ),
// // // // // // // // //   );
// // // // // // // // // }

// // // // // // // // // // =========================================================
// // // // // // // // // // LEGEND
// // // // // // // // // // =========================================================

// // // // // // // // // Widget _legend(
// // // // // // // // //     Color color,
// // // // // // // // //     String text,
// // // // // // // // //     ) {

// // // // // // // // //   return Row(

// // // // // // // // //     children: [

// // // // // // // // //       Container(

// // // // // // // // //         width: 14,
// // // // // // // // //         height: 14,

// // // // // // // // //         decoration: BoxDecoration(
// // // // // // // // //           color: color,
// // // // // // // // //           shape: BoxShape.circle,
// // // // // // // // //         ),
// // // // // // // // //       ),

// // // // // // // // //       const SizedBox(width: 8),

// // // // // // // // //       Text(text),
// // // // // // // // //     ],
// // // // // // // // //   );
// // // // // // // // // }

// // // // // // // // // // =========================================================
// // // // // // // // // // DROPDOWN
// // // // // // // // // // =========================================================

// // // // // // // // // Widget _dropdown(
// // // // // // // // //     String label,
// // // // // // // // //     List<String> items,
// // // // // // // // //     String? value,
// // // // // // // // //     Function(String?) onChanged,
// // // // // // // // //     ) {

// // // // // // // // //   return Padding(

// // // // // // // // //     padding: const EdgeInsets.only(
// // // // // // // // //       bottom: 14,
// // // // // // // // //     ),

// // // // // // // // //     child: DropdownButtonFormField<String>(

// // // // // // // // //       value:
// // // // // // // // //       items.contains(value)
// // // // // // // // //           ? value
// // // // // // // // //           : null,

// // // // // // // // //       items: items.map((e) {

// // // // // // // // //         return DropdownMenuItem(
// // // // // // // // //           value: e,
// // // // // // // // //           child: Text(e),
// // // // // // // // //         );

// // // // // // // // //       }).toList(),

// // // // // // // // //       onChanged: onChanged,

// // // // // // // // //       decoration: InputDecoration(

// // // // // // // // //         labelText: label,

// // // // // // // // //         filled: true,

// // // // // // // // //         fillColor: Colors.grey.shade100,

// // // // // // // // //         border: OutlineInputBorder(

// // // // // // // // //           borderRadius:
// // // // // // // // //           BorderRadius.circular(16),

// // // // // // // // //           borderSide: BorderSide.none,
// // // // // // // // //         ),
// // // // // // // // //       ),
// // // // // // // // //     ),
// // // // // // // // //   );
// // // // // // // // // }

// // // // // // // // // // =========================================================
// // // // // // // // // // CONTROL CARD
// // // // // // // // // // =========================================================

// // // // // // // // // Widget _controlCard() {

// // // // // // // // //   return Container(

// // // // // // // // //     padding: const EdgeInsets.all(22),

// // // // // // // // //     decoration: _box(),

// // // // // // // // //     child: Column(

// // // // // // // // //       children: [

// // // // // // // // //         _dropdown(
// // // // // // // // //           "Category",
// // // // // // // // //           categories,
// // // // // // // // //           selectedCategory,
// // // // // // // // //               (v) async {

// // // // // // // // //             setState(() {

// // // // // // // // //               selectedCategory = v;

// // // // // // // // //               selectedProduct = null;

// // // // // // // // //               products = [];
// // // // // // // // //             });

// // // // // // // // //             if (v != null) {
// // // // // // // // //               await loadProducts(v);
// // // // // // // // //             }
// // // // // // // // //           },
// // // // // // // // //         ),

// // // // // // // // //         _dropdown(
// // // // // // // // //           "Product",
// // // // // // // // //           products,
// // // // // // // // //           selectedProduct,
// // // // // // // // //               (v) {

// // // // // // // // //             setState(() {
// // // // // // // // //               selectedProduct = v;
// // // // // // // // //             });
// // // // // // // // //           },
// // // // // // // // //         ),

// // // // // // // // //         _dropdown(
// // // // // // // // //           "Forecast Month",
// // // // // // // // //           months,
// // // // // // // // //           selectedMonth,
// // // // // // // // //               (v) {

// // // // // // // // //             setState(() {
// // // // // // // // //               selectedMonth = v;
// // // // // // // // //             });
// // // // // // // // //           },
// // // // // // // // //         ),

// // // // // // // // //         const SizedBox(height: 12),

// // // // // // // // //         TextField(

// // // // // // // // //           controller: priceController,

// // // // // // // // //           keyboardType: TextInputType.number,

// // // // // // // // //           decoration: InputDecoration(

// // // // // // // // //             labelText: "Price Per Unittttt",

// // // // // // // // //             prefixIcon:
// // // // // // // // //             const Icon(Icons.currency_rupee),

// // // // // // // // //             filled: true,

// // // // // // // // //             fillColor: Colors.grey.shade100,

// // // // // // // // //             border: OutlineInputBorder(

// // // // // // // // //               borderRadius:
// // // // // // // // //               BorderRadius.circular(16),

// // // // // // // // //               borderSide: BorderSide.none,
// // // // // // // // //             ),
// // // // // // // // //           ),
// // // // // // // // //         ),

// // // // // // // // //         const SizedBox(height: 22),

// // // // // // // // //         SizedBox(

// // // // // // // // //           width: double.infinity,

// // // // // // // // //           height: 54,

// // // // // // // // //           child: ElevatedButton(

// // // // // // // // //             onPressed:
// // // // // // // // //             loading
// // // // // // // // //                 ? null
// // // // // // // // //                 : predict,

// // // // // // // // //             style: ElevatedButton.styleFrom(

// // // // // // // // //               backgroundColor:
// // // // // // // // //               Colors.blue.shade700,

// // // // // // // // //               shape: RoundedRectangleBorder(

// // // // // // // // //                 borderRadius:
// // // // // // // // //                 BorderRadius.circular(16),
// // // // // // // // //               ),
// // // // // // // // //             ),

// // // // // // // // //             child: loading

// // // // // // // // //                 ? const CircularProgressIndicator(
// // // // // // // // //               color: Colors.white,
// // // // // // // // //             )

// // // // // // // // //                 : const Text(

// // // // // // // // //               "RUN AI FORECAST",

// // // // // // // // //               style: TextStyle(

// // // // // // // // //                 fontSize: 16,

// // // // // // // // //                 fontWeight:
// // // // // // // // //                 FontWeight.bold,
// // // // // // // // //               ),
// // // // // // // // //             ),
// // // // // // // // //           ),
// // // // // // // // //         ),
// // // // // // // // //       ],
// // // // // // // // //     ),
// // // // // // // // //   );
// // // // // // // // // }

// // // // // // // // // // =========================================================
// // // // // // // // // // COMMON BOX
// // // // // // // // // // =========================================================

// // // // // // // // // BoxDecoration _box() {

// // // // // // // // //   return BoxDecoration(

// // // // // // // // //     color: Colors.white,

// // // // // // // // //     borderRadius:
// // // // // // // // //     BorderRadius.circular(24),

// // // // // // // // //     boxShadow: [

// // // // // // // // //       BoxShadow(

// // // // // // // // //         color: Colors.black.withOpacity(
// // // // // // // // //           0.04,
// // // // // // // // //         ),

// // // // // // // // //         blurRadius: 10,

// // // // // // // // //         offset: const Offset(0, 4),
// // // // // // // // //       ),
// // // // // // // // //     ],
// // // // // // // // //   );
// // // // // // // // // }}
// // // // // // // // import 'dart:convert';
// // // // // // // // import 'package:fl_chart/fl_chart.dart';
// // // // // // // // import 'package:flutter/material.dart';
// // // // // // // // import 'package:http/http.dart' as http;
// // // // // // // // import 'package:cloud_firestore/cloud_firestore.dart';

// // // // // // // // class PredictionPage extends StatefulWidget {
// // // // // // // //   const PredictionPage({super.key});

// // // // // // // //   @override
// // // // // // // //   State<PredictionPage> createState() => _PredictionPageState();
// // // // // // // // }

// // // // // // // // class _PredictionPageState extends State<PredictionPage> {

// // // // // // // //   // =========================================================
// // // // // // // //   // DATA
// // // // // // // //   // =========================================================

// // // // // // // //   List<double> historySales = [];
// // // // // // // //   List<double> historyUnits = [];
// // // // // // // //   List<String> historyMonths = [];

// // // // // // // //   List<String> categories = [];
// // // // // // // //   List<String> products = [];
// // // // // // // //   List<String> months = [];

// // // // // // // //   String? selectedCategory;
// // // // // // // //   String? selectedProduct;
// // // // // // // //   String? selectedMonth;

// // // // // // // //   bool loading = false;

// // // // // // // //   // =========================================================
// // // // // // // //   // ML RESULTS
// // // // // // // //   // =========================================================

// // // // // // // //   double predictedSales = 0;
// // // // // // // //   double predictedUnits = 0;
// // // // // // // //   double latestUnits = 0;
// // // // // // // //   double rollingAvg = 0;
// // // // // // // //   double accuracy = 0;

// // // // // // // //   final TextEditingController priceController = TextEditingController(text: "500");

// // // // // // // //   final String baseUrl = "http://192.168.100.218:5000";
// // // // // // // //   final FirebaseFirestore firestore = FirebaseFirestore.instance;

// // // // // // // //   // =========================================================
// // // // // // // //   // INIT
// // // // // // // //   // =========================================================

// // // // // // // //   @override
// // // // // // // //   void initState() {
// // // // // // // //     super.initState();
// // // // // // // //     initialize();
// // // // // // // //   }

// // // // // // // //   Future<void> initialize() async {
// // // // // // // //     await loadCategories();
// // // // // // // //     await loadMonths();
// // // // // // // //   }

// // // // // // // //   // =========================================================
// // // // // // // //   // FETCH PRODUCT PRICE FROM FIRESTORE
// // // // // // // //   // =========================================================
// // // // // // // //   Future<double> fetchProductPrice(String product, String category) async {
// // // // // // // //     try {
// // // // // // // //       final snapshot = await firestore
// // // // // // // //           .collection("inventory")
// // // // // // // //           .where("product", isEqualTo: product)
// // // // // // // //           .where("category", isEqualTo: category)
// // // // // // // //           .get();
      
// // // // // // // //       if (snapshot.docs.isNotEmpty) {
// // // // // // // //         final data = snapshot.docs.first.data();
// // // // // // // //         final price = (data["price"] ?? 500).toDouble();
// // // // // // // //         return price;
// // // // // // // //       }
// // // // // // // //       return 500;
// // // // // // // //     } catch (e) {
// // // // // // // //       debugPrint("Error fetching price: $e");
// // // // // // // //       return 500;
// // // // // // // //     }
// // // // // // // //   }

// // // // // // // //   // =========================================================
// // // // // // // //   // FETCH LIST
// // // // // // // //   // =========================================================

// // // // // // // //   Future<List<String>> fetchList(String endpoint, String key) async {
// // // // // // // //     try {
// // // // // // // //       final res = await http.get(Uri.parse("$baseUrl/$endpoint"));
// // // // // // // //       final data = jsonDecode(res.body);
// // // // // // // //       return List<String>.from(data[key] ?? []);
// // // // // // // //     } catch (_) {
// // // // // // // //       return [];
// // // // // // // //     }
// // // // // // // //   }

// // // // // // // //   Future<void> loadCategories() async {
// // // // // // // //     categories = await fetchList("categories", "categories");

// // // // // // // //     setState(() {
// // // // // // // //       selectedCategory = categories.isNotEmpty ? categories.first : null;
// // // // // // // //       selectedProduct = null;
// // // // // // // //       products = [];
// // // // // // // //     });

// // // // // // // //     if (selectedCategory != null) {
// // // // // // // //       await loadProducts(selectedCategory!);
// // // // // // // //     }
// // // // // // // //   }

// // // // // // // //   // Future<void> loadProducts(String category) async {
// // // // // // // //   //   try {
// // // // // // // //   //     final res = await http.get(
// // // // // // // //   //       Uri.parse("$baseUrl/products?category=$category"),
// // // // // // // //   //     );

// // // // // // // //   //     final data = jsonDecode(res.body);

// // // // // // // //   //     setState(() {
// // // // // // // //   //       products = List<String>.from(data["products"] ?? []);
// // // // // // // //   //       selectedProduct = products.isNotEmpty ? products.first : null;
// // // // // // // //   //     });
      
// // // // // // // //   //     // Fetch price for the first product
// // // // // // // //   //     if (selectedProduct != null && selectedCategory != null) {
// // // // // // // //   //       final price = await fetchProductPrice(selectedProduct!, selectedCategory!);
// // // // // // // //   //       priceController.text = price.toStringAsFixed(0);
// // // // // // // //   //     }
// // // // // // // //   //   } catch (_) {
// // // // // // // //   //     setState(() {
// // // // // // // //   //       products = [];
// // // // // // // //   //       selectedProduct = null;
// // // // // // // //   //     });
// // // // // // // //   //   }
// // // // // // // //   // }

// // // // // // // // Future<void> loadProducts(String category) async {
// // // // // // // //   try {
// // // // // // // //     final response = await http.get(
// // // // // // // //       Uri.parse("$baseUrl/products?category=$category"),
// // // // // // // //     );

// // // // // // // //     final data = jsonDecode(response.body);

// // // // // // // //     List<dynamic> productData =
// // // // // // // //         data["products_with_prices"] ?? [];

// // // // // // // //     List<String> loadedProducts = productData
// // // // // // // //         .map((e) => e["name"].toString())
// // // // // // // //         .toList();

// // // // // // // //     setState(() {
// // // // // // // //       products = loadedProducts;

// // // // // // // //       if (loadedProducts.isNotEmpty) {
// // // // // // // //         selectedProduct = loadedProducts.first;

// // // // // // // //         double firstPrice =
// // // // // // // //             (productData.first["price"] ?? 500)
// // // // // // // //                 .toDouble();

// // // // // // // //         priceController.text =
// // // // // // // //             firstPrice.toStringAsFixed(0);
// // // // // // // //       } else {
// // // // // // // //         selectedProduct = null;
// // // // // // // //       }
// // // // // // // //     });

// // // // // // // //     debugPrint(
// // // // // // // //       "✅ Loaded ${products.length} products",
// // // // // // // //     );
// // // // // // // //   } catch (e) {
// // // // // // // //     debugPrint("❌ loadProducts error: $e");

// // // // // // // //     setState(() {
// // // // // // // //       products = [];
// // // // // // // //       selectedProduct = null;
// // // // // // // //     });
// // // // // // // //   }
// // // // // // // // }



// // // // // // // //   Future<void> loadMonths() async {
// // // // // // // //     months = await fetchList("months", "months");

// // // // // // // //     setState(() {
// // // // // // // //       selectedMonth = months.isNotEmpty ? months.last : null;
// // // // // // // //     });
// // // // // // // //   }

// // // // // // // //   int getMonthIndex(String month) {
// // // // // // // //     const monthOrder = [
// // // // // // // //       "jan","feb","mar","apr","may","jun",
// // // // // // // //       "jul","aug","sep","oct","nov","dec",
// // // // // // // //     ];

// // // // // // // //     String shortMonth = month.toLowerCase().substring(0, 3);
// // // // // // // //     return monthOrder.indexOf(shortMonth);
// // // // // // // //   }

// // // // // // // //   // =========================================================
// // // // // // // //   // PREDICT + FIRESTORE SAVE
// // // // // // // //   // =========================================================
// // // // // // // //   Future<void> predict() async {
// // // // // // // //     if (selectedCategory == null || selectedProduct == null || selectedMonth == null) {
// // // // // // // //       return;
// // // // // // // //     }

// // // // // // // //     setState(() => loading = true);

// // // // // // // //     try {
// // // // // // // //       final res = await http.post(
// // // // // // // //         Uri.parse("$baseUrl/predict"),
// // // // // // // //         headers: {"Content-Type": "application/json"},
// // // // // // // //         body: jsonEncode({
// // // // // // // //           "category": selectedCategory,
// // // // // // // //           "product": selectedProduct,
// // // // // // // //           "month": selectedMonth,
// // // // // // // //           "price": double.tryParse(priceController.text) ?? 0,
// // // // // // // //         }),
// // // // // // // //       );

// // // // // // // //       final data = jsonDecode(res.body);

// // // // // // // //       List<String> rawMonths = List<String>.from(data["history_months"] ?? []);
// // // // // // // //       List<double> rawSales = List<double>.from((data["history_sales"] ?? [])
// // // // // // // //           .map((e) => (e as num).toDouble()));
// // // // // // // //       List<double> rawUnits = List<double>.from((data["history_units"] ?? [])
// // // // // // // //           .map((e) => (e as num).toDouble()));

// // // // // // // //       List<Map<String, dynamic>> combined = [];

// // // // // // // //       for (int i = 0; i < rawMonths.length; i++) {
// // // // // // // //         combined.add({
// // // // // // // //           "month": rawMonths[i],
// // // // // // // //           "sales": i < rawSales.length ? rawSales[i] : 0,
// // // // // // // //           "units": i < rawUnits.length ? rawUnits[i] : 0,
// // // // // // // //         });
// // // // // // // //       }

// // // // // // // //       const int maxPoints = 12;

// // // // // // // //       if (historySales.length > maxPoints) {
// // // // // // // //         historySales = historySales.sublist(historySales.length - maxPoints);
// // // // // // // //         historyUnits = historyUnits.sublist(historyUnits.length - maxPoints);
// // // // // // // //         historyMonths = historyMonths.sublist(historyMonths.length - maxPoints);
// // // // // // // //       }

// // // // // // // //       combined.sort((a, b) {
// // // // // // // //         try {
// // // // // // // //           final aParts = a["month"].toString().split("-");
// // // // // // // //           final bParts = b["month"].toString().split("-");

// // // // // // // //           int aYear = int.parse(aParts[0]);
// // // // // // // //           int bYear = int.parse(bParts[0]);

// // // // // // // //           int aMonth = getMonthIndex(aParts[1]);
// // // // // // // //           int bMonth = getMonthIndex(bParts[1]);

// // // // // // // //           if (aYear != bYear) {
// // // // // // // //             return aYear.compareTo(bYear);
// // // // // // // //           }

// // // // // // // //           return aMonth.compareTo(bMonth);
// // // // // // // //         } catch (_) {
// // // // // // // //           return 0;
// // // // // // // //         }
// // // // // // // //       });

// // // // // // // //       historyMonths = combined.map((e) => e["month"].toString()).toList();
// // // // // // // //       historySales = combined.map((e) => (e["sales"] as num).toDouble()).toList();
// // // // // // // //       historyUnits = combined.map((e) => (e["units"] as num).toDouble()).toList();

// // // // // // // //       setState(() {
// // // // // // // //         predictedSales = (data["predicted_sales"] ?? 0).toDouble();
// // // // // // // //         predictedUnits = (data["predicted_units"] ?? 0).toDouble();
// // // // // // // //         latestUnits = (data["latest_units"] ?? data["latest_units_used"] ?? 0).toDouble();
// // // // // // // //         rollingAvg = (data["rolling_avg"] ?? data["rolling_avg_used"] ?? 0).toDouble();
// // // // // // // //         accuracy = ((data["accuracy"] ?? 0) * 100).toDouble();
// // // // // // // //         loading = false;
// // // // // // // //       });

// // // // // // // //       await firestore.collection("prediction_history").add({
// // // // // // // //         "category": selectedCategory,
// // // // // // // //         "product": selectedProduct,
// // // // // // // //         "month": selectedMonth,
// // // // // // // //         "price": double.tryParse(priceController.text) ?? 0,
// // // // // // // //         "predicted_sales": predictedSales,
// // // // // // // //         "predicted_units": predictedUnits,
// // // // // // // //         "created_at": FieldValue.serverTimestamp(),
// // // // // // // //       });

// // // // // // // //       final docId = "${selectedProduct}_${selectedCategory}".replaceAll(" ", "_");

// // // // // // // //       await firestore
// // // // // // // //           .collection("inventory_predictions")
// // // // // // // //           .doc(docId)
// // // // // // // //           .set({
// // // // // // // //         "product": selectedProduct,
// // // // // // // //         "category": selectedCategory,
// // // // // // // //         "month": selectedMonth,
// // // // // // // //         "predicted_units": predictedUnits,
// // // // // // // //         "predicted_sales": predictedSales,
// // // // // // // //         "updated_at": FieldValue.serverTimestamp(),
// // // // // // // //       });
// // // // // // // //     } catch (e) {
// // // // // // // //       setState(() => loading = false);
// // // // // // // //       debugPrint(e.toString());
// // // // // // // //     }
// // // // // // // //   }

// // // // // // // //   // =========================================================
// // // // // // // //   // CONTROL CARD (UPDATED with price fetch)
// // // // // // // //   // =========================================================
// // // // // // // //   Widget _controlCard() {
// // // // // // // //     return Container(
// // // // // // // //       padding: const EdgeInsets.all(22),
// // // // // // // //       decoration: _box(),
// // // // // // // //       child: Column(
// // // // // // // //         children: [
// // // // // // // //           _dropdown(
// // // // // // // //             "Category",
// // // // // // // //             categories,
// // // // // // // //             selectedCategory,
// // // // // // // //             (v) async {
// // // // // // // //               setState(() {
// // // // // // // //                 selectedCategory = v;
// // // // // // // //                 selectedProduct = null;
// // // // // // // //                 products = [];
// // // // // // // //               });
// // // // // // // //               if (v != null) {
// // // // // // // //                 await loadProducts(v);
// // // // // // // //               }
// // // // // // // //             },
// // // // // // // //           ),

// // // // // // // //           // _dropdown(
// // // // // // // //           //   "Product",
// // // // // // // //           //   products,
// // // // // // // //           //   selectedProduct,
// // // // // // // //           //   (v) async {
// // // // // // // //           //     setState(() {
// // // // // // // //           //       selectedProduct = v;
// // // // // // // //           //     });
              
// // // // // // // //           //     // 🔥 FETCH PRICE WHEN PRODUCT IS SELECTED
// // // // // // // //           //     if (v != null && selectedCategory != null) {
// // // // // // // //           //       final price = await fetchProductPrice(v, selectedCategory!);
// // // // // // // //           //       priceController.text = price.toStringAsFixed(0);
// // // // // // // //           //     }
// // // // // // // //           //   },
// // // // // // // //           // ),


// // // // // // // // _dropdown(
// // // // // // // //   "Product",
// // // // // // // //   products,
// // // // // // // //   selectedProduct,
// // // // // // // //   (v) async {
// // // // // // // //     if (v == null) return;

// // // // // // // //     setState(() {
// // // // // // // //       selectedProduct = v;
// // // // // // // //     });

// // // // // // // //     try {
// // // // // // // //       final response = await http.get(
// // // // // // // //         Uri.parse(
// // // // // // // //           "$baseUrl/product_price?product=$v",
// // // // // // // //         ),
// // // // // // // //       );

// // // // // // // //       final data = jsonDecode(response.body);

// // // // // // // //       double price =
// // // // // // // //           (data["price"] ?? 500).toDouble();

// // // // // // // //       setState(() {
// // // // // // // //         priceController.text =
// // // // // // // //             price.toStringAsFixed(0);
// // // // // // // //       });

// // // // // // // //       debugPrint("✅ Price Loaded: $price");
// // // // // // // //     } catch (e) {
// // // // // // // //       debugPrint("❌ Price Error: $e");
// // // // // // // //     }
// // // // // // // //   },
// // // // // // // // ),


// // // // // // // //           _dropdown(
// // // // // // // //             "Forecast Month",
// // // // // // // //             months,
// // // // // // // //             selectedMonth,
// // // // // // // //             (v) {
// // // // // // // //               setState(() {
// // // // // // // //                 selectedMonth = v;
// // // // // // // //               });
// // // // // // // //             },
// // // // // // // //           ),

// // // // // // // //           const SizedBox(height: 12),

// // // // // // // //           TextField(
// // // // // // // //             controller: priceController,
// // // // // // // //             keyboardType: TextInputType.number,
// // // // // // // //             decoration: InputDecoration(
// // // // // // // //               labelText: "Unit Price (₹)",
// // // // // // // //               prefixIcon: const Icon(Icons.currency_rupee),
// // // // // // // //               hintText: "Auto-loaded from inventory",
// // // // // // // //               helperText: "Price fetched from product data",
// // // // // // // //               helperStyle: TextStyle(fontSize: 10, color: Colors.grey.shade500),
// // // // // // // //               filled: true,
// // // // // // // //               fillColor: Colors.grey.shade100,
// // // // // // // //               border: OutlineInputBorder(
// // // // // // // //                 borderRadius: BorderRadius.circular(16),
// // // // // // // //                 borderSide: BorderSide.none,
// // // // // // // //               ),
// // // // // // // //             ),
// // // // // // // //           ),

// // // // // // // //           const SizedBox(height: 22),

// // // // // // // //           SizedBox(
// // // // // // // //             width: double.infinity,
// // // // // // // //             height: 54,
// // // // // // // //             child: ElevatedButton(
// // // // // // // //               onPressed: loading ? null : predict,
// // // // // // // //               style: ElevatedButton.styleFrom(
// // // // // // // //                 backgroundColor: Colors.blue.shade700,
// // // // // // // //                 shape: RoundedRectangleBorder(
// // // // // // // //                   borderRadius: BorderRadius.circular(16),
// // // // // // // //                 ),
// // // // // // // //               ),
// // // // // // // //               child: loading
// // // // // // // //                   ? const CircularProgressIndicator(color: Colors.white)
// // // // // // // //                   : const Text(
// // // // // // // //                       "RUN AI FORECAST",
// // // // // // // //                       style: TextStyle(
// // // // // // // //                         fontSize: 16,
// // // // // // // //                         fontWeight: FontWeight.bold,
// // // // // // // //                       ),
// // // // // // // //                     ),
// // // // // // // //             ),
// // // // // // // //           ),
// // // // // // // //         ],
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   // =========================================================
// // // // // // // //   // SALES CHART
// // // // // // // //   // =========================================================
// // // // // // // //   Widget _salesChart() {
// // // // // // // //     const int maxPoints = 12;

// // // // // // // //     List<double> sales = List.from(historySales);
// // // // // // // //     List<String> months = List.from(historyMonths);

// // // // // // // //     if (sales.length > maxPoints) {
// // // // // // // //       sales = sales.sublist(sales.length - maxPoints);
// // // // // // // //       months = months.sublist(months.length - maxPoints);
// // // // // // // //     }

// // // // // // // //     if (sales.isEmpty) {
// // // // // // // //       return Container(
// // // // // // // //         height: 420,
// // // // // // // //         padding: const EdgeInsets.all(20),
// // // // // // // //         decoration: _box(),
// // // // // // // //         child: const Center(child: Text("No data")),
// // // // // // // //       );
// // // // // // // //     }

// // // // // // // //     List<FlSpot> actualSpots = [];

// // // // // // // //     for (int i = 0; i < sales.length; i++) {
// // // // // // // //       double v = sales[i];
// // // // // // // //       if (v.isNaN || v.isInfinite) v = 0;
// // // // // // // //       actualSpots.add(FlSpot(i.toDouble(), v));
// // // // // // // //     }

// // // // // // // //     double safePrediction = predictedSales;
// // // // // // // //     if (safePrediction.isNaN || safePrediction.isInfinite || safePrediction <= 0) {
// // // // // // // //       safePrediction = sales.last;
// // // // // // // //     }

// // // // // // // //     final predictionSpot = FlSpot(sales.length.toDouble(), safePrediction);
// // // // // // // //     List<FlSpot> forecastSpots = [
// // // // // // // //       actualSpots.last,
// // // // // // // //       predictionSpot,
// // // // // // // //     ];

// // // // // // // //     double maxY = sales.reduce((a, b) => a > b ? a : b);
// // // // // // // //     if (safePrediction > maxY) maxY = safePrediction;
// // // // // // // //     if (maxY <= 0) maxY = 100;

// // // // // // // //     double interval = maxY / 5;
// // // // // // // //     if (interval.isNaN || interval.isInfinite || interval <= 0) {
// // // // // // // //       interval = 20;
// // // // // // // //     }

// // // // // // // //     return Container(
// // // // // // // //       height: 420,
// // // // // // // //       padding: const EdgeInsets.all(20),
// // // // // // // //       decoration: _box(),
// // // // // // // //       child: Column(
// // // // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // //         children: [
// // // // // // // //           const Text(
// // // // // // // //             "Actual Sales vs Forecast",
// // // // // // // //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// // // // // // // //           ),
// // // // // // // //           const SizedBox(height: 20),
// // // // // // // //           Expanded(
// // // // // // // //             child: LineChart(
// // // // // // // //               LineChartData(
// // // // // // // //                 minY: 0,
// // // // // // // //                 maxY: maxY * 1.2,
// // // // // // // //                 gridData: FlGridData(
// // // // // // // //                   show: true,
// // // // // // // //                   horizontalInterval: interval,
// // // // // // // //                 ),
// // // // // // // //                 borderData: FlBorderData(show: false),
// // // // // // // //                 titlesData: FlTitlesData(
// // // // // // // //                   leftTitles: const AxisTitles(
// // // // // // // //                     sideTitles: SideTitles(showTitles: true, reservedSize: 45),
// // // // // // // //                   ),
// // // // // // // //                   bottomTitles: AxisTitles(
// // // // // // // //                     sideTitles: SideTitles(
// // // // // // // //                       showTitles: true,
// // // // // // // //                       interval: 2,
// // // // // // // //                       getTitlesWidget: (value, meta) {
// // // // // // // //                         int i = value.toInt();
// // // // // // // //                         if (i >= 0 && i < months.length) {
// // // // // // // //                           String m = months[i];
// // // // // // // //                           if (m.contains("-")) {
// // // // // // // //                             m = m.split("-")[1];
// // // // // // // //                           }
// // // // // // // //                           return Text(m.substring(0, 3),
// // // // // // // //                               style: const TextStyle(fontSize: 10));
// // // // // // // //                         }
// // // // // // // //                         return const SizedBox();
// // // // // // // //                       },
// // // // // // // //                     ),
// // // // // // // //                   ),
// // // // // // // //                   topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
// // // // // // // //                   rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
// // // // // // // //                 ),
// // // // // // // //                 lineBarsData: [
// // // // // // // //                   LineChartBarData(
// // // // // // // //                     spots: actualSpots,
// // // // // // // //                     isCurved: true,
// // // // // // // //                     color: Colors.blue,
// // // // // // // //                     barWidth: 4,
// // // // // // // //                     dotData: const FlDotData(show: false),
// // // // // // // //                   ),
// // // // // // // //                   LineChartBarData(
// // // // // // // //                     spots: forecastSpots,
// // // // // // // //                     isCurved: true,
// // // // // // // //                     color: Colors.green,
// // // // // // // //                     barWidth: 4,
// // // // // // // //                     dashArray: [6, 4],
// // // // // // // //                     dotData: const FlDotData(show: true),
// // // // // // // //                   ),
// // // // // // // //                 ],
// // // // // // // //               ),
// // // // // // // //             ),
// // // // // // // //           ),
// // // // // // // //           const SizedBox(height: 12),
// // // // // // // //           Row(
// // // // // // // //             children: [
// // // // // // // //               _legend(Colors.blue, "Actual Sales"),
// // // // // // // //               const SizedBox(width: 20),
// // // // // // // //               _legend(Colors.green, "Forecast"),
// // // // // // // //             ],
// // // // // // // //           ),
// // // // // // // //         ],
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   // =========================================================
// // // // // // // //   // UNITS BAR CHART
// // // // // // // //   // =========================================================
// // // // // // // //   Widget _unitsChart() {
// // // // // // // //     const int maxPoints = 12;

// // // // // // // //     List<double> units = List.from(historyUnits);
// // // // // // // //     List<String> months = List.from(historyMonths);

// // // // // // // //     if (units.length > maxPoints) {
// // // // // // // //       units = units.sublist(units.length - maxPoints);
// // // // // // // //       months = months.sublist(months.length - maxPoints);
// // // // // // // //     }

// // // // // // // //     if (units.isEmpty) {
// // // // // // // //       return Container(
// // // // // // // //         height: 420,
// // // // // // // //         padding: const EdgeInsets.all(20),
// // // // // // // //         decoration: _box(),
// // // // // // // //         child: const Center(child: Text("No data")),
// // // // // // // //       );
// // // // // // // //     }

// // // // // // // //     List<BarChartGroupData> bars = [];
// // // // // // // //     double maxY = 0;

// // // // // // // //     for (int i = 0; i < units.length; i++) {
// // // // // // // //       double value = units[i];
// // // // // // // //       if (value.isNaN || value.isInfinite) value = 0;
// // // // // // // //       if (value > maxY) maxY = value;

// // // // // // // //       bars.add(
// // // // // // // //         BarChartGroupData(
// // // // // // // //           x: i,
// // // // // // // //           barRods: [
// // // // // // // //             BarChartRodData(
// // // // // // // //               toY: value,
// // // // // // // //               width: 14,
// // // // // // // //               borderRadius: BorderRadius.circular(6),
// // // // // // // //               gradient: LinearGradient(
// // // // // // // //                 colors: [
// // // // // // // //                   Colors.orange.shade300,
// // // // // // // //                   Colors.deepOrange.shade400,
// // // // // // // //                 ],
// // // // // // // //                 begin: Alignment.bottomCenter,
// // // // // // // //                 end: Alignment.topCenter,
// // // // // // // //               ),
// // // // // // // //             ),
// // // // // // // //           ],
// // // // // // // //         ),
// // // // // // // //       );
// // // // // // // //     }

// // // // // // // //     if (maxY <= 0) maxY = 100;

// // // // // // // //     double interval = maxY / 5;
// // // // // // // //     if (interval.isNaN || interval.isInfinite || interval <= 0) {
// // // // // // // //       interval = 20;
// // // // // // // //     }

// // // // // // // //     return Container(
// // // // // // // //       height: 420,
// // // // // // // //       padding: const EdgeInsets.all(20),
// // // // // // // //       decoration: _box(),
// // // // // // // //       child: Column(
// // // // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // //         children: [
// // // // // // // //           const Text(
// // // // // // // //             "Units Sold History",
// // // // // // // //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// // // // // // // //           ),
// // // // // // // //           const SizedBox(height: 10),
// // // // // // // //           Text(
// // // // // // // //             "Last ${units.length} months trend",
// // // // // // // //             style: TextStyle(color: Colors.grey.shade600),
// // // // // // // //           ),
// // // // // // // //           const SizedBox(height: 20),
// // // // // // // //           Expanded(
// // // // // // // //             child: BarChart(
// // // // // // // //               BarChartData(
// // // // // // // //                 minY: 0,
// // // // // // // //                 maxY: maxY * 1.2,
// // // // // // // //                 borderData: FlBorderData(show: false),
// // // // // // // //                 gridData: FlGridData(
// // // // // // // //                   show: true,
// // // // // // // //                   horizontalInterval: interval,
// // // // // // // //                 ),
// // // // // // // //                 titlesData: FlTitlesData(
// // // // // // // //                   leftTitles: const AxisTitles(
// // // // // // // //                     sideTitles: SideTitles(showTitles: true, reservedSize: 35),
// // // // // // // //                   ),
// // // // // // // //                   bottomTitles: AxisTitles(
// // // // // // // //                     sideTitles: SideTitles(
// // // // // // // //                       showTitles: true,
// // // // // // // //                       interval: 2,
// // // // // // // //                       getTitlesWidget: (value, meta) {
// // // // // // // //                         int index = value.toInt();
// // // // // // // //                         if (index >= 0 && index < months.length) {
// // // // // // // //                           String label = months[index];
// // // // // // // //                           if (label.contains("-")) {
// // // // // // // //                             label = label.split("-")[1];
// // // // // // // //                           }
// // // // // // // //                           label = label.substring(0, 3);
// // // // // // // //                           return Padding(
// // // // // // // //                             padding: const EdgeInsets.only(top: 8),
// // // // // // // //                             child: Text(label, style: const TextStyle(fontSize: 10)),
// // // // // // // //                           );
// // // // // // // //                         }
// // // // // // // //                         return const SizedBox();
// // // // // // // //                       },
// // // // // // // //                     ),
// // // // // // // //                   ),
// // // // // // // //                   topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
// // // // // // // //                   rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
// // // // // // // //                 ),
// // // // // // // //                 barGroups: bars,
// // // // // // // //               ),
// // // // // // // //             ),
// // // // // // // //           ),
// // // // // // // //         ],
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   // =========================================================
// // // // // // // //   // COMPARISON SECTION
// // // // // // // //   // =========================================================
// // // // // // // //   Widget _comparisonSection() {
// // // // // // // //     double lastActual = historySales.isNotEmpty ? historySales.last : 0;
// // // // // // // //     double change = predictedSales - lastActual;
// // // // // // // //     double percent = lastActual == 0 ? 0 : (change / lastActual) * 100;
// // // // // // // //     bool growth = change >= 0;

// // // // // // // //     return Container(
// // // // // // // //       width: double.infinity,
// // // // // // // //       padding: const EdgeInsets.all(24),
// // // // // // // //       decoration: _box(),
// // // // // // // //       child: Column(
// // // // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // //         children: [
// // // // // // // //           const Text(
// // // // // // // //             "Actual vs Predicted Analysis",
// // // // // // // //             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
// // // // // // // //           ),
// // // // // // // //           const SizedBox(height: 24),
// // // // // // // //           Row(
// // // // // // // //             children: [
// // // // // // // //               Expanded(child: _comparisonTile("Last Actual", "Rs ${lastActual.toStringAsFixed(0)}", Colors.blue)),
// // // // // // // //               const SizedBox(width: 14),
// // // // // // // //               Expanded(child: _comparisonTile("Forecast", "Rs ${predictedSales.toStringAsFixed(0)}", Colors.green)),
// // // // // // // //               const SizedBox(width: 14),
// // // // // // // //               Expanded(
// // // // // // // //                 child: _comparisonTile(
// // // // // // // //                   "Growth",
// // // // // // // //                   "${percent.toStringAsFixed(1)}%",
// // // // // // // //                   growth ? Colors.green : Colors.red,
// // // // // // // //                 ),
// // // // // // // //               ),
// // // // // // // //             ],
// // // // // // // //           ),
// // // // // // // //         ],
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   // =========================================================
// // // // // // // //   // INSIGHT CARD
// // // // // // // //   // =========================================================
// // // // // // // //   Widget _insightCard() {
// // // // // // // //     double lastActual = historySales.isNotEmpty ? historySales.last : 0;
// // // // // // // //     double change = predictedSales - lastActual;
// // // // // // // //     double percent = lastActual == 0 ? 0 : (change / lastActual) * 100;
// // // // // // // //     bool growth = change >= 0;

// // // // // // // //     return Container(
// // // // // // // //       width: double.infinity,
// // // // // // // //       padding: const EdgeInsets.all(22),
// // // // // // // //       decoration: BoxDecoration(
// // // // // // // //         color: growth ? Colors.green.shade50 : Colors.red.shade50,
// // // // // // // //         borderRadius: BorderRadius.circular(22),
// // // // // // // //       ),
// // // // // // // //       child: Row(
// // // // // // // //         children: [
// // // // // // // //           Container(
// // // // // // // //             padding: const EdgeInsets.all(14),
// // // // // // // //             decoration: BoxDecoration(
// // // // // // // //               color: growth ? Colors.green.shade100 : Colors.red.shade100,
// // // // // // // //               shape: BoxShape.circle,
// // // // // // // //             ),
// // // // // // // //             child: Icon(
// // // // // // // //               growth ? Icons.trending_up : Icons.trending_down,
// // // // // // // //               color: growth ? Colors.green : Colors.red,
// // // // // // // //             ),
// // // // // // // //           ),
// // // // // // // //           const SizedBox(width: 18),
// // // // // // // //           Expanded(
// // // // // // // //             child: Column(
// // // // // // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // //               children: [
// // // // // // // //                 Text(
// // // // // // // //                   growth ? "Positive Sales Forecast" : "Sales Decline Risk",
// // // // // // // //                   style: TextStyle(
// // // // // // // //                     fontSize: 18,
// // // // // // // //                     fontWeight: FontWeight.bold,
// // // // // // // //                     color: growth ? Colors.green : Colors.red,
// // // // // // // //                   ),
// // // // // // // //                 ),
// // // // // // // //                 const SizedBox(height: 8),
// // // // // // // //                 Text(
// // // // // // // //                   growth
// // // // // // // //                       ? "AI predicts approximately ${percent.toStringAsFixed(1)}% growth compared to the latest actual sales performance."
// // // // // // // //                       : "AI predicts approximately ${percent.abs().toStringAsFixed(1)}% decline compared to historical sales performance.",
// // // // // // // //                 ),
// // // // // // // //               ],
// // // // // // // //             ),
// // // // // // // //           ),
// // // // // // // //         ],
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   // =========================================================
// // // // // // // //   // ANALYTICS CARD
// // // // // // // //   // =========================================================
// // // // // // // //   Widget _analyticsCard(String title, String value, IconData icon, Color color) {
// // // // // // // //     return Container(
// // // // // // // //       padding: const EdgeInsets.all(18),
// // // // // // // //       decoration: _box(),
// // // // // // // //       child: Column(
// // // // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // //         children: [
// // // // // // // //           Container(
// // // // // // // //             padding: const EdgeInsets.all(10),
// // // // // // // //             decoration: BoxDecoration(
// // // // // // // //               color: color.withOpacity(0.1),
// // // // // // // //               borderRadius: BorderRadius.circular(14),
// // // // // // // //             ),
// // // // // // // //             child: Icon(icon, color: color),
// // // // // // // //           ),
// // // // // // // //           const SizedBox(height: 18),
// // // // // // // //           Text(title, style: TextStyle(color: Colors.grey.shade700)),
// // // // // // // //           const SizedBox(height: 8),
// // // // // // // //           Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
// // // // // // // //         ],
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   // =========================================================
// // // // // // // //   // HEADER STATS
// // // // // // // //   // =========================================================
// // // // // // // //   Widget _topStat(String title, String value, IconData icon) {
// // // // // // // //     return Container(
// // // // // // // //       padding: const EdgeInsets.all(16),
// // // // // // // //       decoration: BoxDecoration(
// // // // // // // //         color: Colors.white.withOpacity(0.15),
// // // // // // // //         borderRadius: BorderRadius.circular(18),
// // // // // // // //       ),
// // // // // // // //       child: Column(
// // // // // // // //         children: [
// // // // // // // //           Icon(icon, color: Colors.white),
// // // // // // // //           const SizedBox(height: 10),
// // // // // // // //           Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
// // // // // // // //           const SizedBox(height: 4),
// // // // // // // //           Text(title, textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(0.9))),
// // // // // // // //         ],
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   // =========================================================
// // // // // // // //   // COMPARISON TILE
// // // // // // // //   // =========================================================
// // // // // // // //   Widget _comparisonTile(String title, String value, Color color) {
// // // // // // // //     return Container(
// // // // // // // //       padding: const EdgeInsets.all(18),
// // // // // // // //       decoration: BoxDecoration(
// // // // // // // //         color: color.withOpacity(0.08),
// // // // // // // //         borderRadius: BorderRadius.circular(18),
// // // // // // // //       ),
// // // // // // // //       child: Column(
// // // // // // // //         children: [
// // // // // // // //           Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
// // // // // // // //           const SizedBox(height: 10),
// // // // // // // //           Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
// // // // // // // //         ],
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   // =========================================================
// // // // // // // //   // LEGEND
// // // // // // // //   // =========================================================
// // // // // // // //   Widget _legend(Color color, String text) {
// // // // // // // //     return Row(
// // // // // // // //       children: [
// // // // // // // //         Container(width: 14, height: 14, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
// // // // // // // //         const SizedBox(width: 8),
// // // // // // // //         Text(text),
// // // // // // // //       ],
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   // =========================================================
// // // // // // // //   // DROPDOWN
// // // // // // // //   // =========================================================
// // // // // // // //   Widget _dropdown(String label, List<String> items, String? value, Function(String?) onChanged) {
// // // // // // // //     return Padding(
// // // // // // // //       padding: const EdgeInsets.only(bottom: 14),
// // // // // // // //       child: DropdownButtonFormField<String>(
// // // // // // // //         value: items.contains(value) ? value : null,
// // // // // // // //         items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
// // // // // // // //         onChanged: onChanged,
// // // // // // // //         decoration: InputDecoration(
// // // // // // // //           labelText: label,
// // // // // // // //           filled: true,
// // // // // // // //           fillColor: Colors.grey.shade100,
// // // // // // // //           border: OutlineInputBorder(
// // // // // // // //             borderRadius: BorderRadius.circular(16),
// // // // // // // //             borderSide: BorderSide.none,
// // // // // // // //           ),
// // // // // // // //         ),
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   // =========================================================
// // // // // // // //   // COMMON BOX
// // // // // // // //   // =========================================================
// // // // // // // //   BoxDecoration _box() {
// // // // // // // //     return BoxDecoration(
// // // // // // // //       color: Colors.white,
// // // // // // // //       borderRadius: BorderRadius.circular(24),
// // // // // // // //       boxShadow: [
// // // // // // // //         BoxShadow(
// // // // // // // //           color: Colors.black.withOpacity(0.04),
// // // // // // // //           blurRadius: 10,
// // // // // // // //           offset: const Offset(0, 4),
// // // // // // // //         ),
// // // // // // // //       ],
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   // =========================================================
// // // // // // // //   // BUILD
// // // // // // // //   // =========================================================
// // // // // // // //   @override
// // // // // // // //   Widget build(BuildContext context) {
// // // // // // // //     return Scaffold(
// // // // // // // //       backgroundColor: const Color(0xffF4F7FC),
// // // // // // // //       appBar: AppBar(
// // // // // // // //         elevation: 0,
// // // // // // // //         backgroundColor: Colors.white,
// // // // // // // //         foregroundColor: Colors.black,
// // // // // // // //         title: const Text(
// // // // // // // //           "AI Forecast Dashboard",
// // // // // // // //           style: TextStyle(fontWeight: FontWeight.bold),
// // // // // // // //         ),
// // // // // // // //       ),
// // // // // // // //       body: SingleChildScrollView(
// // // // // // // //         padding: const EdgeInsets.all(20),
// // // // // // // //         child: Column(
// // // // // // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // //           children: [
// // // // // // // //             Container(
// // // // // // // //               width: double.infinity,
// // // // // // // //               padding: const EdgeInsets.all(24),
// // // // // // // //               decoration: BoxDecoration(
// // // // // // // //                 gradient: LinearGradient(
// // // // // // // //                   colors: [Colors.blue.shade700, Colors.indigo.shade600],
// // // // // // // //                   begin: Alignment.topLeft,
// // // // // // // //                   end: Alignment.bottomRight,
// // // // // // // //                 ),
// // // // // // // //                 borderRadius: BorderRadius.circular(28),
// // // // // // // //               ),
// // // // // // // //               child: Column(
// // // // // // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // //                 children: [
// // // // // // // //                   const Text(
// // // // // // // //                     "AI Retail Analytics",
// // // // // // // //                     style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
// // // // // // // //                   ),
// // // // // // // //                   const SizedBox(height: 12),
// // // // // // // //                   Text(
// // // // // // // //                     "Advanced machine learning forecasting system for inventory intelligence",
// // // // // // // //                     style: TextStyle(color: Colors.white.withOpacity(0.92), height: 1.5),
// // // // // // // //                   ),
// // // // // // // //                   const SizedBox(height: 24),
// // // // // // // //                   Row(
// // // // // // // //                     children: [
// // // // // // // //                       Expanded(child: _topStat("Accuracy", "${accuracy.toStringAsFixed(1)}%", Icons.analytics)),
// // // // // // // //                       const SizedBox(width: 14),
// // // // // // // //                       Expanded(child: _topStat("Forecast Units", predictedUnits.toStringAsFixed(0), Icons.inventory_2)),
// // // // // // // //                     ],
// // // // // // // //                   ),
// // // // // // // //                 ],
// // // // // // // //               ),
// // // // // // // //             ),
// // // // // // // //             const SizedBox(height: 24),
// // // // // // // //             _controlCard(),
// // // // // // // //             const SizedBox(height: 24),
// // // // // // // //             if (historySales.isNotEmpty) ...[
// // // // // // // //               Row(
// // // // // // // //                 children: [
// // // // // // // //                   Expanded(child: _analyticsCard("Predicted Revenue", "Rs ${predictedSales.toStringAsFixed(0)}", Icons.currency_rupee, Colors.blue)),
// // // // // // // //                   const SizedBox(width: 14),
// // // // // // // //                   Expanded(child: _analyticsCard("Latest Units", latestUnits.toStringAsFixed(0), Icons.shopping_cart, Colors.orange)),
// // // // // // // //                   const SizedBox(width: 14),
// // // // // // // //                   Expanded(child: _analyticsCard("Rolling Average", rollingAvg.toStringAsFixed(0), Icons.show_chart, Colors.green)),
// // // // // // // //                 ],
// // // // // // // //               ),
// // // // // // // //               const SizedBox(height: 24),
// // // // // // // //               Row(
// // // // // // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // //                 children: [
// // // // // // // //                   Expanded(flex: 2, child: _salesChart()),
// // // // // // // //                   const SizedBox(width: 18),
// // // // // // // //                   Expanded(child: _unitsChart()),
// // // // // // // //                 ],
// // // // // // // //               ),
// // // // // // // //               const SizedBox(height: 24),
// // // // // // // //               _comparisonSection(),
// // // // // // // //               const SizedBox(height: 24),
// // // // // // // //               _insightCard(),
// // // // // // // //             ],
// // // // // // // //           ],
// // // // // // // //         ),
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }
// // // // // // // // }
// // // // // // // import 'dart:convert';
// // // // // // // import 'package:fl_chart/fl_chart.dart';
// // // // // // // import 'package:flutter/material.dart';
// // // // // // // import 'package:http/http.dart' as http;
// // // // // // // import 'package:cloud_firestore/cloud_firestore.dart';

// // // // // // // class PredictionPage extends StatefulWidget {
// // // // // // //   const PredictionPage({super.key});

// // // // // // //   @override
// // // // // // //   State<PredictionPage> createState() => _PredictionPageState();
// // // // // // // }

// // // // // // // class _PredictionPageState extends State<PredictionPage> {

// // // // // // //   // =========================================================
// // // // // // //   // DATA
// // // // // // //   // =========================================================

// // // // // // //   List<double> historySales = [];
// // // // // // //   List<double> historyUnits = [];
// // // // // // //   List<String> historyMonths = [];

// // // // // // //   List<String> categories = [];
// // // // // // //   List<String> products = [];
// // // // // // //   List<String> months = [];

// // // // // // //   String? selectedCategory;
// // // // // // //   String? selectedProduct;
// // // // // // //   String? selectedMonth;

// // // // // // //   bool loading = false;

// // // // // // //   // =========================================================
// // // // // // //   // ML RESULTS
// // // // // // //   // =========================================================

// // // // // // //   double predictedSales = 0;
// // // // // // //   double predictedUnits = 0;
// // // // // // //   double latestUnits = 0;
// // // // // // //   double rollingAvg = 0;
// // // // // // //   double accuracy = 0;

// // // // // // //   final TextEditingController priceController = TextEditingController(text: "500");

// // // // // // //   final String baseUrl = "http://192.168.100.218:5000";
// // // // // // //   final FirebaseFirestore firestore = FirebaseFirestore.instance;

// // // // // // //   // Cache for prices to avoid repeated Firebase calls
// // // // // // //   final Map<String, double> _priceCache = {};

// // // // // // //   // =========================================================
// // // // // // //   // INIT
// // // // // // //   // =========================================================

// // // // // // //   @override
// // // // // // //   void initState() {
// // // // // // //     super.initState();
// // // // // // //     initialize();
// // // // // // //   }

// // // // // // //   Future<void> initialize() async {
// // // // // // //     await loadCategories();
// // // // // // //     await loadMonths();
// // // // // // //   }

// // // // // // //   // =========================================================
// // // // // // //   // IMPROVED PRICE FETCHING WITH MULTIPLE STRATEGIES
// // // // // // //   // =========================================================
// // // // // // //   Future<double> fetchProductPrice(String product, String category) async {
// // // // // // //     // Check cache first
// // // // // // //     String cacheKey = "$category|$product";
// // // // // // //     if (_priceCache.containsKey(cacheKey)) {
// // // // // // //       return _priceCache[cacheKey]!;
// // // // // // //     }

// // // // // // //     double price = 500; // Default fallback price

// // // // // // //     try {
// // // // // // //       // Strategy 1: Try exact match in inventory collection
// // // // // // //       QuerySnapshot exactMatch = await firestore
// // // // // // //           .collection("inventory")
// // // // // // //           .where("product", isEqualTo: product)
// // // // // // //           .where("category", isEqualTo: category)
// // // // // // //           .limit(1)
// // // // // // //           .get();
      
// // // // // // //       if (exactMatch.docs.isNotEmpty) {
// // // // // // //         price = (exactMatch.docs.first.data() as Map<String, dynamic>)["price"]?.toDouble() ?? 500;
// // // // // // //         _priceCache[cacheKey] = price;
// // // // // // //         debugPrint("✅ Price found for $product: ₹$price (exact match)");
// // // // // // //         return price;
// // // // // // //       }

// // // // // // //       // Strategy 2: Try case-insensitive search
// // // // // // //       QuerySnapshot caseInsensitive = await firestore
// // // // // // //           .collection("inventory")
// // // // // // //           .where("product", isEqualTo: product.toLowerCase())
// // // // // // //           .where("category", isEqualTo: category.toLowerCase())
// // // // // // //           .limit(1)
// // // // // // //           .get();
      
// // // // // // //       if (caseInsensitive.docs.isNotEmpty) {
// // // // // // //         price = (caseInsensitive.docs.first.data() as Map<String, dynamic>)["price"]?.toDouble() ?? 500;
// // // // // // //         _priceCache[cacheKey] = price;
// // // // // // //         debugPrint("✅ Price found for $product: ₹$price (case-insensitive)");
// // // // // // //         return price;
// // // // // // //       }

// // // // // // //       // Strategy 3: Search by product only (ignore category)
// // // // // // //       QuerySnapshot productOnly = await firestore
// // // // // // //           .collection("inventory")
// // // // // // //           .where("product", isEqualTo: product)
// // // // // // //           .limit(1)
// // // // // // //           .get();
      
// // // // // // //       if (productOnly.docs.isNotEmpty) {
// // // // // // //         price = (productOnly.docs.first.data() as Map<String, dynamic>)["price"]?.toDouble() ?? 500;
// // // // // // //         _priceCache[cacheKey] = price;
// // // // // // //         debugPrint("✅ Price found for $product: ₹$price (product only)");
// // // // // // //         return price;
// // // // // // //       }

// // // // // // //       // Strategy 4: Try to find similar product names
// // // // // // //       QuerySnapshot allProducts = await firestore
// // // // // // //           .collection("inventory")
// // // // // // //           .limit(20)
// // // // // // //           .get();
      
// // // // // // //       double bestMatchPrice = 500;
// // // // // // //       double bestMatchScore = 0;
      
// // // // // // //       for (var doc in allProducts.docs) {
// // // // // // //         String dbProduct = (doc.data() as Map<String, dynamic>)["product"]?.toString().toLowerCase() ?? "";
// // // // // // //         String dbCategory = (doc.data() as Map<String, dynamic>)["category"]?.toString().toLowerCase() ?? "";
        
// // // // // // //         double score = 0;
// // // // // // //         if (dbProduct.contains(product.toLowerCase())) score += 0.7;
// // // // // // //         if (product.toLowerCase().contains(dbProduct)) score += 0.5;
// // // // // // //         if (dbCategory == category.toLowerCase()) score += 0.3;
        
// // // // // // //         if (score > bestMatchScore && score > 0.5) {
// // // // // // //           bestMatchScore = score;
// // // // // // //           bestMatchPrice = (doc.data() as Map<String, dynamic>)["price"]?.toDouble() ?? 500;
// // // // // // //         }
// // // // // // //       }
      
// // // // // // //       if (bestMatchScore > 0) {
// // // // // // //         price = bestMatchPrice;
// // // // // // //         _priceCache[cacheKey] = price;
// // // // // // //         debugPrint("✅ Similar product found for $product: ₹$price (similarity: ${(bestMatchScore * 100).toInt()}%)");
// // // // // // //         return price;
// // // // // // //       }

// // // // // // //       // Strategy 5: Use category average price
// // // // // // //       QuerySnapshot categoryProducts = await firestore
// // // // // // //           .collection("inventory")
// // // // // // //           .where("category", isEqualTo: category)
// // // // // // //           .get();
      
// // // // // // //       if (categoryProducts.docs.isNotEmpty) {
// // // // // // //         double total = 0;
// // // // // // //         int count = 0;
// // // // // // //         for (var doc in categoryProducts.docs) {
// // // // // // //           double p = (doc.data() as Map<String, dynamic>)["price"]?.toDouble() ?? 0;
// // // // // // //           if (p > 0) {
// // // // // // //             total += p;
// // // // // // //             count++;
// // // // // // //           }
// // // // // // //         }
// // // // // // //         if (count > 0) {
// // // // // // //           price = total / count;
// // // // // // //           _priceCache[cacheKey] = price;
// // // // // // //           debugPrint("✅ Using category average for $product: ₹${price.toStringAsFixed(0)}");
// // // // // // //           return price;
// // // // // // //         }
// // // // // // //       }

// // // // // // //       debugPrint("⚠️ No price found for $product, using default ₹500");
      
// // // // // // //     } catch (e) {
// // // // // // //       debugPrint("❌ Error fetching price for $product: $e");
// // // // // // //     }
    
// // // // // // //     _priceCache[cacheKey] = price;
// // // // // // //     return price;
// // // // // // //   }

// // // // // // //   // =========================================================
// // // // // // //   // BULK PRICE LOADING FOR ALL PRODUCTS IN CATEGORY
// // // // // // //   // =========================================================
// // // // // // //   Future<Map<String, double>> loadAllProductPrices(String category) async {
// // // // // // //     Map<String, double> priceMap = {};
    
// // // // // // //     try {
// // // // // // //       QuerySnapshot snapshot = await firestore
// // // // // // //           .collection("inventory")
// // // // // // //           .where("category", isEqualTo: category)
// // // // // // //           .get();
      
// // // // // // //       for (var doc in snapshot.docs) {
// // // // // // //         String product = (doc.data() as Map<String, dynamic>)["product"]?.toString() ?? "";
// // // // // // //         double price = (doc.data() as Map<String, dynamic>)["price"]?.toDouble() ?? 0;
// // // // // // //         if (product.isNotEmpty && price > 0) {
// // // // // // //           priceMap[product] = price;
// // // // // // //         }
// // // // // // //       }
      
// // // // // // //       debugPrint("📦 Loaded ${priceMap.length} prices for category: $category");
// // // // // // //     } catch (e) {
// // // // // // //       debugPrint("Error bulk loading prices: $e");
// // // // // // //     }
    
// // // // // // //     return priceMap;
// // // // // // //   }

// // // // // // //   // =========================================================
// // // // // // //   // FETCH LIST
// // // // // // //   // =========================================================

// // // // // // //   Future<List<String>> fetchList(String endpoint, String key) async {
// // // // // // //     try {
// // // // // // //       final res = await http.get(Uri.parse("$baseUrl/$endpoint"));
// // // // // // //       final data = jsonDecode(res.body);
// // // // // // //       return List<String>.from(data[key] ?? []);
// // // // // // //     } catch (_) {
// // // // // // //       return [];
// // // // // // //     }
// // // // // // //   }

// // // // // // //   Future<void> loadCategories() async {
// // // // // // //     categories = await fetchList("categories", "categories");

// // // // // // //     setState(() {
// // // // // // //       selectedCategory = categories.isNotEmpty ? categories.first : null;
// // // // // // //       selectedProduct = null;
// // // // // // //       products = [];
// // // // // // //     });

// // // // // // //     if (selectedCategory != null) {
// // // // // // //       await loadProducts(selectedCategory!);
// // // // // // //     }
// // // // // // //   }

// // // // // // //   Future<void> loadProducts(String category) async {
// // // // // // //     try {
// // // // // // //       final res = await http.get(
// // // // // // //         Uri.parse("$baseUrl/products?category=$category"),
// // // // // // //       );

// // // // // // //       final data = jsonDecode(res.body);

// // // // // // //       setState(() {
// // // // // // //         products = List<String>.from(data["products"] ?? []);
// // // // // // //         selectedProduct = products.isNotEmpty ? products.first : null;
// // // // // // //       });
      
// // // // // // //       // Bulk load prices for all products in this category
// // // // // // //       Map<String, double> priceMap = await loadAllProductPrices(category);
      
// // // // // // //       // Fetch price for the first product
// // // // // // //       if (selectedProduct != null && selectedCategory != null) {
// // // // // // //         double price;
// // // // // // //         if (priceMap.containsKey(selectedProduct)) {
// // // // // // //           price = priceMap[selectedProduct]!;
// // // // // // //         } else {
// // // // // // //           price = await fetchProductPrice(selectedProduct!, selectedCategory!);
// // // // // // //         }
// // // // // // //         priceController.text = price.toStringAsFixed(0);
// // // // // // //       }
// // // // // // //     } catch (_) {
// // // // // // //       setState(() {
// // // // // // //         products = [];
// // // // // // //         selectedProduct = null;
// // // // // // //       });
// // // // // // //     }
// // // // // // //   }

// // // // // // //   Future<void> loadMonths() async {
// // // // // // //     months = await fetchList("months", "months");

// // // // // // //     setState(() {
// // // // // // //       selectedMonth = months.isNotEmpty ? months.last : null;
// // // // // // //     });
// // // // // // //   }

// // // // // // //   int getMonthIndex(String month) {
// // // // // // //     const monthOrder = [
// // // // // // //       "jan","feb","mar","apr","may","jun",
// // // // // // //       "jul","aug","sep","oct","nov","dec",
// // // // // // //     ];

// // // // // // //     String shortMonth = month.toLowerCase().substring(0, 3);
// // // // // // //     return monthOrder.indexOf(shortMonth);
// // // // // // //   }

// // // // // // //   // =========================================================
// // // // // // //   // PREDICT + FIRESTORE SAVE
// // // // // // //   // =========================================================
// // // // // // //   Future<void> predict() async {
// // // // // // //     if (selectedCategory == null || selectedProduct == null || selectedMonth == null) {
// // // // // // //       return;
// // // // // // //     }

// // // // // // //     setState(() => loading = true);

// // // // // // //     try {
// // // // // // //       final res = await http.post(
// // // // // // //         Uri.parse("$baseUrl/predict"),
// // // // // // //         headers: {"Content-Type": "application/json"},
// // // // // // //         body: jsonEncode({
// // // // // // //           "category": selectedCategory,
// // // // // // //           "product": selectedProduct,
// // // // // // //           "month": selectedMonth,
// // // // // // //           "price": double.tryParse(priceController.text) ?? 0,
// // // // // // //         }),
// // // // // // //       );

// // // // // // //       final data = jsonDecode(res.body);

// // // // // // //       List<String> rawMonths = List<String>.from(data["history_months"] ?? []);
// // // // // // //       List<double> rawSales = List<double>.from((data["history_sales"] ?? [])
// // // // // // //           .map((e) => (e as num).toDouble()));
// // // // // // //       List<double> rawUnits = List<double>.from((data["history_units"] ?? [])
// // // // // // //           .map((e) => (e as num).toDouble()));

// // // // // // //       List<Map<String, dynamic>> combined = [];

// // // // // // //       for (int i = 0; i < rawMonths.length; i++) {
// // // // // // //         combined.add({
// // // // // // //           "month": rawMonths[i],
// // // // // // //           "sales": i < rawSales.length ? rawSales[i] : 0,
// // // // // // //           "units": i < rawUnits.length ? rawUnits[i] : 0,
// // // // // // //         });
// // // // // // //       }

// // // // // // //       const int maxPoints = 12;

// // // // // // //       if (historySales.length > maxPoints) {
// // // // // // //         historySales = historySales.sublist(historySales.length - maxPoints);
// // // // // // //         historyUnits = historyUnits.sublist(historyUnits.length - maxPoints);
// // // // // // //         historyMonths = historyMonths.sublist(historyMonths.length - maxPoints);
// // // // // // //       }

// // // // // // //       combined.sort((a, b) {
// // // // // // //         try {
// // // // // // //           final aParts = a["month"].toString().split("-");
// // // // // // //           final bParts = b["month"].toString().split("-");

// // // // // // //           int aYear = int.parse(aParts[0]);
// // // // // // //           int bYear = int.parse(bParts[0]);

// // // // // // //           int aMonth = getMonthIndex(aParts[1]);
// // // // // // //           int bMonth = getMonthIndex(bParts[1]);

// // // // // // //           if (aYear != bYear) {
// // // // // // //             return aYear.compareTo(bYear);
// // // // // // //           }

// // // // // // //           return aMonth.compareTo(bMonth);
// // // // // // //         } catch (_) {
// // // // // // //           return 0;
// // // // // // //         }
// // // // // // //       });

// // // // // // //       historyMonths = combined.map((e) => e["month"].toString()).toList();
// // // // // // //       historySales = combined.map((e) => (e["sales"] as num).toDouble()).toList();
// // // // // // //       historyUnits = combined.map((e) => (e["units"] as num).toDouble()).toList();

// // // // // // //       setState(() {
// // // // // // //         predictedSales = (data["predicted_sales"] ?? 0).toDouble();
// // // // // // //         predictedUnits = (data["predicted_units"] ?? 0).toDouble();
// // // // // // //         latestUnits = (data["latest_units"] ?? data["latest_units_used"] ?? 0).toDouble();
// // // // // // //         rollingAvg = (data["rolling_avg"] ?? data["rolling_avg_used"] ?? 0).toDouble();
// // // // // // //         accuracy = ((data["accuracy"] ?? 0) * 100).toDouble();
// // // // // // //         loading = false;
// // // // // // //       });

// // // // // // //       await firestore.collection("prediction_history").add({
// // // // // // //         "category": selectedCategory,
// // // // // // //         "product": selectedProduct,
// // // // // // //         "month": selectedMonth,
// // // // // // //         "price": double.tryParse(priceController.text) ?? 0,
// // // // // // //         "predicted_sales": predictedSales,
// // // // // // //         "predicted_units": predictedUnits,
// // // // // // //         "created_at": FieldValue.serverTimestamp(),
// // // // // // //       });

// // // // // // //       final docId = "${selectedProduct}_${selectedCategory}".replaceAll(" ", "_");

// // // // // // //       await firestore
// // // // // // //           .collection("inventory_predictions")
// // // // // // //           .doc(docId)
// // // // // // //           .set({
// // // // // // //         "product": selectedProduct,
// // // // // // //         "category": selectedCategory,
// // // // // // //         "month": selectedMonth,
// // // // // // //         "predicted_units": predictedUnits,
// // // // // // //         "predicted_sales": predictedSales,
// // // // // // //         "updated_at": FieldValue.serverTimestamp(),
// // // // // // //       });
// // // // // // //     } catch (e) {
// // // // // // //       setState(() => loading = false);
// // // // // // //       debugPrint(e.toString());
// // // // // // //     }
// // // // // // //   }

// // // // // // //   // =========================================================
// // // // // // //   // CONTROL CARD WITH PRICE EDIT OPTION
// // // // // // //   // =========================================================
// // // // // // //   Widget _controlCard() {
// // // // // // //     return Container(
// // // // // // //       padding: const EdgeInsets.all(22),
// // // // // // //       decoration: _box(),
// // // // // // //       child: Column(
// // // // // // //         children: [
// // // // // // //           _dropdown(
// // // // // // //             "Category",
// // // // // // //             categories,
// // // // // // //             selectedCategory,
// // // // // // //             (v) async {
// // // // // // //               setState(() {
// // // // // // //                 selectedCategory = v;
// // // // // // //                 selectedProduct = null;
// // // // // // //                 products = [];
// // // // // // //               });
// // // // // // //               if (v != null) {
// // // // // // //                 await loadProducts(v);
// // // // // // //               }
// // // // // // //             },
// // // // // // //           ),

// // // // // // //           _dropdown(
// // // // // // //             "Product",
// // // // // // //             products,
// // // // // // //             selectedProduct,
// // // // // // //             (v) async {
// // // // // // //               setState(() {
// // // // // // //                 selectedProduct = v;
// // // // // // //               });
              
// // // // // // //               // Fetch price when product is selected
// // // // // // //               if (v != null && selectedCategory != null) {
// // // // // // //                 final price = await fetchProductPrice(v, selectedCategory!);
// // // // // // //                 priceController.text = price.toStringAsFixed(0);
                
// // // // // // //                 // Show a snackbar if using default price
// // // // // // //                 if (price == 500) {
// // // // // // //                   if (mounted) {
// // // // // // //                     ScaffoldMessenger.of(context).showSnackBar(
// // // // // // //                       SnackBar(
// // // // // // //                         content: Text("⚠️ No price found for $v, using default ₹500. You can edit it."),
// // // // // // //                         backgroundColor: Colors.orange,
// // // // // // //                         duration: const Duration(seconds: 3),
// // // // // // //                       ),
// // // // // // //                     );
// // // // // // //                   }
// // // // // // //                 } else {
// // // // // // //                   if (mounted) {
// // // // // // //                     ScaffoldMessenger.of(context).showSnackBar(
// // // // // // //                       SnackBar(
// // // // // // //                         content: Text("✅ Price loaded: ₹${price.toStringAsFixed(0)} for $v"),
// // // // // // //                         backgroundColor: Colors.green,
// // // // // // //                         duration: const Duration(seconds: 2),
// // // // // // //                       ),
// // // // // // //                     );
// // // // // // //                   }
// // // // // // //                 }
// // // // // // //               }
// // // // // // //             },
// // // // // // //           ),

// // // // // // //           _dropdown(
// // // // // // //             "Forecast Month",
// // // // // // //             months,
// // // // // // //             selectedMonth,
// // // // // // //             (v) {
// // // // // // //               setState(() {
// // // // // // //                 selectedMonth = v;
// // // // // // //               });
// // // // // // //             },
// // // // // // //           ),

// // // // // // //           const SizedBox(height: 12),

// // // // // // //           TextField(
// // // // // // //             controller: priceController,
// // // // // // //             keyboardType: TextInputType.number,
// // // // // // //             decoration: InputDecoration(
// // // // // // //               labelText: "Unit Price (₹)",
// // // // // // //               prefixIcon: const Icon(Icons.currency_rupee),
// // // // // // //               hintText: "Auto-loaded or manual entry",
// // // // // // //               helperText: "Price auto-loaded from inventory or you can edit",
// // // // // // //               helperStyle: TextStyle(fontSize: 10, color: Colors.grey.shade500),
// // // // // // //               filled: true,
// // // // // // //               fillColor: Colors.grey.shade100,
// // // // // // //               border: OutlineInputBorder(
// // // // // // //                 borderRadius: BorderRadius.circular(16),
// // // // // // //                 borderSide: BorderSide.none,
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //           ),

// // // // // // //           const SizedBox(height: 22),

// // // // // // //           SizedBox(
// // // // // // //             width: double.infinity,
// // // // // // //             height: 54,
// // // // // // //             child: ElevatedButton(
// // // // // // //               onPressed: loading ? null : predict,
// // // // // // //               style: ElevatedButton.styleFrom(
// // // // // // //                 backgroundColor: Colors.blue.shade700,
// // // // // // //                 shape: RoundedRectangleBorder(
// // // // // // //                   borderRadius: BorderRadius.circular(16),
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //               child: loading
// // // // // // //                   ? const CircularProgressIndicator(color: Colors.white)
// // // // // // //                   : const Text(
// // // // // // //                       "RUN AI FORECAST",
// // // // // // //                       style: TextStyle(
// // // // // // //                         fontSize: 16,
// // // // // // //                         fontWeight: FontWeight.bold,
// // // // // // //                       ),
// // // // // // //                     ),
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   // Add this button to manually refresh prices
// // // // // // //   Widget _refreshPricesButton() {
// // // // // // //     return IconButton(
// // // // // // //       icon: const Icon(Icons.refresh),
// // // // // // //       onPressed: () async {
// // // // // // //         if (selectedCategory != null) {
// // // // // // //           await loadProducts(selectedCategory!);
// // // // // // //           if (mounted) {
// // // // // // //             ScaffoldMessenger.of(context).showSnackBar(
// // // // // // //               const SnackBar(content: Text("Prices refreshed from database")),
// // // // // // //             );
// // // // // // //           }
// // // // // // //         }
// // // // // // //       },
// // // // // // //       tooltip: "Refresh prices from database",
// // // // // // //     );
// // // // // // //   }

// // // // // // //   // =========================================================
// // // // // // //   // SALES CHART
// // // // // // //   // =========================================================
// // // // // // //   Widget _salesChart() {
// // // // // // //     const int maxPoints = 12;

// // // // // // //     List<double> sales = List.from(historySales);
// // // // // // //     List<String> months = List.from(historyMonths);

// // // // // // //     if (sales.length > maxPoints) {
// // // // // // //       sales = sales.sublist(sales.length - maxPoints);
// // // // // // //       months = months.sublist(months.length - maxPoints);
// // // // // // //     }

// // // // // // //     if (sales.isEmpty) {
// // // // // // //       return Container(
// // // // // // //         height: 420,
// // // // // // //         padding: const EdgeInsets.all(20),
// // // // // // //         decoration: _box(),
// // // // // // //         child: const Center(child: Text("No data")),
// // // // // // //       );
// // // // // // //     }

// // // // // // //     List<FlSpot> actualSpots = [];

// // // // // // //     for (int i = 0; i < sales.length; i++) {
// // // // // // //       double v = sales[i];
// // // // // // //       if (v.isNaN || v.isInfinite) v = 0;
// // // // // // //       actualSpots.add(FlSpot(i.toDouble(), v));
// // // // // // //     }

// // // // // // //     double safePrediction = predictedSales;
// // // // // // //     if (safePrediction.isNaN || safePrediction.isInfinite || safePrediction <= 0) {
// // // // // // //       safePrediction = sales.last;
// // // // // // //     }

// // // // // // //     final predictionSpot = FlSpot(sales.length.toDouble(), safePrediction);
// // // // // // //     List<FlSpot> forecastSpots = [
// // // // // // //       actualSpots.last,
// // // // // // //       predictionSpot,
// // // // // // //     ];

// // // // // // //     double maxY = sales.reduce((a, b) => a > b ? a : b);
// // // // // // //     if (safePrediction > maxY) maxY = safePrediction;
// // // // // // //     if (maxY <= 0) maxY = 100;

// // // // // // //     double interval = maxY / 5;
// // // // // // //     if (interval.isNaN || interval.isInfinite || interval <= 0) {
// // // // // // //       interval = 20;
// // // // // // //     }

// // // // // // //     return Container(
// // // // // // //       height: 420,
// // // // // // //       padding: const EdgeInsets.all(20),
// // // // // // //       decoration: _box(),
// // // // // // //       child: Column(
// // // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //         children: [
// // // // // // //           const Text(
// // // // // // //             "Actual Sales vs Forecast",
// // // // // // //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// // // // // // //           ),
// // // // // // //           const SizedBox(height: 20),
// // // // // // //           Expanded(
// // // // // // //             child: LineChart(
// // // // // // //               LineChartData(
// // // // // // //                 minY: 0,
// // // // // // //                 maxY: maxY * 1.2,
// // // // // // //                 gridData: FlGridData(
// // // // // // //                   show: true,
// // // // // // //                   horizontalInterval: interval,
// // // // // // //                 ),
// // // // // // //                 borderData: FlBorderData(show: false),
// // // // // // //                 titlesData: FlTitlesData(
// // // // // // //                   leftTitles: const AxisTitles(
// // // // // // //                     sideTitles: SideTitles(showTitles: true, reservedSize: 45),
// // // // // // //                   ),
// // // // // // //                   bottomTitles: AxisTitles(
// // // // // // //                     sideTitles: SideTitles(
// // // // // // //                       showTitles: true,
// // // // // // //                       interval: 2,
// // // // // // //                       getTitlesWidget: (value, meta) {
// // // // // // //                         int i = value.toInt();
// // // // // // //                         if (i >= 0 && i < months.length) {
// // // // // // //                           String m = months[i];
// // // // // // //                           if (m.contains("-")) {
// // // // // // //                             m = m.split("-")[1];
// // // // // // //                           }
// // // // // // //                           return Text(m.substring(0, 3),
// // // // // // //                               style: const TextStyle(fontSize: 10));
// // // // // // //                         }
// // // // // // //                         return const SizedBox();
// // // // // // //                       },
// // // // // // //                     ),
// // // // // // //                   ),
// // // // // // //                   topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
// // // // // // //                   rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
// // // // // // //                 ),
// // // // // // //                 lineBarsData: [
// // // // // // //                   LineChartBarData(
// // // // // // //                     spots: actualSpots,
// // // // // // //                     isCurved: true,
// // // // // // //                     color: Colors.blue,
// // // // // // //                     barWidth: 4,
// // // // // // //                     dotData: const FlDotData(show: false),
// // // // // // //                   ),
// // // // // // //                   LineChartBarData(
// // // // // // //                     spots: forecastSpots,
// // // // // // //                     isCurved: true,
// // // // // // //                     color: Colors.green,
// // // // // // //                     barWidth: 4,
// // // // // // //                     dashArray: [6, 4],
// // // // // // //                     dotData: const FlDotData(show: true),
// // // // // // //                   ),
// // // // // // //                 ],
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //           const SizedBox(height: 12),
// // // // // // //           Row(
// // // // // // //             children: [
// // // // // // //               _legend(Colors.blue, "Actual Sales"),
// // // // // // //               const SizedBox(width: 20),
// // // // // // //               _legend(Colors.green, "Forecast"),
// // // // // // //             ],
// // // // // // //           ),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   // =========================================================
// // // // // // //   // UNITS BAR CHART
// // // // // // //   // =========================================================
// // // // // // //   Widget _unitsChart() {
// // // // // // //     const int maxPoints = 12;

// // // // // // //     List<double> units = List.from(historyUnits);
// // // // // // //     List<String> months = List.from(historyMonths);

// // // // // // //     if (units.length > maxPoints) {
// // // // // // //       units = units.sublist(units.length - maxPoints);
// // // // // // //       months = months.sublist(months.length - maxPoints);
// // // // // // //     }

// // // // // // //     if (units.isEmpty) {
// // // // // // //       return Container(
// // // // // // //         height: 420,
// // // // // // //         padding: const EdgeInsets.all(20),
// // // // // // //         decoration: _box(),
// // // // // // //         child: const Center(child: Text("No data")),
// // // // // // //       );
// // // // // // //     }

// // // // // // //     List<BarChartGroupData> bars = [];
// // // // // // //     double maxY = 0;

// // // // // // //     for (int i = 0; i < units.length; i++) {
// // // // // // //       double value = units[i];
// // // // // // //       if (value.isNaN || value.isInfinite) value = 0;
// // // // // // //       if (value > maxY) maxY = value;

// // // // // // //       bars.add(
// // // // // // //         BarChartGroupData(
// // // // // // //           x: i,
// // // // // // //           barRods: [
// // // // // // //             BarChartRodData(
// // // // // // //               toY: value,
// // // // // // //               width: 14,
// // // // // // //               borderRadius: BorderRadius.circular(6),
// // // // // // //               gradient: LinearGradient(
// // // // // // //                 colors: [
// // // // // // //                   Colors.orange.shade300,
// // // // // // //                   Colors.deepOrange.shade400,
// // // // // // //                 ],
// // // // // // //                 begin: Alignment.bottomCenter,
// // // // // // //                 end: Alignment.topCenter,
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //           ],
// // // // // // //         ),
// // // // // // //       );
// // // // // // //     }

// // // // // // //     if (maxY <= 0) maxY = 100;

// // // // // // //     double interval = maxY / 5;
// // // // // // //     if (interval.isNaN || interval.isInfinite || interval <= 0) {
// // // // // // //       interval = 20;
// // // // // // //     }

// // // // // // //     return Container(
// // // // // // //       height: 420,
// // // // // // //       padding: const EdgeInsets.all(20),
// // // // // // //       decoration: _box(),
// // // // // // //       child: Column(
// // // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //         children: [
// // // // // // //           const Text(
// // // // // // //             "Units Sold History",
// // // // // // //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// // // // // // //           ),
// // // // // // //           const SizedBox(height: 10),
// // // // // // //           Text(
// // // // // // //             "Last ${units.length} months trend",
// // // // // // //             style: TextStyle(color: Colors.grey.shade600),
// // // // // // //           ),
// // // // // // //           const SizedBox(height: 20),
// // // // // // //           Expanded(
// // // // // // //             child: BarChart(
// // // // // // //               BarChartData(
// // // // // // //                 minY: 0,
// // // // // // //                 maxY: maxY * 1.2,
// // // // // // //                 borderData: FlBorderData(show: false),
// // // // // // //                 gridData: FlGridData(
// // // // // // //                   show: true,
// // // // // // //                   horizontalInterval: interval,
// // // // // // //                 ),
// // // // // // //                 titlesData: FlTitlesData(
// // // // // // //                   leftTitles: const AxisTitles(
// // // // // // //                     sideTitles: SideTitles(showTitles: true, reservedSize: 35),
// // // // // // //                   ),
// // // // // // //                   bottomTitles: AxisTitles(
// // // // // // //                     sideTitles: SideTitles(
// // // // // // //                       showTitles: true,
// // // // // // //                       interval: 2,
// // // // // // //                       getTitlesWidget: (value, meta) {
// // // // // // //                         int index = value.toInt();
// // // // // // //                         if (index >= 0 && index < months.length) {
// // // // // // //                           String label = months[index];
// // // // // // //                           if (label.contains("-")) {
// // // // // // //                             label = label.split("-")[1];
// // // // // // //                           }
// // // // // // //                           label = label.substring(0, 3);
// // // // // // //                           return Padding(
// // // // // // //                             padding: const EdgeInsets.only(top: 8),
// // // // // // //                             child: Text(label, style: const TextStyle(fontSize: 10)),
// // // // // // //                           );
// // // // // // //                         }
// // // // // // //                         return const SizedBox();
// // // // // // //                       },
// // // // // // //                     ),
// // // // // // //                   ),
// // // // // // //                   topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
// // // // // // //                   rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
// // // // // // //                 ),
// // // // // // //                 barGroups: bars,
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   // =========================================================
// // // // // // //   // COMPARISON SECTION
// // // // // // //   // =========================================================
// // // // // // //   Widget _comparisonSection() {
// // // // // // //     double lastActual = historySales.isNotEmpty ? historySales.last : 0;
// // // // // // //     double change = predictedSales - lastActual;
// // // // // // //     double percent = lastActual == 0 ? 0 : (change / lastActual) * 100;
// // // // // // //     bool growth = change >= 0;

// // // // // // //     return Container(
// // // // // // //       width: double.infinity,
// // // // // // //       padding: const EdgeInsets.all(24),
// // // // // // //       decoration: _box(),
// // // // // // //       child: Column(
// // // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //         children: [
// // // // // // //           const Text(
// // // // // // //             "Actual vs Predicted Analysis",
// // // // // // //             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
// // // // // // //           ),
// // // // // // //           const SizedBox(height: 24),
// // // // // // //           Row(
// // // // // // //             children: [
// // // // // // //               Expanded(child: _comparisonTile("Last Actual", "Rs ${lastActual.toStringAsFixed(0)}", Colors.blue)),
// // // // // // //               const SizedBox(width: 14),
// // // // // // //               Expanded(child: _comparisonTile("Forecast", "Rs ${predictedSales.toStringAsFixed(0)}", Colors.green)),
// // // // // // //               const SizedBox(width: 14),
// // // // // // //               Expanded(
// // // // // // //                 child: _comparisonTile(
// // // // // // //                   "Growth",
// // // // // // //                   "${percent.toStringAsFixed(1)}%",
// // // // // // //                   growth ? Colors.green : Colors.red,
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //             ],
// // // // // // //           ),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   // =========================================================
// // // // // // //   // INSIGHT CARD
// // // // // // //   // =========================================================
// // // // // // //   Widget _insightCard() {
// // // // // // //     double lastActual = historySales.isNotEmpty ? historySales.last : 0;
// // // // // // //     double change = predictedSales - lastActual;
// // // // // // //     double percent = lastActual == 0 ? 0 : (change / lastActual) * 100;
// // // // // // //     bool growth = change >= 0;

// // // // // // //     return Container(
// // // // // // //       width: double.infinity,
// // // // // // //       padding: const EdgeInsets.all(22),
// // // // // // //       decoration: BoxDecoration(
// // // // // // //         color: growth ? Colors.green.shade50 : Colors.red.shade50,
// // // // // // //         borderRadius: BorderRadius.circular(22),
// // // // // // //       ),
// // // // // // //       child: Row(
// // // // // // //         children: [
// // // // // // //           Container(
// // // // // // //             padding: const EdgeInsets.all(14),
// // // // // // //             decoration: BoxDecoration(
// // // // // // //               color: growth ? Colors.green.shade100 : Colors.red.shade100,
// // // // // // //               shape: BoxShape.circle,
// // // // // // //             ),
// // // // // // //             child: Icon(
// // // // // // //               growth ? Icons.trending_up : Icons.trending_down,
// // // // // // //               color: growth ? Colors.green : Colors.red,
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //           const SizedBox(width: 18),
// // // // // // //           Expanded(
// // // // // // //             child: Column(
// // // // // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //               children: [
// // // // // // //                 Text(
// // // // // // //                   growth ? "Positive Sales Forecast" : "Sales Decline Risk",
// // // // // // //                   style: TextStyle(
// // // // // // //                     fontSize: 18,
// // // // // // //                     fontWeight: FontWeight.bold,
// // // // // // //                     color: growth ? Colors.green : Colors.red,
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //                 const SizedBox(height: 8),
// // // // // // //                 Text(
// // // // // // //                   growth
// // // // // // //                       ? "AI predicts approximately ${percent.toStringAsFixed(1)}% growth compared to the latest actual sales performance."
// // // // // // //                       : "AI predicts approximately ${percent.abs().toStringAsFixed(1)}% decline compared to historical sales performance.",
// // // // // // //                 ),
// // // // // // //               ],
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   // =========================================================
// // // // // // //   // ANALYTICS CARD
// // // // // // //   // =========================================================
// // // // // // //   Widget _analyticsCard(String title, String value, IconData icon, Color color) {
// // // // // // //     return Container(
// // // // // // //       padding: const EdgeInsets.all(18),
// // // // // // //       decoration: _box(),
// // // // // // //       child: Column(
// // // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //         children: [
// // // // // // //           Container(
// // // // // // //             padding: const EdgeInsets.all(10),
// // // // // // //             decoration: BoxDecoration(
// // // // // // //               color: color.withOpacity(0.1),
// // // // // // //               borderRadius: BorderRadius.circular(14),
// // // // // // //             ),
// // // // // // //             child: Icon(icon, color: color),
// // // // // // //           ),
// // // // // // //           const SizedBox(height: 18),
// // // // // // //           Text(title, style: TextStyle(color: Colors.grey.shade700)),
// // // // // // //           const SizedBox(height: 8),
// // // // // // //           Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   // =========================================================
// // // // // // //   // HEADER STATS
// // // // // // //   // =========================================================
// // // // // // //   Widget _topStat(String title, String value, IconData icon) {
// // // // // // //     return Container(
// // // // // // //       padding: const EdgeInsets.all(16),
// // // // // // //       decoration: BoxDecoration(
// // // // // // //         color: Colors.white.withOpacity(0.15),
// // // // // // //         borderRadius: BorderRadius.circular(18),
// // // // // // //       ),
// // // // // // //       child: Column(
// // // // // // //         children: [
// // // // // // //           Icon(icon, color: Colors.white),
// // // // // // //           const SizedBox(height: 10),
// // // // // // //           Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
// // // // // // //           const SizedBox(height: 4),
// // // // // // //           Text(title, textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(0.9))),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   // =========================================================
// // // // // // //   // COMPARISON TILE
// // // // // // //   // =========================================================
// // // // // // //   Widget _comparisonTile(String title, String value, Color color) {
// // // // // // //     return Container(
// // // // // // //       padding: const EdgeInsets.all(18),
// // // // // // //       decoration: BoxDecoration(
// // // // // // //         color: color.withOpacity(0.08),
// // // // // // //         borderRadius: BorderRadius.circular(18),
// // // // // // //       ),
// // // // // // //       child: Column(
// // // // // // //         children: [
// // // // // // //           Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
// // // // // // //           const SizedBox(height: 10),
// // // // // // //           Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   // =========================================================
// // // // // // //   // LEGEND
// // // // // // //   // =========================================================
// // // // // // //   Widget _legend(Color color, String text) {
// // // // // // //     return Row(
// // // // // // //       children: [
// // // // // // //         Container(width: 14, height: 14, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
// // // // // // //         const SizedBox(width: 8),
// // // // // // //         Text(text),
// // // // // // //       ],
// // // // // // //     );
// // // // // // //   }

// // // // // // //   // =========================================================
// // // // // // //   // DROPDOWN
// // // // // // //   // =========================================================
// // // // // // //   Widget _dropdown(String label, List<String> items, String? value, Function(String?) onChanged) {
// // // // // // //     return Padding(
// // // // // // //       padding: const EdgeInsets.only(bottom: 14),
// // // // // // //       child: DropdownButtonFormField<String>(
// // // // // // //         value: items.contains(value) ? value : null,
// // // // // // //         items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
// // // // // // //         onChanged: onChanged,
// // // // // // //         decoration: InputDecoration(
// // // // // // //           labelText: label,
// // // // // // //           filled: true,
// // // // // // //           fillColor: Colors.grey.shade100,
// // // // // // //           border: OutlineInputBorder(
// // // // // // //             borderRadius: BorderRadius.circular(16),
// // // // // // //             borderSide: BorderSide.none,
// // // // // // //           ),
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   // =========================================================
// // // // // // //   // COMMON BOX
// // // // // // //   // =========================================================
// // // // // // //   BoxDecoration _box() {
// // // // // // //     return BoxDecoration(
// // // // // // //       color: Colors.white,
// // // // // // //       borderRadius: BorderRadius.circular(24),
// // // // // // //       boxShadow: [
// // // // // // //         BoxShadow(
// // // // // // //           color: Colors.black.withOpacity(0.04),
// // // // // // //           blurRadius: 10,
// // // // // // //           offset: const Offset(0, 4),
// // // // // // //         ),
// // // // // // //       ],
// // // // // // //     );
// // // // // // //   }

// // // // // // //   // =========================================================
// // // // // // //   // BUILD
// // // // // // //   // =========================================================
// // // // // // //   @override
// // // // // // //   Widget build(BuildContext context) {
// // // // // // //     return Scaffold(
// // // // // // //       backgroundColor: const Color(0xffF4F7FC),
// // // // // // //       appBar: AppBar(
// // // // // // //         elevation: 0,
// // // // // // //         backgroundColor: Colors.white,
// // // // // // //         foregroundColor: Colors.black,
// // // // // // //         title: const Text(
// // // // // // //           "AI Forecast Dashboard",
// // // // // // //           style: TextStyle(fontWeight: FontWeight.bold),
// // // // // // //         ),
// // // // // // //         actions: [
// // // // // // //           _refreshPricesButton(),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //       body: SingleChildScrollView(
// // // // // // //         padding: const EdgeInsets.all(20),
// // // // // // //         child: Column(
// // // // // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //           children: [
// // // // // // //             Container(
// // // // // // //               width: double.infinity,
// // // // // // //               padding: const EdgeInsets.all(24),
// // // // // // //               decoration: BoxDecoration(
// // // // // // //                 gradient: LinearGradient(
// // // // // // //                   colors: [Colors.blue.shade700, Colors.indigo.shade600],
// // // // // // //                   begin: Alignment.topLeft,
// // // // // // //                   end: Alignment.bottomRight,
// // // // // // //                 ),
// // // // // // //                 borderRadius: BorderRadius.circular(28),
// // // // // // //               ),
// // // // // // //               child: Column(
// // // // // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //                 children: [
// // // // // // //                   const Text(
// // // // // // //                     "AI Retail Analytics",
// // // // // // //                     style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
// // // // // // //                   ),
// // // // // // //                   const SizedBox(height: 12),
// // // // // // //                   Text(
// // // // // // //                     "Advanced machine learning forecasting system for inventory intelligence",
// // // // // // //                     style: TextStyle(color: Colors.white.withOpacity(0.92), height: 1.5),
// // // // // // //                   ),
// // // // // // //                   const SizedBox(height: 24),
// // // // // // //                   Row(
// // // // // // //                     children: [
// // // // // // //                       Expanded(child: _topStat("Accuracy", "${accuracy.toStringAsFixed(1)}%", Icons.analytics)),
// // // // // // //                       const SizedBox(width: 14),
// // // // // // //                       Expanded(child: _topStat("Forecast Units", predictedUnits.toStringAsFixed(0), Icons.inventory_2)),
// // // // // // //                     ],
// // // // // // //                   ),
// // // // // // //                 ],
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //             const SizedBox(height: 24),
// // // // // // //             _controlCard(),
// // // // // // //             const SizedBox(height: 24),
// // // // // // //             if (historySales.isNotEmpty) ...[
// // // // // // //               Row(
// // // // // // //                 children: [
// // // // // // //                   Expanded(child: _analyticsCard("Predicted Revenue", "Rs ${predictedSales.toStringAsFixed(0)}", Icons.currency_rupee, Colors.blue)),
// // // // // // //                   const SizedBox(width: 14),
// // // // // // //                   Expanded(child: _analyticsCard("Latest Units", latestUnits.toStringAsFixed(0), Icons.shopping_cart, Colors.orange)),
// // // // // // //                   const SizedBox(width: 14),
// // // // // // //                   Expanded(child: _analyticsCard("Rolling Average", rollingAvg.toStringAsFixed(0), Icons.show_chart, Colors.green)),
// // // // // // //                 ],
// // // // // // //               ),
// // // // // // //               const SizedBox(height: 24),
// // // // // // //               Row(
// // // // // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //                 children: [
// // // // // // //                   Expanded(flex: 2, child: _salesChart()),
// // // // // // //                   const SizedBox(width: 18),
// // // // // // //                   Expanded(child: _unitsChart()),
// // // // // // //                 ],
// // // // // // //               ),
// // // // // // //               const SizedBox(height: 24),
// // // // // // //               _comparisonSection(),
// // // // // // //               const SizedBox(height: 24),
// // // // // // //               _insightCard(),
// // // // // // //             ],
// // // // // // //           ],
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // // }
// // // // // // import 'dart:convert';
// // // // // // import 'package:fl_chart/fl_chart.dart';
// // // // // // import 'package:flutter/material.dart';
// // // // // // import 'package:http/http.dart' as http;
// // // // // // import 'package:cloud_firestore/cloud_firestore.dart';

// // // // // // class PredictionPage extends StatefulWidget {
// // // // // //   const PredictionPage({super.key});

// // // // // //   @override
// // // // // //   State<PredictionPage> createState() => _PredictionPageState();
// // // // // // }

// // // // // // class _PredictionPageState extends State<PredictionPage> {

// // // // // //   // =========================================================
// // // // // //   // DATA
// // // // // //   // =========================================================

// // // // // //   List<double> historySales = [];
// // // // // //   List<double> historyUnits = [];
// // // // // //   List<String> historyMonths = [];

// // // // // //   List<String> categories = [];
// // // // // //   List<String> products = [];
// // // // // //   List<String> months = [];

// // // // // //   String? selectedCategory;
// // // // // //   String? selectedProduct;
// // // // // //   String? selectedMonth;

// // // // // //   bool loading = false;

// // // // // //   // =========================================================
// // // // // //   // ML RESULTS
// // // // // //   // =========================================================

// // // // // //   double predictedSales = 0;
// // // // // //   double predictedUnits = 0;
// // // // // //   double latestUnits = 0;
// // // // // //   double rollingAvg = 0;
// // // // // //   double accuracy = 0;

// // // // // //   final TextEditingController priceController = TextEditingController(text: "500");

// // // // // //   final String baseUrl = "http://192.168.100.218:5000";
// // // // // //   final FirebaseFirestore firestore = FirebaseFirestore.instance;

// // // // // //   // Cache for prices to avoid repeated Firebase calls
// // // // // //   final Map<String, double> _priceCache = {};

// // // // // //   // =========================================================
// // // // // //   // INIT
// // // // // //   // =========================================================

// // // // // //   @override
// // // // // //   void initState() {
// // // // // //     super.initState();
// // // // // //     initialize();
// // // // // //   }

// // // // // //   Future<void> initialize() async {
// // // // // //     await loadCategories();
// // // // // //     await loadMonths();
// // // // // //   }

// // // // // //   // =========================================================
// // // // // //   // IMPROVED PRICE FETCHING WITH MULTIPLE STRATEGIES
// // // // // //   // =========================================================
// // // // // //   Future<double> fetchProductPrice(String product, String category) async {
// // // // // //     // Check cache first
// // // // // //     String cacheKey = "$category|$product";
// // // // // //     if (_priceCache.containsKey(cacheKey)) {
// // // // // //       return _priceCache[cacheKey]!;
// // // // // //     }

// // // // // //     double price = 500; // Default fallback price

// // // // // //     try {
// // // // // //       // Strategy 1: Try exact match in inventory collection
// // // // // //       QuerySnapshot exactMatch = await firestore
// // // // // //           .collection("inventory")
// // // // // //           .where("product", isEqualTo: product)
// // // // // //           .where("category", isEqualTo: category)
// // // // // //           .limit(1)
// // // // // //           .get();
      
// // // // // //       if (exactMatch.docs.isNotEmpty) {
// // // // // //         price = (exactMatch.docs.first.data() as Map<String, dynamic>)["price"]?.toDouble() ?? 500;
// // // // // //         _priceCache[cacheKey] = price;
// // // // // //         debugPrint("✅ Price found for $product: ₹$price (exact match)");
// // // // // //         return price;
// // // // // //       }

// // // // // //       // Strategy 2: Try case-insensitive search
// // // // // //       QuerySnapshot caseInsensitive = await firestore
// // // // // //           .collection("inventory")
// // // // // //           .where("product", isEqualTo: product.toLowerCase())
// // // // // //           .where("category", isEqualTo: category.toLowerCase())
// // // // // //           .limit(1)
// // // // // //           .get();
      
// // // // // //       if (caseInsensitive.docs.isNotEmpty) {
// // // // // //         price = (caseInsensitive.docs.first.data() as Map<String, dynamic>)["price"]?.toDouble() ?? 500;
// // // // // //         _priceCache[cacheKey] = price;
// // // // // //         debugPrint("✅ Price found for $product: ₹$price (case-insensitive)");
// // // // // //         return price;
// // // // // //       }

// // // // // //       // Strategy 3: Search by product only (ignore category)
// // // // // //       QuerySnapshot productOnly = await firestore
// // // // // //           .collection("inventory")
// // // // // //           .where("product", isEqualTo: product)
// // // // // //           .limit(1)
// // // // // //           .get();
      
// // // // // //       if (productOnly.docs.isNotEmpty) {
// // // // // //         price = (productOnly.docs.first.data() as Map<String, dynamic>)["price"]?.toDouble() ?? 500;
// // // // // //         _priceCache[cacheKey] = price;
// // // // // //         debugPrint("✅ Price found for $product: ₹$price (product only)");
// // // // // //         return price;
// // // // // //       }

// // // // // //       // Strategy 4: Try to find similar product names
// // // // // //       QuerySnapshot allProducts = await firestore
// // // // // //           .collection("inventory")
// // // // // //           .limit(20)
// // // // // //           .get();
      
// // // // // //       double bestMatchPrice = 500;
// // // // // //       double bestMatchScore = 0;
      
// // // // // //       for (var doc in allProducts.docs) {
// // // // // //         String dbProduct = (doc.data() as Map<String, dynamic>)["product"]?.toString().toLowerCase() ?? "";
// // // // // //         String dbCategory = (doc.data() as Map<String, dynamic>)["category"]?.toString().toLowerCase() ?? "";
        
// // // // // //         double score = 0;
// // // // // //         if (dbProduct.contains(product.toLowerCase())) score += 0.7;
// // // // // //         if (product.toLowerCase().contains(dbProduct)) score += 0.5;
// // // // // //         if (dbCategory == category.toLowerCase()) score += 0.3;
        
// // // // // //         if (score > bestMatchScore && score > 0.5) {
// // // // // //           bestMatchScore = score;
// // // // // //           bestMatchPrice = (doc.data() as Map<String, dynamic>)["price"]?.toDouble() ?? 500;
// // // // // //         }
// // // // // //       }
      
// // // // // //       if (bestMatchScore > 0) {
// // // // // //         price = bestMatchPrice;
// // // // // //         _priceCache[cacheKey] = price;
// // // // // //         debugPrint("✅ Similar product found for $product: ₹$price (similarity: ${(bestMatchScore * 100).toInt()}%)");
// // // // // //         return price;
// // // // // //       }

// // // // // //       // Strategy 5: Use category average price
// // // // // //       QuerySnapshot categoryProducts = await firestore
// // // // // //           .collection("inventory")
// // // // // //           .where("category", isEqualTo: category)
// // // // // //           .get();
      
// // // // // //       if (categoryProducts.docs.isNotEmpty) {
// // // // // //         double total = 0;
// // // // // //         int count = 0;
// // // // // //         for (var doc in categoryProducts.docs) {
// // // // // //           double p = (doc.data() as Map<String, dynamic>)["price"]?.toDouble() ?? 0;
// // // // // //           if (p > 0) {
// // // // // //             total += p;
// // // // // //             count++;
// // // // // //           }
// // // // // //         }
// // // // // //         if (count > 0) {
// // // // // //           price = total / count;
// // // // // //           _priceCache[cacheKey] = price;
// // // // // //           debugPrint("✅ Using category average for $product: ₹${price.toStringAsFixed(0)}");
// // // // // //           return price;
// // // // // //         }
// // // // // //       }

// // // // // //       debugPrint("⚠️ No price found for $product, using default ₹500");
      
// // // // // //     } catch (e) {
// // // // // //       debugPrint("❌ Error fetching price for $product: $e");
// // // // // //     }
    
// // // // // //     _priceCache[cacheKey] = price;
// // // // // //     return price;
// // // // // //   }

// // // // // //   // =========================================================
// // // // // //   // BULK PRICE LOADING FOR ALL PRODUCTS IN CATEGORY
// // // // // //   // =========================================================
// // // // // //   Future<Map<String, double>> loadAllProductPrices(String category) async {
// // // // // //     Map<String, double> priceMap = {};
    
// // // // // //     try {
// // // // // //       QuerySnapshot snapshot = await firestore
// // // // // //           .collection("inventory")
// // // // // //           .where("category", isEqualTo: category)
// // // // // //           .get();
      
// // // // // //       for (var doc in snapshot.docs) {
// // // // // //         String product = (doc.data() as Map<String, dynamic>)["product"]?.toString() ?? "";
// // // // // //         double price = (doc.data() as Map<String, dynamic>)["price"]?.toDouble() ?? 0;
// // // // // //         if (product.isNotEmpty && price > 0) {
// // // // // //           priceMap[product] = price;
// // // // // //         }
// // // // // //       }
      
// // // // // //       debugPrint("📦 Loaded ${priceMap.length} prices for category: $category");
// // // // // //     } catch (e) {
// // // // // //       debugPrint("Error bulk loading prices: $e");
// // // // // //     }
    
// // // // // //     return priceMap;
// // // // // //   }

// // // // // //   // =========================================================
// // // // // //   // FETCH LIST
// // // // // //   // =========================================================

// // // // // //   Future<List<String>> fetchList(String endpoint, String key) async {
// // // // // //     try {
// // // // // //       final res = await http.get(Uri.parse("$baseUrl/$endpoint"));
// // // // // //       final data = jsonDecode(res.body);
// // // // // //       return List<String>.from(data[key] ?? []);
// // // // // //     } catch (_) {
// // // // // //       return [];
// // // // // //     }
// // // // // //   }

// // // // // //   Future<void> loadCategories() async {
// // // // // //     categories = await fetchList("categories", "categories");

// // // // // //     setState(() {
// // // // // //       selectedCategory = categories.isNotEmpty ? categories.first : null;
// // // // // //       selectedProduct = null;
// // // // // //       products = [];
// // // // // //     });

// // // // // //     if (selectedCategory != null) {
// // // // // //       await loadProducts(selectedCategory!);
// // // // // //     }
// // // // // //   }

// // // // // //   Future<void> loadProducts(String category) async {
// // // // // //     try {
// // // // // //       final res = await http.get(
// // // // // //         Uri.parse("$baseUrl/products?category=$category"),
// // // // // //       );

// // // // // //       final data = jsonDecode(res.body);

// // // // // //       setState(() {
// // // // // //         products = List<String>.from(data["products"] ?? []);
// // // // // //         selectedProduct = products.isNotEmpty ? products.first : null;
// // // // // //       });
      
// // // // // //       // Bulk load prices for all products in this category
// // // // // //       Map<String, double> priceMap = await loadAllProductPrices(category);
      
// // // // // //       // Fetch price for the first product
// // // // // //       if (selectedProduct != null && selectedCategory != null) {
// // // // // //         double price;
// // // // // //         if (priceMap.containsKey(selectedProduct)) {
// // // // // //           price = priceMap[selectedProduct]!;
// // // // // //         } else {
// // // // // //           price = await fetchProductPrice(selectedProduct!, selectedCategory!);
// // // // // //         }
// // // // // //         priceController.text = price.toStringAsFixed(0);
// // // // // //       }
// // // // // //     } catch (_) {
// // // // // //       setState(() {
// // // // // //         products = [];
// // // // // //         selectedProduct = null;
// // // // // //       });
// // // // // //     }
// // // // // //   }

// // // // // //   Future<void> loadMonths() async {
// // // // // //     months = await fetchList("months", "months");

// // // // // //     setState(() {
// // // // // //       selectedMonth = months.isNotEmpty ? months.last : null;
// // // // // //     });
// // // // // //   }

// // // // // //   int getMonthIndex(String month) {
// // // // // //     const monthOrder = [
// // // // // //       "jan","feb","mar","apr","may","jun",
// // // // // //       "jul","aug","sep","oct","nov","dec",
// // // // // //     ];

// // // // // //     String shortMonth = month.toLowerCase().substring(0, 3);
// // // // // //     return monthOrder.indexOf(shortMonth);
// // // // // //   }

// // // // // //   // =========================================================
// // // // // //   // PREDICT + FIRESTORE SAVE
// // // // // //   // =========================================================
// // // // // //   Future<void> predict() async {
// // // // // //     if (selectedCategory == null || selectedProduct == null || selectedMonth == null) {
// // // // // //       return;
// // // // // //     }

// // // // // //     setState(() => loading = true);

// // // // // //     try {
// // // // // //       final res = await http.post(
// // // // // //         Uri.parse("$baseUrl/predict"),
// // // // // //         headers: {"Content-Type": "application/json"},
// // // // // //         body: jsonEncode({
// // // // // //           "category": selectedCategory,
// // // // // //           "product": selectedProduct,
// // // // // //           "month": selectedMonth,
// // // // // //           "price": double.tryParse(priceController.text) ?? 0,
// // // // // //         }),
// // // // // //       );

// // // // // //       final data = jsonDecode(res.body);

// // // // // //       List<String> rawMonths = List<String>.from(data["history_months"] ?? []);
// // // // // //       List<double> rawSales = List<double>.from((data["history_sales"] ?? [])
// // // // // //           .map((e) => (e as num).toDouble()));
// // // // // //       List<double> rawUnits = List<double>.from((data["history_units"] ?? [])
// // // // // //           .map((e) => (e as num).toDouble()));

// // // // // //       List<Map<String, dynamic>> combined = [];

// // // // // //       for (int i = 0; i < rawMonths.length; i++) {
// // // // // //         combined.add({
// // // // // //           "month": rawMonths[i],
// // // // // //           "sales": i < rawSales.length ? rawSales[i] : 0,
// // // // // //           "units": i < rawUnits.length ? rawUnits[i] : 0,
// // // // // //         });
// // // // // //       }

// // // // // //       const int maxPoints = 12;

// // // // // //       if (historySales.length > maxPoints) {
// // // // // //         historySales = historySales.sublist(historySales.length - maxPoints);
// // // // // //         historyUnits = historyUnits.sublist(historyUnits.length - maxPoints);
// // // // // //         historyMonths = historyMonths.sublist(historyMonths.length - maxPoints);
// // // // // //       }

// // // // // //       combined.sort((a, b) {
// // // // // //         try {
// // // // // //           final aParts = a["month"].toString().split("-");
// // // // // //           final bParts = b["month"].toString().split("-");

// // // // // //           int aYear = int.parse(aParts[0]);
// // // // // //           int bYear = int.parse(bParts[0]);

// // // // // //           int aMonth = getMonthIndex(aParts[1]);
// // // // // //           int bMonth = getMonthIndex(bParts[1]);

// // // // // //           if (aYear != bYear) {
// // // // // //             return aYear.compareTo(bYear);
// // // // // //           }

// // // // // //           return aMonth.compareTo(bMonth);
// // // // // //         } catch (_) {
// // // // // //           return 0;
// // // // // //         }
// // // // // //       });

// // // // // //       historyMonths = combined.map((e) => e["month"].toString()).toList();
// // // // // //       historySales = combined.map((e) => (e["sales"] as num).toDouble()).toList();
// // // // // //       historyUnits = combined.map((e) => (e["units"] as num).toDouble()).toList();

// // // // // //       setState(() {
// // // // // //         predictedSales = (data["predicted_sales"] ?? 0).toDouble();
// // // // // //         predictedUnits = (data["predicted_units"] ?? 0).toDouble();
// // // // // //         latestUnits = (data["latest_units"] ?? data["latest_units_used"] ?? 0).toDouble();
// // // // // //         rollingAvg = (data["rolling_avg"] ?? data["rolling_avg_used"] ?? 0).toDouble();
// // // // // //         accuracy = ((data["accuracy"] ?? 0) * 100).toDouble();
// // // // // //         loading = false;
// // // // // //       });

// // // // // //       await firestore.collection("prediction_history").add({
// // // // // //         "category": selectedCategory,
// // // // // //         "product": selectedProduct,
// // // // // //         "month": selectedMonth,
// // // // // //         "price": double.tryParse(priceController.text) ?? 0,
// // // // // //         "predicted_sales": predictedSales,
// // // // // //         "predicted_units": predictedUnits,
// // // // // //         "created_at": FieldValue.serverTimestamp(),
// // // // // //       });

// // // // // //       final docId = "${selectedProduct}_${selectedCategory}".replaceAll(" ", "_");

// // // // // //       await firestore
// // // // // //           .collection("inventory_predictions")
// // // // // //           .doc(docId)
// // // // // //           .set({
// // // // // //         "product": selectedProduct,
// // // // // //         "category": selectedCategory,
// // // // // //         "month": selectedMonth,
// // // // // //         "predicted_units": predictedUnits,
// // // // // //         "predicted_sales": predictedSales,
// // // // // //         "updated_at": FieldValue.serverTimestamp(),
// // // // // //       });
// // // // // //     } catch (e) {
// // // // // //       setState(() => loading = false);
// // // // // //       debugPrint(e.toString());
// // // // // //     }
// // // // // //   }

// // // // // //   // =========================================================
// // // // // //   // CONTROL CARD WITH PRICE EDIT OPTION
// // // // // //   // =========================================================
// // // // // //   Widget _controlCard() {
// // // // // //     return Container(
// // // // // //       padding: const EdgeInsets.all(22),
// // // // // //       decoration: _box(),
// // // // // //       child: Column(
// // // // // //         children: [
// // // // // //           _dropdown(
// // // // // //             "Category",
// // // // // //             categories,
// // // // // //             selectedCategory,
// // // // // //             (v) async {
// // // // // //               setState(() {
// // // // // //                 selectedCategory = v;
// // // // // //                 selectedProduct = null;
// // // // // //                 products = [];
// // // // // //               });
// // // // // //               if (v != null) {
// // // // // //                 await loadProducts(v);
// // // // // //               }
// // // // // //             },
// // // // // //           ),

// // // // // //           _dropdown(
// // // // // //             "Product",
// // // // // //             products,
// // // // // //             selectedProduct,
// // // // // //             (v) async {
// // // // // //               setState(() {
// // // // // //                 selectedProduct = v;
// // // // // //               });
              
// // // // // //               // Fetch price when product is selected
// // // // // //               if (v != null && selectedCategory != null) {
// // // // // //                 final price = await fetchProductPrice(v, selectedCategory!);
// // // // // //                 priceController.text = price.toStringAsFixed(0);
                
// // // // // //                 // Show a snackbar if using default price
// // // // // //                 if (price == 500) {
// // // // // //                   if (mounted) {
// // // // // //                     ScaffoldMessenger.of(context).showSnackBar(
// // // // // //                       SnackBar(
// // // // // //                         content: Text("⚠️ No price found for $v, using default ₹500. You can edit it."),
// // // // // //                         backgroundColor: Colors.orange,
// // // // // //                         duration: const Duration(seconds: 3),
// // // // // //                       ),
// // // // // //                     );
// // // // // //                   }
// // // // // //                 } else {
// // // // // //                   if (mounted) {
// // // // // //                     ScaffoldMessenger.of(context).showSnackBar(
// // // // // //                       SnackBar(
// // // // // //                         content: Text("✅ Price loaded: ₹${price.toStringAsFixed(0)} for $v"),
// // // // // //                         backgroundColor: Colors.green,
// // // // // //                         duration: const Duration(seconds: 2),
// // // // // //                       ),
// // // // // //                     );
// // // // // //                   }
// // // // // //                 }
// // // // // //               }
// // // // // //             },
// // // // // //           ),

// // // // // //           _dropdown(
// // // // // //             "Forecast Month",
// // // // // //             months,
// // // // // //             selectedMonth,
// // // // // //             (v) {
// // // // // //               setState(() {
// // // // // //                 selectedMonth = v;
// // // // // //               });
// // // // // //             },
// // // // // //           ),

// // // // // //           const SizedBox(height: 12),

// // // // // //           TextField(
// // // // // //             controller: priceController,
// // // // // //             keyboardType: TextInputType.number,
// // // // // //             decoration: InputDecoration(
// // // // // //               labelText: "Unit Price (₹)",
// // // // // //               prefixIcon: const Icon(Icons.currency_rupee),
// // // // // //               hintText: "Auto-loaded or manual entry",
// // // // // //               helperText: "Price auto-loaded from inventory or you can edit",
// // // // // //               helperStyle: TextStyle(fontSize: 10, color: Colors.grey.shade500),
// // // // // //               filled: true,
// // // // // //               fillColor: Colors.grey.shade100,
// // // // // //               border: OutlineInputBorder(
// // // // // //                 borderRadius: BorderRadius.circular(16),
// // // // // //                 borderSide: BorderSide.none,
// // // // // //               ),
// // // // // //             ),
// // // // // //           ),

// // // // // //           const SizedBox(height: 22),

// // // // // //           SizedBox(
// // // // // //             width: double.infinity,
// // // // // //             height: 54,
// // // // // //             child: ElevatedButton(
// // // // // //               onPressed: loading ? null : predict,
// // // // // //               style: ElevatedButton.styleFrom(
// // // // // //                 backgroundColor: Colors.blue.shade700,
// // // // // //                 shape: RoundedRectangleBorder(
// // // // // //                   borderRadius: BorderRadius.circular(16),
// // // // // //                 ),
// // // // // //               ),
// // // // // //               child: loading
// // // // // //                   ? const CircularProgressIndicator(color: Colors.white)
// // // // // //                   : const Text(
// // // // // //                       "RUN AI FORECAST",
// // // // // //                       style: TextStyle(
// // // // // //                         fontSize: 16,
// // // // // //                         fontWeight: FontWeight.bold,
// // // // // //                       ),
// // // // // //                     ),
// // // // // //             ),
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   // Add this button to manually refresh prices
// // // // // //   Widget _refreshPricesButton() {
// // // // // //     return IconButton(
// // // // // //       icon: const Icon(Icons.refresh),
// // // // // //       onPressed: () async {
// // // // // //         if (selectedCategory != null) {
// // // // // //           await loadProducts(selectedCategory!);
// // // // // //           if (mounted) {
// // // // // //             ScaffoldMessenger.of(context).showSnackBar(
// // // // // //               const SnackBar(content: Text("Prices refreshed from database")),
// // // // // //             );
// // // // // //           }
// // // // // //         }
// // // // // //       },
// // // // // //       tooltip: "Refresh prices from database",
// // // // // //     );
// // // // // //   }

// // // // // //   // =========================================================
// // // // // //   // SALES CHART
// // // // // //   // =========================================================
// // // // // //   Widget _salesChart() {
// // // // // //     const int maxPoints = 12;

// // // // // //     List<double> sales = List.from(historySales);
// // // // // //     List<String> months = List.from(historyMonths);

// // // // // //     if (sales.length > maxPoints) {
// // // // // //       sales = sales.sublist(sales.length - maxPoints);
// // // // // //       months = months.sublist(months.length - maxPoints);
// // // // // //     }

// // // // // //     if (sales.isEmpty) {
// // // // // //       return Container(
// // // // // //         height: 420,
// // // // // //         padding: const EdgeInsets.all(20),
// // // // // //         decoration: _box(),
// // // // // //         child: const Center(child: Text("No data")),
// // // // // //       );
// // // // // //     }

// // // // // //     List<FlSpot> actualSpots = [];

// // // // // //     for (int i = 0; i < sales.length; i++) {
// // // // // //       double v = sales[i];
// // // // // //       if (v.isNaN || v.isInfinite) v = 0;
// // // // // //       actualSpots.add(FlSpot(i.toDouble(), v));
// // // // // //     }

// // // // // //     double safePrediction = predictedSales;
// // // // // //     if (safePrediction.isNaN || safePrediction.isInfinite || safePrediction <= 0) {
// // // // // //       safePrediction = sales.last;
// // // // // //     }

// // // // // //     final predictionSpot = FlSpot(sales.length.toDouble(), safePrediction);
// // // // // //     List<FlSpot> forecastSpots = [
// // // // // //       actualSpots.last,
// // // // // //       predictionSpot,
// // // // // //     ];

// // // // // //     double maxY = sales.reduce((a, b) => a > b ? a : b);
// // // // // //     if (safePrediction > maxY) maxY = safePrediction;
// // // // // //     if (maxY <= 0) maxY = 100;

// // // // // //     double interval = maxY / 5;
// // // // // //     if (interval.isNaN || interval.isInfinite || interval <= 0) {
// // // // // //       interval = 20;
// // // // // //     }

// // // // // //     return Container(
// // // // // //       height: 420,
// // // // // //       padding: const EdgeInsets.all(20),
// // // // // //       decoration: _box(),
// // // // // //       child: Column(
// // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //         children: [
// // // // // //           const Text(
// // // // // //             "Actual Sales vs Forecast",
// // // // // //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// // // // // //           ),
// // // // // //           const SizedBox(height: 20),
// // // // // //           Expanded(
// // // // // //             child: LineChart(
// // // // // //               LineChartData(
// // // // // //                 minY: 0,
// // // // // //                 maxY: maxY * 1.2,
// // // // // //                 gridData: FlGridData(
// // // // // //                   show: true,
// // // // // //                   horizontalInterval: interval,
// // // // // //                 ),
// // // // // //                 borderData: FlBorderData(show: false),
// // // // // //                 titlesData: FlTitlesData(
// // // // // //                   leftTitles: const AxisTitles(
// // // // // //                     sideTitles: SideTitles(showTitles: true, reservedSize: 45),
// // // // // //                   ),
// // // // // //                   bottomTitles: AxisTitles(
// // // // // //                     sideTitles: SideTitles(
// // // // // //                       showTitles: true,
// // // // // //                       interval: 2,
// // // // // //                       getTitlesWidget: (value, meta) {
// // // // // //                         int i = value.toInt();
// // // // // //                         if (i >= 0 && i < months.length) {
// // // // // //                           String m = months[i];
// // // // // //                           if (m.contains("-")) {
// // // // // //                             m = m.split("-")[1];
// // // // // //                           }
// // // // // //                           return Text(m.substring(0, 3),
// // // // // //                               style: const TextStyle(fontSize: 10));
// // // // // //                         }
// // // // // //                         return const SizedBox();
// // // // // //                       },
// // // // // //                     ),
// // // // // //                   ),
// // // // // //                   topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
// // // // // //                   rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
// // // // // //                 ),
// // // // // //                 lineBarsData: [
// // // // // //                   LineChartBarData(
// // // // // //                     spots: actualSpots,
// // // // // //                     isCurved: true,
// // // // // //                     color: Colors.blue,
// // // // // //                     barWidth: 4,
// // // // // //                     dotData: const FlDotData(show: false),
// // // // // //                   ),
// // // // // //                   LineChartBarData(
// // // // // //                     spots: forecastSpots,
// // // // // //                     isCurved: true,
// // // // // //                     color: Colors.green,
// // // // // //                     barWidth: 4,
// // // // // //                     dashArray: [6, 4],
// // // // // //                     dotData: const FlDotData(show: true),
// // // // // //                   ),
// // // // // //                 ],
// // // // // //               ),
// // // // // //             ),
// // // // // //           ),
// // // // // //           const SizedBox(height: 12),
// // // // // //           Row(
// // // // // //             children: [
// // // // // //               _legend(Colors.blue, "Actual Sales"),
// // // // // //               const SizedBox(width: 20),
// // // // // //               _legend(Colors.green, "Forecast"),
// // // // // //             ],
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   // =========================================================
// // // // // //   // UNITS BAR CHART
// // // // // //   // =========================================================
// // // // // //   Widget _unitsChart() {
// // // // // //     const int maxPoints = 12;

// // // // // //     List<double> units = List.from(historyUnits);
// // // // // //     List<String> months = List.from(historyMonths);

// // // // // //     if (units.length > maxPoints) {
// // // // // //       units = units.sublist(units.length - maxPoints);
// // // // // //       months = months.sublist(months.length - maxPoints);
// // // // // //     }

// // // // // //     if (units.isEmpty) {
// // // // // //       return Container(
// // // // // //         height: 420,
// // // // // //         padding: const EdgeInsets.all(20),
// // // // // //         decoration: _box(),
// // // // // //         child: const Center(child: Text("No data")),
// // // // // //       );
// // // // // //     }

// // // // // //     List<BarChartGroupData> bars = [];
// // // // // //     double maxY = 0;

// // // // // //     for (int i = 0; i < units.length; i++) {
// // // // // //       double value = units[i];
// // // // // //       if (value.isNaN || value.isInfinite) value = 0;
// // // // // //       if (value > maxY) maxY = value;

// // // // // //       bars.add(
// // // // // //         BarChartGroupData(
// // // // // //           x: i,
// // // // // //           barRods: [
// // // // // //             BarChartRodData(
// // // // // //               toY: value,
// // // // // //               width: 14,
// // // // // //               borderRadius: BorderRadius.circular(6),
// // // // // //               gradient: LinearGradient(
// // // // // //                 colors: [
// // // // // //                   Colors.orange.shade300,
// // // // // //                   Colors.deepOrange.shade400,
// // // // // //                 ],
// // // // // //                 begin: Alignment.bottomCenter,
// // // // // //                 end: Alignment.topCenter,
// // // // // //               ),
// // // // // //             ),
// // // // // //           ],
// // // // // //         ),
// // // // // //       );
// // // // // //     }

// // // // // //     if (maxY <= 0) maxY = 100;

// // // // // //     double interval = maxY / 5;
// // // // // //     if (interval.isNaN || interval.isInfinite || interval <= 0) {
// // // // // //       interval = 20;
// // // // // //     }

// // // // // //     return Container(
// // // // // //       height: 420,
// // // // // //       padding: const EdgeInsets.all(20),
// // // // // //       decoration: _box(),
// // // // // //       child: Column(
// // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //         children: [
// // // // // //           const Text(
// // // // // //             "Units Sold History",
// // // // // //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// // // // // //           ),
// // // // // //           const SizedBox(height: 10),
// // // // // //           Text(
// // // // // //             "Last ${units.length} months trend",
// // // // // //             style: TextStyle(color: Colors.grey.shade600),
// // // // // //           ),
// // // // // //           const SizedBox(height: 20),
// // // // // //           Expanded(
// // // // // //             child: BarChart(
// // // // // //               BarChartData(
// // // // // //                 minY: 0,
// // // // // //                 maxY: maxY * 1.2,
// // // // // //                 borderData: FlBorderData(show: false),
// // // // // //                 gridData: FlGridData(
// // // // // //                   show: true,
// // // // // //                   horizontalInterval: interval,
// // // // // //                 ),
// // // // // //                 titlesData: FlTitlesData(
// // // // // //                   leftTitles: const AxisTitles(
// // // // // //                     sideTitles: SideTitles(showTitles: true, reservedSize: 35),
// // // // // //                   ),
// // // // // //                   bottomTitles: AxisTitles(
// // // // // //                     sideTitles: SideTitles(
// // // // // //                       showTitles: true,
// // // // // //                       interval: 2,
// // // // // //                       getTitlesWidget: (value, meta) {
// // // // // //                         int index = value.toInt();
// // // // // //                         if (index >= 0 && index < months.length) {
// // // // // //                           String label = months[index];
// // // // // //                           if (label.contains("-")) {
// // // // // //                             label = label.split("-")[1];
// // // // // //                           }
// // // // // //                           label = label.substring(0, 3);
// // // // // //                           return Padding(
// // // // // //                             padding: const EdgeInsets.only(top: 8),
// // // // // //                             child: Text(label, style: const TextStyle(fontSize: 10)),
// // // // // //                           );
// // // // // //                         }
// // // // // //                         return const SizedBox();
// // // // // //                       },
// // // // // //                     ),
// // // // // //                   ),
// // // // // //                   topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
// // // // // //                   rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
// // // // // //                 ),
// // // // // //                 barGroups: bars,
// // // // // //               ),
// // // // // //             ),
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   // =========================================================
// // // // // //   // COMPARISON SECTION
// // // // // //   // =========================================================
// // // // // //   Widget _comparisonSection() {
// // // // // //     double lastActual = historySales.isNotEmpty ? historySales.last : 0;
// // // // // //     double change = predictedSales - lastActual;
// // // // // //     double percent = lastActual == 0 ? 0 : (change / lastActual) * 100;
// // // // // //     bool growth = change >= 0;

// // // // // //     return Container(
// // // // // //       width: double.infinity,
// // // // // //       padding: const EdgeInsets.all(24),
// // // // // //       decoration: _box(),
// // // // // //       child: Column(
// // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //         children: [
// // // // // //           const Text(
// // // // // //             "Actual vs Predicted Analysis",
// // // // // //             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
// // // // // //           ),
// // // // // //           const SizedBox(height: 24),
// // // // // //           Row(
// // // // // //             children: [
// // // // // //               Expanded(child: _comparisonTile("Last Actual", "Rs ${lastActual.toStringAsFixed(0)}", Colors.blue)),
// // // // // //               const SizedBox(width: 14),
// // // // // //               Expanded(child: _comparisonTile("Forecast", "Rs ${predictedSales.toStringAsFixed(0)}", Colors.green)),
// // // // // //               const SizedBox(width: 14),
// // // // // //               Expanded(
// // // // // //                 child: _comparisonTile(
// // // // // //                   "Growth",
// // // // // //                   "${percent.toStringAsFixed(1)}%",
// // // // // //                   growth ? Colors.green : Colors.red,
// // // // // //                 ),
// // // // // //               ),
// // // // // //             ],
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   // =========================================================
// // // // // //   // INSIGHT CARD
// // // // // //   // =========================================================
// // // // // //   Widget _insightCard() {
// // // // // //     double lastActual = historySales.isNotEmpty ? historySales.last : 0;
// // // // // //     double change = predictedSales - lastActual;
// // // // // //     double percent = lastActual == 0 ? 0 : (change / lastActual) * 100;
// // // // // //     bool growth = change >= 0;

// // // // // //     return Container(
// // // // // //       width: double.infinity,
// // // // // //       padding: const EdgeInsets.all(22),
// // // // // //       decoration: BoxDecoration(
// // // // // //         color: growth ? Colors.green.shade50 : Colors.red.shade50,
// // // // // //         borderRadius: BorderRadius.circular(22),
// // // // // //       ),
// // // // // //       child: Row(
// // // // // //         children: [
// // // // // //           Container(
// // // // // //             padding: const EdgeInsets.all(14),
// // // // // //             decoration: BoxDecoration(
// // // // // //               color: growth ? Colors.green.shade100 : Colors.red.shade100,
// // // // // //               shape: BoxShape.circle,
// // // // // //             ),
// // // // // //             child: Icon(
// // // // // //               growth ? Icons.trending_up : Icons.trending_down,
// // // // // //               color: growth ? Colors.green : Colors.red,
// // // // // //             ),
// // // // // //           ),
// // // // // //           const SizedBox(width: 18),
// // // // // //           Expanded(
// // // // // //             child: Column(
// // // // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //               children: [
// // // // // //                 Text(
// // // // // //                   growth ? "Positive Sales Forecast" : "Sales Decline Risk",
// // // // // //                   style: TextStyle(
// // // // // //                     fontSize: 18,
// // // // // //                     fontWeight: FontWeight.bold,
// // // // // //                     color: growth ? Colors.green : Colors.red,
// // // // // //                   ),
// // // // // //                 ),
// // // // // //                 const SizedBox(height: 8),
// // // // // //                 Text(
// // // // // //                   growth
// // // // // //                       ? "AI predicts approximately ${percent.toStringAsFixed(1)}% growth compared to the latest actual sales performance."
// // // // // //                       : "AI predicts approximately ${percent.abs().toStringAsFixed(1)}% decline compared to historical sales performance.",
// // // // // //                 ),
// // // // // //               ],
// // // // // //             ),
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   // =========================================================
// // // // // //   // ANALYTICS CARD
// // // // // //   // =========================================================
// // // // // //   Widget _analyticsCard(String title, String value, IconData icon, Color color) {
// // // // // //     return Container(
// // // // // //       padding: const EdgeInsets.all(18),
// // // // // //       decoration: _box(),
// // // // // //       child: Column(
// // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //         children: [
// // // // // //           Container(
// // // // // //             padding: const EdgeInsets.all(10),
// // // // // //             decoration: BoxDecoration(
// // // // // //               color: color.withOpacity(0.1),
// // // // // //               borderRadius: BorderRadius.circular(14),
// // // // // //             ),
// // // // // //             child: Icon(icon, color: color),
// // // // // //           ),
// // // // // //           const SizedBox(height: 18),
// // // // // //           Text(title, style: TextStyle(color: Colors.grey.shade700)),
// // // // // //           const SizedBox(height: 8),
// // // // // //           Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   // =========================================================
// // // // // //   // HEADER STATS
// // // // // //   // =========================================================
// // // // // //   Widget _topStat(String title, String value, IconData icon) {
// // // // // //     return Container(
// // // // // //       padding: const EdgeInsets.all(16),
// // // // // //       decoration: BoxDecoration(
// // // // // //         color: Colors.white.withOpacity(0.15),
// // // // // //         borderRadius: BorderRadius.circular(18),
// // // // // //       ),
// // // // // //       child: Column(
// // // // // //         children: [
// // // // // //           Icon(icon, color: Colors.white),
// // // // // //           const SizedBox(height: 10),
// // // // // //           Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
// // // // // //           const SizedBox(height: 4),
// // // // // //           Text(title, textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(0.9))),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   // =========================================================
// // // // // //   // COMPARISON TILE
// // // // // //   // =========================================================
// // // // // //   Widget _comparisonTile(String title, String value, Color color) {
// // // // // //     return Container(
// // // // // //       padding: const EdgeInsets.all(18),
// // // // // //       decoration: BoxDecoration(
// // // // // //         color: color.withOpacity(0.08),
// // // // // //         borderRadius: BorderRadius.circular(18),
// // // // // //       ),
// // // // // //       child: Column(
// // // // // //         children: [
// // // // // //           Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
// // // // // //           const SizedBox(height: 10),
// // // // // //           Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   // =========================================================
// // // // // //   // LEGEND
// // // // // //   // =========================================================
// // // // // //   Widget _legend(Color color, String text) {
// // // // // //     return Row(
// // // // // //       children: [
// // // // // //         Container(width: 14, height: 14, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
// // // // // //         const SizedBox(width: 8),
// // // // // //         Text(text),
// // // // // //       ],
// // // // // //     );
// // // // // //   }

// // // // // //   // =========================================================
// // // // // //   // DROPDOWN
// // // // // //   // =========================================================
// // // // // //   Widget _dropdown(String label, List<String> items, String? value, Function(String?) onChanged) {
// // // // // //     return Padding(
// // // // // //       padding: const EdgeInsets.only(bottom: 14),
// // // // // //       child: DropdownButtonFormField<String>(
// // // // // //         value: items.contains(value) ? value : null,
// // // // // //         items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
// // // // // //         onChanged: onChanged,
// // // // // //         decoration: InputDecoration(
// // // // // //           labelText: label,
// // // // // //           filled: true,
// // // // // //           fillColor: Colors.grey.shade100,
// // // // // //           border: OutlineInputBorder(
// // // // // //             borderRadius: BorderRadius.circular(16),
// // // // // //             borderSide: BorderSide.none,
// // // // // //           ),
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   // =========================================================
// // // // // //   // COMMON BOX
// // // // // //   // =========================================================
// // // // // //   BoxDecoration _box() {
// // // // // //     return BoxDecoration(
// // // // // //       color: Colors.white,
// // // // // //       borderRadius: BorderRadius.circular(24),
// // // // // //       boxShadow: [
// // // // // //         BoxShadow(
// // // // // //           color: Colors.black.withOpacity(0.04),
// // // // // //           blurRadius: 10,
// // // // // //           offset: const Offset(0, 4),
// // // // // //         ),
// // // // // //       ],
// // // // // //     );
// // // // // //   }

// // // // // //   // =========================================================
// // // // // //   // BUILD
// // // // // //   // =========================================================
// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     return Scaffold(
// // // // // //       backgroundColor: const Color(0xffF4F7FC),
// // // // // //       appBar: AppBar(
// // // // // //         elevation: 0,
// // // // // //         backgroundColor: Colors.white,
// // // // // //         foregroundColor: Colors.black,
// // // // // //         title: const Text(
// // // // // //           "AI Forecast Dashboard",
// // // // // //           style: TextStyle(fontWeight: FontWeight.bold),
// // // // // //         ),
// // // // // //         actions: [
// // // // // //           _refreshPricesButton(),
// // // // // //         ],
// // // // // //       ),
// // // // // //       body: SingleChildScrollView(
// // // // // //         padding: const EdgeInsets.all(20),
// // // // // //         child: Column(
// // // // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //           children: [
// // // // // //             Container(
// // // // // //               width: double.infinity,
// // // // // //               padding: const EdgeInsets.all(24),
// // // // // //               decoration: BoxDecoration(
// // // // // //                 gradient: LinearGradient(
// // // // // //                   colors: [Colors.blue.shade700, Colors.indigo.shade600],
// // // // // //                   begin: Alignment.topLeft,
// // // // // //                   end: Alignment.bottomRight,
// // // // // //                 ),
// // // // // //                 borderRadius: BorderRadius.circular(28),
// // // // // //               ),
// // // // // //               child: Column(
// // // // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //                 children: [
// // // // // //                   const Text(
// // // // // //                     "AI Retail Analytics",
// // // // // //                     style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
// // // // // //                   ),
// // // // // //                   const SizedBox(height: 12),
// // // // // //                   Text(
// // // // // //                     "Advanced machine learning forecasting system for inventory intelligence",
// // // // // //                     style: TextStyle(color: Colors.white.withOpacity(0.92), height: 1.5),
// // // // // //                   ),
// // // // // //                   const SizedBox(height: 24),
// // // // // //                   Row(
// // // // // //                     children: [
// // // // // //                       Expanded(child: _topStat("Accuracy", "${accuracy.toStringAsFixed(1)}%", Icons.analytics)),
// // // // // //                       const SizedBox(width: 14),
// // // // // //                       Expanded(child: _topStat("Forecast Units", predictedUnits.toStringAsFixed(0), Icons.inventory_2)),
// // // // // //                     ],
// // // // // //                   ),
// // // // // //                 ],
// // // // // //               ),
// // // // // //             ),
// // // // // //             const SizedBox(height: 24),
// // // // // //             _controlCard(),
// // // // // //             const SizedBox(height: 24),
// // // // // //             if (historySales.isNotEmpty) ...[
// // // // // //               Row(
// // // // // //                 children: [
// // // // // //                   Expanded(child: _analyticsCard("Predicted Revenue", "Rs ${predictedSales.toStringAsFixed(0)}", Icons.currency_rupee, Colors.blue)),
// // // // // //                   const SizedBox(width: 14),
// // // // // //                   Expanded(child: _analyticsCard("Latest Units", latestUnits.toStringAsFixed(0), Icons.shopping_cart, Colors.orange)),
// // // // // //                   const SizedBox(width: 14),
// // // // // //                   Expanded(child: _analyticsCard("Rolling Average", rollingAvg.toStringAsFixed(0), Icons.show_chart, Colors.green)),
// // // // // //                 ],
// // // // // //               ),
// // // // // //               const SizedBox(height: 24),
// // // // // //               Row(
// // // // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //                 children: [
// // // // // //                   Expanded(flex: 2, child: _salesChart()),
// // // // // //                   const SizedBox(width: 18),
// // // // // //                   Expanded(child: _unitsChart()),
// // // // // //                 ],
// // // // // //               ),
// // // // // //               const SizedBox(height: 24),
// // // // // //               _comparisonSection(),
// // // // // //               const SizedBox(height: 24),
// // // // // //               _insightCard(),
// // // // // //             ],
// // // // // //           ],
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // import 'dart:convert';
// // // // // import 'package:fl_chart/fl_chart.dart';
// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:http/http.dart' as http;
// // // // // import 'package:cloud_firestore/cloud_firestore.dart';

// // // // // class PredictionPage extends StatefulWidget {
// // // // //   const PredictionPage({super.key});

// // // // //   @override
// // // // //   State<PredictionPage> createState() => _PredictionPageState();
// // // // // }

// // // // // class _PredictionPageState extends State<PredictionPage> {
// // // // //   // =========================================================
// // // // //   // DATA
// // // // //   // =========================================================

// // // // //   List<double> historySales = [];
// // // // //   List<double> historyUnits = [];
// // // // //   List<String> historyMonths = [];

// // // // //   List<String> categories = [];
// // // // //   List<String> products = [];
// // // // //   List<String> months = [];

// // // // //   String? selectedCategory;
// // // // //   String? selectedProduct;
// // // // //   String? selectedMonth;

// // // // //   bool loading = false;

// // // // //   // =========================================================
// // // // //   // RESULTS
// // // // //   // =========================================================

// // // // //   double predictedSales = 0;
// // // // //   double predictedUnits = 0;
// // // // //   double latestUnits = 0;
// // // // //   double rollingAvg = 0;
// // // // //   double accuracy = 0;

// // // // //   final TextEditingController priceController =
// // // // //       TextEditingController(text: "500");

// // // // //   final String baseUrl = "http://192.168.100.218:5000";
// // // // //   final FirebaseFirestore firestore = FirebaseFirestore.instance;

// // // // //   // =========================================================
// // // // //   // INIT
// // // // //   // =========================================================

// // // // //   @override
// // // // //   void initState() {
// // // // //     super.initState();
// // // // //     initialize();
// // // // //   }

// // // // //   Future<void> initialize() async {
// // // // //     await loadCategories();
// // // // //     await loadMonths();
// // // // //   }

// // // // //   // =========================================================
// // // // //   // SAFE PARSER
// // // // //   // =========================================================

// // // // //   double safeNum(dynamic v) {
// // // // //     if (v == null) return 0;
// // // // //     final d = (v as num).toDouble();
// // // // //     if (d.isNaN || d.isInfinite) return 0;
// // // // //     return d;
// // // // //   }

// // // // //   // =========================================================
// // // // //   // MONTH INDEX
// // // // //   // =========================================================

// // // // //   int getMonthIndex(String month) {
// // // // //     const map = {
// // // // //       "january": 1,
// // // // //       "february": 2,
// // // // //       "march": 3,
// // // // //       "april": 4,
// // // // //       "may": 5,
// // // // //       "june": 6,
// // // // //       "july": 7,
// // // // //       "august": 8,
// // // // //       "september": 9,
// // // // //       "october": 10,
// // // // //       "november": 11,
// // // // //       "december": 12,
// // // // //     };
// // // // //     return map[month.toLowerCase()] ?? 0;
// // // // //   }

// // // // //   // =========================================================
// // // // //   // FETCH LISTS
// // // // //   // =========================================================

// // // // //   Future<List<String>> fetchList(String endpoint, String key) async {
// // // // //     try {
// // // // //       final res = await http.get(Uri.parse("$baseUrl/$endpoint"));
// // // // //       final data = jsonDecode(res.body);
// // // // //       return (data[key] as List<dynamic>? ?? [])
// // // // //           .map((e) => e.toString())
// // // // //           .toList();
// // // // //     } catch (_) {
// // // // //       return [];
// // // // //     }
// // // // //   }

// // // // //   Future<void> loadCategories() async {
// // // // //     categories = await fetchList("categories", "categories");

// // // // //     setState(() {
// // // // //       selectedCategory = categories.isNotEmpty ? categories.first : null;
// // // // //       selectedProduct = null;
// // // // //       products = [];
// // // // //     });

// // // // //     if (selectedCategory != null) {
// // // // //       await loadProducts(selectedCategory!);
// // // // //     }
// // // // //   }

// // // // //   Future<void> loadMonths() async {
// // // // //     months = await fetchList("months", "months");

// // // // //     setState(() {
// // // // //       selectedMonth = months.isNotEmpty ? months.last : null;
// // // // //     });
// // // // //   }

// // // // //   // =========================================================
// // // // //   // PRODUCTS
// // // // //   // =========================================================

// // // // //   Future<void> loadProducts(String category) async {
// // // // //     try {
// // // // //       final res =
// // // // //           await http.get(Uri.parse("$baseUrl/products?category=$category"));

// // // // //       final data = jsonDecode(res.body);

// // // // //       setState(() {
// // // // //         products = (data["products"] as List<dynamic>? ?? [])
// // // // //             .map((e) => e.toString())
// // // // //             .toList();

// // // // //         selectedProduct = products.isNotEmpty ? products.first : null;
// // // // //       });
// // // // //     } catch (_) {
// // // // //       setState(() {
// // // // //         products = [];
// // // // //         selectedProduct = null;
// // // // //       });
// // // // //     }
// // // // //   }

// // // // //   // =========================================================
// // // // //   // PREDICT
// // // // //   // =========================================================

// // // // //   Future<void> predict() async {
// // // // //     if (selectedCategory == null ||
// // // // //         selectedProduct == null ||
// // // // //         selectedMonth == null) return;

// // // // //     setState(() => loading = true);

// // // // //     try {
// // // // //       final res = await http.post(
// // // // //         Uri.parse("$baseUrl/predict"),
// // // // //         headers: {"Content-Type": "application/json"},
// // // // //         body: jsonEncode({
// // // // //           "category": selectedCategory,
// // // // //           "product": selectedProduct,
// // // // //           "month": selectedMonth,
// // // // //         }),
// // // // //       );

// // // // //       final data = jsonDecode(res.body);

// // // // //       // ================= HISTORY =================

// // // // //       historyMonths = (data["history_months"] as List<dynamic>? ?? [])
// // // // //           .map((e) => e.toString())
// // // // //           .toList();

// // // // //       historySales = (data["history_sales"] as List<dynamic>? ?? [])
// // // // //           .map((e) => safeNum(e))
// // // // //           .toList();

// // // // //       historyUnits = (data["history_units"] as List<dynamic>? ?? [])
// // // // //           .map((e) => safeNum(e))
// // // // //           .toList();

// // // // //       // ================= CLEAN + SORT =================

// // // // //       List<Map<String, dynamic>> combined = [];

// // // // //       for (int i = 0; i < historyMonths.length; i++) {
// // // // //         combined.add({
// // // // //           "m": historyMonths[i],
// // // // //           "s": i < historySales.length ? historySales[i] : 0,
// // // // //           "u": i < historyUnits.length ? historyUnits[i] : 0,
// // // // //         });
// // // // //       }

// // // // //       combined.sort((a, b) {
// // // // //         try {
// // // // //           final aParts = a["m"].split("-");
// // // // //           final bParts = b["m"].split("-");

// // // // //           int aYear = int.parse(aParts[0]);
// // // // //           int bYear = int.parse(bParts[0]);

// // // // //           int aMonth = getMonthIndex(aParts[1]);
// // // // //           int bMonth = getMonthIndex(bParts[1]);

// // // // //           if (aYear != bYear) return aYear.compareTo(bYear);
// // // // //           return aMonth.compareTo(bMonth);
// // // // //         } catch (_) {
// // // // //           return 0;
// // // // //         }
// // // // //       });

// // // // //       historyMonths = combined.map((e) => e["m"].toString()).toList();
// // // // //       historySales = combined.map((e) => (e["s"] as num).toDouble()).toList();
// // // // //       historyUnits = combined.map((e) => (e["u"] as num).toDouble()).toList();

// // // // //       // ================= UI VALUES =================

// // // // //       setState(() {
// // // // //         predictedSales = safeNum(data["predicted_sales"]);
// // // // //         predictedUnits = safeNum(data["predicted_units"]);
// // // // //         latestUnits = safeNum(data["latest_units"]);
// // // // //         rollingAvg = safeNum(data["rolling_avg"]);
// // // // //         accuracy = safeNum(data["accuracy"]) * 100;
// // // // //         loading = false;
// // // // //       });
// // // // //     } catch (e) {
// // // // //       setState(() => loading = false);
// // // // //       debugPrint("ERROR: $e");
// // // // //     }
// // // // //   }

// // // // //   // =========================================================
// // // // //   // UI WIDGETS (UNCHANGED DESIGN)
// // // // //   // =========================================================

// // // // //   Widget _dropdown(
// // // // //     String label,
// // // // //     List<String> items,
// // // // //     String? value,
// // // // //     Function(String?) onChanged,
// // // // //   ) {
// // // // //     return Padding(
// // // // //       padding: const EdgeInsets.only(bottom: 14),
// // // // //       child: DropdownButtonFormField<String>(
// // // // //         value: items.contains(value) ? value : null,
// // // // //         items:
// // // // //             items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
// // // // //         onChanged: onChanged,
// // // // //         decoration: InputDecoration(
// // // // //           labelText: label,
// // // // //           filled: true,
// // // // //           fillColor: Colors.grey.shade100,
// // // // //           border: OutlineInputBorder(
// // // // //             borderRadius: BorderRadius.circular(16),
// // // // //             borderSide: BorderSide.none,
// // // // //           ),
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   BoxDecoration _box() {
// // // // //     return BoxDecoration(
// // // // //       color: Colors.white,
// // // // //       borderRadius: BorderRadius.circular(24),
// // // // //       boxShadow: [
// // // // //         BoxShadow(
// // // // //           color: Colors.black.withOpacity(0.05),
// // // // //           blurRadius: 10,
// // // // //           offset: const Offset(0, 4),
// // // // //         ),
// // // // //       ],
// // // // //     );
// // // // //   }

// // // // //   // =========================================================
// // // // //   // CONTROL PANEL
// // // // //   // =========================================================

// // // // //   Widget _controlCard() {
// // // // //     return Container(
// // // // //       padding: const EdgeInsets.all(22),
// // // // //       decoration: _box(),
// // // // //       child: Column(
// // // // //         children: [
// // // // //           _dropdown("Category", categories, selectedCategory, (v) async {
// // // // //             setState(() {
// // // // //               selectedCategory = v;
// // // // //               selectedProduct = null;
// // // // //               products = [];
// // // // //             });
// // // // //             if (v != null) await loadProducts(v);
// // // // //           }),

// // // // //           _dropdown("Product", products, selectedProduct,
// // // // //               (v) => setState(() => selectedProduct = v)),

// // // // //           _dropdown("Month", months, selectedMonth,
// // // // //               (v) => setState(() => selectedMonth = v)),

// // // // //           const SizedBox(height: 16),

// // // // //           SizedBox(
// // // // //             width: double.infinity,
// // // // //             height: 50,
// // // // //             child: ElevatedButton(
// // // // //               onPressed: loading ? null : predict,
// // // // //               child: loading
// // // // //                   ? const CircularProgressIndicator(color: Colors.white)
// // // // //                   : const Text("RUN FORECAST"),
// // // // //             ),
// // // // //           )
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   // =========================================================
// // // // //   // BUILD
// // // // //   // =========================================================

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return Scaffold(
// // // // //       appBar: AppBar(title: const Text("AI Forecast Dashboard")),
// // // // //       body: SingleChildScrollView(
// // // // //         padding: const EdgeInsets.all(16),
// // // // //         child: Column(
// // // // //           children: [
// // // // //             _controlCard(),
// // // // //             const SizedBox(height: 20),

// // // // //             if (historySales.isNotEmpty)
// // // // //               Container(
// // // // //                 height: 300,
// // // // //                 padding: const EdgeInsets.all(16),
// // // // //                 decoration: _box(),
// // // // //                 child: LineChart(
// // // // //                   LineChartData(
// // // // //                     lineBarsData: [
// // // // //                       LineChartBarData(
// // // // //                         spots: List.generate(
// // // // //                           historySales.length,
// // // // //                           (i) => FlSpot(i.toDouble(), historySales[i]),
// // // // //                         ),
// // // // //                         isCurved: true,
// // // // //                         color: Colors.blue,
// // // // //                       ),
// // // // //                     ],
// // // // //                   ),
// // // // //                 ),
// // // // //               ),
// // // // //           ],
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }
// // // // // //   }
// // // // // // }
// // // // import 'dart:convert';
// // // // import 'package:fl_chart/fl_chart.dart';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:http/http.dart' as http;
// // // // import 'package:cloud_firestore/cloud_firestore.dart';

// // // // class PredictionPage extends StatefulWidget {
// // // //   const PredictionPage({super.key});

// // // //   @override
// // // //   State<PredictionPage> createState() => _PredictionPageState();
// // // // }

// // // // class _PredictionPageState extends State<PredictionPage> {
// // // //   // =========================================================
// // // //   // DATA
// // // //   // =========================================================

// // // //   List<double> historySales = [];
// // // //   List<double> historyUnits = [];
// // // //   List<String> historyMonths = [];

// // // //   List<String> categories = [];
// // // //   List<String> products = [];
// // // //   List<String> months = [];

// // // //   String? selectedCategory;
// // // //   String? selectedProduct;
// // // //   String? selectedMonth;

// // // //   bool loading = false;

// // // //   // =========================================================
// // // //   // RESULTS
// // // //   // =========================================================

// // // //   double predictedSales = 0;
// // // //   double predictedUnits = 0;
// // // //   double latestUnits = 0;
// // // //   double rollingAvg = 0;
// // // //   double accuracy = 0;

// // // //   final TextEditingController priceController =
// // // //       TextEditingController(text: "500");

// // // //   final String baseUrl = "http://192.168.100.218:5000";
// // // //   final FirebaseFirestore firestore = FirebaseFirestore.instance;

// // // //   final Map<String, double> _priceCache = {};

// // // //   // =========================================================
// // // //   // INIT
// // // //   // =========================================================

// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     initialize();
// // // //   }

// // // //   Future<void> initialize() async {
// // // //     await loadCategories();
// // // //     await loadMonths();
// // // //   }

// // // //   // =========================================================
// // // //   // SAFE PARSER
// // // //   // =========================================================

// // // //   double safeNum(dynamic v) {
// // // //     if (v == null) return 0;
// // // //     final d = (v as num).toDouble();
// // // //     if (d.isNaN || d.isInfinite) return 0;
// // // //     return d;
// // // //   }

// // // //   // =========================================================
// // // //   // MONTH INDEX FIXED
// // // //   // =========================================================

// // // //   int getMonthIndex(String month) {
// // // //     const map = {
// // // //       "january": 1,
// // // //       "february": 2,
// // // //       "march": 3,
// // // //       "april": 4,
// // // //       "may": 5,
// // // //       "june": 6,
// // // //       "july": 7,
// // // //       "august": 8,
// // // //       "september": 9,
// // // //       "october": 10,
// // // //       "november": 11,
// // // //       "december": 12,
// // // //     };

// // // //     return map[month.toLowerCase()] ?? 0;
// // // //   }

// // // //   // =========================================================
// // // //   // FETCH LIST
// // // //   // =========================================================

// // // //   Future<List<String>> fetchList(String endpoint, String key) async {
// // // //     try {
// // // //       final res = await http.get(Uri.parse("$baseUrl/$endpoint"));
// // // //       final data = jsonDecode(res.body);
// // // //       return List<String>.from(data[key] ?? []);
// // // //     } catch (_) {
// // // //       return [];
// // // //     }
// // // //   }

// // // //   Future<void> loadCategories() async {
// // // //     categories = await fetchList("categories", "categories");

// // // //     setState(() {
// // // //       selectedCategory = categories.isNotEmpty ? categories.first : null;
// // // //       selectedProduct = null;
// // // //       products = [];
// // // //     });

// // // //     if (selectedCategory != null) {
// // // //       await loadProducts(selectedCategory!);
// // // //     }
// // // //   }

// // // //   Future<void> loadMonths() async {
// // // //     months = await fetchList("months", "months");

// // // //     setState(() {
// // // //       selectedMonth = months.isNotEmpty ? months.last : null;
// // // //     });
// // // //   }

// // // //   // =========================================================
// // // //   // PRODUCTS
// // // //   // =========================================================

// // // //   Future<void> loadProducts(String category) async {
// // // //     try {
// // // //       final res =
// // // //           await http.get(Uri.parse("$baseUrl/products?category=$category"));

// // // //       final data = jsonDecode(res.body);

// // // //       setState(() {
// // // //         products = List<String>.from(data["products"] ?? []);
// // // //         selectedProduct = products.isNotEmpty ? products.first : null;
// // // //       });
// // // //     } catch (_) {
// // // //       setState(() {
// // // //         products = [];
// // // //         selectedProduct = null;
// // // //       });
// // // //     }
// // // //   }

// // // //   // =========================================================
// // // //   // PREDICT
// // // //   // =========================================================

// // // //   Future<void> predict() async {
// // // //     if (selectedCategory == null ||
// // // //         selectedProduct == null ||
// // // //         selectedMonth == null) return;

// // // //     setState(() => loading = true);

// // // //     try {
// // // //       final res = await http.post(
// // // //         Uri.parse("$baseUrl/predict"),
// // // //         headers: {"Content-Type": "application/json"},
// // // //         body: jsonEncode({
// // // //           "category": selectedCategory,
// // // //           "product": selectedProduct,
// // // //           "month": selectedMonth,
// // // //         }),
// // // //       );

// // // //       final data = jsonDecode(res.body);

// // // //       if (data["error"] != null) {
// // // //         throw Exception(data["error"]);
// // // //       }

// // // //       // ================= HISTORY SAFE =================
// // // //       historyMonths =
// // // //           List<String>.from(data["history_months"] ?? []);

// // // //       historySales = List<double>.from(
// // // //           (data["history_sales"] ?? []).map((e) => safeNum(e)));

// // // //       historyUnits = List<double>.from(
// // // //           (data["history_units"] ?? []).map((e) => safeNum(e)));

// // // //       // ================= SORT =================
// // // //       List<Map<String, dynamic>> combined = [];

// // // //       for (int i = 0; i < historyMonths.length; i++) {
// // // //         combined.add({
// // // //           "m": historyMonths[i],
// // // //           "s": i < historySales.length ? historySales[i] : 0,
// // // //           "u": i < historyUnits.length ? historyUnits[i] : 0,
// // // //         });
// // // //       }

// // // //       combined.sort((a, b) {
// // // //         try {
// // // //           final aParts = a["m"].split("-");
// // // //           final bParts = b["m"].split("-");

// // // //           int aYear = int.parse(aParts[0]);
// // // //           int bYear = int.parse(bParts[0]);

// // // //           int aMonth = getMonthIndex(aParts[1]);
// // // //           int bMonth = getMonthIndex(bParts[1]);

// // // //           if (aYear != bYear) return aYear.compareTo(bYear);
// // // //           return aMonth.compareTo(bMonth);
// // // //         } catch (_) {
// // // //           return 0;
// // // //         }
// // // //       });

// // // //     //  historyMonths = combined.map((e) => e["m"]).toList();
// // // //       historySales =
// // // //           combined.map((e) => (e["s"] as num).toDouble()).toList();
// // // //       historyUnits =
// // // //           combined.map((e) => (e["u"] as num).toDouble()).toList();

// // // //       setState(() {
// // // //         predictedSales = safeNum(data["predicted_sales"]);
// // // //         predictedUnits = safeNum(data["predicted_units"]);
// // // //         latestUnits = safeNum(data["latest_units"]);
// // // //         rollingAvg = safeNum(data["rolling_avg"]);
// // // //         accuracy = safeNum(data["accuracy"]) * 100;
// // // //         loading = false;
// // // //       });
// // // //     } catch (e) {
// // // //       setState(() => loading = false);
// // // //       debugPrint("Prediction error: $e");
// // // //     }
// // // //   }

// // // //   // =========================================================
// // // //   // UI HELPERS (UNCHANGED STYLE)
// // // //   // =========================================================

// // // //   Widget _dropdown(
// // // //     String label,
// // // //     List<String> items,
// // // //     String? value,
// // // //     Function(String?) onChanged,
// // // //   ) {
// // // //     return Padding(
// // // //       padding: const EdgeInsets.only(bottom: 14),
// // // //       child: DropdownButtonFormField<String>(
// // // //         value: items.contains(value) ? value : null,
// // // //         items:
// // // //             items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
// // // //         onChanged: onChanged,
// // // //         decoration: InputDecoration(
// // // //           labelText: label,
// // // //           filled: true,
// // // //           fillColor: Colors.grey.shade100,
// // // //           border: OutlineInputBorder(
// // // //             borderRadius: BorderRadius.circular(16),
// // // //             borderSide: BorderSide.none,
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   BoxDecoration _box() {
// // // //     return BoxDecoration(
// // // //       color: Colors.white,
// // // //       borderRadius: BorderRadius.circular(24),
// // // //       boxShadow: [
// // // //         BoxShadow(
// // // //           color: Colors.black.withOpacity(0.04),
// // // //           blurRadius: 10,
// // // //           offset: const Offset(0, 4),
// // // //         ),
// // // //       ],
// // // //     );
// // // //   }

// // // //   // =========================================================
// // // //   // CONTROL PANEL
// // // //   // =========================================================

// // // //   Widget _controlCard() {
// // // //     return Container(
// // // //       padding: const EdgeInsets.all(22),
// // // //       decoration: _box(),
// // // //       child: Column(
// // // //         children: [
// // // //           _dropdown("Category", categories, selectedCategory, (v) async {
// // // //             setState(() {
// // // //               selectedCategory = v;
// // // //               selectedProduct = null;
// // // //               products = [];
// // // //             });
// // // //             if (v != null) await loadProducts(v);
// // // //           }),

// // // //           _dropdown("Product", products, selectedProduct, (v) {
// // // //             setState(() => selectedProduct = v);
// // // //           }),

// // // //           _dropdown("Month", months, selectedMonth,
// // // //               (v) => setState(() => selectedMonth = v)),

// // // //           const SizedBox(height: 16),

// // // //           SizedBox(
// // // //             width: double.infinity,
// // // //             height: 50,
// // // //             child: ElevatedButton(
// // // //               onPressed: loading ? null : predict,
// // // //               child: loading
// // // //                   ? const CircularProgressIndicator(color: Colors.white)
// // // //                   : const Text("RUN FORECAST"),
// // // //             ),
// // // //           )
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   // =========================================================
// // // //   // BUILD
// // // //   // =========================================================

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(title: const Text("AI Forecast")),
// // // //       body: SingleChildScrollView(
// // // //         padding: const EdgeInsets.all(16),
// // // //         child: Column(
// // // //           children: [
// // // //             _controlCard(),

// // // //             const SizedBox(height: 20),

// // // //             if (historySales.isNotEmpty)
// // // //               Container(
// // // //                 height: 300,
// // // //                 padding: const EdgeInsets.all(16),
// // // //                 decoration: _box(),
// // // //                 child: LineChart(
// // // //                   LineChartData(
// // // //                     lineBarsData: [
// // // //                       LineChartBarData(
// // // //                         spots: List.generate(
// // // //                           historySales.length,
// // // //                           (i) => FlSpot(i.toDouble(), historySales[i]),
// // // //                         ),
// // // //                         isCurved: true,
// // // //                         color: Colors.blue,
// // // //                       ),
// // // //                     ],
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // // import 'dart:convert';
// // // import 'package:fl_chart/fl_chart.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:http/http.dart' as http;
// // // import 'package:cloud_firestore/cloud_firestore.dart';

// // // class PredictionPage extends StatefulWidget {
// // //   const PredictionPage({super.key});

// // //   @override
// // //   State<PredictionPage> createState() => _PredictionPageState();
// // // }

// // // class _PredictionPageState extends State<PredictionPage> {

// // //   // =========================================================
// // //   // DATA
// // //   // =========================================================

// // //   List<double> historySales = [];
// // //   List<double> historyUnits = [];
// // //   List<String> historyMonths = [];

// // //   List<String> categories = [];
// // //   List<String> products = [];
// // //   List<String> months = [];

// // //   String? selectedCategory;
// // //   String? selectedProduct;
// // //   String? selectedMonth;

// // //   bool loading = false;

// // //   // =========================================================
// // //   // ML RESULTS
// // //   // =========================================================

// // //   double predictedSales = 0;
// // //   double predictedUnits = 0;
// // //   double latestUnits = 0;
// // //   double rollingAvg = 0;
// // //   double accuracy = 0;

// // //   final TextEditingController priceController = TextEditingController(text: "500");

// // //   final String baseUrl = "http://192.168.100.218:5000";
// // //   final FirebaseFirestore firestore = FirebaseFirestore.instance;

// // //   // Cache for prices to avoid repeated Firebase calls
// // //   final Map<String, double> _priceCache = {};

// // //   // =========================================================
// // //   // INIT
// // //   // =========================================================

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     initialize();
// // //   }

// // //   Future<void> initialize() async {
// // //     await loadCategories();
// // //     await loadMonths();
// // //   }

// // //   // =========================================================
// // //   // IMPROVED PRICE FETCHING WITH MULTIPLE STRATEGIES
// // //   // =========================================================
// // //   Future<double> fetchProductPrice(String product, String category) async {
// // //     // Check cache first
// // //     String cacheKey = "$category|$product";
// // //     if (_priceCache.containsKey(cacheKey)) {
// // //       return _priceCache[cacheKey]!;
// // //     }

// // //     double price = 500; // Default fallback price

// // //     try {
// // //       // Strategy 1: Try exact match in inventory collection
// // //       QuerySnapshot exactMatch = await firestore
// // //           .collection("inventory")
// // //           .where("product", isEqualTo: product)
// // //           .where("category", isEqualTo: category)
// // //           .limit(1)
// // //           .get();
      
// // //       if (exactMatch.docs.isNotEmpty) {
// // //         price = (exactMatch.docs.first.data() as Map<String, dynamic>)["price"]?.toDouble() ?? 500;
// // //         _priceCache[cacheKey] = price;
// // //         debugPrint("✅ Price found for $product: ₹$price (exact match)");
// // //         return price;
// // //       }

// // //       // Strategy 2: Try case-insensitive search
// // //       QuerySnapshot caseInsensitive = await firestore
// // //           .collection("inventory")
// // //           .where("product", isEqualTo: product.toLowerCase())
// // //           .where("category", isEqualTo: category.toLowerCase())
// // //           .limit(1)
// // //           .get();
      
// // //       if (caseInsensitive.docs.isNotEmpty) {
// // //         price = (caseInsensitive.docs.first.data() as Map<String, dynamic>)["price"]?.toDouble() ?? 500;
// // //         _priceCache[cacheKey] = price;
// // //         debugPrint("✅ Price found for $product: ₹$price (case-insensitive)");
// // //         return price;
// // //       }

// // //       // Strategy 3: Search by product only (ignore category)
// // //       QuerySnapshot productOnly = await firestore
// // //           .collection("inventory")
// // //           .where("product", isEqualTo: product)
// // //           .limit(1)
// // //           .get();
      
// // //       if (productOnly.docs.isNotEmpty) {
// // //         price = (productOnly.docs.first.data() as Map<String, dynamic>)["price"]?.toDouble() ?? 500;
// // //         _priceCache[cacheKey] = price;
// // //         debugPrint("✅ Price found for $product: ₹$price (product only)");
// // //         return price;
// // //       }

// // //       // Strategy 4: Try to find similar product names
// // //       QuerySnapshot allProducts = await firestore
// // //           .collection("inventory")
// // //           .limit(20)
// // //           .get();
      
// // //       double bestMatchPrice = 500;
// // //       double bestMatchScore = 0;
      
// // //       for (var doc in allProducts.docs) {
// // //         String dbProduct = (doc.data() as Map<String, dynamic>)["product"]?.toString().toLowerCase() ?? "";
// // //         String dbCategory = (doc.data() as Map<String, dynamic>)["category"]?.toString().toLowerCase() ?? "";
        
// // //         double score = 0;
// // //         if (dbProduct.contains(product.toLowerCase())) score += 0.7;
// // //         if (product.toLowerCase().contains(dbProduct)) score += 0.5;
// // //         if (dbCategory == category.toLowerCase()) score += 0.3;
        
// // //         if (score > bestMatchScore && score > 0.5) {
// // //           bestMatchScore = score;
// // //           bestMatchPrice = (doc.data() as Map<String, dynamic>)["price"]?.toDouble() ?? 500;
// // //         }
// // //       }
      
// // //       if (bestMatchScore > 0) {
// // //         price = bestMatchPrice;
// // //         _priceCache[cacheKey] = price;
// // //         debugPrint("✅ Similar product found for $product: ₹$price (similarity: ${(bestMatchScore * 100).toInt()}%)");
// // //         return price;
// // //       }

// // //       // Strategy 5: Use category average price
// // //       QuerySnapshot categoryProducts = await firestore
// // //           .collection("inventory")
// // //           .where("category", isEqualTo: category)
// // //           .get();
      
// // //       if (categoryProducts.docs.isNotEmpty) {
// // //         double total = 0;
// // //         int count = 0;
// // //         for (var doc in categoryProducts.docs) {
// // //           double p = (doc.data() as Map<String, dynamic>)["price"]?.toDouble() ?? 0;
// // //           if (p > 0) {
// // //             total += p;
// // //             count++;
// // //           }
// // //         }
// // //         if (count > 0) {
// // //           price = total / count;
// // //           _priceCache[cacheKey] = price;
// // //           debugPrint("✅ Using category average for $product: ₹${price.toStringAsFixed(0)}");
// // //           return price;
// // //         }
// // //       }

// // //       debugPrint("⚠️ No price found for $product, using default ₹500");
      
// // //     } catch (e) {
// // //       debugPrint("❌ Error fetching price for $product: $e");
// // //     }
    
// // //     _priceCache[cacheKey] = price;
// // //     return price;
// // //   }

// // //   // =========================================================
// // //   // BULK PRICE LOADING FOR ALL PRODUCTS IN CATEGORY
// // //   // =========================================================
// // //   Future<Map<String, double>> loadAllProductPrices(String category) async {
// // //     Map<String, double> priceMap = {};
    
// // //     try {
// // //       QuerySnapshot snapshot = await firestore
// // //           .collection("inventory")
// // //           .where("category", isEqualTo: category)
// // //           .get();
      
// // //       for (var doc in snapshot.docs) {
// // //         String product = (doc.data() as Map<String, dynamic>)["product"]?.toString() ?? "";
// // //         double price = (doc.data() as Map<String, dynamic>)["price"]?.toDouble() ?? 0;
// // //         if (product.isNotEmpty && price > 0) {
// // //           priceMap[product] = price;
// // //         }
// // //       }
      
// // //       debugPrint("📦 Loaded ${priceMap.length} prices for category: $category");
// // //     } catch (e) {
// // //       debugPrint("Error bulk loading prices: $e");
// // //     }
    
// // //     return priceMap;
// // //   }

// // //   // =========================================================
// // //   // FETCH LIST
// // //   // =========================================================

// // //   Future<List<String>> fetchList(String endpoint, String key) async {
// // //     try {
// // //       final res = await http.get(Uri.parse("$baseUrl/$endpoint"));
// // //       final data = jsonDecode(res.body);
// // //       return List<String>.from(data[key] ?? []);
// // //     } catch (_) {
// // //       return [];
// // //     }
// // //   }

// // //   Future<void> loadCategories() async {
// // //     categories = await fetchList("categories", "categories");

// // //     setState(() {
// // //       selectedCategory = categories.isNotEmpty ? categories.first : null;
// // //       selectedProduct = null;
// // //       products = [];
// // //     });

// // //     if (selectedCategory != null) {
// // //       await loadProducts(selectedCategory!);
// // //     }
// // //   }

// // //   Future<void> loadProducts(String category) async {
// // //     try {
// // //       final res = await http.get(
// // //         Uri.parse("$baseUrl/products?category=$category"),
// // //       );

// // //       final data = jsonDecode(res.body);

// // //       setState(() {
// // //         products = List<String>.from(data["products"] ?? []);
// // //         selectedProduct = products.isNotEmpty ? products.first : null;
// // //       });
      
// // //       // Bulk load prices for all products in this category
// // //       Map<String, double> priceMap = await loadAllProductPrices(category);
      
// // //       // Fetch price for the first product
// // //       if (selectedProduct != null && selectedCategory != null) {
// // //         double price;
// // //         if (priceMap.containsKey(selectedProduct)) {
// // //           price = priceMap[selectedProduct]!;
// // //         } else {
// // //           price = await fetchProductPrice(selectedProduct!, selectedCategory!);
// // //         }
// // //         priceController.text = price.toStringAsFixed(0);
// // //       }
// // //     } catch (_) {
// // //       setState(() {
// // //         products = [];
// // //         selectedProduct = null;
// // //       });
// // //     }
// // //   }

// // //   Future<void> loadMonths() async {
// // //     months = await fetchList("months", "months");

// // //     setState(() {
// // //       selectedMonth = months.isNotEmpty ? months.last : null;
// // //     });
// // //   }

// // //   int getMonthIndex(String month) {
// // //     const monthOrder = [
// // //       "jan","feb","mar","apr","may","jun",
// // //       "jul","aug","sep","oct","nov","dec",
// // //     ];

// // //     String shortMonth = month.toLowerCase().substring(0, 3);
// // //     return monthOrder.indexOf(shortMonth);
// // //   }

// // //   // =========================================================
// // //   // PREDICT + FIRESTORE SAVE
// // //   // =========================================================
// // //   Future<void> predict() async {
// // //     if (selectedCategory == null || selectedProduct == null || selectedMonth == null) {
// // //       return;
// // //     }

// // //     setState(() => loading = true);

// // //     try {
// // //       final res = await http.post(
// // //         Uri.parse("$baseUrl/predict"),
// // //         headers: {"Content-Type": "application/json"},
// // //         body: jsonEncode({
// // //           "category": selectedCategory,
// // //           "product": selectedProduct,
// // //           "month": selectedMonth,
// // //           "price": double.tryParse(priceController.text) ?? 0,
// // //         }),
// // //       );

// // //       final data = jsonDecode(res.body);

// // //       List<String> rawMonths = List<String>.from(data["history_months"] ?? []);
// // //       List<double> rawSales = List<double>.from((data["history_sales"] ?? [])
// // //           .map((e) => (e as num).toDouble()));
// // //       List<double> rawUnits = List<double>.from((data["history_units"] ?? [])
// // //           .map((e) => (e as num).toDouble()));

// // //       List<Map<String, dynamic>> combined = [];

// // //       for (int i = 0; i < rawMonths.length; i++) {
// // //         combined.add({
// // //           "month": rawMonths[i],
// // //           "sales": i < rawSales.length ? rawSales[i] : 0,
// // //           "units": i < rawUnits.length ? rawUnits[i] : 0,
// // //         });
// // //       }

// // //       const int maxPoints = 12;

// // //       if (historySales.length > maxPoints) {
// // //         historySales = historySales.sublist(historySales.length - maxPoints);
// // //         historyUnits = historyUnits.sublist(historyUnits.length - maxPoints);
// // //         historyMonths = historyMonths.sublist(historyMonths.length - maxPoints);
// // //       }

// // //       combined.sort((a, b) {
// // //         try {
// // //           final aParts = a["month"].toString().split("-");
// // //           final bParts = b["month"].toString().split("-");

// // //           int aYear = int.parse(aParts[0]);
// // //           int bYear = int.parse(bParts[0]);

// // //           int aMonth = getMonthIndex(aParts[1]);
// // //           int bMonth = getMonthIndex(bParts[1]);

// // //           if (aYear != bYear) {
// // //             return aYear.compareTo(bYear);
// // //           }

// // //           return aMonth.compareTo(bMonth);
// // //         } catch (_) {
// // //           return 0;
// // //         }
// // //       });

// // //       historyMonths = combined.map((e) => e["month"].toString()).toList();
// // //       historySales = combined.map((e) => (e["sales"] as num).toDouble()).toList();
// // //       historyUnits = combined.map((e) => (e["units"] as num).toDouble()).toList();

// // //       setState(() {
// // //         predictedSales = (data["predicted_sales"] ?? 0).toDouble();
// // //         predictedUnits = (data["predicted_units"] ?? 0).toDouble();
// // //         latestUnits = (data["latest_units"] ?? data["latest_units_used"] ?? 0).toDouble();
// // //         rollingAvg = (data["rolling_avg"] ?? data["rolling_avg_used"] ?? 0).toDouble();
// // //         accuracy = ((data["accuracy"] ?? 0) * 100).toDouble();
// // //         loading = false;
// // //       });

// // //       await firestore.collection("prediction_history").add({
// // //         "category": selectedCategory,
// // //         "product": selectedProduct,
// // //         "month": selectedMonth,
// // //         "price": double.tryParse(priceController.text) ?? 0,
// // //         "predicted_sales": predictedSales,
// // //         "predicted_units": predictedUnits,
// // //         "created_at": FieldValue.serverTimestamp(),
// // //       });

// // //       final docId = "${selectedProduct}_${selectedCategory}".replaceAll(" ", "_");

// // //       await firestore
// // //           .collection("inventory_predictions")
// // //           .doc(docId)
// // //           .set({
// // //         "product": selectedProduct,
// // //         "category": selectedCategory,
// // //         "month": selectedMonth,
// // //         "predicted_units": predictedUnits,
// // //         "predicted_sales": predictedSales,
// // //         "updated_at": FieldValue.serverTimestamp(),
// // //       });
// // //     } catch (e) {
// // //       setState(() => loading = false);
// // //       debugPrint(e.toString());
// // //     }
// // //   }

// // //   // =========================================================
// // //   // CONTROL CARD WITH PRICE EDIT OPTION
// // //   // =========================================================
// // //   Widget _controlCard() {
// // //     return Container(
// // //       padding: const EdgeInsets.all(22),
// // //       decoration: _box(),
// // //       child: Column(
// // //         children: [
// // //           _dropdown(
// // //             "Category",
// // //             categories,
// // //             selectedCategory,
// // //             (v) async {
// // //               setState(() {
// // //                 selectedCategory = v;
// // //                 selectedProduct = null;
// // //                 products = [];
// // //               });
// // //               if (v != null) {
// // //                 await loadProducts(v);
// // //               }
// // //             },
// // //           ),

// // //           _dropdown(
// // //             "Product",
// // //             products,
// // //             selectedProduct,
// // //             (v) async {
// // //               setState(() {
// // //                 selectedProduct = v;
// // //               });
              
// // //               // Fetch price when product is selected
// // //               if (v != null && selectedCategory != null) {
// // //                 final price = await fetchProductPrice(v, selectedCategory!);
// // //                 priceController.text = price.toStringAsFixed(0);
                
// // //                 // Show a snackbar if using default price
// // //                 if (price == 500) {
// // //                   if (mounted) {
// // //                     ScaffoldMessenger.of(context).showSnackBar(
// // //                       SnackBar(
// // //                         content: Text("⚠️ No price found for $v, using default ₹500. You can edit it."),
// // //                         backgroundColor: Colors.orange,
// // //                         duration: const Duration(seconds: 3),
// // //                       ),
// // //                     );
// // //                   }
// // //                 } else {
// // //                   if (mounted) {
// // //                     ScaffoldMessenger.of(context).showSnackBar(
// // //                       SnackBar(
// // //                         content: Text("✅ Price loaded: ₹${price.toStringAsFixed(0)} for $v"),
// // //                         backgroundColor: Colors.green,
// // //                         duration: const Duration(seconds: 2),
// // //                       ),
// // //                     );
// // //                   }
// // //                 }
// // //               }
// // //             },
// // //           ),

// // //           _dropdown(
// // //             "Forecast Month",
// // //             months,
// // //             selectedMonth,
// // //             (v) {
// // //               setState(() {
// // //                 selectedMonth = v;
// // //               });
// // //             },
// // //           ),

// // //           const SizedBox(height: 12),

// // //           TextField(
// // //             controller: priceController,
// // //             keyboardType: TextInputType.number,
// // //             decoration: InputDecoration(
// // //               labelText: "Unit Price (₹)",
// // //               prefixIcon: const Icon(Icons.currency_rupee),
// // //               hintText: "Auto-loaded or manual entry",
// // //               helperText: "Price auto-loaded from inventory or you can edit",
// // //               helperStyle: TextStyle(fontSize: 10, color: Colors.grey.shade500),
// // //               filled: true,
// // //               fillColor: Colors.grey.shade100,
// // //               border: OutlineInputBorder(
// // //                 borderRadius: BorderRadius.circular(16),
// // //                 borderSide: BorderSide.none,
// // //               ),
// // //             ),
// // //           ),

// // //           const SizedBox(height: 22),

// // //           SizedBox(
// // //             width: double.infinity,
// // //             height: 54,
// // //             child: ElevatedButton(
// // //               onPressed: loading ? null : predict,
// // //               style: ElevatedButton.styleFrom(
// // //                 backgroundColor: Colors.blue.shade700,
// // //                 shape: RoundedRectangleBorder(
// // //                   borderRadius: BorderRadius.circular(16),
// // //                 ),
// // //               ),
// // //               child: loading
// // //                   ? const CircularProgressIndicator(color: Colors.white)
// // //                   : const Text(
// // //                       "RUN AI FORECAST",
// // //                       style: TextStyle(
// // //                         fontSize: 16,
// // //                         fontWeight: FontWeight.bold,
// // //                       ),
// // //                     ),
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   // Add this button to manually refresh prices
// // //   Widget _refreshPricesButton() {
// // //     return IconButton(
// // //       icon: const Icon(Icons.refresh),
// // //       onPressed: () async {
// // //         if (selectedCategory != null) {
// // //           await loadProducts(selectedCategory!);
// // //           if (mounted) {
// // //             ScaffoldMessenger.of(context).showSnackBar(
// // //               const SnackBar(content: Text("Prices refreshed from database")),
// // //             );
// // //           }
// // //         }
// // //       },
// // //       tooltip: "Refresh prices from database",
// // //     );
// // //   }

// // //   // =========================================================
// // //   // SALES CHART
// // //   // =========================================================
// // //   Widget _salesChart() {
// // //     const int maxPoints = 12;

// // //     List<double> sales = List.from(historySales);
// // //     List<String> months = List.from(historyMonths);

// // //     if (sales.length > maxPoints) {
// // //       sales = sales.sublist(sales.length - maxPoints);
// // //       months = months.sublist(months.length - maxPoints);
// // //     }

// // //     if (sales.isEmpty) {
// // //       return Container(
// // //         height: 420,
// // //         padding: const EdgeInsets.all(20),
// // //         decoration: _box(),
// // //         child: const Center(child: Text("No data")),
// // //       );
// // //     }

// // //     List<FlSpot> actualSpots = [];

// // //     for (int i = 0; i < sales.length; i++) {
// // //       double v = sales[i];
// // //       if (v.isNaN || v.isInfinite) v = 0;
// // //       actualSpots.add(FlSpot(i.toDouble(), v));
// // //     }

// // //     double safePrediction = predictedSales;
// // //     if (safePrediction.isNaN || safePrediction.isInfinite || safePrediction <= 0) {
// // //       safePrediction = sales.last;
// // //     }

// // //     final predictionSpot = FlSpot(sales.length.toDouble(), safePrediction);
// // //     List<FlSpot> forecastSpots = [
// // //       actualSpots.last,
// // //       predictionSpot,
// // //     ];

// // //     double maxY = sales.reduce((a, b) => a > b ? a : b);
// // //     if (safePrediction > maxY) maxY = safePrediction;
// // //     if (maxY <= 0) maxY = 100;

// // //     double interval = maxY / 5;
// // //     if (interval.isNaN || interval.isInfinite || interval <= 0) {
// // //       interval = 20;
// // //     }

// // //     return Container(
// // //       height: 420,
// // //       padding: const EdgeInsets.all(20),
// // //       decoration: _box(),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           const Text(
// // //             "Actual Sales vs Forecast",
// // //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// // //           ),
// // //           const SizedBox(height: 20),
// // //           Expanded(
// // //             child: LineChart(
// // //               LineChartData(
// // //                 minY: 0,
// // //                 maxY: maxY * 1.2,
// // //                 gridData: FlGridData(
// // //                   show: true,
// // //                   horizontalInterval: interval,
// // //                 ),
// // //                 borderData: FlBorderData(show: false),
// // //                 titlesData: FlTitlesData(
// // //                   leftTitles: const AxisTitles(
// // //                     sideTitles: SideTitles(showTitles: true, reservedSize: 45),
// // //                   ),
// // //                   bottomTitles: AxisTitles(
// // //                     sideTitles: SideTitles(
// // //                       showTitles: true,
// // //                       interval: 2,
// // //                       getTitlesWidget: (value, meta) {
// // //                         int i = value.toInt();
// // //                         if (i >= 0 && i < months.length) {
// // //                           String m = months[i];
// // //                           if (m.contains("-")) {
// // //                             m = m.split("-")[1];
// // //                           }
// // //                           return Text(m.substring(0, 3),
// // //                               style: const TextStyle(fontSize: 10));
// // //                         }
// // //                         return const SizedBox();
// // //                       },
// // //                     ),
// // //                   ),
// // //                   topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
// // //                   rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
// // //                 ),
// // //                 lineBarsData: [
// // //                   LineChartBarData(
// // //                     spots: actualSpots,
// // //                     isCurved: true,
// // //                     color: Colors.blue,
// // //                     barWidth: 4,
// // //                     dotData: const FlDotData(show: false),
// // //                   ),
// // //                   LineChartBarData(
// // //                     spots: forecastSpots,
// // //                     isCurved: true,
// // //                     color: Colors.green,
// // //                     barWidth: 4,
// // //                     dashArray: [6, 4],
// // //                     dotData: const FlDotData(show: true),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           ),
// // //           const SizedBox(height: 12),
// // //           Row(
// // //             children: [
// // //               _legend(Colors.blue, "Actual Sales"),
// // //               const SizedBox(width: 20),
// // //               _legend(Colors.green, "Forecast"),
// // //             ],
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   // =========================================================
// // //   // UNITS BAR CHART
// // //   // =========================================================
// // //   Widget _unitsChart() {
// // //     const int maxPoints = 12;

// // //     List<double> units = List.from(historyUnits);
// // //     List<String> months = List.from(historyMonths);

// // //     if (units.length > maxPoints) {
// // //       units = units.sublist(units.length - maxPoints);
// // //       months = months.sublist(months.length - maxPoints);
// // //     }

// // //     if (units.isEmpty) {
// // //       return Container(
// // //         height: 420,
// // //         padding: const EdgeInsets.all(20),
// // //         decoration: _box(),
// // //         child: const Center(child: Text("No data")),
// // //       );
// // //     }

// // //     List<BarChartGroupData> bars = [];
// // //     double maxY = 0;

// // //     for (int i = 0; i < units.length; i++) {
// // //       double value = units[i];
// // //       if (value.isNaN || value.isInfinite) value = 0;
// // //       if (value > maxY) maxY = value;

// // //       bars.add(
// // //         BarChartGroupData(
// // //           x: i,
// // //           barRods: [
// // //             BarChartRodData(
// // //               toY: value,
// // //               width: 14,
// // //               borderRadius: BorderRadius.circular(6),
// // //               gradient: LinearGradient(
// // //                 colors: [
// // //                   Colors.orange.shade300,
// // //                   Colors.deepOrange.shade400,
// // //                 ],
// // //                 begin: Alignment.bottomCenter,
// // //                 end: Alignment.topCenter,
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       );
// // //     }

// // //     if (maxY <= 0) maxY = 100;

// // //     double interval = maxY / 5;
// // //     if (interval.isNaN || interval.isInfinite || interval <= 0) {
// // //       interval = 20;
// // //     }

// // //     return Container(
// // //       height: 420,
// // //       padding: const EdgeInsets.all(20),
// // //       decoration: _box(),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           const Text(
// // //             "Units Sold History",
// // //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// // //           ),
// // //           const SizedBox(height: 10),
// // //           Text(
// // //             "Last ${units.length} months trend",
// // //             style: TextStyle(color: Colors.grey.shade600),
// // //           ),
// // //           const SizedBox(height: 20),
// // //           Expanded(
// // //             child: BarChart(
// // //               BarChartData(
// // //                 minY: 0,
// // //                 maxY: maxY * 1.2,
// // //                 borderData: FlBorderData(show: false),
// // //                 gridData: FlGridData(
// // //                   show: true,
// // //                   horizontalInterval: interval,
// // //                 ),
// // //                 titlesData: FlTitlesData(
// // //                   leftTitles: const AxisTitles(
// // //                     sideTitles: SideTitles(showTitles: true, reservedSize: 35),
// // //                   ),
// // //                   bottomTitles: AxisTitles(
// // //                     sideTitles: SideTitles(
// // //                       showTitles: true,
// // //                       interval: 2,
// // //                       getTitlesWidget: (value, meta) {
// // //                         int index = value.toInt();
// // //                         if (index >= 0 && index < months.length) {
// // //                           String label = months[index];
// // //                           if (label.contains("-")) {
// // //                             label = label.split("-")[1];
// // //                           }
// // //                           label = label.substring(0, 3);
// // //                           return Padding(
// // //                             padding: const EdgeInsets.only(top: 8),
// // //                             child: Text(label, style: const TextStyle(fontSize: 10)),
// // //                           );
// // //                         }
// // //                         return const SizedBox();
// // //                       },
// // //                     ),
// // //                   ),
// // //                   topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
// // //                   rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
// // //                 ),
// // //                 barGroups: bars,
// // //               ),
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   // =========================================================
// // //   // COMPARISON SECTION
// // //   // =========================================================
// // //   Widget _comparisonSection() {
// // //     double lastActual = historySales.isNotEmpty ? historySales.last : 0;
// // //     double change = predictedSales - lastActual;
// // //     double percent = lastActual == 0 ? 0 : (change / lastActual) * 100;
// // //     bool growth = change >= 0;

// // //     return Container(
// // //       width: double.infinity,
// // //       padding: const EdgeInsets.all(24),
// // //       decoration: _box(),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           const Text(
// // //             "Actual vs Predicted Analysis",
// // //             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
// // //           ),
// // //           const SizedBox(height: 24),
// // //           Row(
// // //             children: [
// // //               Expanded(child: _comparisonTile("Last Actual", "Rs ${lastActual.toStringAsFixed(0)}", Colors.blue)),
// // //               const SizedBox(width: 14),
// // //               Expanded(child: _comparisonTile("Forecast", "Rs ${predictedSales.toStringAsFixed(0)}", Colors.green)),
// // //               const SizedBox(width: 14),
// // //               Expanded(
// // //                 child: _comparisonTile(
// // //                   "Growth",
// // //                   "${percent.toStringAsFixed(1)}%",
// // //                   growth ? Colors.green : Colors.red,
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   // =========================================================
// // //   // INSIGHT CARD
// // //   // =========================================================
// // //   Widget _insightCard() {
// // //     double lastActual = historySales.isNotEmpty ? historySales.last : 0;
// // //     double change = predictedSales - lastActual;
// // //     double percent = lastActual == 0 ? 0 : (change / lastActual) * 100;
// // //     bool growth = change >= 0;

// // //     return Container(
// // //       width: double.infinity,
// // //       padding: const EdgeInsets.all(22),
// // //       decoration: BoxDecoration(
// // //         color: growth ? Colors.green.shade50 : Colors.red.shade50,
// // //         borderRadius: BorderRadius.circular(22),
// // //       ),
// // //       child: Row(
// // //         children: [
// // //           Container(
// // //             padding: const EdgeInsets.all(14),
// // //             decoration: BoxDecoration(
// // //               color: growth ? Colors.green.shade100 : Colors.red.shade100,
// // //               shape: BoxShape.circle,
// // //             ),
// // //             child: Icon(
// // //               growth ? Icons.trending_up : Icons.trending_down,
// // //               color: growth ? Colors.green : Colors.red,
// // //             ),
// // //           ),
// // //           const SizedBox(width: 18),
// // //           Expanded(
// // //             child: Column(
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 Text(
// // //                   growth ? "Positive Sales Forecast" : "Sales Decline Risk",
// // //                   style: TextStyle(
// // //                     fontSize: 18,
// // //                     fontWeight: FontWeight.bold,
// // //                     color: growth ? Colors.green : Colors.red,
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 8),
// // //                 Text(
// // //                   growth
// // //                       ? "AI predicts approximately ${percent.toStringAsFixed(1)}% growth compared to the latest actual sales performance."
// // //                       : "AI predicts approximately ${percent.abs().toStringAsFixed(1)}% decline compared to historical sales performance.",
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   // =========================================================
// // //   // ANALYTICS CARD
// // //   // =========================================================
// // //   Widget _analyticsCard(String title, String value, IconData icon, Color color) {
// // //     return Container(
// // //       padding: const EdgeInsets.all(18),
// // //       decoration: _box(),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           Container(
// // //             padding: const EdgeInsets.all(10),
// // //             decoration: BoxDecoration(
// // //               color: color.withOpacity(0.1),
// // //               borderRadius: BorderRadius.circular(14),
// // //             ),
// // //             child: Icon(icon, color: color),
// // //           ),
// // //           const SizedBox(height: 18),
// // //           Text(title, style: TextStyle(color: Colors.grey.shade700)),
// // //           const SizedBox(height: 8),
// // //           Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   // =========================================================
// // //   // HEADER STATS
// // //   // =========================================================
// // //   Widget _topStat(String title, String value, IconData icon) {
// // //     return Container(
// // //       padding: const EdgeInsets.all(16),
// // //       decoration: BoxDecoration(
// // //         color: Colors.white.withOpacity(0.15),
// // //         borderRadius: BorderRadius.circular(18),
// // //       ),
// // //       child: Column(
// // //         children: [
// // //           Icon(icon, color: Colors.white),
// // //           const SizedBox(height: 10),
// // //           Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
// // //           const SizedBox(height: 4),
// // //           Text(title, textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(0.9))),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   // =========================================================
// // //   // COMPARISON TILE
// // //   // =========================================================
// // //   Widget _comparisonTile(String title, String value, Color color) {
// // //     return Container(
// // //       padding: const EdgeInsets.all(18),
// // //       decoration: BoxDecoration(
// // //         color: color.withOpacity(0.08),
// // //         borderRadius: BorderRadius.circular(18),
// // //       ),
// // //       child: Column(
// // //         children: [
// // //           Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
// // //           const SizedBox(height: 10),
// // //           Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   // =========================================================
// // //   // LEGEND
// // //   // =========================================================
// // //   Widget _legend(Color color, String text) {
// // //     return Row(
// // //       children: [
// // //         Container(width: 14, height: 14, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
// // //         const SizedBox(width: 8),
// // //         Text(text),
// // //       ],
// // //     );
// // //   }

// // //   // =========================================================
// // //   // DROPDOWN
// // //   // =========================================================
// // //   Widget _dropdown(String label, List<String> items, String? value, Function(String?) onChanged) {
// // //     return Padding(
// // //       padding: const EdgeInsets.only(bottom: 14),
// // //       child: DropdownButtonFormField<String>(
// // //         value: items.contains(value) ? value : null,
// // //         items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
// // //         onChanged: onChanged,
// // //         decoration: InputDecoration(
// // //           labelText: label,
// // //           filled: true,
// // //           fillColor: Colors.grey.shade100,
// // //           border: OutlineInputBorder(
// // //             borderRadius: BorderRadius.circular(16),
// // //             borderSide: BorderSide.none,
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   // =========================================================
// // //   // COMMON BOX
// // //   // =========================================================
// // //   BoxDecoration _box() {
// // //     return BoxDecoration(
// // //       color: Colors.white,
// // //       borderRadius: BorderRadius.circular(24),
// // //       boxShadow: [
// // //         BoxShadow(
// // //           color: Colors.black.withOpacity(0.04),
// // //           blurRadius: 10,
// // //           offset: const Offset(0, 4),
// // //         ),
// // //       ],
// // //     );
// // //   }

// // //   // =========================================================
// // //   // BUILD
// // //   // =========================================================
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: const Color(0xffF4F7FC),
// // //       appBar: AppBar(
// // //         elevation: 0,
// // //         backgroundColor: Colors.white,
// // //         foregroundColor: Colors.black,
// // //         title: const Text(
// // //           "AI Forecast Dashboard",
// // //           style: TextStyle(fontWeight: FontWeight.bold),
// // //         ),
// // //         actions: [
// // //           _refreshPricesButton(),
// // //         ],
// // //       ),
// // //       body: SingleChildScrollView(
// // //         padding: const EdgeInsets.all(20),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             Container(
// // //               width: double.infinity,
// // //               padding: const EdgeInsets.all(24),
// // //               decoration: BoxDecoration(
// // //                 gradient: LinearGradient(
// // //                   colors: [Colors.blue.shade700, Colors.indigo.shade600],
// // //                   begin: Alignment.topLeft,
// // //                   end: Alignment.bottomRight,
// // //                 ),
// // //                 borderRadius: BorderRadius.circular(28),
// // //               ),
// // //               child: Column(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   const Text(
// // //                     "AI Retail Analytics",
// // //                     style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
// // //                   ),
// // //                   const SizedBox(height: 12),
// // //                   Text(
// // //                     "Advanced machine learning forecasting system for inventory intelligence",
// // //                     style: TextStyle(color: Colors.white.withOpacity(0.92), height: 1.5),
// // //                   ),
// // //                   const SizedBox(height: 24),
// // //                   Row(
// // //                     children: [
// // //                       Expanded(child: _topStat("Accuracy", "${accuracy.toStringAsFixed(1)}%", Icons.analytics)),
// // //                       const SizedBox(width: 14),
// // //                       Expanded(child: _topStat("Forecast Units", predictedUnits.toStringAsFixed(0), Icons.inventory_2)),
// // //                     ],
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //             const SizedBox(height: 24),
// // //             _controlCard(),
// // //             const SizedBox(height: 24),
// // //             if (historySales.isNotEmpty) ...[
// // //               Row(
// // //                 children: [
// // //                   Expanded(child: _analyticsCard("Predicted Revenue", "Rs ${predictedSales.toStringAsFixed(0)}", Icons.currency_rupee, Colors.blue)),
// // //                   const SizedBox(width: 14),
// // //                   Expanded(child: _analyticsCard("Latest Units", latestUnits.toStringAsFixed(0), Icons.shopping_cart, Colors.orange)),
// // //                   const SizedBox(width: 14),
// // //                   Expanded(child: _analyticsCard("Rolling Average", rollingAvg.toStringAsFixed(0), Icons.show_chart, Colors.green)),
// // //                 ],
// // //               ),
// // //               const SizedBox(height: 24),
// // //               Row(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   Expanded(flex: 2, child: _salesChart()),
// // //                   const SizedBox(width: 18),
// // //                   Expanded(child: _unitsChart()),
// // //                 ],
// // //               ),
// // //               const SizedBox(height: 24),
// // //               _comparisonSection(),
// // //               const SizedBox(height: 24),
// // //               _insightCard(),
// // //             ],
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // import 'dart:convert';
// // import 'package:fl_chart/fl_chart.dart';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:cloud_firestore/cloud_firestore.dart';

// // class PredictionPage extends StatefulWidget {
// //   const PredictionPage({super.key});

// //   @override
// //   State<PredictionPage> createState() => _PredictionPageState();
// // }

// // class _PredictionPageState extends State<PredictionPage> {
// //   // =========================================================
// //   // DATA
// //   // =========================================================
// //   List<double> historySales = [];
// //   List<double> historyUnits = [];
// //   List<String> historyMonths = [];

// //   List<String> categories = [];
// //   List<String> products = [];
// //   List<String> months = [];

// //   String? selectedCategory;
// //   String? selectedProduct;
// //   String? selectedMonth;

// //   bool loading = false;

// //   // =========================================================
// //   // ML RESULTS
// //   // =========================================================
// //   double predictedSales = 0;
// //   double predictedUnits = 0;
// //   double predictedProfit = 0;
// //   double latestUnits = 0;
// //   double rollingAvg = 0;
// //   double accuracy = 0;
// //   double priceUsed = 0;
// //   double costUsed = 0;
// //   double profitMargin = 0;

// //   final TextEditingController priceController = TextEditingController(text: "500");

// //   final String baseUrl = "http://192.168.100.218:5000";
// //   final FirebaseFirestore firestore = FirebaseFirestore.instance;

// //   // =========================================================
// //   // INIT
// //   // =========================================================
// //   @override
// //   void initState() {
// //     super.initState();
// //     initialize();
// //   }

// //   Future<void> initialize() async {
// //     await loadCategories();
// //     await loadMonths();
// //   }

// //   // =========================================================
// //   // FETCH PRODUCT PRICE FROM FLASK BACKEND (EXCEL)
// //   // =========================================================
// //   Future<Map<String, dynamic>> fetchProductPriceFromExcel(String product) async {
// //     try {
// //       final res = await http.get(
// //         Uri.parse("$baseUrl/product_price?product=$product"),
// //       );
      
// //       if (res.statusCode == 200) {
// //         final data = jsonDecode(res.body);
// //         return {
// //           "price": (data["price"] ?? 500).toDouble(),
// //           "cost": (data["cost"] ?? 325).toDouble(),
// //           "profit_margin": (data["profit_margin"] ?? 0).toDouble(),
// //         };
// //       }
// //     } catch (e) {
// //       debugPrint("Error fetching price from Excel: $e");
// //     }
    
// //     return {"price": 500.0, "cost": 325.0, "profit_margin": 35.0};
// //   }

// //   // =========================================================
// //   // FETCH LIST
// //   // =========================================================
// //   Future<List<String>> fetchList(String endpoint, String key) async {
// //     try {
// //       final res = await http.get(Uri.parse("$baseUrl/$endpoint"));
// //       final data = jsonDecode(res.body);
// //       return List<String>.from(data[key] ?? []);
// //     } catch (_) {
// //       return [];
// //     }
// //   }

// //   Future<void> loadCategories() async {
// //     categories = await fetchList("categories", "categories");

// //     setState(() {
// //       selectedCategory = categories.isNotEmpty ? categories.first : null;
// //       selectedProduct = null;
// //       products = [];
// //     });

// //     if (selectedCategory != null) {
// //       await loadProducts(selectedCategory!);
// //     }
// //   }

// //   Future<void> loadProducts(String category) async {
// //     try {
// //       final res = await http.get(
// //         Uri.parse("$baseUrl/products?category=$category"),
// //       );

// //       final data = jsonDecode(res.body);

// //       setState(() {
// //         products = List<String>.from(data["products"] ?? []);
// //         selectedProduct = products.isNotEmpty ? products.first : null;
// //       });
      
// //       // Fetch price from Excel for the first product
// //       if (selectedProduct != null) {
// //         final priceData = await fetchProductPriceFromExcel(selectedProduct!);
// //         priceController.text = priceData["price"].toStringAsFixed(0);
// //       }
// //     } catch (_) {
// //       setState(() {
// //         products = [];
// //         selectedProduct = null;
// //       });
// //     }
// //   }

// //   Future<void> loadMonths() async {
// //     months = await fetchList("months", "months");

// //     setState(() {
// //       selectedMonth = months.isNotEmpty ? months.last : null;
// //     });
// //   }

// //   int getMonthIndex(String month) {
// //     const monthOrder = [
// //       "jan","feb","mar","apr","may","jun",
// //       "jul","aug","sep","oct","nov","dec",
// //     ];

// //     String shortMonth = month.toLowerCase().substring(0, 3);
// //     return monthOrder.indexOf(shortMonth);
// //   }

// //   // =========================================================
// //   // PREDICT + FIRESTORE SAVE
// //   // =========================================================
// //   Future<void> predict() async {
// //     if (selectedCategory == null || selectedProduct == null || selectedMonth == null) {
// //       return;
// //     }

// //     setState(() => loading = true);

// //     try {
// //       final res = await http.post(
// //         Uri.parse("$baseUrl/predict"),
// //         headers: {"Content-Type": "application/json"},
// //         body: jsonEncode({
// //           "category": selectedCategory,
// //           "product": selectedProduct,
// //           "month": selectedMonth,
// //           "price": double.tryParse(priceController.text) ?? 0,
// //         }),
// //       );

// //       final data = jsonDecode(res.body);

// //       // Check for error
// //       if (data.containsKey("error")) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text(data["error"]), backgroundColor: Colors.red),
// //         );
// //         setState(() => loading = false);
// //         return;
// //       }

// //       List<String> rawMonths = List<String>.from(data["history_months"] ?? []);
// //       List<double> rawSales = List<double>.from((data["history_sales"] ?? [])
// //           .map((e) => (e as num).toDouble()));
// //       List<double> rawUnits = List<double>.from((data["history_units"] ?? [])
// //           .map((e) => (e as num).toDouble()));

// //       List<Map<String, dynamic>> combined = [];

// //       for (int i = 0; i < rawMonths.length; i++) {
// //         combined.add({
// //           "month": rawMonths[i],
// //           "sales": i < rawSales.length ? rawSales[i] : 0,
// //           "units": i < rawUnits.length ? rawUnits[i] : 0,
// //         });
// //       }

// //       combined.sort((a, b) {
// //         try {
// //           final aParts = a["month"].toString().split("-");
// //           final bParts = b["month"].toString().split("-");

// //           int aYear = int.parse(aParts[0]);
// //           int bYear = int.parse(bParts[0]);

// //           int aMonth = getMonthIndex(aParts[1]);
// //           int bMonth = getMonthIndex(bParts[1]);

// //           if (aYear != bYear) {
// //             return aYear.compareTo(bYear);
// //           }
// //           return aMonth.compareTo(bMonth);
// //         } catch (_) {
// //           return 0;
// //         }
// //       });

// //       setState(() {
// //         historyMonths = combined.map((e) => e["month"].toString()).toList();
// //         historySales = combined.map((e) => (e["sales"] as num).toDouble()).toList();
// //         historyUnits = combined.map((e) => (e["units"] as num).toDouble()).toList();
        
// //         predictedUnits = (data["predicted_units"] ?? 0).toDouble();
// //         predictedSales = (data["predicted_sales"] ?? 0).toDouble();
// //         predictedProfit = (data["predicted_profit"] ?? 0).toDouble();
// //         latestUnits = (data["latest_units"] ?? 0).toDouble();
// //         rollingAvg = (data["rolling_avg"] ?? 0).toDouble();
// //         accuracy = (data["accuracy"] ?? 0).toDouble();
// //         priceUsed = (data["price_used"] ?? 0).toDouble();
// //         costUsed = (data["cost_used"] ?? 0).toDouble();
// //         profitMargin = (data["profit_margin"] ?? 0).toDouble();
        
// //         loading = false;
// //       });

// //       // Update price controller with the price used
// //       priceController.text = priceUsed.toStringAsFixed(0);

// //       await firestore.collection("prediction_history").add({
// //         "category": selectedCategory,
// //         "product": selectedProduct,
// //         "month": selectedMonth,
// //         "price": priceUsed,
// //         "cost": costUsed,
// //         "predicted_sales": predictedSales,
// //         "predicted_units": predictedUnits,
// //         "predicted_profit": predictedProfit,
// //         "created_at": FieldValue.serverTimestamp(),
// //       });

// //       final docId = "${selectedProduct}_${selectedCategory}".replaceAll(" ", "_");

// //       await firestore
// //           .collection("inventory_predictions")
// //           .doc(docId)
// //           .set({
// //         "product": selectedProduct,
// //         "category": selectedCategory,
// //         "month": selectedMonth,
// //         "predicted_units": predictedUnits,
// //         "predicted_sales": predictedSales,
// //         "predicted_profit": predictedProfit,
// //         "price_used": priceUsed,
// //         "cost_used": costUsed,
// //         "updated_at": FieldValue.serverTimestamp(),
// //       });
      
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text("✅ Prediction complete! ${accuracy.toStringAsFixed(1)}% accuracy"),
// //           backgroundColor: Colors.green,
// //           duration: const Duration(seconds: 2),
// //         ),
// //       );
      
// //     } catch (e) {
// //       setState(() => loading = false);
// //       debugPrint(e.toString());
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
// //       );
// //     }
// //   }

// //   // =========================================================
// //   // CONTROL CARD
// //   // =========================================================
// //   Widget _controlCard() {
// //     return Container(
// //       padding: const EdgeInsets.all(22),
// //       decoration: _box(),
// //       child: Column(
// //         children: [
// //           _dropdown(
// //             "Category",
// //             categories,
// //             selectedCategory,
// //             (v) async {
// //               setState(() {
// //                 selectedCategory = v;
// //                 selectedProduct = null;
// //                 products = [];
// //               });
// //               if (v != null) {
// //                 await loadProducts(v);
// //               }
// //             },
// //           ),

// //           _dropdown(
// //             "Product",
// //             products,
// //             selectedProduct,
// //             (v) async {
// //               setState(() {
// //                 selectedProduct = v;
// //               });
              
// //               // Fetch price from Excel backend
// //               if (v != null) {
// //                 final priceData = await fetchProductPriceFromExcel(v);
// //                 priceController.text = priceData["price"].toStringAsFixed(0);
                
// //                 if (mounted) {
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     SnackBar(
// //                       content: Text("📦 Price: ₹${priceData["price"].toStringAsFixed(0)} | Cost: ₹${priceData["cost"].toStringAsFixed(0)}"),
// //                       backgroundColor: Colors.blue,
// //                       duration: const Duration(seconds: 2),
// //                     ),
// //                   );
// //                 }
// //               }
// //             },
// //           ),

// //           _dropdown(
// //             "Forecast Month",
// //             months,
// //             selectedMonth,
// //             (v) {
// //               setState(() {
// //                 selectedMonth = v;
// //               });
// //             },
// //           ),

// //           const SizedBox(height: 12),

// //           TextField(
// //             controller: priceController,
// //             keyboardType: TextInputType.number,
// //             decoration: InputDecoration(
// //               labelText: "Unit Price (₹)",
// //               prefixIcon: const Icon(Icons.currency_rupee),
// //               hintText: "Auto-loaded from Excel",
// //               helperText: "Price fetched from your Excel dataset",
// //               helperStyle: TextStyle(fontSize: 10, color: Colors.grey.shade500),
// //               filled: true,
// //               fillColor: Colors.grey.shade100,
// //               border: OutlineInputBorder(
// //                 borderRadius: BorderRadius.circular(16),
// //                 borderSide: BorderSide.none,
// //               ),
// //             ),
// //           ),

// //           const SizedBox(height: 22),

// //           SizedBox(
// //             width: double.infinity,
// //             height: 54,
// //             child: ElevatedButton(
// //               onPressed: loading ? null : predict,
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: Colors.blue.shade700,
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(16),
// //                 ),
// //               ),
// //               child: loading
// //                   ? const CircularProgressIndicator(color: Colors.white)
// //                   : const Text(
// //                       "RUN AI FORECAST",
// //                       style: TextStyle(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _refreshButton() {
// //     return IconButton(
// //       icon: const Icon(Icons.refresh),
// //       onPressed: () async {
// //         if (selectedCategory != null) {
// //           await loadProducts(selectedCategory!);
// //           if (mounted) {
// //             ScaffoldMessenger.of(context).showSnackBar(
// //               const SnackBar(content: Text("Data refreshed from Excel")),
// //             );
// //           }
// //         }
// //       },
// //       tooltip: "Refresh from Excel",
// //     );
// //   }

// //   // =========================================================
// //   // SALES CHART
// //   // =========================================================
// //   Widget _salesChart() {
// //     const int maxPoints = 12;

// //     List<double> sales = List.from(historySales);
// //     List<String> monthsList = List.from(historyMonths);

// //     if (sales.length > maxPoints) {
// //       sales = sales.sublist(sales.length - maxPoints);
// //       monthsList = monthsList.sublist(monthsList.length - maxPoints);
// //     }

// //     if (sales.isEmpty) {
// //       return Container(
// //         height: 420,
// //         padding: const EdgeInsets.all(20),
// //         decoration: _box(),
// //         child: const Center(child: Text("Run prediction to see chart")),
// //       );
// //     }

// //     List<FlSpot> actualSpots = [];

// //     for (int i = 0; i < sales.length; i++) {
// //       double v = sales[i];
// //       if (v.isNaN || v.isInfinite) v = 0;
// //       actualSpots.add(FlSpot(i.toDouble(), v));
// //     }

// //     double safePrediction = predictedSales;
// //     if (safePrediction.isNaN || safePrediction.isInfinite || safePrediction <= 0) {
// //       safePrediction = sales.last;
// //     }

// //     final predictionSpot = FlSpot(sales.length.toDouble(), safePrediction);
// //     List<FlSpot> forecastSpots = [
// //       actualSpots.last,
// //       predictionSpot,
// //     ];

// //     double maxY = sales.reduce((a, b) => a > b ? a : b);
// //     if (safePrediction > maxY) maxY = safePrediction;
// //     if (maxY <= 0) maxY = 100;

// //     double interval = maxY / 5;
// //     if (interval.isNaN || interval.isInfinite || interval <= 0) {
// //       interval = 20;
// //     }

// //     return Container(
// //       height: 420,
// //       padding: const EdgeInsets.all(20),
// //       decoration: _box(),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           const Text(
// //             "Actual Sales vs Forecast",
// //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// //           ),
// //           const SizedBox(height: 20),
// //           Expanded(
// //             child: LineChart(
// //               LineChartData(
// //                 minY: 0,
// //                 maxY: maxY * 1.2,
// //                 gridData: FlGridData(
// //                   show: true,
// //                   horizontalInterval: interval,
// //                 ),
// //                 borderData: FlBorderData(show: false),
// //                 titlesData: FlTitlesData(
// //                   leftTitles: const AxisTitles(
// //                     sideTitles: SideTitles(showTitles: true, reservedSize: 45),
// //                   ),
// //                   bottomTitles: AxisTitles(
// //                     sideTitles: SideTitles(
// //                       showTitles: true,
// //                       interval: 2,
// //                       getTitlesWidget: (value, meta) {
// //                         int i = value.toInt();
// //                         if (i >= 0 && i < monthsList.length) {
// //                           String m = monthsList[i];
// //                           if (m.contains("-")) {
// //                             m = m.split("-")[1];
// //                           }
// //                           return Text(m.substring(0, 3),
// //                               style: const TextStyle(fontSize: 10));
// //                         }
// //                         return const SizedBox();
// //                       },
// //                     ),
// //                   ),
// //                   topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
// //                   rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
// //                 ),
// //                 lineBarsData: [
// //                   LineChartBarData(
// //                     spots: actualSpots,
// //                     isCurved: true,
// //                     color: Colors.blue,
// //                     barWidth: 4,
// //                     dotData: const FlDotData(show: false),
// //                   ),
// //                   LineChartBarData(
// //                     spots: forecastSpots,
// //                     isCurved: true,
// //                     color: Colors.green,
// //                     barWidth: 4,
// //                     dashArray: [6, 4],
// //                     dotData: const FlDotData(show: true),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //           const SizedBox(height: 12),
// //           Row(
// //             children: [
// //               _legend(Colors.blue, "Actual Sales"),
// //               const SizedBox(width: 20),
// //               _legend(Colors.green, "Forecast"),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // =========================================================
// //   // UNITS BAR CHART
// //   // =========================================================
// //   Widget _unitsChart() {
// //     const int maxPoints = 12;

// //     List<double> units = List.from(historyUnits);
// //     List<String> monthsList = List.from(historyMonths);

// //     if (units.length > maxPoints) {
// //       units = units.sublist(units.length - maxPoints);
// //       monthsList = monthsList.sublist(monthsList.length - maxPoints);
// //     }

// //     if (units.isEmpty) {
// //       return Container(
// //         height: 420,
// //         padding: const EdgeInsets.all(20),
// //         decoration: _box(),
// //         child: const Center(child: Text("Run prediction to see chart")),
// //       );
// //     }

// //     List<BarChartGroupData> bars = [];
// //     double maxY = 0;

// //     for (int i = 0; i < units.length; i++) {
// //       double value = units[i];
// //       if (value.isNaN || value.isInfinite) value = 0;
// //       if (value > maxY) maxY = value;

// //       bars.add(
// //         BarChartGroupData(
// //           x: i,
// //           barRods: [
// //             BarChartRodData(
// //               toY: value,
// //               width: 14,
// //               borderRadius: BorderRadius.circular(6),
// //               gradient: LinearGradient(
// //                 colors: [
// //                   Colors.orange.shade300,
// //                   Colors.deepOrange.shade400,
// //                 ],
// //                 begin: Alignment.bottomCenter,
// //                 end: Alignment.topCenter,
// //               ),
// //             ),
// //           ],
// //         ),
// //       );
// //     }

// //     if (maxY <= 0) maxY = 100;

// //     double interval = maxY / 5;
// //     if (interval.isNaN || interval.isInfinite || interval <= 0) {
// //       interval = 20;
// //     }

// //     return Container(
// //       height: 420,
// //       padding: const EdgeInsets.all(20),
// //       decoration: _box(),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           const Text(
// //             "Units Sold History",
// //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// //           ),
// //           const SizedBox(height: 10),
// //           Text(
// //             "Last ${units.length} months trend",
// //             style: TextStyle(color: Colors.grey.shade600),
// //           ),
// //           const SizedBox(height: 20),
// //           Expanded(
// //             child: BarChart(
// //               BarChartData(
// //                 minY: 0,
// //                 maxY: maxY * 1.2,
// //                 borderData: FlBorderData(show: false),
// //                 gridData: FlGridData(
// //                   show: true,
// //                   horizontalInterval: interval,
// //                 ),
// //                 titlesData: FlTitlesData(
// //                   leftTitles: const AxisTitles(
// //                     sideTitles: SideTitles(showTitles: true, reservedSize: 35),
// //                   ),
// //                   bottomTitles: AxisTitles(
// //                     sideTitles: SideTitles(
// //                       showTitles: true,
// //                       interval: 2,
// //                       getTitlesWidget: (value, meta) {
// //                         int index = value.toInt();
// //                         if (index >= 0 && index < monthsList.length) {
// //                           String label = monthsList[index];
// //                           if (label.contains("-")) {
// //                             label = label.split("-")[1];
// //                           }
// //                           label = label.substring(0, 3);
// //                           return Padding(
// //                             padding: const EdgeInsets.only(top: 8),
// //                             child: Text(label, style: const TextStyle(fontSize: 10)),
// //                           );
// //                         }
// //                         return const SizedBox();
// //                       },
// //                     ),
// //                   ),
// //                   topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
// //                   rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
// //                 ),
// //                 barGroups: bars,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // =========================================================
// //   // UPDATED METRICS ROW WITH PROFIT
// //   // =========================================================
// //   Widget _metricsRow() {
// //     return Row(
// //       children: [
// //         Expanded(
// //           child: _analyticsCard(
// //             "Predicted Revenue",
// //             "₹ ${predictedSales.toStringAsFixed(0)}",
// //             Icons.currency_rupee,
// //             Colors.blue,
// //           ),
// //         ),
// //         const SizedBox(width: 12),
// //         Expanded(
// //           child: _analyticsCard(
// //             "Predicted Profit",
// //             "₹ ${predictedProfit.toStringAsFixed(0)}",
// //             Icons.trending_up,
// //             Colors.green,
// //           ),
// //         ),
// //         const SizedBox(width: 12),
// //         Expanded(
// //           child: _analyticsCard(
// //             "Margin",
// //             "${profitMargin.toStringAsFixed(1)}%",
// //             Icons.percent,
// //             Colors.purple,
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   // =========================================================
// //   // COMPARISON SECTION
// //   // =========================================================
// //   Widget _comparisonSection() {
// //     double lastActual = historySales.isNotEmpty ? historySales.last : 0;
// //     double change = predictedSales - lastActual;
// //     double percent = lastActual == 0 ? 0 : (change / lastActual) * 100;
// //     bool growth = change >= 0;

// //     return Container(
// //       width: double.infinity,
// //       padding: const EdgeInsets.all(24),
// //       decoration: _box(),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           const Text(
// //             "Actual vs Predicted Analysis",
// //             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
// //           ),
// //           const SizedBox(height: 24),
// //           Row(
// //             children: [
// //               Expanded(child: _comparisonTile("Last Actual", "₹ ${lastActual.toStringAsFixed(0)}", Colors.blue)),
// //               const SizedBox(width: 14),
// //               Expanded(child: _comparisonTile("Forecast", "₹ ${predictedSales.toStringAsFixed(0)}", Colors.green)),
// //               const SizedBox(width: 14),
// //               Expanded(
// //                 child: _comparisonTile(
// //                   "Growth",
// //                   "${percent.toStringAsFixed(1)}%",
// //                   growth ? Colors.green : Colors.red,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // =========================================================
// //   // INSIGHT CARD
// //   // =========================================================
// //   Widget _insightCard() {
// //     double lastActual = historySales.isNotEmpty ? historySales.last : 0;
// //     double change = predictedSales - lastActual;
// //     double percent = lastActual == 0 ? 0 : (change / lastActual) * 100;
// //     bool growth = change >= 0;

// //     return Container(
// //       width: double.infinity,
// //       padding: const EdgeInsets.all(22),
// //       decoration: BoxDecoration(
// //         color: growth ? Colors.green.shade50 : Colors.red.shade50,
// //         borderRadius: BorderRadius.circular(22),
// //       ),
// //       child: Row(
// //         children: [
// //           Container(
// //             padding: const EdgeInsets.all(14),
// //             decoration: BoxDecoration(
// //               color: growth ? Colors.green.shade100 : Colors.red.shade100,
// //               shape: BoxShape.circle,
// //             ),
// //             child: Icon(
// //               growth ? Icons.trending_up : Icons.trending_down,
// //               color: growth ? Colors.green : Colors.red,
// //             ),
// //           ),
// //           const SizedBox(width: 18),
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   growth ? "Positive Sales Forecast" : "Sales Decline Risk",
// //                   style: TextStyle(
// //                     fontSize: 18,
// //                     fontWeight: FontWeight.bold,
// //                     color: growth ? Colors.green : Colors.red,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 8),
// //                 Text(
// //                   growth
// //                       ? "AI predicts approximately ${percent.toStringAsFixed(1)}% growth. Expected profit: ₹${predictedProfit.toStringAsFixed(0)}"
// //                       : "AI predicts approximately ${percent.abs().toStringAsFixed(1)}% decline. Review inventory levels.",
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // =========================================================
// //   // ANALYTICS CARD
// //   // =========================================================
// //   Widget _analyticsCard(String title, String value, IconData icon, Color color) {
// //     return Container(
// //       padding: const EdgeInsets.all(18),
// //       decoration: _box(),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Container(
// //             padding: const EdgeInsets.all(10),
// //             decoration: BoxDecoration(
// //               color: color.withOpacity(0.1),
// //               borderRadius: BorderRadius.circular(14),
// //             ),
// //             child: Icon(icon, color: color),
// //           ),
// //           const SizedBox(height: 18),
// //           Text(title, style: TextStyle(color: Colors.grey.shade700)),
// //           const SizedBox(height: 8),
// //           Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
// //         ],
// //       ),
// //     );
// //   }

// //   // =========================================================
// //   // HEADER STATS
// //   // =========================================================
// //   Widget _topStat(String title, String value, IconData icon) {
// //     return Container(
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: Colors.white.withOpacity(0.15),
// //         borderRadius: BorderRadius.circular(18),
// //       ),
// //       child: Column(
// //         children: [
// //           Icon(icon, color: Colors.white),
// //           const SizedBox(height: 10),
// //           Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
// //           const SizedBox(height: 4),
// //           Text(title, textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(0.9))),
// //         ],
// //       ),
// //     );
// //   }

// //   // =========================================================
// //   // COMPARISON TILE
// //   // =========================================================
// //   Widget _comparisonTile(String title, String value, Color color) {
// //     return Container(
// //       padding: const EdgeInsets.all(18),
// //       decoration: BoxDecoration(
// //         color: color.withOpacity(0.08),
// //         borderRadius: BorderRadius.circular(18),
// //       ),
// //       child: Column(
// //         children: [
// //           Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
// //           const SizedBox(height: 10),
// //           Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
// //         ],
// //       ),
// //     );
// //   }

// //   // =========================================================
// //   // LEGEND
// //   // =========================================================
// //   Widget _legend(Color color, String text) {
// //     return Row(
// //       children: [
// //         Container(width: 14, height: 14, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
// //         const SizedBox(width: 8),
// //         Text(text),
// //       ],
// //     );
// //   }

// //   // =========================================================
// //   // DROPDOWN
// //   // =========================================================
// //   Widget _dropdown(String label, List<String> items, String? value, Function(String?) onChanged) {
// //     return Padding(
// //       padding: const EdgeInsets.only(bottom: 14),
// //       child: DropdownButtonFormField<String>(
// //         value: items.contains(value) ? value : null,
// //         items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
// //         onChanged: onChanged,
// //         decoration: InputDecoration(
// //           labelText: label,
// //           filled: true,
// //           fillColor: Colors.grey.shade100,
// //           border: OutlineInputBorder(
// //             borderRadius: BorderRadius.circular(16),
// //             borderSide: BorderSide.none,
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   // =========================================================
// //   // COMMON BOX
// //   // =========================================================
// //   BoxDecoration _box() {
// //     return BoxDecoration(
// //       color: Colors.white,
// //       borderRadius: BorderRadius.circular(24),
// //       boxShadow: [
// //         BoxShadow(
// //           color: Colors.black.withOpacity(0.04),
// //           blurRadius: 10,
// //           offset: const Offset(0, 4),
// //         ),
// //       ],
// //     );
// //   }

// //   // =========================================================
// //   // BUILD
// //   // =========================================================
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xffF4F7FC),
// //       appBar: AppBar(
// //         elevation: 0,
// //         backgroundColor: Colors.white,
// //         foregroundColor: Colors.black,
// //         title: const Text(
// //           "AI Forecast Dashboard",
// //           style: TextStyle(fontWeight: FontWeight.bold),
// //         ),
// //         actions: [
// //           _refreshButton(),
// //         ],
// //       ),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(20),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Container(
// //               width: double.infinity,
// //               padding: const EdgeInsets.all(24),
// //               decoration: BoxDecoration(
// //                 gradient: LinearGradient(
// //                   colors: [Colors.blue.shade700, Colors.indigo.shade600],
// //                   begin: Alignment.topLeft,
// //                   end: Alignment.bottomRight,
// //                 ),
// //                 borderRadius: BorderRadius.circular(28),
// //               ),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   const Text(
// //                     "AI Retail Analytics",
// //                     style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
// //                   ),
// //                   const SizedBox(height: 12),
// //                   Text(
// //                     "Advanced machine learning forecasting system for inventory intelligence",
// //                     style: TextStyle(color: Colors.white.withOpacity(0.92), height: 1.5),
// //                   ),
// //                   const SizedBox(height: 24),
// //                   Row(
// //                     children: [
// //                       Expanded(child: _topStat("Accuracy", "${accuracy.toStringAsFixed(1)}%", Icons.analytics)),
// //                       const SizedBox(width: 14),
// //                       Expanded(child: _topStat("Forecast Units", predictedUnits.toStringAsFixed(0), Icons.inventory_2)),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             const SizedBox(height: 24),
// //             _controlCard(),
// //             const SizedBox(height: 24),
// //             if (historySales.isNotEmpty) ...[
// //               _metricsRow(),
// //               const SizedBox(height: 24),
// //               Row(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Expanded(flex: 2, child: _salesChart()),
// //                   const SizedBox(width: 18),
// //                   Expanded(child: _unitsChart()),
// //                 ],
// //               ),
// //               const SizedBox(height: 24),
// //               _comparisonSection(),
// //               const SizedBox(height: 24),
// //               _insightCard(),
// //             ],
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'dart:convert';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:cloud_firestore/cloud_firestore.dart';

// class PredictionPage extends StatefulWidget {
//   const PredictionPage({super.key});

//   @override
//   State<PredictionPage> createState() => _PredictionPageState();
// }

// class _PredictionPageState extends State<PredictionPage> {

//   // =========================================================
//   // DATA
//   // =========================================================

//   List<double> historySales = [];
//   List<double> historyUnits = [];
//   List<String> historyMonths = [];

//   List<String> categories = [];
//   List<String> products = [];
//   List<String> months = [];

//   String? selectedCategory;
//   String? selectedProduct;
//   String? selectedMonth;

//   bool loading = false;

//   // =========================================================
//   // ML RESULTS
//   // =========================================================

//   double predictedSales = 0;
//   double predictedUnits = 0;
//   double predictedProfit = 0;
//   double latestUnits = 0;
//   double rollingAvg = 0;
//   double accuracy = 0;
//   double priceUsed = 0;
//   double costUsed = 0;
//   double profitMargin = 0;
//   double totalCost = 0;
//   double profitRate = 0;

//   final TextEditingController priceController = TextEditingController(text: "500");
//   final TextEditingController costController = TextEditingController(text: "325");

//   final String baseUrl = "http://192.168.100.218:5000";
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;

//   // =========================================================
//   // INIT
//   // =========================================================

//   @override
//   void initState() {
//     super.initState();
//     initialize();
//   }

//   Future<void> initialize() async {
//     await loadCategories();
//     await loadMonths();
//   }

//   // =========================================================
//   // FETCH PRODUCT PRICE & COST FROM FLASK BACKEND (EXCEL)
//   // =========================================================
//   Future<Map<String, dynamic>> fetchProductPriceFromExcel(String product) async {
//     try {
//       final res = await http.get(
//         Uri.parse("$baseUrl/product_price?product=$product"),
//       );
      
//       if (res.statusCode == 200) {
//         final data = jsonDecode(res.body);
//         return {
//           "price": (data["price"] ?? 500).toDouble(),
//           "cost": (data["cost"] ?? 325).toDouble(),
//           "profit_margin": (data["profit_margin"] ?? 0).toDouble(),
//         };
//       }
//     } catch (e) {
//       debugPrint("Error fetching price from Excel: $e");
//     }
    
//     return {"price": 500.0, "cost": 325.0, "profit_margin": 35.0};
//   }

//   // =========================================================
//   // FETCH LIST
//   // =========================================================

//   Future<List<String>> fetchList(String endpoint, String key) async {
//     try {
//       final res = await http.get(Uri.parse("$baseUrl/$endpoint"));
//       final data = jsonDecode(res.body);
//       return List<String>.from(data[key] ?? []);
//     } catch (_) {
//       return [];
//     }
//   }

//   Future<void> loadCategories() async {
//     categories = await fetchList("categories", "categories");

//     setState(() {
//       selectedCategory = categories.isNotEmpty ? categories.first : null;
//       selectedProduct = null;
//       products = [];
//     });

//     if (selectedCategory != null) {
//       await loadProducts(selectedCategory!);
//     }
//   }

//   Future<void> loadProducts(String category) async {
//     try {
//       final res = await http.get(
//         Uri.parse("$baseUrl/products?category=$category"),
//       );

//       final data = jsonDecode(res.body);

//       setState(() {
//         products = List<String>.from(data["products"] ?? []);
//         selectedProduct = products.isNotEmpty ? products.first : null;
//       });
      
//       // Fetch price & cost from Excel for the first product
//       if (selectedProduct != null) {
//         final priceData = await fetchProductPriceFromExcel(selectedProduct!);
//         priceController.text = priceData["price"].toStringAsFixed(0);
//         costController.text = priceData["cost"].toStringAsFixed(0);
//       }
//     } catch (_) {
//       setState(() {
//         products = [];
//         selectedProduct = null;
//       });
//     }
//   }

//   Future<void> loadMonths() async {
//     months = await fetchList("months", "months");

//     setState(() {
//       selectedMonth = months.isNotEmpty ? months.last : null;
//     });
//   }

//   int getMonthIndex(String month) {
//     const monthOrder = [
//       "jan","feb","mar","apr","may","jun",
//       "jul","aug","sep","oct","nov","dec",
//     ];

//     String shortMonth = month.toLowerCase().substring(0, 3);
//     return monthOrder.indexOf(shortMonth);
//   }

//   // =========================================================
//   // PREDICT + FIRESTORE SAVE
//   // =========================================================
//   Future<void> predict() async {
//     if (selectedCategory == null || selectedProduct == null || selectedMonth == null) {
//       return;
//     }

//     setState(() => loading = true);

//     try {
//       final res = await http.post(
//         Uri.parse("$baseUrl/predict"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "category": selectedCategory,
//           "product": selectedProduct,
//           "month": selectedMonth,
//           "price": double.tryParse(priceController.text) ?? 0,
//         }),
//       );

//       final data = jsonDecode(res.body);

//       if (data.containsKey("error")) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(data["error"]), backgroundColor: Colors.red),
//         );
//         setState(() => loading = false);
//         return;
//       }

//       List<String> rawMonths = List<String>.from(data["history_months"] ?? []);
//       List<double> rawSales = List<double>.from((data["history_sales"] ?? [])
//           .map((e) => (e as num).toDouble()));
//       List<double> rawUnits = List<double>.from((data["history_units"] ?? [])
//           .map((e) => (e as num).toDouble()));

//       List<Map<String, dynamic>> combined = [];

//       for (int i = 0; i < rawMonths.length; i++) {
//         combined.add({
//           "month": rawMonths[i],
//           "sales": i < rawSales.length ? rawSales[i] : 0,
//           "units": i < rawUnits.length ? rawUnits[i] : 0,
//         });
//       }

//       combined.sort((a, b) {
//         try {
//           final aParts = a["month"].toString().split("-");
//           final bParts = b["month"].toString().split("-");

//           int aYear = int.parse(aParts[0]);
//           int bYear = int.parse(bParts[0]);

//           int aMonth = getMonthIndex(aParts[1]);
//           int bMonth = getMonthIndex(bParts[1]);

//           if (aYear != bYear) {
//             return aYear.compareTo(bYear);
//           }
//           return aMonth.compareTo(bMonth);
//         } catch (_) {
//           return 0;
//         }
//       });

//       setState(() {
//         historyMonths = combined.map((e) => e["month"].toString()).toList();
//         historySales = combined.map((e) => (e["sales"] as num).toDouble()).toList();
//         historyUnits = combined.map((e) => (e["units"] as num).toDouble()).toList();
        
//         predictedUnits = (data["predicted_units"] ?? 0).toDouble();
//         predictedSales = (data["predicted_sales"] ?? 0).toDouble();
//         predictedProfit = (data["predicted_profit"] ?? 0).toDouble();
//         latestUnits = (data["latest_units"] ?? 0).toDouble();
//         rollingAvg = (data["rolling_avg"] ?? 0).toDouble();
//         accuracy = (data["accuracy"] ?? 0).toDouble();
//         priceUsed = (data["price_used"] ?? 0).toDouble();
//         costUsed = (data["cost_used"] ?? 0).toDouble();
//         profitMargin = (data["profit_margin"] ?? 0).toDouble();
        
//         // Calculate additional metrics
//         totalCost = predictedUnits * costUsed;
//         profitRate = (predictedProfit / predictedSales) * 100;
        
//         loading = false;
//       });

//       // Update controllers
//       priceController.text = priceUsed.toStringAsFixed(0);
//       costController.text = costUsed.toStringAsFixed(0);

//       await firestore.collection("prediction_history").add({
//         "category": selectedCategory,
//         "product": selectedProduct,
//         "month": selectedMonth,
//         "price": priceUsed,
//         "cost": costUsed,
//         "predicted_sales": predictedSales,
//         "predicted_units": predictedUnits,
//         "predicted_profit": predictedProfit,
//         "total_cost": totalCost,
//         "profit_rate": profitRate,
//         "created_at": FieldValue.serverTimestamp(),
//       });

//       final docId = "${selectedProduct}_${selectedCategory}".replaceAll(" ", "_");

//       await firestore
//           .collection("inventory_predictions")
//           .doc(docId)
//           .set({
//         "product": selectedProduct,
//         "category": selectedCategory,
//         "month": selectedMonth,
//         "predicted_units": predictedUnits,
//         "predicted_sales": predictedSales,
//         "predicted_profit": predictedProfit,
//         "price_used": priceUsed,
//         "cost_used": costUsed,
//         "total_cost": totalCost,
//         "profit_rate": profitRate,
//         "updated_at": FieldValue.serverTimestamp(),
//       });
      
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("✅ Prediction complete! ${accuracy.toStringAsFixed(1)}% accuracy"),
//           backgroundColor: Colors.green,
//           duration: const Duration(seconds: 2),
//         ),
//       );
      
//     } catch (e) {
//       setState(() => loading = false);
//       debugPrint(e.toString());
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
//       );
//     }
//   }

//   // =========================================================
//   // CONTROL CARD WITH PRICE & COST
//   // =========================================================
//   Widget _controlCard() {
//     return Container(
//       padding: const EdgeInsets.all(22),
//       decoration: _box(),
//       child: Column(
//         children: [
//           _dropdown(
//             "Category",
//             categories,
//             selectedCategory,
//             (v) async {
//               setState(() {
//                 selectedCategory = v;
//                 selectedProduct = null;
//                 products = [];
//               });
//               if (v != null) {
//                 await loadProducts(v);
//               }
//             },
//           ),

//           _dropdown(
//             "Product",
//             products,
//             selectedProduct,
//             (v) async {
//               setState(() {
//                 selectedProduct = v;
//               });
              
//               if (v != null) {
//                 final priceData = await fetchProductPriceFromExcel(v);
//                 priceController.text = priceData["price"].toStringAsFixed(0);
//                 costController.text = priceData["cost"].toStringAsFixed(0);
                
//                 if (mounted) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text("📦 Price: ₹${priceData["price"].toStringAsFixed(0)} | Cost: ₹${priceData["cost"].toStringAsFixed(0)}"),
//                       backgroundColor: Colors.blue,
//                       duration: const Duration(seconds: 2),
//                     ),
//                   );
//                 }
//               }
//             },
//           ),

//           _dropdown(
//             "Forecast Month",
//             months,
//             selectedMonth,
//             (v) {
//               setState(() {
//                 selectedMonth = v;
//               });
//             },
//           ),

//           const SizedBox(height: 12),

//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: priceController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     labelText: "Selling Price (₹)",
//                     prefixIcon: const Icon(Icons.currency_rupee, size: 18),
//                     filled: true,
//                     fillColor: Colors.grey.shade100,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(16),
//                       borderSide: BorderSide.none,
//                     ),
//                     contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: TextField(
//                   controller: costController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     labelText: "Cost Price (₹)",
//                     prefixIcon: const Icon(Icons.shopping_bag, size: 18),
//                     filled: true,
//                     fillColor: Colors.grey.shade100,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(16),
//                       borderSide: BorderSide.none,
//                     ),
//                     contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//                   ),
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 22),

//           SizedBox(
//             width: double.infinity,
//             height: 54,
//             child: ElevatedButton(
//               onPressed: loading ? null : predict,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color.fromARGB(255, 110, 149, 227),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//               ),
//               child: loading
//                   ? const CircularProgressIndicator(color: Colors.white)
//                   : const Text(
//                       "RUN AI FORECAST",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _refreshButton() {
//     return IconButton(
//       icon: const Icon(Icons.refresh),
//       onPressed: () async {
//         if (selectedCategory != null) {
//           await loadProducts(selectedCategory!);
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text("Data refreshed from Excel")),
//             );
//           }
//         }
//       },
//       tooltip: "Refresh from Excel",
//     );
//   }

//   // =========================================================
//   // SALES CHART
//   // =========================================================
//   Widget _salesChart() {
//     const int maxPoints = 12;

//     List<double> sales = List.from(historySales);
//     List<String> monthsList = List.from(historyMonths);

//     if (sales.length > maxPoints) {
//       sales = sales.sublist(sales.length - maxPoints);
//       monthsList = monthsList.sublist(monthsList.length - maxPoints);
//     }

//     if (sales.isEmpty) {
//       return Container(
//         height: 420,
//         padding: const EdgeInsets.all(20),
//         decoration: _box(),
//         child: const Center(child: Text("Run prediction to see chart")),
//       );
//     }

//     List<FlSpot> actualSpots = [];

//     for (int i = 0; i < sales.length; i++) {
//       double v = sales[i];
//       if (v.isNaN || v.isInfinite) v = 0;
//       actualSpots.add(FlSpot(i.toDouble(), v));
//     }

//     double safePrediction = predictedSales;
//     if (safePrediction.isNaN || safePrediction.isInfinite || safePrediction <= 0) {
//       safePrediction = sales.last;
//     }

//     final predictionSpot = FlSpot(sales.length.toDouble(), safePrediction);
//     List<FlSpot> forecastSpots = [
//       actualSpots.last,
//       predictionSpot,
//     ];

//     double maxY = sales.reduce((a, b) => a > b ? a : b);
//     if (safePrediction > maxY) maxY = safePrediction;
//     if (maxY <= 0) maxY = 100;

//     double interval = maxY / 5;
//     if (interval.isNaN || interval.isInfinite || interval <= 0) {
//       interval = 20;
//     }

//     return Container(
//       height: 420,
//       padding: const EdgeInsets.all(20),
//       decoration: _box(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "Actual Sales vs Forecast",
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 20),
//           Expanded(
//             child: LineChart(
//               LineChartData(
//                 minY: 0,
//                 maxY: maxY * 1.2,
//                 gridData: FlGridData(
//                   show: true,
//                   horizontalInterval: interval,
//                 ),
//                 borderData: FlBorderData(show: false),
//                 titlesData: FlTitlesData(
//                   leftTitles: const AxisTitles(
//                     sideTitles: SideTitles(showTitles: true, reservedSize: 45),
//                   ),
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       interval: 2,
//                       getTitlesWidget: (value, meta) {
//                         int i = value.toInt();
//                         if (i >= 0 && i < monthsList.length) {
//                           String m = monthsList[i];
//                           if (m.contains("-")) {
//                             m = m.split("-")[1];
//                           }
//                           return Text(m.substring(0, 3),
//                               style: const TextStyle(fontSize: 10));
//                         }
//                         return const SizedBox();
//                       },
//                     ),
//                   ),
//                   topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                   rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                 ),
//                 lineBarsData: [
//                   LineChartBarData(
//                     spots: actualSpots,
//                     isCurved: true,
//                     color: const Color.fromARGB(255, 250, 209, 165),
//                     barWidth: 4,
//                     dotData: const FlDotData(show: false),
//                   ),
//                   LineChartBarData(
//                     spots: forecastSpots,
//                     isCurved: true,
//                     color: Colors.green,
//                     barWidth: 4,
//                     dashArray: [6, 4],
//                     dotData: const FlDotData(show: true),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               _legend(Colors.blue, "Actual Sales"),
//               const SizedBox(width: 20),
//               _legend(Colors.green, "Forecast"),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // =========================================================
//   // UNITS BAR CHART
//   // =========================================================
//   Widget _unitsChart() {
//     const int maxPoints = 12;

//     List<double> units = List.from(historyUnits);
//     List<String> monthsList = List.from(historyMonths);

//     if (units.length > maxPoints) {
//       units = units.sublist(units.length - maxPoints);
//       monthsList = monthsList.sublist(monthsList.length - maxPoints);
//     }

//     if (units.isEmpty) {
//       return Container(
//         height: 420,
//         padding: const EdgeInsets.all(20),
//         decoration: _box(),
//         child: const Center(child: Text("Run prediction to see chart")),
//       );
//     }

//     List<BarChartGroupData> bars = [];
//     double maxY = 0;

//     for (int i = 0; i < units.length; i++) {
//       double value = units[i];
//       if (value.isNaN || value.isInfinite) value = 0;
//       if (value > maxY) maxY = value;

//       bars.add(
//         BarChartGroupData(
//           x: i,
//           barRods: [
//             BarChartRodData(
//               toY: value,
//               width: 14,
//               borderRadius: BorderRadius.circular(6),
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.orange.shade300,
//                   Colors.deepOrange.shade400,
//                 ],
//                 begin: Alignment.bottomCenter,
//                 end: Alignment.topCenter,
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     if (maxY <= 0) maxY = 100;

//     double interval = maxY / 5;
//     if (interval.isNaN || interval.isInfinite || interval <= 0) {
//       interval = 20;
//     }

//     return Container(
//       height: 420,
//       padding: const EdgeInsets.all(20),
//       decoration: _box(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "Units Sold History",
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 10),
//           Text(
//             "Last ${units.length} months trend",
//             style: TextStyle(color: Colors.grey.shade600),
//           ),
//           const SizedBox(height: 20),
//           Expanded(
//             child: BarChart(
//               BarChartData(
//                 minY: 0,
//                 maxY: maxY * 1.2,
//                 borderData: FlBorderData(show: false),
//                 gridData: FlGridData(
//                   show: true,
//                   horizontalInterval: interval,
//                 ),
//                 titlesData: FlTitlesData(
//                   leftTitles: const AxisTitles(
//                     sideTitles: SideTitles(showTitles: true, reservedSize: 35),
//                   ),
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       interval: 2,
//                       getTitlesWidget: (value, meta) {
//                         int index = value.toInt();
//                         if (index >= 0 && index < monthsList.length) {
//                           String label = monthsList[index];
//                           if (label.contains("-")) {
//                             label = label.split("-")[1];
//                           }
//                           label = label.substring(0, 3);
//                           return Padding(
//                             padding: const EdgeInsets.only(top: 8),
//                             child: Text(label, style: const TextStyle(fontSize: 10)),
//                           );
//                         }
//                         return const SizedBox();
//                       },
//                     ),
//                   ),
//                   topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                   rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                 ),
//                 barGroups: bars,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // =========================================================
//   // METRICS ROW (4 Cards)
//   // =========================================================
//   // Widget _metricsRow() {
//   //   return Row(
//   //     children: [
//   //       Expanded(
//   //         child: _analyticsCard(
//   //           "Predicted Revenue",
//   //           "₹ ${predictedSales.toStringAsFixed(0)}",
//   //           Icons.currency_rupee,
//   //           Colors.blue,
//   //         ),
//   //       ),
//   //       const SizedBox(width: 10),
//   //       Expanded(
//   //         child: _analyticsCard(
//   //           "Total Cost",
//   //           "₹ ${totalCost.toStringAsFixed(0)}",
//   //           Icons.shopping_cart,
//   //           Colors.orange,
//   //         ),
//   //       ),
//   //       const SizedBox(width: 10),
//   //       Expanded(
//   //         child: _analyticsCard(
//   //           "Predicted Profit",
//   //           "₹ ${predictedProfit.toStringAsFixed(0)}",
//   //           Icons.trending_up,
//   //           Colors.green,
//   //         ),
//   //       ),
//   //       const SizedBox(width: 10),
//   //       Expanded(
//   //         child: _analyticsCard(
//   //           "Profit Rate",
//   //           "${profitRate.toStringAsFixed(1)}%",
//   //           Icons.percent,
//   //           Colors.purple,
//   //         ),
//   //       ),
//   //     ],
//   //   );
//  // }
//  Widget _metricsRow() {
//   return Column(
//     children: [
//       Row(
//         children: [
//           Expanded(
//             child: _analyticsCard(
//               "Revenue",
//               "₹ ${predictedSales.toStringAsFixed(0)}",
//               Icons.currency_rupee,
//               Colors.blue,
//             ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: _analyticsCard(
//               "Cost",
//               "₹ ${totalCost.toStringAsFixed(0)}",
//               Icons.shopping_cart,
//               Colors.orange,
//             ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: _analyticsCard(
//               "Profit",
//               "₹ ${predictedProfit.toStringAsFixed(0)}",
//               Icons.trending_up,
//               Colors.green,
//             ),
//           ),
//         ],
//       ),

//       const SizedBox(height: 10),

//       Row(
//         children: [
//           Expanded(
//             child: _analyticsCard(
//               "Profit Rate",
//               "${profitRate.toStringAsFixed(1)}%",
//               Icons.percent,
//               Colors.purple,
//             ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: _analyticsCard(
//               "Last Month Units",
//               latestUnits.toStringAsFixed(0),
//               Icons.inventory_2,
//               Colors.indigo,
//             ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: _analyticsCard(
//               "Avg Units Sold",
//               rollingAvg.toStringAsFixed(0),
//               Icons.show_chart,
//               Colors.teal,
//             ),
//           ),
//         ],
//       ),
//     ],
//   );
// }

//   // =========================================================
//   // COMPARISON SECTION (Updated with Cost and Profit)
//   // =========================================================
//   Widget _comparisonSection() {
//     double lastActual = historySales.isNotEmpty ? historySales.last : 0;
//     double change = predictedSales - lastActual;
//     double percent = lastActual == 0 ? 0 : (change / lastActual) * 100;
//     bool growth = change >= 0;

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(24),
//       decoration: _box(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "Financial Analysis",
//             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 20),
//           Row(
//             children: [
//               Expanded(child: _comparisonTile("Last Revenue", "₹ ${lastActual.toStringAsFixed(0)}", Colors.blue)),
//               const SizedBox(width: 10),
//               Expanded(child: _comparisonTile("Forecast Revenue", "₹ ${predictedSales.toStringAsFixed(0)}", Colors.green)),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: _comparisonTile(
//                   "Growth",
//                   "${percent.toStringAsFixed(1)}%",
//                   growth ? Colors.green : Colors.red,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Divider(color: Colors.grey.shade200),
//           const SizedBox(height: 16),
//           // Row(
//           //   children: [
//           //     Expanded(child: _comparisonTile("Total Cost", "₹ ${totalCost.toStringAsFixed(0)}", Colors.orange)),
//           //     const SizedBox(width: 10),
//           //     Expanded(child: _comparisonTile("Net Profit", "₹ ${predictedProfit.toStringAsFixed(0)}", Colors.green)),
//           //     const SizedBox(width: 10),
//           //     Expanded(child: _comparisonTile("Profit Rate", "${profitRate.toStringAsFixed(1)}%", Colors.purple)),
//           //   ],
//           // ),
//         ],
//       ),
//     );
//   }

//   // =========================================================
//   // INSIGHT CARD (Updated)
//   // =========================================================
//   Widget _insightCard() {
//     double lastActual = historySales.isNotEmpty ? historySales.last : 0;
//     double change = predictedSales - lastActual;
//     double percent = lastActual == 0 ? 0 : (change / lastActual) * 100;
//     bool growth = change >= 0;

//     String insightMessage = growth
//         ? "📈 AI predicts ${percent.toStringAsFixed(1)}% revenue growth. "
//           "Expected profit: ₹${predictedProfit.toStringAsFixed(0)} at ${profitRate.toStringAsFixed(1)}% margin."
//         : "📉 AI predicts ${percent.abs().toStringAsFixed(1)}% revenue decline. "
//           "Review pricing strategy. Current margin: ${profitRate.toStringAsFixed(1)}%";

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(22),
//       decoration: BoxDecoration(
//         color: growth ? Colors.green.shade50 : Colors.red.shade50,
//         borderRadius: BorderRadius.circular(22),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(
//               color: growth ? Colors.green.shade100 : Colors.red.shade100,
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               growth ? Icons.trending_up : Icons.trending_down,
//               color: growth ? Colors.green : Colors.red,
//               size: 28,
//             ),
//           ),
//           const SizedBox(width: 18),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   growth ? "Positive Growth Forecast" : "Sales Decline Warning",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: growth ? Colors.green : Colors.red,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(insightMessage),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // =========================================================
//   // ANALYTICS CARD
//   // =========================================================
//   Widget _analyticsCard(String title, String value, IconData icon, Color color) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: _box(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(icon, color: color, size: 20),
//           ),
//           const SizedBox(height: 12),
//           Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
//           const SizedBox(height: 4),
//           Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
//         ],
//       ),
//     );
//   }

//   // =========================================================
//   // HEADER STATS
//   // =========================================================
//   Widget _topStat(String title, String value, IconData icon) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.15),
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: Column(
//         children: [
//           Icon(icon, color: Colors.white),
//           const SizedBox(height: 10),
//           Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 4),
//           Text(title, textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(0.9))),
//         ],
//       ),
//     );
//   }

//   // =========================================================
//   // COMPARISON TILE
//   // =========================================================
//   Widget _comparisonTile(String title, String value, Color color) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.08),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         children: [
//           Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
//           const SizedBox(height: 8),
//           Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//         ],
//       ),
//     );
//   }

//   // =========================================================
//   // LEGEND
//   // =========================================================
//   Widget _legend(Color color, String text) {
//     return Row(
//       children: [
//         Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
//         const SizedBox(width: 6),
//         Text(text, style: const TextStyle(fontSize: 12)),
//       ],
//     );
//   }

//   // =========================================================
//   // DROPDOWN
//   // =========================================================
//   Widget _dropdown(String label, List<String> items, String? value, Function(String?) onChanged) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 14),
//       child: DropdownButtonFormField<String>(
//         value: items.contains(value) ? value : null,
//         items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
//         onChanged: onChanged,
//         decoration: InputDecoration(
//           labelText: label,
//           filled: true,
//           fillColor: Colors.grey.shade100,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(16),
//             borderSide: BorderSide.none,
//           ),
//         ),
//       ),
//     );
//   }

//   // =========================================================
//   // COMMON BOX
//   // =========================================================
//   BoxDecoration _box() {
//     return BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(20),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.04),
//           blurRadius: 10,
//           offset: const Offset(0, 4),
//         ),
//       ],
//     );
//   }

//   // =========================================================
//   // BUILD
//   // =========================================================
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF4F7FC),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         title: const Text(
//           "AI Forecast Dashboard",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         actions: [
//           _refreshButton(),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [const Color.fromARGB(255, 255, 178, 126), const Color.fromARGB(255, 251, 180, 139)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(24),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "AI Retail Analytics",
//                     style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     "Advanced ML forecasting for inventory intelligence",
//                     style: TextStyle(color: Colors.white.withOpacity(0.92), fontSize: 13),
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     children: [
//                       Expanded(child: _topStat("Accuracy", "${accuracy.toStringAsFixed(1)}%", Icons.analytics)),
//                       const SizedBox(width: 12),
//                       Expanded(child: _topStat("Forecast Units", predictedUnits.toStringAsFixed(0), Icons.inventory_2)),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             _controlCard(),
//             const SizedBox(height: 20),
//             if (historySales.isNotEmpty) ...[
//               _metricsRow(),
//               const SizedBox(height: 20),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(flex: 2, child: _salesChart()),
//                   const SizedBox(width: 16),
//                   Expanded(child: _unitsChart()),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               _comparisonSection(),
//               const SizedBox(height: 20),
//               _insightCard(),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
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
  final Color primaryColor = const Color(0xFF2563EB); // Blue
  final Color secondaryColor = const Color(0xFFF59E0B); // Amber/Orange
  final Color successColor = const Color(0xFF10B981); // Green
  final Color dangerColor = const Color(0xFFEF4444); // Red
  final Color purpleColor = const Color(0xFF8B5CF6); // Purple
  final Color tealColor = const Color(0xFF14B8A6); // Teal
  final Color indigoColor = const Color(0xFF6366F1); // Indigo

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
  // PREDICT + FIRESTORE SAVE
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
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("✅ Prediction complete! ${accuracy.toStringAsFixed(1)}% accuracy"),
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
                      content: Text("📦 Price: ₹${priceData["price"].toStringAsFixed(0)} | Cost: ₹${priceData["cost"].toStringAsFixed(0)}"),
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
  Widget _salesChart() {
    const int maxPoints = 12;

    List<double> sales = List.from(historySales);
    List<String> monthsList = List.from(historyMonths);

    if (sales.length > maxPoints) {
      sales = sales.sublist(sales.length - maxPoints);
      monthsList = monthsList.sublist(monthsList.length - maxPoints);
    }

    if (sales.isEmpty) {
      return Container(
        height: 420,
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
      height: 420,
      padding: const EdgeInsets.all(20),
      decoration: _box(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Actual Sales vs Forecast",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
          Row(
            children: [
              _legend(primaryColor, "Actual Sales"),
              const SizedBox(width: 20),
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
  Widget _unitsChart() {
    const int maxPoints = 12;

    List<double> units = List.from(historyUnits);
    List<String> monthsList = List.from(historyMonths);

    if (units.length > maxPoints) {
      units = units.sublist(units.length - maxPoints);
      monthsList = monthsList.sublist(monthsList.length - maxPoints);
    }

    if (units.isEmpty) {
      return Container(
        height: 420,
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
      height: 420,
      padding: const EdgeInsets.all(20),
      decoration: _box(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Units Sold History",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            "Last ${units.length} months trend",
            style: TextStyle(color: Colors.grey.shade600),
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
  // METRICS ROW (6 Cards - 2 Rows of 3)
  // =========================================================
  Widget _metricsRow() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _analyticsCard(
                "Revenue",
                "₹ ${predictedSales.toStringAsFixed(0)}",
                Icons.currency_rupee,
                primaryColor,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _analyticsCard(
                "Cost",
                "₹ ${totalCost.toStringAsFixed(0)}",
                Icons.shopping_cart,
                secondaryColor,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _analyticsCard(
                "Profit",
                "₹ ${predictedProfit.toStringAsFixed(0)}",
                Icons.trending_up,
                successColor,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: _analyticsCard(
                "Profit Rate",
                "${profitRate.toStringAsFixed(1)}%",
                Icons.percent,
                purpleColor,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _analyticsCard(
                "Last Month Units",
                latestUnits.toStringAsFixed(0),
                Icons.inventory_2,
                tealColor,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _analyticsCard(
                "Avg Units Sold",
                rollingAvg.toStringAsFixed(0),
                Icons.show_chart,
                indigoColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // =========================================================
  // COMPARISON SECTION
  // =========================================================
  Widget _comparisonSection() {
    double lastActual = historySales.isNotEmpty ? historySales.last : 0;
    double change = predictedSales - lastActual;
    double percent = lastActual == 0 ? 0 : (change / lastActual) * 100;
    bool growth = change >= 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: _box(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Financial Analysis",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _comparisonTile("Last Revenue", "₹ ${lastActual.toStringAsFixed(0)}", primaryColor)),
              const SizedBox(width: 10),
              Expanded(child: _comparisonTile("Forecast Revenue", "₹ ${predictedSales.toStringAsFixed(0)}", successColor)),
              const SizedBox(width: 10),
              Expanded(
                child: _comparisonTile(
                  "Growth",
                  "${percent.toStringAsFixed(1)}%",
                  growth ? successColor : dangerColor,
                ),
              ),
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
  Widget _insightCard() {
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
      padding: const EdgeInsets.all(22),
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
              size: 28,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  growth ? "Positive Growth Forecast" : "Sales Decline Warning",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: growth ? successColor : dangerColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(insightMessage),
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
      padding: const EdgeInsets.all(16),
      decoration: _box(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  // =========================================================
  // HEADER STATS
  // =========================================================
  Widget _topStat(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title, textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(0.9))),
        ],
      ),
    );
  }

  // =========================================================
  // COMPARISON TILE
  // =========================================================
  Widget _comparisonTile(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // =========================================================
  // LEGEND
  // =========================================================
  Widget _legend(Color color, String text) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12)),
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
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // =========================================================
  // BUILD
  // =========================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "AI Forecast Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          _refreshButton(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, primaryColor.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "AI Retail Analytics",
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Advanced ML forecasting for inventory intelligence",
                    style: TextStyle(color: Colors.white.withOpacity(0.92), fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: _topStat("Accuracy", "${accuracy.toStringAsFixed(1)}%", Icons.analytics)),
                      const SizedBox(width: 12),
                      Expanded(child: _topStat("Forecast Units", predictedUnits.toStringAsFixed(0), Icons.inventory_2)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _controlCard(),
            const SizedBox(height: 20),
            if (historySales.isNotEmpty) ...[
              _metricsRow(),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: _salesChart()),
                  const SizedBox(width: 16),
                  Expanded(child: _unitsChart()),
                ],
              ),
              const SizedBox(height: 20),
              _comparisonSection(),
              const SizedBox(height: 20),
              _insightCard(),
            ],
          ],
        ),
      ),
    );
  }
}