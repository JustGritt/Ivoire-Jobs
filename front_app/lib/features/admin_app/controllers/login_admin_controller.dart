import 'package:barassage_app/features/admin_app/screens/desktop/login_desktop_screen.dart';
import 'package:flutter/material.dart';

class LoginDesktopController extends StatelessWidget {
  const LoginDesktopController({super.key});

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Admin Login',
      color: Colors.blue,
      child: const LoginDesktopScreen(),
    );
  }
}
