import 'package:barassage_app/features/admin_app/screens/home/register_email_validation.dart';
import 'package:flutter/material.dart';

class EmailValidationController extends StatelessWidget {
  const EmailValidationController({super.key});

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Email Validation Section',
      color: Colors.blue,
      child: const RegisterEmailValidation(),
    );
  }
}