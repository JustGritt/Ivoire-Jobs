import 'package:barassage_app/features/admin_app/screens/desktop/team_manager_screen.dart';
import 'package:barassage_app/features/admin_app/widgets/admin_menu.dart';
import 'package:flutter/material.dart';

class TeamManagerController extends StatelessWidget {
  const TeamManagerController({super.key});

  @override
  Widget build(BuildContext context) {
    return Title(
      color: Colors.blue,
      child: AdminScaffold(
        title: 'Admins',
        body: const TeamManagerScreen(),
      ),
    );
  }
}
