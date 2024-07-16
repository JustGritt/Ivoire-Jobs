import 'package:barassage_app/features/admin_app/screens/desktop/manage_categories_screen.dart';
import 'package:flutter/material.dart';
import 'package:barassage_app/features/admin_app/widgets/admin_menu.dart';


class CategoriesController extends StatelessWidget {
  const CategoriesController({super.key});

  @override
  Widget build(BuildContext context) {
    return Title(
      color: Colors.blue,
      child: AdminScaffold(
        title: 'Categories',
        body: const ManageCategoriesScreen(),
      ),
    );
  }
}
