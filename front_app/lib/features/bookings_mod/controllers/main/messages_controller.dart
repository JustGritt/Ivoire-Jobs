import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../screens/screen.dart' as mobile;

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
