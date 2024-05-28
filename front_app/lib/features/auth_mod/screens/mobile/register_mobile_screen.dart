import 'package:barassage_app/core/blocs/authentication/authentication_bloc.dart';
import 'package:barassage_app/features/auth_mod/models/user_signup.dart';
import 'package:flutter/material.dart';

import 'dart:developer';
import 'dart:ui';

import 'package:barassage_app/features/auth_mod/widgets/app_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/user.dart';
import '../../widgets/widget_functions.dart';

class RegisterMobileScreen extends StatefulWidget {
  const RegisterMobileScreen({
    Key? key,
    void Function(String username, String password)? onLogged,
  }) : super(key: key);

  @override
  State<RegisterMobileScreen> createState() => _RegisterMobileScreenState();
}

class _RegisterMobileScreenState extends State<RegisterMobileScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  bool _isPasswordHide = true;
  String? email, password, firstname, lastname;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
        backgroundColor: theme.cardColor,
        body: SafeArea(
          child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {},
            builder: (context, state) {
              return SingleChildScrollView(
                child: Form(
                  key: _globalKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 14.0),
                    child: Column(children: [
                      Stack(children: [
                        Container(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: SvgPicture.asset(
                            fit: BoxFit.fill,
                            'assets/images/ill_register.svg',
                            width: 180,
                            semanticsLabel: 'Acme Logo',
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: ClipRect(
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                              child: Container(
                                // the size where the blurring starts
                                height: 40,
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: ClipRect(
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                              child: Container(
                                // the size where the blurring starts
                                height: 50,
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ]),
                      Container(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Column(
                          children: [
                            Text(
                              appLocalizations.welcome_back,
                              style: theme.textTheme.displayLarge,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              appLocalizations.welcome_register,
                              style: theme.textTheme.displayMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      // Username Fields
                      Field(
                        nameField: appLocalizations.lastname,
                        onValid: (user) => lastname = user,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Field(
                        nameField: appLocalizations.firstname,
                        onValid: (user) => firstname = user,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Field(
                        nameField: appLocalizations.email,
                        onValid: (user) => email = user,
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      // Password Fields
                      passwordField(
                        onValid: (pass) => password = pass,
                        passHide: _isPasswordHide,
                        onKeyBtnPressed: (val) {
                          setState(() {
                            _isPasswordHide = val;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      // Buttons Fields

                      const SizedBox(
                        height: 15,
                      ),
                      AppButton(
                        onPressed: () {
                          if (_globalKey.currentState!.validate()) {
                            context.read<AuthenticationBloc>().add(
                                  SignUpUser(UserSignup(
                                      firstName: firstname!,
                                      lastName: lastname!,
                                      email: email!,
                                      password: password!)),
                                );
                            debugPrint('Login Validate');
                          }
                        },
                        backgroundColor: theme.primaryColorDark,
                        label: appLocalizations.btn_register,
                        stretch: true,
                      ),

                      const SizedBox(
                        height: 30,
                      ),
                      Text.rich(
                          TextSpan(
                              text: '${appLocalizations.have_account_text} ',
                              children: <InlineSpan>[
                                TextSpan(
                                  text: appLocalizations.btn_login,
                                  style: theme.textTheme.displayMedium
                                      ?.copyWith(
                                          color: theme.primaryColorDark,
                                          fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.of(context).pop(),
                                )
                              ]),
                          style: theme.textTheme.displayMedium),
                    ]),
                  ),
                ),
              );
            },
          ),
        ));
  }
}
