//import 'package:barassage_app/features/admin_app/controllers/abuse_claims_controller.dart';
//import 'package:barassage_app/features/admin_app/controllers/admin_dashboard_controller.dart';
//import 'package:barassage_app/features/admin_app/controllers/manage_services_controller.dart';
import 'package:barassage_app/features/admin_app/controllers/controllers.dart';
import 'package:barassage_app/features/admin_app/screens/desktop/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../core/classes/route_manager.dart';
//import 'controllers/login_admin_controller.dart';
//import 'controllers/manage_users_controller.dart';

class AdminApp extends RouteManager {
  static const String users = '/admin/users';
  static const String adminLogin = '/admin/login';
  static const String services = '/admin/service';
  static const String dashboard = '/admin/dashboard';
  static const String abuseClaims = '/admin/abuse-claims';
  static const String splash = '/admin/splash';

  AdminApp() {
    addRoute(GoRoute(
        path: AdminApp.users,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: UsersController());
        }));
    addRoute(GoRoute(
      path: AdminApp.adminLogin,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: LoginDesktopController());
      },
    ));
    addRoute(GoRoute(
        path: AdminApp.services,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: ServicesController());
        }));
    addRoute(GoRoute(
        path: AdminApp.dashboard,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: AdminDashboardController());
        }));
    addRoute(GoRoute(
        path: AdminApp.abuseClaims,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: AbuseClaimsController());
        }));
    addRoute(GoRoute(
        path: AdminApp.splash,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: SplashDesktopScreen());
        }));
  }
}
