import 'package:flutter/material.dart';

import '../screens/mobile/login_mobile_screen.dart';

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
