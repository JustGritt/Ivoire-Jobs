import 'package:barassage_app/features/admin_app/controllers/abuse_claims_controller.dart';
import 'package:barassage_app/features/admin_app/controllers/manage_services_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../core/classes/route_manager.dart';
import 'controllers/manage_users_controller.dart';

class AdminApp extends RouteManager {
  static const String users = '/admin/users';
  static const String services = '/admin/services';
  static const String abuseClaims = '/admin/abuse-claims';

  AdminApp() {
    addRoute(GoRoute(
        path: AdminApp.users,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: UsersController());
        }));
    addRoute(GoRoute(
      path: AdminApp.services,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: ServicesController());
      }));
    addRoute(GoRoute(
      path: AdminApp.abuseClaims,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: AbuseClaimsController());
      }));
  }
}
