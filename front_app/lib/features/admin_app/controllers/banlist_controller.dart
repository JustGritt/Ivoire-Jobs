import 'package:barassage_app/features/admin_app/screens/desktop/banlist_screen.dart';
import 'package:barassage_app/features/admin_app/widgets/admin_menu.dart';
import 'package:flutter/material.dart';

class BanListController extends StatelessWidget {
  const BanListController({super.key});

  @override
  Widget build(BuildContext context) {
    return Title(
      color: Colors.blue,
      child: AdminScaffold(
        title: 'Ban List',
        body: const BanListScreen(),
      ),
    );
  }
}
