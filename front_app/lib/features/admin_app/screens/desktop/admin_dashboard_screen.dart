import 'package:barassage_app/features/admin_app/widgets/admin_menu.dart';
import 'package:barassage_app/features/admin_app/screens/screens.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = -1;

  final List<String> _routes = [
    '/admin/users',
    '/admin/services',
    '/admin/reports',
    '/admin/banlist',
    '/admin/settings',
    '/admin/members'
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });


    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go(_routes[index]);

      if (Scaffold.of(context).isDrawerOpen) {
        Navigator.pop(context);
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
        return const Placeholder();
      case 3:
        return const BanListScreen();
      case 4:
        return const DashboardSettings();
      default:
        return const Placeholder();
    }
  }
}
