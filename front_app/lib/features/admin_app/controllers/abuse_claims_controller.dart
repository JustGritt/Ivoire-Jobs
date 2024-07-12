import 'package:barassage_app/features/admin_app/screens/desktop/reports_screen.dart';
import 'package:flutter/material.dart';

class AbuseClaimsController extends StatelessWidget {
  const AbuseClaimsController({super.key});

  @override
  Widget build(BuildContext context) {
    return Title(
      color: Colors.blue,
      child: const ReportScreen(),
    );
  }
}
