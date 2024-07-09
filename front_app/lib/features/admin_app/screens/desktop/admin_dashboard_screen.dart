import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens.dart';
import '../../widgets/admin_menu.dart'; // Import the common AdminScaffold widget

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = -1; // Default to a placeholder screen

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

    // Defer the navigation to avoid modifying the widget tree during the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go(_routes[index]); // Use context.go instead of push to replace the current route

      if (Scaffold.of(context).isDrawerOpen) {
        Navigator.pop(context); // Close the drawer if it's open
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'Admin Dashboard',
      body: _buildBody(),
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
