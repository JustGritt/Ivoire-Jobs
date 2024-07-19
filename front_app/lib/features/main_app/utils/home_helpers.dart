import 'package:barassage_app/config/app_ws.dart';
import 'package:barassage_app/core/blocs/authentication/authentication_bloc.dart';
import 'package:barassage_app/features/auth_mod/models/user.dart';
import 'package:barassage_app/features/auth_mod/screens/mobile/under_maintenance_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomeHelpers {
  WebSocketChannel? channel;
  listenToMaintenanceMode(BuildContext context) async {
    // listen to maintenance mode
    final user =
        (context.read<AuthenticationBloc>().state.props as List)[0] as User;

    AppWs appWs = AppWs();
    channel = await appWs.connectToServiceMaintenance();
    channel?.stream.listen((event) {
      if (event == 'true') {
        showModalBottomSheet(
            context: context, builder: (ctx) => UnderMaintenanceScreen());
      }
    });
  }

  void dispose() {
    channel?.sink.close();
  }
}
