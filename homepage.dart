import 'package:flutter/material.dart';
import 'package:flutter_application_1/dashboard.dart/addproducts.dart';
import 'package:flutter_application_1/dashboard.dart/dash.dart';
import 'package:flutter_application_1/dashboard.dart/list.dart';
import 'package:flutter_application_1/dashboard.dart/prediction.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [

          // 📌 SIDEBAR
          Container(
            width: 220,
            color: const Color.fromARGB(255, 101, 153, 178),
            child: Column(
              children: [

                const SizedBox(height: 40),

                const Text(
                  "Retail Menu",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                // 📌 MENU ITEMS
                sidebarItem(Icons.dashboard, "Dashboard", 0),
                sidebarItem(Icons.shopping_cart, "Orders", 1),
                sidebarItem(Icons.bar_chart, "Reports", 2),
                sidebarItem(Icons.auto_graph, "Predictions", 3),
              ],
            ),
          ),

          // 📊 PAGE AREA
          Expanded(
            child: getPage(),
          ),
        ],
      ),
    );
  }

  // 🔄 PAGE SWITCHER
  Widget getPage() {

    // DASHBOARD PAGE
    if (selectedPage == 0) {
      return const DashboardPage();
    }

    // ORDERS PAGE
    else if (selectedPage == 1) {
return const AddInventoryPage();
    }

    // REPORTS PAGE
    else if (selectedPage == 2) {
      return const InventoryPage();
    }

    // PREDICTION PAGE
    else if (selectedPage == 3) {
      return const PredictionPage();
    }

    return const DashboardPage();
  }

  // 📌 SIDEBAR ITEM
  Widget sidebarItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),

      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),

      selected: selectedPage == index,

      selectedTileColor: const Color.fromARGB(255, 156, 202, 241),

      onTap: () {
        setState(() {
          selectedPage = index;
        });
      },
    );
  }
}