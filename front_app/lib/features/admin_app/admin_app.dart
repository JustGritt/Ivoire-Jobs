import 'package:barassage_app/features/admin_app/controllers/abuse_claims_controller.dart';
import 'package:barassage_app/features/admin_app/controllers/manage_services_controller.dart';

import '../../core/classes/route_manager.dart';
import 'controllers/manage_users_controller.dart';

class AdminApp extends RouteManager {
  static const String users = '/admin/users';
  static const String services = '/admin/services';
  static const String abuseClaims = '/admin/abuse-claims';

  AdminApp() {
    addRoute(AdminApp.users, (context) => const UsersController());
    addRoute(AdminApp.services, (context) => const ServicesController());
    addRoute(AdminApp.abuseClaims, (context) => const AbuseClaimsController());
  }
}
