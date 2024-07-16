import 'package:barassage_app/features/admin_app/screens/desktop/manage_services_screen.dart';
import 'package:barassage_app/features/admin_app/widgets/admin_menu.dart';
import 'package:flutter/material.dart';

class ServicesController extends StatelessWidget {
  const ServicesController({super.key});

  @override
  Widget build(BuildContext context) {
    return Title(
      color: Colors.blue,
      child: AdminScaffold(
        title: 'Services',
        body: const ManageServicesScreen(),
      ),
    );
  }
}
