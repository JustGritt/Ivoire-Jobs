import 'package:barassage_app/core/blocs/authentication/authentication_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:barassage_app/features/admin_app/admin_app.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

// TODO: Remove this screen
import 'package:barassage_app/features/main_app/app.dart';

class SplashDesktopScreen extends StatefulWidget {
  const SplashDesktopScreen({super.key});

  @override
  State<SplashDesktopScreen> createState() => _SplashDesktopScreenState();
}

class _SplashDesktopScreenState extends State<SplashDesktopScreen>
    with TickerProviderStateMixin {
  late final AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();
    _authenticationBloc = serviceLocator<AuthenticationBloc>();
    _authenticationBloc.add(InitiateAuth());
    _authenticationBloc.stream.listen((state) {
      // TODO: Replace this with the actual routes
      if (state is AuthenticationSuccessState) {
        // context.go(AdminApp.dashboard);
        context.go(App.home);
      } else if (state is AuthenticationFailureState) {
        // context.go(AdminApp.home);
        context.go(App.home);
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
      ))
    );
  }
}
