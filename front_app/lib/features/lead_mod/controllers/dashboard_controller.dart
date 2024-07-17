import 'package:barassage_app/core/classes/controller_manager.dart';
import 'package:barassage_app/core/classes/display_manager.dart';
import 'package:barassage_app/features/lead_mod/lead_mod.dart';
import 'package:barassage_app/config/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class DashboardController extends StatelessController {
  const DashboardController({super.key});

  @override
  bool get auth => true;

  @override
  Display view(BuildContext context) {
    var ep = context.read<EnqueryProvider>();
    ep.setEnquery();

    // Navigation Bug Fixes
    var tm = context.read<ThemeProvider>();
    tm.setNavIndex(0);

    return Display(title: 'Dashboard', mobile: const DashboardForMobile());
  }
}
