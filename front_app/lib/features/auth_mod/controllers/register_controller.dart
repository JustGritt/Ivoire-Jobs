import 'package:barassage_app/features/auth_mod/screens/mobile/register_mobile_screen.dart';
import 'package:flutter/material.dart';

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
