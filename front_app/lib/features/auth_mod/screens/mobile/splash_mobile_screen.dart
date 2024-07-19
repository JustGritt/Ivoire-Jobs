import 'dart:async';

import 'package:barassage_app/config/app_cache.dart';
import 'package:barassage_app/core/blocs/authentication/authentication_bloc.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:barassage_app/features/auth_mod/auth_app.dart';
import 'package:barassage_app/features/main_app/app.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

AppCache appCache = serviceLocator<AppCache>();

class SplashMobileScreen extends StatefulWidget {
  const SplashMobileScreen({super.key});

  @override
  State<SplashMobileScreen> createState() => _SplashMobileScreenState();
}

class _SplashMobileScreenState extends State<SplashMobileScreen>
    with TickerProviderStateMixin {
  late final AuthenticationBloc _authenticationBloc;
  late final StreamSubscription _authSubscription;

  @override
  void initState() {
    super.initState();
    _authenticationBloc = context.read<AuthenticationBloc>()
      ..add(InitiateAuth());

    _authSubscription = _authenticationBloc.stream.listen((state) async {
      if (!mounted) return;
      if (state is AuthenticationSuccessState) {
        context.go(App.home);
      } else if (state is AuthenticationFailureState) {
        bool isSeenOnboarding = await appCache.isSeenOnboarding();
        if (!isSeenOnboarding) {
          context.go(AuthApp.onboarding);
        } else if (isSeenOnboarding) {
          context.go(AuthApp.login);
        } else {
          context.go(AuthApp.register);
        }
      }
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: LoadingAnimationWidget.prograssiveDots(
          color: theme.primaryColor,
          size: 70,
        ),
      ),
    );
  }
}
