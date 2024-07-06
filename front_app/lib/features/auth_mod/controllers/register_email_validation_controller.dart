import 'package:flutter/material.dart';

import '../screens/desktop/register_email_validation.dart';

class EmailValidationController extends StatelessWidget {
  const EmailValidationController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Email Validation Section',
      color: Colors.blue,
      child: const RegisterEmailValidation(),
    );
  }
}
