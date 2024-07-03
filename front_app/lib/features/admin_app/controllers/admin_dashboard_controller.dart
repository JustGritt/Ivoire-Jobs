import 'package:flutter/material.dart';

import '../screens/desktop/admin_dashboard_screen.dart';

class AdminDashboardController extends StatelessWidget {

  const AdminDashboardController({super.key});

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Admin Dashboard',
      color: Colors.blue,
      child: const AdminDashboardScreen(),
    );
  }
}