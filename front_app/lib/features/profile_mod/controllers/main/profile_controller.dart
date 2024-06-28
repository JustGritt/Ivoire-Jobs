import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../screens/screen.dart' as mobile;

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
