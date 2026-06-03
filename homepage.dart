import 'package:flutter/material.dart';
import 'package:flutter_application_1/dashboard.dart/addproducts.dart';
import 'package:flutter_application_1/dashboard.dart/dash.dart';
import 'package:flutter_application_1/dashboard.dart/list.dart';
import 'package:flutter_application_1/dashboard.dart/logoutpage.dart';
import 'package:flutter_application_1/dashboard.dart/prediction.dart';

import 'package:flutter_application_1/profile.dart';

import 'package:flutter_application_1/responsivelayout.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int selectedPage = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Menu items configuration
  final List<MenuItem> menuItems = [
    MenuItem(Icons.dashboard, "Dashboard", 0),
    MenuItem(Icons.auto_graph, "Predictions", 1),
    MenuItem(Icons.shopping_cart, "Add Products", 2),
    MenuItem(Icons.bar_chart, "Inventory List", 3),
    MenuItem(Icons.person, "Profile", 4),
    MenuItem(Icons.logout, "Logout", 5),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final isTablet = ResponsiveLayout.isTablet(context);
    final isDesktop = ResponsiveLayout.isDesktop(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: isMobile
          ? AppBar(
              elevation: 0,
              backgroundColor: const Color(0xFF2B6CB0),
              foregroundColor: Colors.white,
              title: const Text(
                "Retail Manager",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
              actions: [
                // Optional: Add action buttons for mobile
                IconButton(
                  icon: const Icon(Icons.notifications_none),
                  onPressed: () {},
                ),
              ],
            )
          : null,
      drawer: isMobile
          ? Drawer(
              child: Container(
                color: const Color(0xFF2B6CB0),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E3A5F),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.store,
                              color: Colors.white,
                              size: 48,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Retail Manager",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Version 1.0",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...menuItems.map((item) => _buildDrawerItem(item)),
                  ],
                ),
              ),
            )
          : null,
      body: Row(
        children: [
          // Sidebar - Only show on tablet and desktop
          if (!isMobile)
            Container(
              width: isTablet ? 220 : 260,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomLeft,
                  colors: [
                    const Color(0xFF1E3A5F),
                    const Color(0xFF2C5282),
                    const Color(0xFF2B6CB0),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(2, 0),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  
                  // App Logo/Title
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.store,
                      color: Colors.white,
                      size: isTablet ? 40 : 48,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Text(
                    "Retail Manager",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isTablet ? 18 : 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Container(
                    height: 1,
                    width: 50,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Menu Items
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: menuItems.map((item) => _buildSidebarItem(item)).toList(),
                    ),
                  ),
                  
                  // Footer
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Container(
                          height: 1,
                          color: Colors.white.withOpacity(0.2),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "© 2024 Retail Manager",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          
          // Main Content Area
          Expanded(
            child: Container(
              color: const Color(0xFFF7FAFC),
              child: getPage(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: isMobile
          ? BottomNavigationBar(
              currentIndex: selectedPage,
              onTap: (index) {
                setState(() {
                  selectedPage = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: const Color(0xFF2B6CB0),
              unselectedItemColor: Colors.grey,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.auto_graph),
                  label: 'Predictions',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart),
                  label: 'Add',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart),
                  label: 'List',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.logout),
                  label: 'Logout',
                ),
              ],
            )
          : null,
    );
  }

  // Sidebar item for tablet/desktop
  Widget _buildSidebarItem(MenuItem item) {
    final isSelected = selectedPage == item.index;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
      ),
      child: ListTile(
        leading: Icon(
          item.icon,
          color: Colors.white,
          size: 22,
        ),
        title: Text(
          item.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        selected: isSelected,
        onTap: () {
          setState(() {
            selectedPage = item.index;
          });
        },
      ),
    );
  }

  // Drawer item for mobile
  Widget _buildDrawerItem(MenuItem item) {
    final isSelected = selectedPage == item.index;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
      ),
      child: ListTile(
        leading: Icon(
          item.icon,
          color: Colors.white,
          size: 24,
        ),
        title: Text(
          item.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        selected: isSelected,
        onTap: () {
          setState(() {
            selectedPage = item.index;
            Navigator.pop(context); // Close drawer
          });
        },
      ),
    );
  }

  // Page Switcher
  Widget getPage() {
    switch (selectedPage) {
      case 0:
        return const DashboardPage();
      case 1:
        return const PredictionPage();
      case 2:
        return const AddInventoryPage();
      case 3:
        return const InventoryPage();
      case 4:
        return const ProfilePage();
      case 5:
        return const LogoutPage();
      default:
        return const DashboardPage();
    }
  }
}

// Menu Item Model
class MenuItem {
  final IconData icon;
  final String title;
  final int index;

  MenuItem(this.icon, this.title, this.index);
}
