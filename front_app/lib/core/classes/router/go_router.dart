import 'package:barassage_app/features/admin_app/admin_app.dart';
import 'package:barassage_app/core/classes/app_context.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:barassage_app/features/main_app/app.dart';
import 'package:barassage_app/config/config.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';

String initialLocation = kIsWeb ? AdminApp.home : App.splash;

final router = GoRouter(
  navigatorKey: serviceLocator<AppContext>().navigatorKey,
  initialLocation: initialLocation,
  routes: Routes().routes,
);
