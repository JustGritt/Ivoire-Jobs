import 'package:barassage_app/features/admin_app/screens/desktop/admin_dashboard_screen.dart';
import 'package:flutter/material.dart';

class AdminDashboardController extends StatelessWidget {
  const AdminDashboardController({super.key});

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Dashboard',
      color: Colors.blue,
      child: AdminDashboardScreen(),
    );
  }
}
