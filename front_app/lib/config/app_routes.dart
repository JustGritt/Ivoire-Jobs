import 'package:barassage_app/features/admin_app/admin_app.dart';
import 'package:barassage_app/features/auth_mod/auth_app.dart';
import 'package:barassage_app/core/classes/route_manager.dart';
import 'package:barassage_app/features/main_app/app.dart';
import 'package:flutter/foundation.dart';

class Routes extends RouteManager {
  Routes() {
    if (!kIsWeb) {
      addAll(AuthApp().routes);
      // addAll(LeadApp().routes);
      addAll(App().routes);
    } else {
      addAll(AdminApp().routes);
    }
  }
}
