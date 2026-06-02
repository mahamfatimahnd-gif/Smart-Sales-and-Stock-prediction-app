
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
