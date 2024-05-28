import 'package:flutter/material.dart';

import '../screens/mobile/register_mobile_screen.dart';

class RegisterController extends StatelessWidget {
  const RegisterController({super.key});

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Login Section',
      color: Colors.blue,
      child: const RegisterMobileScreen(),
    );
  }
}
