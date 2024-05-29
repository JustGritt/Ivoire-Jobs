import 'dart:async';

import 'package:barassage_app/core/blocs/authentication/authentication_bloc.dart';
import 'package:barassage_app/core/classes/route_manager.dart';
import 'package:barassage_app/features/auth_mod/auth_app.dart';
import 'package:barassage_app/features/main_app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../core/init_dependencies.dart';

class SplashMobileScreen extends StatefulWidget {
  const SplashMobileScreen({super.key});

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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/onboarding.png'),
            SizedBox(height: 20),
            Text(
              'Welcome to Ivory Jobs',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Discover amazing features and enjoy a seamless experience.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Nav.to(context, '/login');
              },
              child: Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
