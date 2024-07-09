import 'package:flutter/material.dart';

import '../screens/desktop/settings_screen.dart';
import 'package:barassage_app/features/admin_app/widgets/admin_menu.dart'; // Import the common AdminScaffold widget


class AdminSettingsController extends StatelessWidget {
  const AdminSettingsController({super.key});

  @override
  Widget build(BuildContext context) {
    return Title(
      color: Colors.blue,
      child: AdminScaffold(
        title: 'Admin Settings',
        body: const DashboardSettings(),
      ),
    );
  }
}
