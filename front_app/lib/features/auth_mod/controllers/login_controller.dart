import 'package:barassage_app/features/auth_mod/screens/mobile/login_mobile_screen.dart';
import 'package:flutter/material.dart';

class LoginController extends StatelessWidget {
  const LoginController({super.key});

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Login Section',
      color: Colors.blue,
      child: const LoginMobileScreen(),
    );
  }
}
