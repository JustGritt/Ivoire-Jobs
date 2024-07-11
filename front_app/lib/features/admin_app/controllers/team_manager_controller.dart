import 'package:barassage_app/features/admin_app/screens/desktop/manage_users_screen.dart';
import 'package:barassage_app/features/admin_app/screens/desktop/team_manager_screen.dart';
import 'package:flutter/material.dart';
import 'package:barassage_app/features/admin_app/widgets/admin_menu.dart'; // Import the common AdminScaffold widget

class TeamManagerController extends StatelessWidget {
  const TeamManagerController({super.key});

  @override
  Widget build(BuildContext context) {
    return Title(
      color: Colors.blue,
      child: AdminScaffold(
        title: 'Manage Teams',
        body: const TeamManagerScreen(),
      ),
    );
  }
}
