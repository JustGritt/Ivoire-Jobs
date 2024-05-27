import 'dart:async';

import 'package:clean_architecture/core/blocs/authentication/authentication_bloc.dart';
import 'package:clean_architecture/features/auth_mod/auth_mod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../core/classes/route_manager.dart';
import '../../../../core/init_dependencies.dart';
import '../../../../core/widgets/day_night_switch.dart';
import '../../widgets/auth_button.dart';
import '../../widgets/text_input_field.dart';

class SplashMobileScreen extends StatefulWidget {
  const SplashMobileScreen({Key? key}) : super(key: key);

  @override
  State<SplashMobileScreen> createState() => _SplashMobileScreenState();
}

class _SplashMobileScreenState extends State<SplashMobileScreen> with TickerProviderStateMixin {

  late final AuthenticationBloc _authenticationBloc;
  late StreamSubscription<AuthenticationState> _subscription;

  @override
  void initState() {
    super.initState();
    _authenticationBloc = serviceLocator<AuthenticationBloc>();
    // _authenticationBloc.add(AuthenticationStartedEvent());
    _subscription = _authenticationBloc.stream.listen((state) {
      if (state is AuthenticationSuccessState) {

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
