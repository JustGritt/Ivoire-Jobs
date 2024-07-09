import 'package:flutter/material.dart';

import '../screens/desktop/settings_screen.dart';

class AdminSettingsController extends StatelessWidget {
  const AdminSettingsController({super.key});

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Admin Settings',
      color: Colors.blue,
      child: const DashboardSettings(),
    );
  }
}
