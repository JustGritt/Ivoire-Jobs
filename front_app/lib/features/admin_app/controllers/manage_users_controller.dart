import 'package:barassage_app/features/admin_app/screens/desktop/manage_users_screen.dart';
import 'package:flutter/material.dart';

class UsersController extends StatelessWidget {
  const UsersController({super.key});

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Manage Users',
      color: Colors.blue,
      child: const ManageUsersScreen(),
    );
  }
}
