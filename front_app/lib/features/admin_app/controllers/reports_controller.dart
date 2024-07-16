import 'package:barassage_app/features/admin_app/screens/desktop/reports_screen.dart';
import 'package:barassage_app/features/admin_app/widgets/admin_menu.dart';
import 'package:flutter/material.dart';

class ReportsController extends StatelessWidget {
  const ReportsController({super.key});

  @override
  Widget build(BuildContext context) {
    return Title(
      color: Colors.blue,
      child: AdminScaffold(
        title: 'Reports',
        body: const ReportScreen(),
      ),
    );
  }
}
