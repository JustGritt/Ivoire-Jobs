import 'package:barassage_app/features/admin_app/screens/desktop/manage_services_screen.dart';
import 'package:barassage_app/features/admin_app/widgets/admin_menu.dart';
import 'package:flutter/material.dart';

import '../screens/desktop/manage_members_screen.dart';

class MembersController extends StatelessWidget {
  const MembersController({super.key});

  @override
  Widget build(BuildContext context) {
    return Title(
      color: Colors.blue,
      child: AdminScaffold(
        title: 'Manage Services',
        body: const ManageMembersScreen(),
      ),
    );
  }
}
