import 'package:barassage_app/features/admin_app/screens/desktop/logs_screen.dart';
import 'package:barassage_app/features/admin_app/widgets/admin_menu.dart';
import 'package:flutter/material.dart';

class LogsController extends StatelessWidget {
  const LogsController({super.key});

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Logs Section',
      color: Colors.blue,
      child: AdminScaffold(
        title: 'Logs',
        body: const LogsScreen(),
      ),
    );
  }
}