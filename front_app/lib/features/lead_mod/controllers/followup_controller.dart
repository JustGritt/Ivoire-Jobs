import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../views/mobile/followup.dart';

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
