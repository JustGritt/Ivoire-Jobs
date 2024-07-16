import 'package:barassage_app/core/core.dart';
import 'package:flutter/material.dart';
import 'package:barassage_app/features/profile_mod/screens/screen.dart'
    as mobile;

class ProfileController extends StatelessController {
  const ProfileController({super.key});

  @override
  bool get auth => true;

  @override
  Display view(BuildContext context) {
    return Display(
      title: 'Profile Area',
      mobile: const mobile.ProfilePageScreen(),
      tabletLandscape: const mobile.ProfilePageScreen(),
      desktop: const mobile.ProfilePageScreen(),
    );
  }
}
