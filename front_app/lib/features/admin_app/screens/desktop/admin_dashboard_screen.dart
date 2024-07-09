import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  final List<String> _routes = [
    '/admin/users',
    '/admin/services',
    '/admin/reports',
    '/admin/ban-list',
    '/admin/settings',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    context.push(_routes[index]); // Navigate to the selected route and update the URL
    Navigator.pop(context); // Close the drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Text(
                'Admin Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            _buildDrawerItem(
              icon: Icons.people,
              text: 'Manage Users',
              index: 0,
            ),
            _buildDrawerItem(
              icon: Icons.build,
              text: 'Manage Services',
              index: 1,
            ),
            _buildDrawerItem(
              icon: Icons.warning,
              text: 'Reports',
              index: 2,
            ),
            _buildDrawerItem(
              icon: Icons.block,
              text: 'Ban List',
              index: 3,
            ),
            _buildDrawerItem(
              icon: Icons.settings,
              text: 'Settings',
              index: 4,
            ),
          ],
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildDrawerItem({required IconData icon, required String text, required int index}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: () => _onItemTapped(index),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const ManageUsersScreen();
      case 1:
        return const ManageServicesScreen();
      case 2:
        return const Placeholder(); // Replace with ReportsScreen
      case 3:
        return const BanListScreen();
      case 4:
        return const DashboardSettings();
      default:
        return const Placeholder();
    }
  }
}
