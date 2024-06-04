import 'package:barassage_app/config/app_routes.dart';
// import 'package:barassage_app/features/main_app/app.dart';
// import 'package:barassage_app/features/main_app/controllers/main/home_controller.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: Routes().routes,
);
