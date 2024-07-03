import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/blocs/authentication/authentication_bloc.dart';
import '../../../auth_mod/widgets/widget_functions.dart';
import '../../../auth_mod/auth_app.dart';
import '../../../auth_mod/widgets/app_button.dart';

class LoginDesktopScreen extends StatefulWidget {
  const LoginDesktopScreen({
    super.key,
    void Function(String username, String password)? onLogged,
  });

  @override
  State<LoginDesktopScreen> createState() => _LoginDesktopScreenState();
}

class _LoginDesktopScreenState extends State<LoginDesktopScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  bool _isPasswordHide = true;
  String? username, password;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: theme.cardColor,
      body: SafeArea(
        child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Form(
                key: _globalKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 14.0),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18.0),
                                child: SvgPicture.asset(
                                  fit: BoxFit.fill,
                                  'assets/images/ill_dx.svg',
                                  width: 200,
                                  semanticsLabel: 'Acme Logo',
                                ),
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: ClipRect(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 2.0, sigmaY: 2.0),
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
                                    filter: ImageFilter.blur(
                                        sigmaX: 2.0, sigmaY: 2.0),
                                    child: Container(
                                      // the size where the blurring starts
                                      height: 50,
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 30.0),
                            child: Column(
                              children: [
                                Text(
                                  appLocalizations.welcome_back_admin,
                                  style: theme.textTheme.displayLarge,
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  appLocalizations.welcome_back_admin_description,
                                  style: theme.textTheme.displayMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Field(
                            nameField: appLocalizations.email,
                            onValid: (user) => username = user,
                          ),
                          const SizedBox(height: 10),
                          passwordField(
                            onValid: (pass) => password = pass,
                            passHide: _isPasswordHide,
                            onKeyBtnPressed: (val) {
                              setState(() {
                                _isPasswordHide = val;
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              forgetButton(
                                context,
                                onForget: () {
                                  return true;
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: double.infinity,
                            child: AppButton(
                              isLoading: state is AuthenticationLoadingState,
                              onPressed: () async {
                                if (_globalKey.currentState!.validate()) {
                                  context.read<AuthenticationBloc>().add(
                                        SignInUser(username!, password!),
                                      );
                                }
                              },
                              backgroundColor: theme.primaryColorDark,
                              label: 'Login',
                              stretch: true,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text.rich(
                            TextSpan(
                              text: '${appLocalizations.no_account_text} ',
                              children: <InlineSpan>[
                                TextSpan(
                                  text: appLocalizations.btn_create,
                                  style:
                                      theme.textTheme.displayMedium?.copyWith(
                                    color: theme.primaryColorDark,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap =
                                        () => context.push(AuthApp.register),
                                )
                              ],
                            ),
                            style: theme.textTheme.displayMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
