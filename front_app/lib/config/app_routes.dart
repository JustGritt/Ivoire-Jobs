import 'package:barassage_app/features/admin_app/admin_app.dart';
import 'package:barassage_app/features/auth_mod/auth_app.dart';

import '../core/classes/route_manager.dart';
// import '../features/auth_mod/auth_app.dart';
// import '../features/feature-2/feature_app.dart';
// import '../features/lead_mod/lead_app.dart';
import '../features/main_app/app.dart';

class Routes extends RouteManager {
  Routes() {
    addAll(AuthApp().routes);
    // addAll(LeadApp().routes);
    addAll(AdminApp().routes);
    addAll(App().routes);
    // addAll(FeatureApp().routes);
  }
}
