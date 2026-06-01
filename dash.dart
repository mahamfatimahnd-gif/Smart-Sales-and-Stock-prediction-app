// // // // // // // import 'package:fl_chart/fl_chart.dart';
// // // // // // // import 'package:flutter/material.dart';

// // // // // // // class DashboardPage extends StatelessWidget {
// // // // // // //   const DashboardPage({super.key});

// // // // // // //   List<double> get monthlySales => [12000, 15000, 18000, 20000, 22000];

// // // // // // //   double predictNextMonthSales() {
// // // // // // //     double growth = 0;
// // // // // // //     for (int i = 1; i < monthlySales.length; i++) {
// // // // // // //       growth += (monthlySales[i] - monthlySales[i - 1]);
// // // // // // //     }
// // // // // // //     return monthlySales.last + (growth / (monthlySales.length - 1));
// // // // // // //   }

// // // // // // //   @override
// // // // // // //   Widget build(BuildContext context) {
// // // // // // //     double totalSales = monthlySales.reduce((a, b) => a + b);
// // // // // // //     double predicted = predictNextMonthSales();

// // // // // // //     return SingleChildScrollView(
// // // // // // //       padding: const EdgeInsets.all(20),
// // // // // // //       child: Column(
// // // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //         children: [
// // // // // // //           const Text(
// // // // // // //             "Dashboard",
// // // // // // //             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
// // // // // // //           ),

// // // // // // //           const SizedBox(height: 20),

// // // // // // //           // KPI CARDS
// // // // // // //           Row(
// // // // // // //             children: [
// // // // // // //               buildCard("Total Sales", totalSales.toStringAsFixed(0),
// // // // // // //                   Colors.blue, Icons.attach_money),
// // // // // // //               buildCard("Profit", predicted.toStringAsFixed(0),
// // // // // // //                   Colors.green, Icons.trending_up),
// // // // // // //               buildCard("Orders", "240", Colors.orange, Icons.shopping_cart),
// // // // // // //               buildCard("Products", "120", Colors.blue, Icons.inventory_2),
// // // // // // //               buildCard("Growth", "18%", Colors.purple, Icons.bar_chart),
// // // // // // //             ],
// // // // // // //           ),

// // // // // // //           const SizedBox(height: 25),

// // // // // // //           // CHARTS
// // // // // // //           Row(
// // // // // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //             children: [
// // // // // // //               Expanded(
// // // // // // //                 flex: 2,
// // // // // // //                 child: containerCard(
// // // // // // //                   "Sales Trend",
// // // // // // //                   LineChart(
// // // // // // //                     LineChartData(
// // // // // // //                       gridData: FlGridData(show: true),
// // // // // // //                       titlesData: FlTitlesData(show: true),
// // // // // // //                       lineBarsData: [
// // // // // // //                         LineChartBarData(
// // // // // // //                           isCurved: true,
// // // // // // //                           color: Colors.blue,
// // // // // // //                           spots: List.generate(
// // // // // // //                             monthlySales.length,
// // // // // // //                             (i) => FlSpot(i.toDouble(), monthlySales[i]),
// // // // // // //                           ),
// // // // // // //                         ),
// // // // // // //                       ],
// // // // // // //                     ),
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //               ),

// // // // // // //               const SizedBox(width: 16),

// // // // // // //               Expanded(
// // // // // // //                 child: containerCard(
// // // // // // //                   "Sales by Category",
// // // // // // //                   PieChart(
// // // // // // //                     PieChartData(
// // // // // // //                       centerSpaceRadius: 40,
// // // // // // //                       sections: [
// // // // // // //                         PieChartSectionData(
// // // // // // //                             value: 40, title: "Electronics", color: Colors.blue),
// // // // // // //                         PieChartSectionData(
// // // // // // //                             value: 25, title: "Clothing", color: Colors.orange),
// // // // // // //                         PieChartSectionData(
// // // // // // //                             value: 20, title: "Groceries", color: Colors.green),
// // // // // // //                         PieChartSectionData(
// // // // // // //                             value: 15, title: "Home", color: Colors.purple),
// // // // // // //                       ],
// // // // // // //                     ),
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //             ],
// // // // // // //           ),

// // // // // // //           const SizedBox(height: 20),

// // // // // // //           // TABLES
// // // // // // //           Row(
// // // // // // //             children: [
// // // // // // //               Expanded(
// // // // // // //                 child: tableCard("Stock Alerts", [
// // // // // // //                   tableRow("Headphones", "Low", Colors.red),
// // // // // // //                   tableRow("Coffee Mug", "Low", Colors.red),
// // // // // // //                 ]),
// // // // // // //               ),
// // // // // // //               const SizedBox(width: 16),
// // // // // // //               Expanded(
// // // // // // //                 child: tableCard("Recent Orders", [
// // // // // // //                   tableRow("#1021 Ali", "\$250", Colors.green),
// // // // // // //                   tableRow("#1020 Sara", "\$180", Colors.green),
// // // // // // //                 ]),
// // // // // // //               ),
// // // // // // //             ],
// // // // // // //           ),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   // ================= WIDGETS =================

