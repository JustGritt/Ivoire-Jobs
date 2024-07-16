import 'package:barassage_app/core/blocs/authentication/authentication_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:barassage_app/features/auth_mod/auth_app.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:barassage_app/features/main_app/app.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

// import '../../../main_app/app.dart';

class SplashMobileScreen extends StatefulWidget {
  const SplashMobileScreen({super.key});

  @override
  State<SplashMobileScreen> createState() => _SplashMobileScreenState();
}

class _SplashMobileScreenState extends State<SplashMobileScreen>
    with TickerProviderStateMixin {
  late final AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();
    _authenticationBloc = serviceLocator<AuthenticationBloc>();
    _authenticationBloc.add(InitiateAuth());
    _authenticationBloc.stream.listen((state) {
      if (state is AuthenticationSuccessState) {
        context.go(App.home);
      } else if (state is AuthenticationFailureState) {
        context.go(AuthApp.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
        body: Center(
            child: LoadingAnimationWidget.prograssiveDots(
      color: theme.primaryColor,
      size: 70,
    )));
  }
}
