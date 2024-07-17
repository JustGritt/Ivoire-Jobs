import 'package:barassage_app/features/auth_mod/screens/mobile/forget_mobile_screen.dart';
import 'package:flutter/material.dart';

class ForgetController extends StatelessWidget {
  const ForgetController({super.key});

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Forget Section',
      color: Colors.blue,
      child: const ForgetMobileScreen(),
    );
  }
}