// // // // // // //   Widget buildCard(
// // // // // // //       String title, String value, Color color, IconData icon) {
// // // // // // //     return Expanded(
// // // // // // //       child: Container(
// // // // // // //         margin: const EdgeInsets.symmetric(horizontal: 6),
// // // // // // //         padding: const EdgeInsets.all(16),
// // // // // // //         decoration: BoxDecoration(
// // // // // // //           color: Colors.white,
// // // // // // //           borderRadius: BorderRadius.circular(14),
// // // // // // //           boxShadow: const [
// // // // // // //             BoxShadow(
// // // // // // //                 blurRadius: 10,
// // // // // // //                 offset: Offset(0, 4),
// // // // // // //                 color: Colors.black12),
// // // // // // //           ],
// // // // // // //         ),
// // // // // // //         child: Row(
// // // // // // //           children: [
// // // // // // //             Container(
// // // // // // //               padding: const EdgeInsets.all(10),
// // // // // // //               decoration: BoxDecoration(
// // // // // // //                 color: color.withOpacity(0.15),
// // // // // // //                 borderRadius: BorderRadius.circular(10),
// // // // // // //               ),
// // // // // // //               child: Icon(icon, color: color),
// // // // // // //             ),
// // // // // // //             const SizedBox(width: 12),
// // // // // // //             Column(
// // // // // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //               children: [
// // // // // // //                 Text(title,
// // // // // // //                     style:
// // // // // // //                         TextStyle(color: Colors.grey[600], fontSize: 12)),
// // // // // // //                 const SizedBox(height: 6),
// // // // // // //                 Text(value,
// // // // // // //                     style: TextStyle(
// // // // // // //                         fontSize: 18,
// // // // // // //                         fontWeight: FontWeight.bold,
// // // // // // //                         color: color)),
// // // // // // //               ],
// // // // // // //             ),
// // // // // // //           ],
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   Widget containerCard(String title, Widget child) {
// // // // // // //     return Container(
// // // // // // //       height: 320,
// // // // // // //       padding: const EdgeInsets.all(16),
// // // // // // //       decoration: BoxDecoration(
// // // // // // //         color: Colors.white,
// // // // // // //         borderRadius: BorderRadius.circular(14),
// // // // // // //         boxShadow: const [
// // // // // // //           BoxShadow(
// // // // // // //               blurRadius: 12,
// // // // // // //               offset: Offset(0, 4),
// // // // // // //               color: Colors.black12),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //       child: Column(
// // // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //         children: [
// // // // // // //           Text(title,
// // // // // // //               style: const TextStyle(
// // // // // // //                   fontWeight: FontWeight.bold, fontSize: 14)),
// // // // // // //           const SizedBox(height: 12),
// // // // // // //           Expanded(child: child),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   Widget tableCard(String title, List<Widget> rows) {
// // // // // // //     return Container(
// // // // // // //       padding: const EdgeInsets.all(16),
// // // // // // //       decoration: BoxDecoration(
// // // // // // //         color: Colors.white,
// // // // // // //         borderRadius: BorderRadius.circular(14),
// // // // // // //         boxShadow: const [
// // // // // // //           BoxShadow(
// // // // // // //               blurRadius: 12,
// // // // // // //               offset: Offset(0, 4),
// // // // // // //               color: Colors.black12),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //       child: Column(
// // // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //         children: [
// // // // // // //           Text(title,
// // // // // // //               style: const TextStyle(
// // // // // // //                   fontWeight: FontWeight.bold, fontSize: 14)),
// // // // // // //           const SizedBox(height: 12),
// // // // // // //           const Divider(),
// // // // // // //           ...rows,
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   Widget tableRow(String name, String status, Color color) {
// // // // // // //     return Padding(
// // // // // // //       padding: const EdgeInsets.symmetric(vertical: 6),
// // // // // // //       child: Row(
// // // // // // //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // // // //         children: [
// // // // // // //           Text(name),
// // // // // // //           Text(status, style: TextStyle(color: color)),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // // }
// // // // // // import 'dart:convert';
// // // // // // import 'package:flutter/material.dart';
// // // // // // import 'package:http/http.dart' as http;
// // // // // // import 'package:fl_chart/fl_chart.dart';

// // // // // // class DashboardPage extends StatefulWidget {
// // // // // //   const DashboardPage({super.key});

// // // // // //   @override
// // // // // //   State<DashboardPage> createState() => _DashboardPageState();
// // // // // // }

// // // // // // class _DashboardPageState extends State<DashboardPage> {
// // // // // //   // Base API configuration (Replace with your actual backend host address/IP)
// // // // // //   final String baseUrl = "http://127.0.0.1:5000";

// // // // // //   bool _isLoading = true;
// // // // // //   String? _errorMessage;

// // // // // //   // Data parsed dynamically from backend APIs
// // // // // //   List<int> years = [];
// // // // // //   List<double> units = [];
// // // // // //   List<double> cost = [];
// // // // // //   List<double> sales = [];
// // // // // //   Map<String, dynamic> globalSummary = {};
// // // // // //   List<String> categories = [];

// // // // // //   @override
// // // // // //   void initState() {
// // // // // //     super.initState();
// // // // // //     _fetchDashboardData();
// // // // // //   }

// // // // // //   Future<void> _fetchDashboardData() async {
// // // // // //     try {
// // // // // //       // Parallel API calls to your Flask routes
// // // // // //       final responses = await Future.wait([
// // // // // //         http.get(Uri.parse('$baseUrl/yearly_summary')),
// // // // // //         http.get(Uri.parse('$baseUrl/categories')),
// // // // // //       ]);

// // // // // //       if (responses[0].statusCode == 200 && responses[1].statusCode == 200) {
// // // // // //         final summaryData = jsonDecode(responses[0].body);
// // // // // //         final categoriesData = jsonDecode(responses[1].body);

// // // // // //         setState(() {
// // // // // //           years = List<int>.from(summaryData['years']);
// // // // // //           units = List<double>.from(summaryData['units']);
// // // // // //           cost = List<double>.from(summaryData['cost']);
// // // // // //           sales = List<double>.from(summaryData['sales']);
// // // // // //           globalSummary = summaryData['summary'];
// // // // // //           categories = List<String>.from(categoriesData['categories']);
// // // // // //           _isLoading = false;
// // // // // //         });
// // // // // //       } else {
// // // // // //         throw Exception("Server responded with an error code status.");
// // // // // //       }
// // // // // //     } catch (e) {
// // // // // //       setState(() {
// // // // // //         _errorMessage = e.toString();
// // // // // //         _isLoading = false;
// // // // // //       });
// // // // // //     }
// // // // // //   }

// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     if (_isLoading) {
// // // // // //       return const Center(
// // // // // //         child: Padding(
// // // // // //           padding: EdgeInsets.all(40.0),
// // // // // //           child: CircularProgressIndicator(),
// // // // // //         ),
// // // // // //       );
// // // // // //     }

// // // // // //     if (_errorMessage != null) {
// // // // // //       return Center(
// // // // // //         child: Padding(
// // // // // //           padding: const EdgeInsets.all(20.0),
// // // // // //           child: Text(
// // // // // //             "Failed to load backend metrics: $_errorMessage",
// // // // // //             style: const TextStyle(color: Colors.red, fontSize: 16),
// // // // // //           ),
// // // // // //         ),
// // // // // //       );
// // // // // //     }

// // // // // //     return SingleChildScrollView(
// // // // // //       padding: const EdgeInsets.all(20),
// // // // // //       child: Column(
// // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //         children: [
// // // // // //           Row(
// // // // // //             mainAxisAlignment: MainAxisAlignment.center,
// // // // // //             children: [
// // // // // //               const Text(
// // // // // //                 "Sales Dashboard",
// // // // // //                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
// // // // // //               ),
// // // // // //               IconButton(
// // // // // //                 icon: const Icon(Icons.refresh),
// // // // // //                 onPressed: () {
// // // // // //                   setState(() => _isLoading = true);
// // // // // //                   _fetchDashboardData();
// // // // // //                 },
// // // // // //               ),
// // // // // //             ],
// // // // // //           ),
// // // // // //           const SizedBox(height: 20),

// // // // // //           // KPI CARDS (Driven by the backend summary computations)
// // // // // //           Row(
// // // // // //             children: [
// // // // // //               buildCard(
// // // // // //                 "Total Sales",
// // // // // //                 globalSummary["total_sales"]?.toStringAsFixed(2) ?? "0.00",
// // // // // //                 Colors.blue,
// // // // // //                 Icons.trending_up,
// // // // // //               ),
// // // // // //               buildCard(
// // // // // //                 "Total Cost",
// // // // // //                 globalSummary["total_cost"]?.toStringAsFixed(2) ?? "0.00",
// // // // // //                 Colors.orange,
// // // // // //                 Icons.account_balance_wallet,
// // // // // //               ),
// // // // // //               buildCard(
// // // // // //                 "Net Profit",
// // // // // //                 globalSummary["profit"]?.toStringAsFixed(2) ?? "0.00",
// // // // // //                 Colors.green,
// // // // // //                 Icons.analytics,
// // // // // //               ),
// // // // // //               buildCard(
// // // // // //                 "Units Handled",
// // // // // //                 globalSummary["total_units"]?.toStringAsFixed(0) ?? "0",
// // // // // //                 Colors.purple,
// // // // // //                 Icons.inventory_2,
// // // // // //               ),
// // // // // //             ],
// // // // // //           ),
// // // // // //           const SizedBox(height: 25),

// // // // // //           // CHARTS SECTION
// // // // // //           Row(
// // // // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //             children: [
// // // // // //               // Dynamic Line Chart displaying real revenue trajectory
// // // // // //               Expanded(
// // // // // //                 flex: 2,
// // // // // //                 child: containerCard(
// // // // // //                   "Annual Revenue Trajectory",
// // // // // //                   sales.isEmpty
// // // // // //                       ? const Center(child: Text("No trend records mapping available."))
// // // // // //                       : LineChart(
// // // // // //                           LineChartData(
// // // // // //                             gridData: const FlGridData(show: true),
// // // // // //                             titlesData: FlTitlesData(
// // // // // //                               show: true,
// // // // // //                               bottomTitles: AxisTitles(
// // // // // //                                 sideTitles: SideTitles(
// // // // // //                                   showTitles: true,
// // // // // //                                   getTitlesWidget: (value, meta) {
// // // // // //                                     int index = value.toInt();
// // // // // //                                     if (index >= 0 && index < years.length) {
// // // // // //                                       return Padding(
// // // // // //                                         padding: const EdgeInsets.all(5),
// // // // // //                                         child: Text(
// // // // // //                                           years[index].toString(),
// // // // // //                                           style: const TextStyle(fontSize: 10),
// // // // // //                                         ),
// // // // // //                                       );
// // // // // //                                     }
// // // // // //                                     return const Text('');
// // // // // //                                   },
// // // // // //                                   reservedSize: 22,
// // // // // //                                 ),
// // // // // //                               ),
// // // // // //                             ),
// // // // // //                             lineBarsData: [
// // // // // //                               LineChartBarData(
// // // // // //                                 isCurved: true,
// // // // // //                                 color: Colors.blue,
// // // // // //                                 barWidth: 4,
// // // // // //                                 isStrokeCapRound: true,
// // // // // //                                 dotData: const FlDotData(show: true),
// // // // // //                                 spots: List.generate(
// // // // // //                                   sales.length,
// // // // // //                                   (i) => FlSpot(i.toDouble(), sales[i]),
// // // // // //                                 ),
// // // // // //                               ),
// // // // // //                             ],
// // // // // //                           ),
// // // // // //                         ),
// // // // // //                 ),
// // // // // //               ),
// // // // // //               const SizedBox(width: 16),

// // // // // //               // Category Tracker Component Block
// // // // // //               Expanded(
// // // // // //                 child: containerCard(
// // // // // //                   "System Operational Categories",
// // // // // //                   ListView.separated(
// // // // // //                     padding: const EdgeInsets.symmetric(vertical: 4),
// // // // // //                     itemCount: categories.length,
// // // // // //                     separatorBuilder: (_, __) => const Divider(height: 1),
// // // // // //                     itemBuilder: (context, index) {
// // // // // //                       return Padding(
// // // // // //                         padding: const EdgeInsets.symmetric(vertical: 8.0),
// // // // // //                         child: Row(
// // // // // //                           children: [
// // // // // //                             const Icon(Icons.label_outline, size: 18, color: Colors.blueGrey),
// // // // // //                             const SizedBox(width: 10),
// // // // // //                             Expanded(
// // // // // //                               child: Text(
// // // // // //                                 categories[index],
// // // // // //                                 style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
// // // // // //                               ),
// // // // // //                             ),
// // // // // //                           ],
// // // // // //                         ),
// // // // // //                       );
// // // // // //                     },
// // // // // //                   ),
// // // // // //                 ),
// // // // // //               ),
// // // // // //             ],
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   // ================= UI SUB-WIDGET COMPONENTS =================

// // // // // //   Widget buildCard(String title, String value, Color color, IconData icon) {
// // // // // //     return Expanded(
// // // // // //       child: Container(
// // // // // //         margin: const EdgeInsets.symmetric(horizontal: 6),
// // // // // //         padding: const EdgeInsets.all(16),
// // // // // //         decoration: BoxDecoration(
// // // // // //           color: Colors.white,
// // // // // //           borderRadius: BorderRadius.circular(14),
// // // // // //           boxShadow: const [
// // // // // //             BoxShadow(blurRadius: 10, offset: Offset(0, 4), color: Colors.black12),
// // // // // //           ],
// // // // // //         ),
// // // // // //         child: Row(
// // // // // //           children: [
// // // // // //             Container(
// // // // // //               padding: const EdgeInsets.all(10),
// // // // // //               decoration: BoxDecoration(
// // // // // //                 color: color.withOpacity(0.15),
// // // // // //                 borderRadius: BorderRadius.circular(10),
// // // // // //               ),
// // // // // //               child: Icon(icon, color: color),
// // // // // //             ),
// // // // // //             const SizedBox(width: 12),
// // // // // //             Expanded(
// // // // // //               child: Column(
// // // // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //                 children: [
// // // // // //                   Text(
// // // // // //                     title,
// // // // // //                     style: TextStyle(color: Colors.grey[600], fontSize: 12),
// // // // // //                     overflow: TextOverflow.ellipsis,
// // // // // //                   ),
// // // // // //                   const SizedBox(height: 6),
// // // // // //                   Text(
// // // // // //                     value,
// // // // // //                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
// // // // // //                     overflow: TextOverflow.ellipsis,
// // // // // //                   ),
// // // // // //                 ],
// // // // // //               ),
// // // // // //             ),
// // // // // //           ],
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   Widget containerCard(String title, Widget child) {
// // // // // //     return Container(
// // // // // //       height: 340,
// // // // // //       padding: const EdgeInsets.all(16),
// // // // // //       decoration: BoxDecoration(
// // // // // //         color: Colors.white,
// // // // // //         borderRadius: BorderRadius.circular(14),
// // // // // //         boxShadow: const [
// // // // // //           BoxShadow(blurRadius: 12, offset: Offset(0, 4), color: Colors.black12),
// // // // // //         ],
// // // // // //       ),
// // // // // //       child: Column(
// // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //         children: [
// // // // // //           Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
// // // // // //           const SizedBox(height: 16),
// // // // // //           Expanded(child: child),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // // }
// // // // // import 'dart:convert';
// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:http/http.dart' as http;
// // // // // import 'package:fl_chart/fl_chart.dart';

// // // // // class DashboardPage extends StatefulWidget {
// // // // //   const DashboardPage({super.key});

// // // // //   @override
// // // // //   State<DashboardPage> createState() => _DashboardPageState();
// // // // // }

// // // // // class _DashboardPageState extends State<DashboardPage> {
// // // // //   // Base API configuration (Replace with your actual backend host address/IP)
// // // // //   final String baseUrl = "http://127.0.0.1:5000";

// // // // //   bool _isLoading = true;
// // // // //   String? _errorMessage;

// // // // //   // Data parsed dynamically from backend APIs
// // // // //   List<int> years = [];
// // // // //   List<double> units = [];
// // // // //   List<double> cost = [];
// // // // //   List<double> sales = [];
// // // // //   Map<String, dynamic> globalSummary = {};

// // // // //   @override
// // // // //   void initState() {
// // // // //     super.initState();
// // // // //     _fetchDashboardData();
// // // // //   }

// // // // //   Future<void> _fetchDashboardData() async {
// // // // //     try {
// // // // //       final response = await http.get(Uri.parse('$baseUrl/yearly_summary'));

// // // // //       if (response.statusCode == 200) {
// // // // //         final summaryData = jsonDecode(response.body);

// // // // //         setState(() {
// // // // //           years = List<int>.from(summaryData['years']);
// // // // //           units = List<double>.from(summaryData['units']);
// // // // //           cost = List<double>.from(summaryData['cost']);
// // // // //           sales = List<double>.from(summaryData['sales']);
// // // // //           globalSummary = summaryData['summary'];
// // // // //           _isLoading = false;
// // // // //         });
// // // // //       } else {
// // // // //         throw Exception("Server responded with an error code status.");
// // // // //       }
// // // // //     } catch (e) {
// // // // //       setState(() {
// // // // //         _errorMessage = e.toString();
// // // // //         _isLoading = false;
// // // // //       });
// // // // //     }
// // // // //   }

// // // // //   // Generate explicit contrasting palette colors for yearly breakdown slices
// // // // //   Color _getSliceColor(int index) {
// // // // //     List<Color> palette = [
// // // // //       Colors.blue,
// // // // //       Colors.orange,
// // // // //       Colors.green,
// // // // //       Colors.purple,
// // // // //       Colors.red,
// // // // //       Colors.cyan,
// // // // //     ];
// // // // //     return palette[index % palette.length];
// // // // //   }

// // // // //   // Generates dynamic pie chart elements based on real backend API data arrays
// // // // //   List<PieChartSectionData> _buildPieSections() {
// // // // //     double totalRevenue = sales.fold(0, (sum, item) => sum + item);
// // // // //     if (totalRevenue == 0) return [];

// // // // //     return List.generate(sales.length, (i) {
// // // // //       double percentage = (sales[i] / totalRevenue) * 100;
// // // // //       return PieChartSectionData(
// // // // //         value: sales[i],
// // // // //         title: "${years[i]}\n${percentage.toStringAsFixed(1)}%",
// // // // //         color: _getSliceColor(i),
// // // // //         radius: 75,
// // // // //         titleStyle: const TextStyle(
// // // // //           fontSize: 11,
// // // // //           fontWeight: FontWeight.bold,
// // // // //           color: Colors.white,
// // // // //         ),
// // // // //       );
// // // // //     });
// // // // //   }

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     if (_isLoading) {
// // // // //       return const Center(
// // // // //         child: Padding(
// // // // //           padding: EdgeInsets.all(40.0),
// // // // //           child: CircularProgressIndicator(),
// // // // //         ),
// // // // //       );
// // // // //     }

// // // // //     if (_errorMessage != null) {
// // // // //       return Center(
// // // // //         child: Padding(
// // // // //           padding: const EdgeInsets.all(20.0),
// // // // //           child: Text(
// // // // //             "Failed to load backend metrics: $_errorMessage",
// // // // //             style: const TextStyle(color: Colors.red, fontSize: 16),
// // // // //           ),
// // // // //         ),
// // // // //       );
// // // // //     }

// // // // //     return SingleChildScrollView(
// // // // //       padding: const EdgeInsets.all(20),
// // // // //       child: Column(
// // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // //         children: [
// // // // //           Row(
// // // // //             mainAxisAlignment: MainAxisAlignment.center,
// // // // //             children: [
// // // // //               const Text(
// // // // //                 "Sales Dashboard",
// // // // //                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
// // // // //               ),
// // // // //               IconButton(
// // // // //                 icon: const Icon(Icons.refresh),
// // // // //                 onPressed: () {
// // // // //                   setState(() => _isLoading = true);
// // // // //                   _fetchDashboardData();
// // // // //                 },
// // // // //               ),
// // // // //             ],
// // // // //           ),
// // // // //           const SizedBox(height: 20),

// // // // //           // KPI CARDS
// // // // //           Row(
// // // // //             children: [
// // // // //               buildCard(
// // // // //                 "Total Sales",
// // // // //                 globalSummary["total_sales"]?.toStringAsFixed(2) ?? "0.00",
// // // // //                 Colors.blue,
// // // // //                 Icons.trending_up,
// // // // //               ),
// // // // //               buildCard(
// // // // //                 "Total Cost",
// // // // //                 globalSummary["total_cost"]?.toStringAsFixed(2) ?? "0.00",
// // // // //                 Colors.orange,
// // // // //                 Icons.account_balance_wallet,
// // // // //               ),
// // // // //               buildCard(
// // // // //                 "Net Profit",
// // // // //                 globalSummary["profit"]?.toStringAsFixed(2) ?? "0.00",
// // // // //                 Colors.green,
// // // // //                 Icons.analytics,
// // // // //               ),
// // // // //               buildCard(
// // // // //                 "Units Handled",
// // // // //                 globalSummary["total_units"]?.toStringAsFixed(0) ?? "0",
// // // // //                 Colors.purple,
// // // // //                 Icons.inventory_2,
// // // // //               ),
// // // // //             ],
// // // // //           ),
// // // // //           const SizedBox(height: 25),

// // // // //           // CHARTS SECTION
// // // // //           Row(
// // // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // // //             children: [
// // // // //               // Trend Line Chart Left
// // // // //               Expanded(
// // // // //                 flex: 2,
// // // // //                 child: containerCard(
// // // // //                   "Annual Revenue Trajectory Trend",
// // // // //                   sales.isEmpty
// // // // //                       ? const Center(child: Text("No trend records available."))
// // // // //                       : LineChart(
// // // // //                           LineChartData(
// // // // //                             gridData: const FlGridData(show: true),
// // // // //                             titlesData: FlTitlesData(
// // // // //                               show: true,
// // // // //                               bottomTitles: AxisTitles(
// // // // //                                 sideTitles: SideTitles(
// // // // //                                   showTitles: true,
// // // // //                                   getTitlesWidget: (value, meta) {
// // // // //                                     int index = value.toInt();
// // // // //                                     if (index >= 0 && index < years.length) {
// // // // //                                       return Padding(
// // // // //                                         padding: const EdgeInsets.all(6.0),
// // // // //                                         child: Text(
// // // // //                                           years[index].toString(),
// // // // //                                           style: const TextStyle(fontSize: 10),
// // // // //                                         ),
// // // // //                                       );
// // // // //                                     }
// // // // //                                     return const Text('');
// // // // //                                   },
// // // // //                                   reservedSize: 22,
// // // // //                                 ),
// // // // //                               ),
// // // // //                             ),
// // // // //                             lineBarsData: [
// // // // //                               LineChartBarData(
// // // // //                                 isCurved: true,
// // // // //                                 color: Colors.blue,
// // // // //                                 barWidth: 4,
// // // // //                                 isStrokeCapRound: true,
// // // // //                                 dotData: const FlDotData(show: true),
// // // // //                                 spots: List.generate(
// // // // //                                   sales.length,
// // // // //                                   (i) => FlSpot(i.toDouble(), sales[i]),
// // // // //                                 ),
// // // // //                               ),
// // // // //                             ],
// // // // //                           ),
// // // // //                         ),
// // // // //                 ),
// // // // //               ),
// // // // //               const SizedBox(width: 16),

// // // // //               // Dynamic Yearly Share Pie Chart Right
// // // // //               Expanded(
// // // // //                 child: containerCard(
// // // // //                   "Yearly Revenue Share",
// // // // //                   sales.isEmpty
// // // // //                       ? const Center(child: Text("No records available to calculate share."))
// // // // //                       : Column(
// // // // //                           children: [
// // // // //                             Expanded(
// // // // //                               child: PieChart(
// // // // //                                 PieChartData(
// // // // //                                   centerSpaceRadius: 35,
// // // // //                                   sectionsSpace: 2,
// // // // //                                   sections: _buildPieSections(),
// // // // //                                 ),
// // // // //                               ),
// // // // //                             ),
// // // // //                             const SizedBox(height: 10),
// // // // //                             // Simple dynamic color legends listing below the pie chart
// // // // //                             Wrap(
// // // // //                               spacing: 8,
// // // // //                               runSpacing: 4,
// // // // //                               children: List.generate(years.length, (idx) {
// // // // //                                 return Row(
// // // // //                                   mainAxisSize: MainAxisSize.min,
// // // // //                                   children: [
// // // // //                                     Container(
// // // // //                                       width: 10,
// // // // //                                       height: 10,
// // // // //                                       color: _getSliceColor(idx),
// // // // //                                     ),
// // // // //                                     const SizedBox(width: 4),
// // // // //                                     Text(
// // // // //                                       years[idx].toString(),
// // // // //                                       style: const TextStyle(fontSize: 11, color: Colors.black),
// // // // //                                     ),
// // // // //                                   ],
// // // // //                                 );
// // // // //                               }),
// // // // //                             )
// // // // //                           ],
// // // // //                         ),
// // // // //                 ),
// // // // //               ),
// // // // //             ],
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   // ================= UI SUB-WIDGET COMPONENTS =================

// // // // //   Widget buildCard(String title, String value, Color color, IconData icon) {
// // // // //     return Expanded(
// // // // //       child: Container(
// // // // //         margin: const EdgeInsets.symmetric(horizontal: 6),
// // // // //         padding: const EdgeInsets.all(16),
// // // // //         decoration: BoxDecoration(
// // // // //           color: Colors.white,
// // // // //           borderRadius: BorderRadius.circular(14),
// // // // //           boxShadow: const [
// // // // //             BoxShadow(blurRadius: 10, offset: Offset(0, 4), color: Colors.black12),
// // // // //           ],
// // // // //         ),
// // // // //         child: Row(
// // // // //           children: [
// // // // //             Container(
// // // // //               padding: const EdgeInsets.all(10),
// // // // //               decoration: BoxDecoration(
// // // // //                 color: color.withOpacity(0.15),
// // // // //                 borderRadius: BorderRadius.circular(10),
// // // // //               ),
// // // // //               child: Icon(icon, color: color),
// // // // //             ),
// // // // //             const SizedBox(width: 12),
// // // // //             Expanded(
// // // // //               child: Column(
// // // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // // //                 children: [
// // // // //                   Text(
// // // // //                     title,
// // // // //                     style: TextStyle(color: Colors.grey[600], fontSize: 12),
// // // // //                     overflow: TextOverflow.ellipsis,
// // // // //                   ),
// // // // //                   const SizedBox(height: 6),
// // // // //                   Text(
// // // // //                     value,
// // // // //                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
// // // // //                     overflow: TextOverflow.ellipsis,
// // // // //                   ),
// // // // //                 ],
// // // // //               ),
// // // // //             ),
// // // // //           ],
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget containerCard(String title, Widget child) {
// // // // //     return Container(
// // // // //       height: 350,
// // // // //       padding: const EdgeInsets.all(16),
// // // // //       decoration: BoxDecoration(
// // // // //         color: Colors.white,
// // // // //         borderRadius: BorderRadius.circular(14),
// // // // //         boxShadow: const [
// // // // //           BoxShadow(blurRadius: 12, offset: Offset(0, 4), color: Colors.black12),
// // // // //         ],
// // // // //       ),
// // // // //       child: Column(
// // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // //         children: [
// // // // //           Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
// // // // //           const SizedBox(height: 16),
// // // // //           Expanded(child: child),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }
// // // // import 'dart:convert';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:http/http.dart' as http;
// // // // import 'package:fl_chart/fl_chart.dart';

// // // // class DashboardPage extends StatefulWidget {
// // // //   const DashboardPage({super.key});

// // // //   @override
// // // //   State<DashboardPage> createState() => _DashboardPageState();
// // // // }

// // // // class _DashboardPageState extends State<DashboardPage> {
// // // //   // Base API configuration (Replace with your actual backend host address/IP)
// // // //   final String baseUrl = "http://127.0.0.1:5000";

// // // //   bool _isLoading = true;
// // // //   String? _errorMessage;

// // // //   // Selected dropdown filter state ("All" represents cumulative global data)
// // // //   String _selectedYearFilter = "All";

// // // //   // Raw dynamic data matrices parsed from backend API
// // // //   List<int> years = [];
// // // //   List<double> units = [];
// // // //   List<double> cost = [];
// // // //   List<double> sales = [];
// // // //   Map<String, dynamic> globalSummary = {};

// // // //   // Current values bound directly to display KPI cards
// // // //   String kpiSales = "0.00";
// // // //   String kpiCost = "0.00";
// // // //   String kpiProfit = "0.00";
// // // //   String kpiUnits = "0";

// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     _fetchDashboardData();
// // // //   }

// // // //   Future<void> _fetchDashboardData() async {
// // // //     try {
// // // //       final response = await http.get(Uri.parse('$baseUrl/yearly_summary'));

// // // //       if (response.statusCode == 200) {
// // // //         final summaryData = jsonDecode(response.body);

// // // //         setState(() {
// // // //           years = List<int>.from(summaryData['years']);
// // // //           units = List<double>.from(summaryData['units']);
// // // //           cost = List<double>.from(summaryData['cost']);
// // // //           sales = List<double>.from(summaryData['sales']);
// // // //           globalSummary = summaryData['summary'];
          
// // // //           // Initialize KPIs with global metrics on load
// // // //           _updateKpiDisplayValues("All");
// // // //           _isLoading = false;
// // // //         });
// // // //       } else {
// // // //         throw Exception("Server responded with an error code status.");
// // // //       }
// // // //     } catch (e) {
// // // //       setState(() {
// // // //         _errorMessage = e.toString();
// // // //         _isLoading = false;
// // // //       });
// // // //     }
// // // //   }

// // // //   // Switches display numbers on cards when dropdown filter selection updates
// // // //   void _updateKpiDisplayValues(String filterValue) {
// // // //     if (filterValue == "All") {
// // // //       kpiSales = globalSummary["total_sales"]?.toStringAsFixed(2) ?? "0.00";
// // // //       kpiCost = globalSummary["total_cost"]?.toStringAsFixed(2) ?? "0.00";
// // // //       kpiProfit = globalSummary["profit"]?.toStringAsFixed(2) ?? "0.00";
// // // //       kpiUnits = globalSummary["total_units"]?.toStringAsFixed(0) ?? "0";
// // // //     } else {
// // // //       int targetYear = int.parse(filterValue);
// // // //       int targetIdx = years.indexOf(targetYear);

// // // //       if (targetIdx != -1) {
// // // //         double targetedSales = sales[targetIdx];
// // // //         double targetedCost = cost[targetIdx];
// // // //         double targetedProfit = targetedSales - targetedCost;
// // // //         double targetedUnits = units[targetIdx];

// // // //         kpiSales = targetedSales.toStringAsFixed(2);
// // // //         kpiCost = targetedCost.toStringAsFixed(2);
// // // //         kpiProfit = targetedProfit.toStringAsFixed(2);
// // // //         kpiUnits = targetedUnits.toStringAsFixed(0);
// // // //       }
// // // //     }
// // // //   }

// // // //   Color _getSliceColor(int index) {
// // // //     List<Color> palette = [
// // // //       Colors.blue,
// // // //       Colors.orange,
// // // //       Colors.green,
// // // //       Colors.purple,
// // // //       Colors.red,
// // // //       Colors.cyan,
// // // //     ];
// // // //     return palette[index % palette.length];
// // // //   }

// // // //   List<PieChartSectionData> _buildPieSections() {
// // // //     double totalRevenue = sales.fold(0, (sum, item) => sum + item);
// // // //     if (totalRevenue == 0) return [];

// // // //     return List.generate(sales.length, (i) {
// // // //       double percentage = (sales[i] / totalRevenue) * 100;
// // // //       return PieChartSectionData(
// // // //         value: sales[i],
// // // //         title: "${years[i]}\n${percentage.toStringAsFixed(1)}%",
// // // //         color: _getSliceColor(i),
// // // //         radius: 75,
// // // //         titleStyle: const TextStyle(
// // // //           fontSize: 11,
// // // //           fontWeight: FontWeight.bold,
// // // //           color: Colors.white,
// // // //         ),
// // // //       );
// // // //     });
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     if (_isLoading) {
// // // //       return const Center(
// // // //         child: Padding(
// // // //           padding: EdgeInsets.all(40.0),
// // // //           child: CircularProgressIndicator(),
// // // //         ),
// // // //       );
// // // //     }

// // // //     if (_errorMessage != null) {
// // // //       return Center(
// // // //         child: Padding(
// // // //           padding: const EdgeInsets.all(20.0),
// // // //           child: Text(
// // // //             "Failed to load backend metrics: $_errorMessage",
// // // //             style: const TextStyle(color: Colors.red, fontSize: 16),
// // // //           ),
// // // //         ),
// // // //       );
// // // //     }

// // // //     return SingleChildScrollView(
// // // //       padding: const EdgeInsets.all(20),
// // // //       child: Column(
// // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // //         children: [
// // // //           // HEADER ROW WITH INTERACTIVE FILTER DROPDOWN
// // // //           Row(
// // // //             mainAxisAlignment: MainAxisAlignment.center,
// // // //             children: [
// // // //               const Text(
// // // //                 "Sales Dashboard",
// // // //                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
// // // //               ),
// // // //               Row(
// // // //                 children: [
// // // //                   const Text("Filter Year: ", style: TextStyle(fontWeight: FontWeight.w500)),
// // // //                   const SizedBox(width: 8),
// // // //                   Container(
// // // //                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
// // // //                     decoration: BoxDecoration(
// // // //                       color: Colors.white,
// // // //                       borderRadius: BorderRadius.circular(8),
// // // //                       border: Border.all(color: Colors.grey.shade300),
// // // //                     ),
// // // //                     child: DropdownButtonHideUnderline(
// // // //                       child: DropdownButton<String>(
// // // //                         value: _selectedYearFilter,
// // // //                         icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
// // // //                         onChanged: (String? newValue) {
// // // //                           if (newValue != null) {
// // // //                             setState(() {
// // // //                               _selectedYearFilter = newValue;
// // // //                               _updateKpiDisplayValues(newValue);
// // // //                             });
// // // //                           }
// // // //                         },
// // // //                         items: [
// // // //                           const DropdownMenuItem<String>(
// // // //                             value: "All",
// // // //                             child: Text("All Years (Combined)"),
// // // //                           ),
// // // //                           ...years.map((int year) {
// // // //                             return DropdownMenuItem<String>(
// // // //                               value: year.toString(),
// // // //                               child: Text(year.toString()),
// // // //                             );
// // // //                           }),
// // // //                         ],
// // // //                       ),
// // // //                     ),
// // // //                   ),
// // // //                   const SizedBox(width: 12),
// // // //                   IconButton(
// // // //                     icon: const Icon(Icons.refresh),
// // // //                     onPressed: () {
// // // //                       setState(() {
// // // //                         _isLoading = true;
// // // //                         _selectedYearFilter = "All";
// // // //                       });
// // // //                       _fetchDashboardData();
// // // //                     },
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //             ],
// // // //           ),
// // // //           const SizedBox(height: 20),

// // // //           // KPI CARDS (Driven interactively by the Dropdown State selections)
// // // //           Row(
// // // //             children: [
// // // //               buildCard("Total Sales", kpiSales, Colors.blue, Icons.trending_up),
// // // //               buildCard("Total Cost", kpiCost, Colors.orange, Icons.account_balance_wallet),
// // // //               buildCard("Net Profit", kpiProfit, Colors.green, Icons.analytics),
// // // //               buildCard("Units Handled", kpiUnits, Colors.purple, Icons.inventory_2),
// // // //             ],
// // // //           ),
// // // //           const SizedBox(height: 25),

// // // //           // CHARTS SECTION
// // // //           Row(
// // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // //             children: [
// // // //               // Trend Line Chart Left
// // // //               Expanded(
// // // //                 flex: 2,
// // // //                 child: containerCard(
// // // //                   "Annual Revenue Trajectory Trend",
// // // //                   sales.isEmpty
// // // //                       ? const Center(child: Text("No trend records available."))
// // // //                       : LineChart(
// // // //                           LineChartData(
// // // //                             gridData: const FlGridData(show: true),
// // // //                             titlesData: FlTitlesData(
// // // //                               show: true,
// // // //                               bottomTitles: AxisTitles(
// // // //                                 sideTitles: SideTitles(
// // // //                                   showTitles: true,
// // // //                                   getTitlesWidget: (value, meta) {
// // // //                                     int index = value.toInt();
// // // //                                     if (index >= 0 && index < years.length) {
// // // //                                       return Padding(
// // // //                                         padding: const EdgeInsets.all(6.0),
// // // //                                         child: Text(
// // // //                                           years[index].toString(),
// // // //                                           style: const TextStyle(fontSize: 10),
// // // //                                         ),
// // // //                                       );
// // // //                                     }
// // // //                                     return const Text('');
// // // //                                   },
// // // //                                   reservedSize: 22,
// // // //                                 ),
// // // //                               ),
// // // //                             ),
// // // //                             lineBarsData: [
// // // //                               LineChartBarData(
// // // //                                 isCurved: true,
// // // //                                 color: Colors.blue,
// // // //                                 barWidth: 4,
// // // //                                 isStrokeCapRound: true,
// // // //                                 dotData: const FlDotData(show: true),
// // // //                                 spots: List.generate(
// // // //                                   sales.length,
// // // //                                   (i) => FlSpot(i.toDouble(), sales[i]),
// // // //                                 ),
// // // //                               ),
// // // //                             ],
// // // //                           ),
// // // //                         ),
// // // //                 ),
// // // //               ),
// // // //               const SizedBox(width: 16),

// // // //               // Pie Chart Right
// // // //               Expanded(
// // // //                 child: containerCard(
// // // //                   "Yearly Revenue Share Breakdown",
// // // //                   sales.isEmpty
// // // //                       ? const Center(child: Text("No data available."))
// // // //                       : Column(
// // // //                           children: [
// // // //                             Expanded(
// // // //                               child: PieChart(
// // // //                                 PieChartData(
// // // //                                   centerSpaceRadius: 35,
// // // //                                   sectionsSpace: 2,
// // // //                                   sections: _buildPieSections(),
// // // //                                 ),
// // // //                               ),
// // // //                             ),
// // // //                             const SizedBox(height: 10),
// // // //                             Wrap(
// // // //                               spacing: 8,
// // // //                               runSpacing: 4,
// // // //                               children: List.generate(years.length, (idx) {
// // // //                                 return Row(
// // // //                                   mainAxisSize: MainAxisSize.min,
// // // //                                   children: [
// // // //                                     Container(width: 10, height: 10, color: _getSliceColor(idx)),
// // // //                                     const SizedBox(width: 4),
// // // //                                     Text(
// // // //                                       years[idx].toString(),
// // // //                                       style: const TextStyle(fontSize: 11, color: Colors.black),
// // // //                                     ),
// // // //                                   ],
// // // //                                 );
// // // //                               }),
// // // //                             )
// // // //                           ],
// // // //                         ),
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   // ================= UI SUB-WIDGET COMPONENTS =================

// // // //   Widget buildCard(String title, String value, Color color, IconData icon) {
// // // //     return Expanded(
// // // //       child: Container(
// // // //         margin: const EdgeInsets.symmetric(horizontal: 6),
// // // //         padding: const EdgeInsets.all(16),
// // // //         decoration: BoxDecoration(
// // // //           color: Colors.white,
// // // //           borderRadius: BorderRadius.circular(14),
// // // //           boxShadow: const [
// // // //             BoxShadow(blurRadius: 10, offset: Offset(0, 4), color: Colors.black12),
// // // //           ],
// // // //         ),
// // // //         child: Row(
// // // //           children: [
// // // //             Container(
// // // //               padding: const EdgeInsets.all(10),
// // // //               decoration: BoxDecoration(
// // // //                 color: color.withOpacity(0.15),
// // // //                 borderRadius: BorderRadius.circular(10),
// // // //               ),
// // // //               child: Icon(icon, color: color),
// // // //             ),
// // // //             const SizedBox(width: 12),
// // // //             Expanded(
// // // //               child: Column(
// // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // //                 children: [
// // // //                   Text(
// // // //                     title,
// // // //                     style: TextStyle(color: Colors.grey[600], fontSize: 12),
// // // //                     overflow: TextOverflow.ellipsis,
// // // //                   ),
// // // //                   const SizedBox(height: 6),
// // // //                   Text(
// // // //                     value,
// // // //                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color),
// // // //                     overflow: TextOverflow.ellipsis,
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget containerCard(String title, Widget child) {
// // // //     return Container(
// // // //       height: 350,
// // // //       padding: const EdgeInsets.all(16),
// // // //       decoration: BoxDecoration(
// // // //         color: Colors.white,
// // // //         borderRadius: BorderRadius.circular(14),
// // // //         boxShadow: const [
// // // //           BoxShadow(blurRadius: 12, offset: Offset(0, 4), color: Colors.black12),
// // // //         ],
// // // //       ),
// // // //       child: Column(
// // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // //         children: [
// // // //           Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
// // // //           const SizedBox(height: 16),
// // // //           Expanded(child: child),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // // import 'dart:convert';
// // // import 'package:flutter/material.dart';
// // // import 'package:http/http.dart' as http;
// // // import 'package:fl_chart/fl_chart.dart';

// // // class DashboardPage extends StatefulWidget {
// // //   const DashboardPage({super.key});

// // //   @override
// // //   State<DashboardPage> createState() => _DashboardPageState();
// // // }

// // // class _DashboardPageState extends State<DashboardPage> {
// // //   // Base API configuration (Replace with your actual backend host address/IP)
// // //   final String baseUrl = "http://127.0.0.1:5000";

// // //   bool _isLoading = true;
// // //   String? _errorMessage;
// // //   String _selectedYearFilter = "All";

// // //   // Dynamic lists from backend
// // //   List<int> years = [];
// // //   List<double> units = [];
// // //   List<double> cost = [];
// // //   List<double> sales = [];
// // //   Map<String, dynamic> globalSummary = {};

// // //   // Display metrics
// // //   String kpiSales = "0.00";
// // //   String kpiCost = "0.00";
// // //   String kpiProfit = "0.00";
// // //   String kpiUnits = "0";

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _fetchDashboardData();
// // //   }

// // //   Future<void> _fetchDashboardData() async {
// // //     try {
// // //       final response = await http.get(Uri.parse('$baseUrl/yearly_summary'));

// // //       if (response.statusCode == 200) {
// // //         final summaryData = jsonDecode(response.body);

// // //         setState(() {
// // //           years = List<int>.from(summaryData['years']);
// // //           units = List<double>.from(summaryData['units']);
// // //           cost = List<double>.from(summaryData['cost']);
// // //           sales = List<double>.from(summaryData['sales']);
// // //           globalSummary = summaryData['summary'];
          
// // //           _updateKpiDisplayValues(_selectedYearFilter);
// // //           _isLoading = false;
// // //         });
// // //       } else {
// // //         throw Exception("Server connection failed.");
// // //       }
// // //     } catch (e) {
// // //       setState(() {
// // //         _errorMessage = e.toString();
// // //         _isLoading = false;
// // //       });
// // //     }
// // //   }

// // //   void _updateKpiDisplayValues(String filterValue) {
// // //     if (filterValue == "All") {
// // //       kpiSales = globalSummary["total_sales"]?.toStringAsFixed(2) ?? "0.00";
// // //       kpiCost = globalSummary["total_cost"]?.toStringAsFixed(2) ?? "0.00";
// // //       kpiProfit = globalSummary["profit"]?.toStringAsFixed(2) ?? "0.00";
// // //       kpiUnits = globalSummary["total_units"]?.toStringAsFixed(0) ?? "0";
// // //     } else {
// // //       int targetYear = int.parse(filterValue);
// // //       int targetIdx = years.indexOf(targetYear);

// // //       if (targetIdx != -1) {
// // //         kpiSales = sales[targetIdx].toStringAsFixed(2);
// // //         kpiCost = cost[targetIdx].toStringAsFixed(2);
// // //         kpiProfit = (sales[targetIdx] - cost[targetIdx]).toStringAsFixed(2);
// // //         kpiUnits = units[targetIdx].toStringAsFixed(0);
// // //       }
// // //     }
// // //   }

// // //   Color _getSliceColor(int index) {
// // //     List<Color> corporatePalette = [
// // //       const Color(0xFF1F4E79), // Deep Steel Blue
// // //       const Color(0xFF2E7D32), // Emerald Green
// // //       const Color(0xFFD66011), // Warm Amber
// // //       const Color(0xFF6B4294), // Refined Purple
// // //       const Color(0xFFB71C1C), // Deep Red
// // //       const Color(0xFF00838F), // Teal
// // //     ];
// // //     return corporatePalette[index % corporatePalette.length];
// // //   }

// // //   List<PieChartSectionData> _buildPieSections() {
// // //     double totalRevenue = sales.fold(0, (sum, item) => sum + item);
// // //     if (totalRevenue == 0) return [];

// // //     return List.generate(sales.length, (i) {
// // //       double percentage = (sales[i] / totalRevenue) * 100;
// // //       return PieChartSectionData(
// // //         value: sales[i],
// // //         title: "${percentage.toStringAsFixed(1)}%",
// // //         color: _getSliceColor(i),
// // //         radius: 65,
// // //         titleStyle: const TextStyle(
// // //           fontSize: 12,
// // //           fontWeight: FontWeight.bold,
// // //           color: Colors.white,
// // //         ),
// // //       );
// // //     });
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     // Premium Background color palette
// // //     return Container(
// // //       color: const Color(0xFFF8FAFC),
// // //       child: _isLoading
// // //           ? const Center(child: CircularProgressIndicator(color: Color(0xFF1F4E79)))
// // //           : _errorMessage != null
// // //               ? Center(child: Text("Error: $_errorMessage", style: const TextStyle(color: Colors.red)))
// // //               : SingleChildScrollView(
// // //                   padding: const EdgeInsets.all(24),
// // //                   child: Column(
// // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // //                     children: [
// // //                       // HEADER SECTION
// // //                       Row(
// // //                         mainAxisAlignment: MainAxisAlignment.center,
// // //                         children: [
// // //                           Column(
// // //                             crossAxisAlignment: CrossAxisAlignment.start,
// // //                             children: const [
// // //                               Text(
// // //                                 "Executive Insights",
// // //                                 style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Color(0xFF0F172A), letterSpacing: -0.5),
// // //                               ),
// // //                               SizedBox(height: 4),
// // //                               Text(
// // //                                 "Real-time summary statistics and historical distribution",
// // //                                 style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
// // //                               ),
// // //                             ],
// // //                           ),
                          
// // //                           // FILTER CARD
// // //                           Row(
// // //                             children: [
// // //                               Container(
// // //                                 padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
// // //                                 decoration: BoxDecoration(
// // //                                   color: Colors.white,
// // //                                   borderRadius: BorderRadius.circular(10),
// // //                                   border: Border.all(color: const Color(0xFFE2E8F0)),
// // //                                   boxShadow: [
// // //                                     BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: const Offset(0, 2)),
// // //                                   ],
// // //                                 ),
// // //                                 child: DropdownButtonHideUnderline(
// // //                                   child: DropdownButton<String>(
// // //                                     value: _selectedYearFilter,
// // //                                     icon: const Icon(Icons.filter_alt_outlined, color: Color(0xFF475569), size: 18),
// // //                                     style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
// // //                                     onChanged: (String? newValue) {
// // //                                       if (newValue != null) {
// // //                                         setState(() {
// // //                                           _selectedYearFilter = newValue;
// // //                                           _updateKpiDisplayValues(newValue);
// // //                                         });
// // //                                       }
// // //                                     },
// // //                                     items: [
// // //                                       const DropdownMenuItem(value: "All", child: Text("All Years Combined  ")),
// // //                                       ...years.map((y) => DropdownMenuItem(value: y.toString(), child: Text("Year $y  "))),
// // //                                     ],
// // //                                   ),
// // //                                 ),
// // //                               ),
// // //                               const SizedBox(width: 12),
// // //                               IconButton(
// // //                                 icon: const Icon(Icons.refresh_rounded, color: Color(0xFF475569)),
// // //                                 onPressed: () {
// // //                                   setState(() => _isLoading = true);
// // //                                   _fetchDashboardData();
// // //                                 },
// // //                               ),
// // //                             ],
// // //                           ),
// // //                         ],
// // //                       ),
// // //                       const SizedBox(height: 28),

// // //                       // KPI METRIC ROW
// // //                       Row(
// // //                         children: [
// // //                           buildCard("Total Revenue", kpiSales, const Color(0xFF1E40AF), Icons.trending_up_rounded),
// // //                           buildCard("Operational Cost", kpiCost, const Color(0xFFD97706), Icons.account_balance_wallet_outlined),
// // //                           buildCard("Net Margins", kpiProfit, const Color(0xFF15803D), Icons.analytics_outlined),
// // //                           buildCard("Volume Distributed", kpiUnits, const Color(0xFF6D28D9), Icons.widgets_outlined),
// // //                         ],
// // //                       ),
// // //                       const SizedBox(height: 28),

// // //                       // CHARTS AND GRAPH PANELS
// // //                       Row(
// // //                         crossAxisAlignment: CrossAxisAlignment.start,
// // //                         children: [
// // //                           // Left Box: Line chart
// // //                           Expanded(
// // //                             flex: 2,
// // //                             child: containerCard(
// // //                               "Revenue Trajectory (Annual Progression)",
// // //                               LineChart(
// // //                                 LineChartData(
// // //                                   gridData: FlGridData(
// // //                                     show: true,
// // //                                     drawVerticalLine: false,
// // //                                     getDrawingHorizontalLine: (val) => FlLine(color: const Color(0xFFF1F5F9), strokeWidth: 1),
// // //                                   ),
// // //                                   borderData: FlBorderData(show: false),
// // //                                   titlesData: FlTitlesData(
// // //                                     show: true,
// // //                                     rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
// // //                                     topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
// // //                                     bottomTitles: AxisTitles(
// // //                                       sideTitles: SideTitles(
// // //                                         showTitles: true,
// // //                                         getTitlesWidget: (value, meta) {
// // //                                           int index = value.toInt();
// // //                                           if (index >= 0 && index < years.length) {
// // //                                             return Text(years[index].toString(), style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold));
// // //                                           }
// // //                                           return const Text('');
// // //                                         },
// // //                                       ),
// // //                                     ),
// // //                                   ),
// // //                                   lineBarsData: [
// // //                                     LineChartBarData(
// // //                                       isCurved: true,
// // //                                       curveSmoothness: 0.35,
// // //                                       color: const Color(0xFF1E40AF),
// // //                                       barWidth: 4,
// // //                                       isStrokeCapRound: true,
// // //                                       dotData: const FlDotData(show: true),
// // //                                       spots: List.generate(sales.length, (i) => FlSpot(i.toDouble(), sales[i])),
// // //                                     ),
// // //                                   ],
// // //                                 ),
// // //                               ),
// // //                             ),
// // //                           ),
// // //                           const SizedBox(width: 20),

// // //                           // Right Box: Pie chart
// // //                           Expanded(
// // //                             child: containerCard(
// // //                               "Revenue Distribution Share",
// // //                               Column(
// // //                                 children: [
// // //                                   Expanded(
// // //                                     child: PieChart(
// // //                                       PieChartData(
// // //                                         centerSpaceRadius: 40,
// // //                                         sectionsSpace: 3,
// // //                                         sections: _buildPieSections(),
// // //                                       ),
// // //                                     ),
// // //                                   ),
// // //                                   const SizedBox(height: 16),
// // //                                   Wrap(
// // //                                     spacing: 12,
// // //                                     runSpacing: 8,
// // //                                     children: List.generate(years.length, (idx) {
// // //                                       return Row(
// // //                                         mainAxisSize: MainAxisSize.min,
// // //                                         children: [
// // //                                           Container(
// // //                                             width: 10,
// // //                                             height: 10,
// // //                                             decoration: BoxDecoration(color: _getSliceColor(idx), shape: BoxShape.circle),
// // //                                           ),
// // //                                           const SizedBox(width: 6),
// // //                                           Text(
// // //                                             years[idx].toString(),
// // //                                             style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
// // //                                           ),
// // //                                         ],
// // //                                       );
// // //                                     }),
// // //                                   )
// // //                                 ],
// // //                               ),
// // //                             ),
// // //                           ),
// // //                         ],
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //     );
// // //   }

// // //   // ================= SIMPLIFIED LAYOUT COMPONENTS =================

// // //   Widget buildCard(String title, String value, Color themeColor, IconData icon) {
// // //     return Expanded(
// // //       child: Container(
// // //         margin: const EdgeInsets.symmetric(horizontal: 6),
// // //         padding: const EdgeInsets.all(20),
// // //         decoration: BoxDecoration(
// // //           color: Colors.white,
// // //           borderRadius: BorderRadius.circular(16),
// // //           border: Border.all(color: const Color(0xFFF1F5F9)),
// // //           boxShadow: [
// // //             BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
// // //           ],
// // //         ),
// // //         child: Row(
// // //           children: [
// // //             Container(
// // //               padding: const EdgeInsets.all(12),
// // //               decoration: BoxDecoration(
// // //                 color: themeColor.withOpacity(0.08),
// // //                 borderRadius: BorderRadius.circular(12),
// // //               ),
// // //               child: Icon(icon, color: themeColor, size: 22),
// // //             ),
// // //             const SizedBox(width: 16),
// // //             Expanded(
// // //               child: Column(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   Text(
// // //                     title,
// // //                     style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w500),
// // //                     overflow: TextOverflow.ellipsis,
// // //                   ),
// // //                   const SizedBox(height: 6),
// // //                   Text(
// // //                     value,
// // //                     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF0F172A), letterSpacing: -0.2),
// // //                     overflow: TextOverflow.ellipsis,
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget containerCard(String panelTitle, Widget contentWidget) {
// // //     return Container(
// // //       height: 380,
// // //       padding: const EdgeInsets.all(24),
// // //       decoration: BoxDecoration(
// // //         color: Colors.white,
// // //         borderRadius: BorderRadius.circular(16),
// // //         border: Border.all(color: const Color(0xFFF1F5F9)),
// // //         boxShadow: [
// // //           BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 12, offset: const Offset(0, 4)),
// // //         ],
// // //       ),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           Text(
// // //             panelTitle,
// // //             style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Color(0xFF1E293B)),
// // //           ),
// // //           const SizedBox(height: 24),
// // //           Expanded(child: contentWidget),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:fl_chart/fl_chart.dart';

// // class DashboardPage extends StatefulWidget {
// //   const DashboardPage({super.key});

// //   @override
// //   State<DashboardPage> createState() => _DashboardPageState();
// // }

// // class _DashboardPageState extends State<DashboardPage> {
// //   // Base API configuration (Replace with your actual backend host address/IP)
// //   final String baseUrl = "http://127.0.0.1:5000";

// //   bool _isLoading = true;
// //   String? _errorMessage;
// //   String _selectedYearFilter = "All";

// //   // Dynamic lists from backend
// //   List<int> years = [];
// //   List<double> units = [];
// //   List<double> cost = [];
// //   List<double> sales = [];
// //   Map<String, dynamic> globalSummary = {};

// //   // Display metrics
// //   String kpiSales = "0.00";
// //   String kpiCost = "0.00";
// //   String kpiProfit = "0.00";
// //   String kpiUnits = "0";

// //   @override
// //   void initState() {
// //     super.initState();
// //     _fetchDashboardData();
// //   }

// //   Future<void> _fetchDashboardData() async {
// //     try {
// //       final response = await http.get(Uri.parse('$baseUrl/yearly_summary'));

// //       if (response.statusCode == 200) {
// //         final summaryData = jsonDecode(response.body);

// //         setState(() {
// //           years = List<int>.from(summaryData['years']);
// //           units = List<double>.from(summaryData['units']);
// //           cost = List<double>.from(summaryData['cost']);
// //           sales = List<double>.from(summaryData['sales']);
// //           globalSummary = summaryData['summary'];
          
// //           _updateKpiDisplayValues(_selectedYearFilter);
// //           _isLoading = false;
// //         });
// //       } else {
// //         throw Exception("Server connection failed.");
// //       }
// //     } catch (e) {
// //       setState(() {
// //         _errorMessage = e.toString();
// //         _isLoading = false;
// //       });
// //     }
// //   }

// //   void _updateKpiDisplayValues(String filterValue) {
// //     if (filterValue == "All") {
// //       kpiSales = globalSummary["total_sales"]?.toStringAsFixed(2) ?? "0.00";
// //       kpiCost = globalSummary["total_cost"]?.toStringAsFixed(2) ?? "0.00";
// //       kpiProfit = globalSummary["profit"]?.toStringAsFixed(2) ?? "0.00";
// //       kpiUnits = globalSummary["total_units"]?.toStringAsFixed(0) ?? "0";
// //     } else {
// //       int targetYear = int.parse(filterValue);
// //       int targetIdx = years.indexOf(targetYear);

// //       if (targetIdx != -1) {
// //         kpiSales = sales[targetIdx].toStringAsFixed(2);
// //         kpiCost = cost[targetIdx].toStringAsFixed(2);
// //         kpiProfit = (sales[targetIdx] - cost[targetIdx]).toStringAsFixed(2);
// //         kpiUnits = units[targetIdx].toStringAsFixed(0);
// //       }
// //     }
// //   }

// //   // Soft Pinterest-inspired palette (Terracotta, Sage, Warm Oats, Blush, Dust Blue)
// //   Color _getSliceColor(int index) {
// //     List<Color> pinterestPalette = [
// //       const Color(0xFFD9745B), // Terracotta
// //       const Color(0xFF8A9A86), // Sage Green
// //       const Color(0xFFE6C594), // Warm Mustard / Oat
// //       const Color(0xFFD4A5A5), // Dusty Blush Rose
// //       const Color(0xFF93A8AC), // Steel / Dust Blue
// //       const Color(0xFFB58A70), // Soft Clay Almond
// //     ];
// //     return pinterestPalette[index % pinterestPalette.length];
// //   }

// //   List<PieChartSectionData> _buildPieSections() {
// //     double totalRevenue = sales.fold(0, (sum, item) => sum + item);
// //     if (totalRevenue == 0) return [];

// //     return List.generate(sales.length, (i) {
// //       double percentage = (sales[i] / totalRevenue) * 100;
// //       return PieChartSectionData(
// //         value: sales[i],
// //         title: "${percentage.toStringAsFixed(1)}%",
// //         color: _getSliceColor(i),
// //         radius: 80, // Bigger pie slices
// //         titleStyle: const TextStyle(
// //           fontSize: 13,
// //           fontWeight: FontWeight.w600,
// //           color: Colors.white,
// //         ),
// //       );
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     // Warm, cream/sand soft background color popular on Pinterest
// //     return Container(
// //       color: const Color(0xFFFAF8F5),
// //       child: _isLoading
// //           ? const Center(child: CircularProgressIndicator(color: Color(0xFFD9745B)))
// //           : _errorMessage != null
// //               ? Center(child: Text("Error: $_errorMessage", style: const TextStyle(color: Colors.red)))
// //               : SingleChildScrollView(
// //                   padding: const EdgeInsets.all(32), // Extra padding for open space
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       // HEADER SECTION
// //                       Row(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         children: [
// //                           Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: const [
// //                               Text(
// //                                 "Overview Analytics",
// //                                 style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF2C2523), letterSpacing: -0.5),
// //                               ),
// //                               SizedBox(height: 6),
// //                               Text(
// //                                 "Your business performance summary and annual trends",
// //                                 style: TextStyle(fontSize: 14, color: Color(0xFF7D7471)),
// //                               ),
// //                             ],
// //                           ),
                          
// //                           // DROPDOWN FILTER
// //                           Row(
// //                             children: [
// //                               Container(
// //                                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
// //                                 decoration: BoxDecoration(
// //                                   color: Colors.white,
// //                                   borderRadius: BorderRadius.circular(12),
// //                                   border: Border.all(color: const Color(0xFFEFECE6)),
// //                                   boxShadow: [
// //                                     BoxShadow(color: const Color(0xFF2C2523).withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 4)),
// //                                   ],
// //                                 ),
// //                                 child: DropdownButtonHideUnderline(
// //                                   child: DropdownButton<String>(
// //                                     value: _selectedYearFilter,
// //                                     icon: const Icon(Icons.expand_more_rounded, color: Color(0xFF7D7471), size: 20),
// //                                     style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2C2523)),
// //                                     dropdownColor: Colors.white,
// //                                     borderRadius: BorderRadius.circular(12),
// //                                     onChanged: (String? newValue) {
// //                                       if (newValue != null) {
// //                                         setState(() {
// //                                           _selectedYearFilter = newValue;
// //                                           _updateKpiDisplayValues(newValue);
// //                                         });
// //                                       }
// //                                     },
// //                                     items: [
// //                                       const DropdownMenuItem(value: "All", child: Text("All Years Combined   ")),
// //                                       ...years.map((y) => DropdownMenuItem(value: y.toString(), child: Text("Year $y   "))),
// //                                     ],
// //                                   ),
// //                                 ),
// //                               ),
// //                               const SizedBox(width: 16),
// //                               IconButton(
// //                                 icon: const Icon(Icons.refresh_rounded, color: Color(0xFF7D7471)),
// //                                 onPressed: () {
// //                                   setState(() => _isLoading = true);
// //                                   _fetchDashboardData();
// //                                 },
// //                               ),
// //                             ],
// //                           ),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 32),

// //                       // LARGER KPI METRIC ROW
// //                       Row(
// //                         children: [
// //                           buildCard("Total Sales", kpiSales, const Color(0xFFD9745B), Icons.star_border_rounded),
// //                           buildCard("Total Expenses", kpiCost, const Color(0xFF8A9A86), Icons.local_mall_outlined),
// //                           buildCard("Net Profit", kpiProfit, const Color(0xFFB58A70), Icons.favorite_border_rounded),
// //                           buildCard("Items Sold", kpiUnits, const Color(0xFF93A8AC), Icons.grid_view_rounded),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 32),

// //                       // TALLER CHARTS SECTION
// //                       Row(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           // Left Box: Line chart (Expanded view)
// //                           Expanded(
// //                             flex: 2,
// //                             child: containerCard(
// //                               "Sales Over Time",
// //                               LineChart(
// //                                 LineChartData(
// //                                   gridData: FlGridData(
// //                                     show: true,
// //                                     drawVerticalLine: false,
// //                                     getDrawingHorizontalLine: (val) => FlLine(color: const Color(0xFFF7F4F0), strokeWidth: 1.5),
// //                                   ),
// //                                   borderData: FlBorderData(show: false),
// //                                   titlesData: FlTitlesData(
// //                                     show: true,
// //                                     rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
// //                                     topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
// //                                     bottomTitles: AxisTitles(
// //                                       sideTitles: SideTitles(
// //                                         showTitles: true,
// //                                         getTitlesWidget: (value, meta) {
// //                                           int index = value.toInt();
// //                                           if (index >= 0 && index < years.length) {
// //                                             return Padding(
// //                                               padding: const EdgeInsets.all(10.0),
// //                                               child: Text(years[index].toString(), style: const TextStyle(fontSize: 12, color: Color(0xFF9C938E), fontWeight: FontWeight.w600)),
// //                                             );
// //                                           }
// //                                           return const Text('');
// //                                         },
// //                                       ),
// //                                     ),
// //                                   ),
// //                                   lineBarsData: [
// //                                     LineChartBarData(
// //                                       isCurved: true,
// //                                       curveSmoothness: 0.3,
// //                                       color: const Color(0xFFD9745B), // Main aesthetic color tone
// //                                       barWidth: 5,
// //                                       isStrokeCapRound: true,
// //                                       dotData: FlDotData(
// //                                         show: true,
// //                                         getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
// //                                           radius: 6,
// //                                           color: Colors.white,
// //                                           strokeWidth: 3,
// //                                           strokeColor: const Color(0xFFD9745B),
// //                                         ),
// //                                       ),
// //                                       belowBarData: BarAreaData(
// //                                         show: true,
// //                                         color: const Color(0xFFD9745B).withOpacity(0.06), // Aesthetic soft gradient fill
// //                                       ),
// //                                       spots: List.generate(sales.length, (i) => FlSpot(i.toDouble(), sales[i])),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ),
// //                             ),
// //                           ),
// //                           const SizedBox(width: 24),

// //                           // Right Box: Pie chart
// //                           Expanded(
// //                             child: containerCard(
// //                               "Sales Percentage Share",
// //                               Column(
// //                                 children: [
// //                                   Expanded(
// //                                     child: PieChart(
// //                                       PieChartData(
// //                                         centerSpaceRadius: 45, // Wider center hole
// //                                         sectionsSpace: 4,
// //                                         sections: _buildPieSections(),
// //                                       ),
// //                                     ),
// //                                   ),
// //                                   const SizedBox(height: 24),
// //                                   Wrap(
// //                                     spacing: 14,
// //                                     runSpacing: 10,
// //                                     children: List.generate(years.length, (idx) {
// //                                       return Row(
// //                                         mainAxisSize: MainAxisSize.min,
// //                                         children: [
// //                                           Container(
// //                                             width: 12,
// //                                             height: 12,
// //                                             decoration: BoxDecoration(color: _getSliceColor(idx), shape: BoxShape.circle),
// //                                           ),
// //                                           const SizedBox(width: 8),
// //                                           Text(
// //                                             years[idx].toString(),
// //                                             style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF4A4240)),
// //                                           ),
// //                                         ],
// //                                       );
// //                                     }),
// //                                   )
// //                                 ],
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //     );
// //   }

// //   // ================= REDESIGNED COMPONENT BLOCKS =================

// //   Widget buildCard(String title, String value, Color warmColor, IconData icon) {
// //     return Expanded(
// //       child: Container(
// //         margin: const EdgeInsets.symmetric(horizontal: 8),
// //         padding: const EdgeInsets.all(24), // Increased layout height and widths
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(20), // Softer corners
// //           border: Border.all(color: const Color(0xFFEFECE6)),
// //           boxShadow: [
// //             BoxShadow(color: const Color(0xFF2C2523).withOpacity(0.02), blurRadius: 12, offset: const Offset(0, 6)),
// //           ],
// //         ),
// //         child: Row(
// //           children: [
// //             Container(
// //               padding: const EdgeInsets.all(14),
// //               decoration: BoxDecoration(
// //                 color: warmColor.withOpacity(0.08),
// //                 shape: BoxShape.circle, // Circular shapes match the mood better
// //               ),
// //               child: Icon(icon, color: warmColor, size: 24),
// //             ),
// //             const SizedBox(width: 18),
// //             Expanded(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     title,
// //                     style: const TextStyle(color: Color(0xFF9C938E), fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.2),
// //                     overflow: TextOverflow.ellipsis,
// //                   ),
// //                   const SizedBox(height: 8),
// //                   Text(
// //                     value,
// //                     style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF2C2523), letterSpacing: -0.4),
// //                     overflow: TextOverflow.ellipsis,
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget containerCard(String panelTitle, Widget contentWidget) {
// //     return Container(
// //       height: 440, // Increased height limits for graphs to make them pop out
// //       padding: const EdgeInsets.all(28),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(24),
// //         border: Border.all(color: const Color(0xFFEFECE6)),
// //         boxShadow: [
// //           BoxShadow(color: const Color(0xFF2C2523).withOpacity(0.02), blurRadius: 16, offset: const Offset(0, 6)),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             panelTitle,
// //             style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF2C2523), letterSpacing: -0.2),
// //           ),
// //           const SizedBox(height: 32),
// //           Expanded(child: contentWidget),
// //         ],
// //       ),
// //     );
// //   }
// // }
// // // }
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:fl_chart/fl_chart.dart';

// class DashboardPage extends StatefulWidget {
//   const DashboardPage({super.key});

//   @override
//   State<DashboardPage> createState() => _DashboardPageState();
// }

// class _DashboardPageState extends State<DashboardPage> {
//   // Base API configuration (Replace with your actual backend host address/IP)
//   final String baseUrl = "http://127.0.0.1:5000";

//   bool _isLoading = true;
//   String? _errorMessage;
//   String _selectedYearFilter = "All";

//   // Dynamic lists from backend
//   List<int> years = [];
//   List<double> units = [];
//   List<double> cost = [];
//   List<double> sales = [];
//   Map<String, dynamic> globalSummary = {};

//   // Display metrics
//   String kpiSales = "0.00";
//   String kpiCost = "0.00";
//   String kpiProfit = "0.00";
//   String kpiUnits = "0";

//   @override
//   void initState() {
//     super.initState();
//     _fetchDashboardData();
//   }

//   Future<void> _fetchDashboardData() async {
//     try {
//       final response = await http.get(Uri.parse('$baseUrl/yearly_summary'));

//       if (response.statusCode == 200) {
//         final summaryData = jsonDecode(response.body);

//         setState(() {
//           years = List<int>.from(summaryData['years']);
//           units = List<double>.from(summaryData['units']);
//           cost = List<double>.from(summaryData['cost']);
//           sales = List<double>.from(summaryData['sales']);
//           globalSummary = summaryData['summary'];
          
//           _updateKpiDisplayValues(_selectedYearFilter);
//           _isLoading = false;
//         });
//       } else {
//         throw Exception("Server connection failed.");
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = e.toString();
//         _isLoading = false;
//       });
//     }
//   }

//   void _updateKpiDisplayValues(String filterValue) {
//     if (filterValue == "All") {
//       kpiSales = globalSummary["total_sales"]?.toStringAsFixed(2) ?? "0.00";
//       kpiCost = globalSummary["total_cost"]?.toStringAsFixed(2) ?? "0.00";
//       kpiProfit = globalSummary["profit"]?.toStringAsFixed(2) ?? "0.00";
//       kpiUnits = globalSummary["total_units"]?.toStringAsFixed(0) ?? "0";
//     } else {
//       int targetYear = int.parse(filterValue);
//       int targetIdx = years.indexOf(targetYear);

//       if (targetIdx != -1) {
//         kpiSales = sales[targetIdx].toStringAsFixed(2);
//         kpiCost = cost[targetIdx].toStringAsFixed(2);
//         kpiProfit = (sales[targetIdx] - cost[targetIdx]).toStringAsFixed(2);
//         kpiUnits = units[targetIdx].toStringAsFixed(0);
//       }
//     }
//   }

//   // Expanded, ultra-soft Pinterest palette (10 tones that are super nice to the eyes)
//   Color _getSliceColor(int index) {
//     List<Color> niceToEyesPalette = [
//       const Color(0xFFD9745B), // Terracotta
//       const Color(0xFF8A9A86), // Sage Green
//       const Color(0xFFE6C594), // Soft Mustard Oat
//       const Color(0xFFD4A5A5), // Dusty Blush Rose
//       const Color(0xFF93A8AC), // Misty Steel Blue
//       const Color(0xFFB58A70), // Soft Clay Almond
//       const Color(0xFFB3A3B4), // Dusty Lavender / Mauve
//       const Color(0xFFE2B49A), // Creamy Peach Sun
//       const Color(0xFFA3B899), // Pale Matcha Green
//       const Color(0xFFABC4FF), // Soft Pastel Sky
//     ];
//     return niceToEyesPalette[index % niceToEyesPalette.length];
//   }

//   List<PieChartSectionData> _buildPieSections() {
//     double totalRevenue = sales.fold(0, (sum, item) => sum + item);
//     if (totalRevenue == 0) return [];

//     return List.generate(sales.length, (i) {
//       double percentage = (sales[i] / totalRevenue) * 100;
//       return PieChartSectionData(
//         value: sales[i],
//         title: "${percentage.toStringAsFixed(1)}%",
//         color: _getSliceColor(i),
//         radius: 80, 
//         titleStyle: const TextStyle(
//           fontSize: 13,
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//         ),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: const Color(0xFFFAF8F5), // Warm, cozy off-white background
//       child: _isLoading
//           ? const Center(child: CircularProgressIndicator(color: Color(0xFFD9745B)))
//           : _errorMessage != null
//               ? Center(child: Text("Error: $_errorMessage", style: const TextStyle(color: Colors.red)))
//               : SingleChildScrollView(
//                   padding: const EdgeInsets.all(32), 
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // HEADER SECTION
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: const [
//                               Text(
//                                 "Overview Analytics",
//                                 style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF2C2523), letterSpacing: -0.5),
//                               ),
//                               SizedBox(height: 6),
//                               Text(
//                                 "Your business performance summary and annual trends",
//                                 style: TextStyle(fontSize: 14, color: Color(0xFF7D7471)),
//                               ),
//                             ],
//                           ),
                          
//                           // DROPDOWN FILTER
//                           Row(
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(12),
//                                   border: Border.all(color: const Color(0xFFEFECE6)),
//                                   boxShadow: [
//                                     BoxShadow(color: const Color(0xFF2C2523).withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 4)),
//                                   ],
//                                 ),
//                                 child: DropdownButtonHideUnderline(
//                                   child: DropdownButton<String>(
//                                     value: _selectedYearFilter,
//                                     icon: const Icon(Icons.expand_more_rounded, color: Color(0xFF7D7471), size: 20),
//                                     style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2C2523)),
//                                     dropdownColor: Colors.white,
//                                     borderRadius: BorderRadius.circular(12),
//                                     onChanged: (String? newValue) {
//                                       if (newValue != null) {
//                                         setState(() {
//                                           _selectedYearFilter = newValue;
//                                           _updateKpiDisplayValues(newValue);
//                                         });
//                                       }
//                                     },
//                                     items: [
//                                       const DropdownMenuItem(value: "All", child: Text("All Years Combined   ")),
//                                       ...years.map((y) => DropdownMenuItem(value: y.toString(), child: Text("Year $y   "))),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 16),
//                               IconButton(
//                                 icon: const Icon(Icons.refresh_rounded, color: Color(0xFF7D7471)),
//                                 onPressed: () {
//                                   setState(() => _isLoading = true);
//                                   _fetchDashboardData();
//                                 },
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 32),

//                       // LARGER KPI METRIC ROW
//                       Row(
//                         children: [
//                           buildCard("Total Sales", kpiSales, const Color(0xFFD9745B), Icons.star_border_rounded),
//                           buildCard("Total Expenses", kpiCost, const Color(0xFF8A9A86), Icons.local_mall_outlined),
//                           buildCard("Net Profit", kpiProfit, const Color(0xFFB58A70), Icons.favorite_border_rounded),
//                           buildCard("Items Sold", kpiUnits, const Color(0xFF93A8AC), Icons.grid_view_rounded),
//                         ],
//                       ),
//                       const SizedBox(height: 32),

//                       // TALLER CHARTS SECTION
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Left Box: Line chart
//                           Expanded(
//                             flex: 2,
//                             child: containerCard(
//                               "Sales Over Time",
//                               LineChart(
//                                 LineChartData(
//                                   gridData: FlGridData(
//                                     show: true,
//                                     drawVerticalLine: false,
//                                     getDrawingHorizontalLine: (val) => FlLine(color: const Color(0xFFF7F4F0), strokeWidth: 1.5),
//                                   ),
//                                   borderData: FlBorderData(show: false),
//                                   titlesData: FlTitlesData(
//                                     show: true,
//                                     rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                                     topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                                     bottomTitles: AxisTitles(
//                                       sideTitles: SideTitles(
//                                         showTitles: true,
//                                         getTitlesWidget: (value, meta) {
//                                           int index = value.toInt();
//                                           if (index >= 0 && index < years.length) {
//                                             return Padding(
//                                               padding: const EdgeInsets.all(10.0),
//                                               child: Text(years[index].toString(), style: const TextStyle(fontSize: 12, color: Color(0xFF9C938E), fontWeight: FontWeight.w600)),
//                                             );
//                                           }
//                                           return const Text('');
//                                         },
//                                       ),
//                                     ),
//                                   ),
//                                   lineBarsData: [
//                                     LineChartBarData(
//                                       isCurved: true,
//                                       curveSmoothness: 0.3,
//                                       color: const Color(0xFFD9745B), 
//                                       barWidth: 5,
//                                       isStrokeCapRound: true,
//                                       dotData: FlDotData(
//                                         show: true,
//                                         getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
//                                           radius: 6,
//                                           color: Colors.white,
//                                           strokeWidth: 3,
//                                           strokeColor: const Color(0xFFD9745B),
//                                         ),
//                                       ),
//                                       belowBarData: BarAreaData(
//                                         show: true,
//                                         color: const Color(0xFFD9745B).withOpacity(0.06), 
//                                       ),
//                                       spots: List.generate(sales.length, (i) => FlSpot(i.toDouble(), sales[i])),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 24),

//                           // Right Box: Pie chart with expanded color legend
//                           Expanded(
//                             child: containerCard(
//                               "Sales Percentage Share",
//                               Column(
//                                 children: [
//                                   Expanded(
//                                     child: PieChart(
//                                       PieChartData(
//                                         centerSpaceRadius: 45, 
//                                         sectionsSpace: 4,
//                                         sections: _buildPieSections(),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 24),
//                                   // Scrollable or wrapping color legend area
//                                   Wrap(
//                                     spacing: 14,
//                                     runSpacing: 10,
//                                     children: List.generate(years.length, (idx) {
//                                       return Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           Container(
//                                             width: 12,
//                                             height: 12,
//                                             decoration: BoxDecoration(color: _getSliceColor(idx), shape: BoxShape.circle),
//                                           ),
//                                           const SizedBox(width: 8),
//                                           Text(
//                                             years[idx].toString(),
//                                             style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF4A4240)),
//                                           ),
//                                         ],
//                                       );
//                                     }),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//     );
//   }

//   // ================= REDESIGNED COMPONENT BLOCKS =================

//   Widget buildCard(String title, String value, Color warmColor, IconData icon) {
//     return Expanded(
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 8),
//         padding: const EdgeInsets.all(24), 
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20), 
//           border: Border.all(color: const Color(0xFFEFECE6)),
//           boxShadow: [
//             BoxShadow(color: const Color(0xFF2C2523).withOpacity(0.02), blurRadius: 12, offset: const Offset(0, 6)),
//           ],
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(14),
//               decoration: BoxDecoration(
//                 color: warmColor.withOpacity(0.08),
//                 shape: BoxShape.circle, 
//               ),
//               child: Icon(icon, color: warmColor, size: 24),
//             ),
//             const SizedBox(width: 18),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(color: Color(0xFF9C938E), fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.2),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     value,
//                     style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF2C2523), letterSpacing: -0.4),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget containerCard(String panelTitle, Widget contentWidget) {
//     return Container(
//       height: 440, 
//       padding: const EdgeInsets.all(28),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(color: const Color(0xFFEFECE6)),
//         boxShadow: [
//           BoxShadow(color: const Color(0xFF2C2523).withOpacity(0.02), blurRadius: 16, offset: const Offset(0, 6)),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             panelTitle,
//             style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF2C2523), letterSpacing: -0.2),
//           ),
//           const SizedBox(height: 32),
//           Expanded(child: contentWidget),
//         ],
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Base API configuration
  final String baseUrl = "http://127.0.0.1:5000";
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool _isLoading = true;
  String? _errorMessage;
  String _selectedYearFilter = "All";

  // Dynamic lists from backend
  List<int> years = [];
  List<double> units = [];
  List<double> cost = [];
  List<double> sales = [];
  Map<String, dynamic> globalSummary = {};

  // Display metrics
  String kpiSales = "0.00";
  String kpiCost = "0.00";
  String kpiProfit = "0.00";
  String kpiUnits = "0";

  // Firestore data
  List<Map<String, dynamic>> lowStockItems = [];
  List<Map<String, dynamic>> hotSellingItems = [];
  bool isLoadingFirestore = true;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
    _fetchLowStockAndHotSelling();
  }

  Future<void> _fetchDashboardData() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/yearly_summary'));

      if (response.statusCode == 200) {
        final summaryData = jsonDecode(response.body);

        setState(() {
          years = List<int>.from(summaryData['years']);
          units = List<double>.from(summaryData['units']);
          cost = List<double>.from(summaryData['cost']);
          sales = List<double>.from(summaryData['sales']);
          globalSummary = summaryData['summary'];
          
          _updateKpiDisplayValues(_selectedYearFilter);
          _isLoading = false;
        });
      } else {
        throw Exception("Server connection failed.");
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }
  

  Future<void> _fetchLowStockAndHotSelling() async {
    try {
      // Fetch inventory with predictions
      final inventorySnapshot = await firestore.collection("inventory").get();
      final predictionsSnapshot = await firestore.collection("inventory_predictions").get();
      
      // Create prediction map
      Map<String, double> predictionMap = {};
      for (var doc in predictionsSnapshot.docs) {
        final data = doc.data();
        String product = data["product"] ?? "";
        String category = data["category"] ?? "";
        String key = "$product-$category";
        predictionMap[key] = (data["predicted_units"] ?? 0).toDouble();
      }
      
      // Calculate low stock and hot selling items
      List<Map<String, dynamic>> lowStock = [];
      List<Map<String, dynamic>> hotSelling = [];
      
      for (var doc in inventorySnapshot.docs) {
        final data = doc.data();
        final String product = data["product"] ?? "Unknown";
        final String category = data["category"] ?? "General";
        final int stock = data["stock"] ?? 0;
        final String key = "$product-$category";
        final double predicted = predictionMap[key] ?? 0;
        final double predictedWithGap = predicted * 1.15; // 15% safety gap
        
        // Check low stock (predicted > stock)
        if (predictedWithGap > stock && predicted > 0) {
          lowStock.add({
            "product": product,
            "category": category,
            "stock": stock,
            "predicted": predicted,
            "needed": (predictedWithGap - stock).ceil(),
          });
        }
        
        // Hot selling items (high predicted demand)
        if (predicted > 50) {
          hotSelling.add({
            "product": product,
            "category": category,
            "stock": stock,
            "predicted": predicted,
            "coverage": stock == 0 ? 0 : ((stock / predicted) * 100).clamp(0, 200),
          });
        }
      }
      
      // Sort low stock by highest needed first
      lowStock.sort((a, b) => b["needed"].compareTo(a["needed"]));
      
      // Sort hot selling by highest predicted demand
      hotSelling.sort((a, b) => b["predicted"].compareTo(a["predicted"]));
      
      setState(() {
        lowStockItems = lowStock.take(10).toList();
        hotSellingItems = hotSelling.take(10).toList();
        isLoadingFirestore = false;
      });
      
    } catch (e) {
      print("Error fetching Firestore data: $e");
      setState(() {
        isLoadingFirestore = false;
      });
    }
  }

  void _updateKpiDisplayValues(String filterValue) {
    if (filterValue == "All") {
      kpiSales = globalSummary["total_sales"]?.toStringAsFixed(2) ?? "0.00";
      kpiCost = globalSummary["total_cost"]?.toStringAsFixed(2) ?? "0.00";
      kpiProfit = globalSummary["profit"]?.toStringAsFixed(2) ?? "0.00";
      kpiUnits = globalSummary["total_units"]?.toStringAsFixed(0) ?? "0";
    } else {
      int targetYear = int.parse(filterValue);
      int targetIdx = years.indexOf(targetYear);

      if (targetIdx != -1) {
        kpiSales = sales[targetIdx].toStringAsFixed(2);
        kpiCost = cost[targetIdx].toStringAsFixed(2);
        kpiProfit = (sales[targetIdx] - cost[targetIdx]).toStringAsFixed(2);
        kpiUnits = units[targetIdx].toStringAsFixed(0);
      }
    }
  }

  Color _getSliceColor(int index) {
    List<Color> niceToEyesPalette = [
      const Color(0xFFD9745B), // Terracotta
      const Color(0xFF8A9A86), // Sage Green
      const Color(0xFFE6C594), // Soft Mustard Oat
      const Color(0xFFD4A5A5), // Dusty Blush Rose
      const Color(0xFF93A8AC), // Misty Steel Blue
      const Color(0xFFB58A70), // Soft Clay Almond
      const Color(0xFFB3A3B4), // Dusty Lavender / Mauve
      const Color(0xFFE2B49A), // Creamy Peach Sun
      const Color(0xFFA3B899), // Pale Matcha Green
      const Color(0xFFABC4FF), // Soft Pastel Sky
    ];
    return niceToEyesPalette[index % niceToEyesPalette.length];
  }

  List<PieChartSectionData> _buildPieSections() {
    double totalRevenue = sales.fold(0, (sum, item) => sum + item);
    if (totalRevenue == 0) return [];

    return List.generate(sales.length, (i) {
      double percentage = (sales[i] / totalRevenue) * 100;
      return PieChartSectionData(
        value: sales[i],
        title: "${percentage.toStringAsFixed(1)}%",
        color: _getSliceColor(i),
        radius: 80, 
        titleStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFAF8F5),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFD9745B)))
          : _errorMessage != null
              ? Center(child: Text("Error: $_errorMessage", style: const TextStyle(color: Colors.red)))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // HEADER SECTION
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Overview Analytics",
                                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF2C2523), letterSpacing: -0.5),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "Your business performance summary and annual trends",
                                style: TextStyle(fontSize: 14, color: Color(0xFF7D7471)),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFEFECE6)),
                                  boxShadow: [
                                    BoxShadow(color: const Color(0xFF2C2523).withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 4)),
                                  ],
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedYearFilter,
                                    icon: const Icon(Icons.expand_more_rounded, color: Color(0xFF7D7471), size: 20),
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2C2523)),
                                    dropdownColor: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        setState(() {
                                          _selectedYearFilter = newValue;
                                          _updateKpiDisplayValues(newValue);
                                        });
                                      }
                                    },
                                    items: [
                                      const DropdownMenuItem(value: "All", child: Text("All Years Combined   ")),
                                      ...years.map((y) => DropdownMenuItem(value: y.toString(), child: Text("Year $y   "))),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              IconButton(
                                icon: const Icon(Icons.refresh_rounded, color: Color(0xFF7D7471)),
                                onPressed: () {
                                  setState(() => _isLoading = true);
                                  _fetchDashboardData();
                                  _fetchLowStockAndHotSelling();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // KPI METRIC ROW
                      Row(
                        children: [
                          buildCard("Total Sales", kpiSales, const Color(0xFFD9745B), Icons.star_border_rounded),
                          buildCard("Total Expenses", kpiCost, const Color(0xFF8A9A86), Icons.local_mall_outlined),
                          buildCard("Net Profit", kpiProfit, const Color(0xFFB58A70), Icons.favorite_border_rounded),
                          buildCard("Items Sold", kpiUnits, const Color(0xFF93A8AC), Icons.grid_view_rounded),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // CHARTS SECTION
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Box: Line chart
                          Expanded(
                            flex: 2,
                            child: containerCard(
                              "Sales Over Time",
                              LineChart(
                                LineChartData(
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: false,
                                    getDrawingHorizontalLine: (val) => FlLine(color: const Color(0xFFF7F4F0), strokeWidth: 1.5),
                                  ),
                                  borderData: FlBorderData(show: false),
                                  titlesData: FlTitlesData(
                                    show: true,
                                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          int index = value.toInt();
                                          if (index >= 0 && index < years.length) {
                                            return Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Text(years[index].toString(), style: const TextStyle(fontSize: 12, color: Color(0xFF9C938E), fontWeight: FontWeight.w600)),
                                            );
                                          }
                                          return const Text('');
                                        },
                                      ),
                                    ),
                                  ),
                                  lineBarsData: [
                                    LineChartBarData(
                                      isCurved: true,
                                      curveSmoothness: 0.3,
                                      color: const Color(0xFFD9745B), 
                                      barWidth: 5,
                                      isStrokeCapRound: true,
                                      dotData: FlDotData(
                                        show: true,
                                        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                                          radius: 6,
                                          color: Colors.white,
                                          strokeWidth: 3,
                                          strokeColor: const Color(0xFFD9745B),
                                        ),
                                      ),
                                      belowBarData: BarAreaData(
                                        show: true,
                                        color: const Color(0xFFD9745B).withOpacity(0.06), 
                                      ),
                                      spots: List.generate(sales.length, (i) => FlSpot(i.toDouble(), sales[i])),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),

                          // Right Box: Pie chart
                          Expanded(
                            child: containerCard(
                              "Sales Percentage Share",
                              Column(
                                children: [
                                  Expanded(
                                    child: PieChart(
                                      PieChartData(
                                        centerSpaceRadius: 45, 
                                        sectionsSpace: 4,
                                        sections: _buildPieSections(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Wrap(
                                    spacing: 14,
                                    runSpacing: 10,
                                    children: List.generate(years.length, (idx) {
                                      return Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 12,
                                            height: 12,
                                            decoration: BoxDecoration(color: _getSliceColor(idx), shape: BoxShape.circle),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            years[idx].toString(),
                                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF4A4240)),
                                          ),
                                        ],
                                      );
                                    }),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // LOW STOCK & HOT SELLING ITEMS SECTION
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Low Stock Items Card
                          Expanded(
                            child: containerCard(
                              "⚠️ Low Stock Items",
                              isLoadingFirestore
                                  ? const Center(child: CircularProgressIndicator())
                                  : lowStockItems.isEmpty
                                      ? const Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.check_circle_rounded, size: 48, color: Colors.green),
                                              SizedBox(height: 12),
                                              Text("No low stock items!", style: TextStyle(color: Color(0xFF7D7471))),
                                            ],
                                          ),
                                        )
                                      : ListView.separated(
                                          shrinkWrap: true,
                                          physics: const BouncingScrollPhysics(),
                                          itemCount: lowStockItems.length,
                                          separatorBuilder: (context, index) => const Divider(color: Color(0xFFEFECE6)),
                                          itemBuilder: (context, index) {
                                            final item = lowStockItems[index];
                                            return Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 8),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 36,
                                                    height: 36,
                                                    decoration: BoxDecoration(
                                                      color: Colors.red.shade50,
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: Icon(Icons.warning_rounded, color: Colors.red.shade400, size: 18),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          item["product"],
                                                          style: const TextStyle(
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 14,
                                                            color: Color(0xFF2C2523),
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                        Text(
                                                          item["category"],
                                                          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        "${item["stock"]} / ${item["predicted"].toInt()}",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.red.shade400,
                                                        ),
                                                      ),
                                                      Text(
                                                        "Need ${item["needed"]}",
                                                        style: TextStyle(fontSize: 10, color: Colors.red.shade300),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                            ),
                          ),
                          const SizedBox(width: 24),

                          // Hot Selling Items Card
                          Expanded(
                            child: containerCard(
                              "🔥 Hot Selling Items",
                              isLoadingFirestore
                                  ? const Center(child: CircularProgressIndicator())
                                  : hotSellingItems.isEmpty
                                      ? const Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.local_fire_department, size: 48, color: Colors.orange),
                                              SizedBox(height: 12),
                                              Text("No hot selling items yet!", style: TextStyle(color: Color(0xFF7D7471))),
                                            ],
                                          ),
                                        )
                                      : ListView.separated(
                                          shrinkWrap: true,
                                          physics: const BouncingScrollPhysics(),
                                          itemCount: hotSellingItems.length,
                                          separatorBuilder: (context, index) => const Divider(color: Color(0xFFEFECE6)),
                                          itemBuilder: (context, index) {
                                            final item = hotSellingItems[index];
                                            final coverageColor = item["coverage"] >= 100 ? Colors.green : Colors.orange;
                                            return Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 8),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 36,
                                                    height: 36,
                                                    decoration: BoxDecoration(
                                                      color: Colors.orange.shade50,
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: Icon(Icons.local_fire_department, color: Colors.orange.shade600, size: 18),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          item["product"],
                                                          style: const TextStyle(
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 14,
                                                            color: Color(0xFF2C2523),
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                        Text(
                                                          item["category"],
                                                          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        "${item["predicted"].toInt()} units",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.orange.shade600,
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                        decoration: BoxDecoration(
                                                          color: coverageColor.withOpacity(0.1),
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: Text(
                                                          "${item["coverage"].toInt()}% covered",
                                                          style: TextStyle(
                                                            fontSize: 9,
                                                            fontWeight: FontWeight.w600,
                                                            color: coverageColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }

  // ================= COMPONENT BLOCKS =================

  Widget buildCard(String title, String value, Color warmColor, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(24), 
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20), 
          border: Border.all(color: const Color(0xFFEFECE6)),
          boxShadow: [
            BoxShadow(color: const Color(0xFF2C2523).withOpacity(0.02), blurRadius: 12, offset: const Offset(0, 6)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: warmColor.withOpacity(0.08),
                shape: BoxShape.circle, 
              ),
              child: Icon(icon, color: warmColor, size: 24),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Color(0xFF9C938E), fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.2),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF2C2523), letterSpacing: -0.4),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget containerCard(String panelTitle, Widget contentWidget) {
    return Container(
      height: 440, 
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEFECE6)),
        boxShadow: [
          BoxShadow(color: const Color(0xFF2C2523).withOpacity(0.02), blurRadius: 16, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            panelTitle,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF2C2523), letterSpacing: -0.2),
          ),
          const SizedBox(height: 20),
          Expanded(child: contentWidget),
        ],
      ),
    );
  }
}