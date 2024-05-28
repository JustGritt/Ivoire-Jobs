import 'dart:async';

import 'package:barassage_app/core/blocs/authentication/authentication_bloc.dart';
import 'package:barassage_app/features/auth_mod/auth_app.dart';
import 'package:barassage_app/features/main_app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../core/init_dependencies.dart';

class SplashMobileScreen extends StatefulWidget {
  const SplashMobileScreen({Key? key}) : super(key: key);

  @override
  State<SplashMobileScreen> createState() => _SplashMobileScreenState();
}

class _SplashMobileScreenState extends State<SplashMobileScreen>
    with TickerProviderStateMixin {
  late final AuthenticationBloc _authenticationBloc;
  late StreamSubscription<AuthenticationState> _subscription;

  @override
  void initState() {
    super.initState();
    _authenticationBloc = serviceLocator<AuthenticationBloc>();
    _authenticationBloc.add(InitiateAuth());
    _subscription = _authenticationBloc.stream.listen((state) {
      if (state is AuthenticationSuccessState) {
        Navigator.of(context).pushReplacementNamed(App.home);
      } else if (state is AuthenticationFailureState) {
        Navigator.of(context).pushReplacementNamed(AuthApp.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
