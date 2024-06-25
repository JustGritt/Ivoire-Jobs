import 'package:barassage_app/core/widgets/bottom_bar_gorouter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainWrapper extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const MainWrapper({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomBarGoRouter(navigationShell: navigationShell),
      body: navigationShell,
    );
  }
}
