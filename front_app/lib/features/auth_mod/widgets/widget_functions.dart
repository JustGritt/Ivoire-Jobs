import 'package:barassage_app/features/auth_mod/auth_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../core/core.dart';
import 'auth_button.dart';

TextFormField passwordField({
  String? Function(String?)? onValid,
  bool passHide = true,
  void Function(bool)? onKeyBtnPressed,
}) {
  return TextFormField(
    keyboardType: TextInputType.visiblePassword,
    style: const TextStyle(fontFamily: 'Okta'),
    obscureText: passHide,
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
      hintText: 'Password',
      suffixIcon: IconButton(
        onPressed: () {
          passHide = !passHide;
          onKeyBtnPressed!(passHide);
        },
        icon: Icon(
          passHide ? Icons.visibility : Icons.visibility_off_outlined,
        ),
      ),
      border: const OutlineInputBorder(
          borderSide: BorderSide(
              color: Color.fromARGB(255, 233, 233, 233),
              style: BorderStyle.none),
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          )),
    ),
    validator: (val) {
      if (val == null || val.isEmpty) {
        return 'Please Input password';
      }
      onValid!(val);
      return null;
    },
  );
}

// ignore: non_constant_identifier_names
TextFormField Field({
  required String nameField,
  String? Function(String?)? onValid,
}) {
  return TextFormField(
    keyboardType: TextInputType.emailAddress,
    style: const TextStyle(fontFamily: 'Okta'),
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
      hintText: nameField,
      border: const OutlineInputBorder(
          borderSide: BorderSide(
              color: Color.fromARGB(255, 233, 233, 233),
              style: BorderStyle.none),
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          )),
    ),
    validator: (val) {
      if (val == null || val.isEmpty) {
        return 'Please Input $nameField';
      }
      onValid!(val);
      return null;
    },
  );
}

// CATextInputField(
//     prefixIcon: Icons.account_circle_outlined,
//     labelTextStr: 'Input Username',
//     validator: (val) {
//       if (val == null || val.isEmpty) {
//         return 'Please Input username';
//       }
//       onValid!(val);
//       return null;
//     },
//   );
Column loginRegisterButtons(
  BuildContext context, {
  GlobalKey<FormState>? key,
  bool Function()? onLogin,
  bool Function()? onRegister,
}) {
  return Column(
    children: [
      AuthButton(
        onPressed: () {
          if (key!.currentState!.validate()) {
            debugPrint('Login Validate');
            bool isLogin = onLogin!();
            if (isLogin && isLogin == true) {
              Nav.to(context, '/');
            }
          }
        },
        label: 'Login Now',
        stretch: true,
      ),
      AuthButton(
        onPressed: () {
          debugPrint('Register now');
          bool isRegister = onRegister!();
          if (isRegister && isRegister == true) {
            Nav.to(context, AuthApp.register);
          }
        },
        label: 'Register Now',
        stretch: true,
      ),
    ],
  );
}

CALinkButton forgetButton(
  BuildContext context, {
  bool Function()? onForget,
}) {
  AppLocalizations appLocalizations = AppLocalizations.of(context)!;
  return CALinkButton(
      onPressed: () {
        debugPrint('Forget Password Click');
        var check = onForget!();
        if (check && check == true) {
          Nav.toNamed(context, '/forget');
        }
      },
      labelStr: appLocalizations.btn_forgot_password);
}
