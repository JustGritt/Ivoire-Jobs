import 'package:barassage_app/config/app_routes.dart';
import 'package:barassage_app/core/classes/app_context.dart';
import 'package:barassage_app/core/init_dependencies.dart';
// import 'package:barassage_app/features/main_app/app.dart';
// import 'package:barassage_app/features/main_app/controllers/main/home_controller.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  navigatorKey: serviceLocator<AppContext>().navigatorKey,
  initialLocation: '/splash',
  routes: Routes().routes,
);
