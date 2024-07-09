import 'package:barassage_app/features/admin_app/screens/desktop/manage_users_screen.dart';
import 'package:flutter/material.dart';
import 'package:barassage_app/features/admin_app/widgets/admin_menu.dart'; // Import the common AdminScaffold widget

class UsersController extends StatelessWidget {
  const UsersController({super.key});

  @override
  Widget build(BuildContext context) {
    return Title(
      color: Colors.blue,
      child: AdminScaffold(
        title: 'Manage Users',
        body: const ManageUsersScreen(),
      ),
    );
  }
}
