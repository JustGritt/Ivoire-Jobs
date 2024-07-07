import 'package:flutter/material.dart';
import 'package:barassage_app/features/auth_mod/screens/register_email_validation_import.dart' as cond;

class EmailValidationController extends StatelessWidget {
  const EmailValidationController({super.key});

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Email Validation Section',
      color: Colors.blue,
      child: const cond.RegisterEmailValidationController(), // This will use the appropriate version based on the platform
    );
  }
}
