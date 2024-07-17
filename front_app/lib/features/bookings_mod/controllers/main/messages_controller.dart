import 'package:barassage_app/core/core.dart';
import 'package:flutter/material.dart';
import 'package:barassage_app/features/bookings_mod/screens/screen.dart'
    as mobile;

class MessagesController extends StatelessController {
  const MessagesController({super.key});

  @override
  Display view(BuildContext context) {
    return Display(
      title: 'Messages Area',
      mobile: const mobile.ConversationsPageScreen(),
    );
  }
}
