import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'dart:html' as html;

import '../../../../core/helpers/auth_helper.dart';
import '../../services/user_service.dart';

class RegisterEmailValidation extends StatefulWidget {
  const RegisterEmailValidation({super.key});

  @override
  State<RegisterEmailValidation> createState() =>
      _RegisterEmailValidationState();
}

class _RegisterEmailValidationState extends State<RegisterEmailValidation> {
  bool isEmailValidated = false;
  bool isLoading = true;
  var token =
      // Uri.dataFromString(html.window.location.href).queryParameters['token'] ??
          '';

  @override
  void initState() {
    super.initState();
    checkRegisterToken(context, token);
  }

  void checkRegisterToken(BuildContext context, String token) async {
    UserService us = UserService();
    try {
      var value = await us.verifyEmailToken(token);
      setState(() {
        isEmailValidated = value;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isEmailValidated = false;
        isLoading = false;
      });
    }
    debugPrint('isEmailValidated: $isEmailValidated');
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10.0),
        child: isLoading
            ? const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text(
              'Verifying...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            )
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              isEmailValidated
                  ? appLocalizations.email_validation_success_title
                  : appLocalizations.email_validation_failure_title,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              isEmailValidated
                  ? appLocalizations.email_validation_success_description
                  : appLocalizations.email_validation_failure_description,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}