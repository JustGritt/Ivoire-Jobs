import 'package:barassage_app/features/lead_mod/views/mobile/followup.dart';
import 'package:barassage_app/core/core.dart';
import 'package:flutter/material.dart';

class FollowupController extends StatelessController {
  const FollowupController({super.key});

  @override
  Display view(BuildContext context) {
    return Display(
      title: 'Followup Section',
      mobile: const FollowupForMobile(),
    );
  }
}
