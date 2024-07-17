import 'package:barassage_app/config/config.dart';
import 'package:barassage_app/core/core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:barassage_app/features/main_app/Screens/mobile/home.dart'
    as mobile;
import 'package:barassage_app/features/main_app/Screens/tablet/home.dart'
    as tablet;
import 'package:barassage_app/features/main_app/Screens/desktop/home.dart'
    as desktop;

class HomeController extends StatelessController {
  final String _title = 'Home Page';
  const HomeController({super.key});

  @override
  bool get auth => true;

  @override
  Display view(BuildContext context) {
    // Navigation Bug Fixes
    var tm = context.read<ThemeProvider>();
    tm.setNavIndex(0);

    return Display(
      title: _title,
      mobile: mobile.Home(title: _title),
      tabletLandscape: tablet.Home(title: _title),
      desktop: desktop.Home(title: _title),
    );
  }
}
