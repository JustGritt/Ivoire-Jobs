import 'package:barassage_app/features/auth_mod/screens/mobile/main_wrapper.dart';
import 'package:barassage_app/features/auth_mod/screens/mobile/splash_mobile_screen.dart';
import 'package:barassage_app/features/main_app/Screens/mobile/services_details.dart';
import 'package:barassage_app/features/main_app/controllers/controller.dart';
import 'package:barassage_app/features/main_app/controllers/main/about_controller.dart';
import 'package:barassage_app/features/main_app/controllers/main/home_controller.dart';
// import 'package:barassage_app/features/main_app/controllers/main/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/classes/route_manager.dart';
// import 'controllers/controller.dart';

class App extends RouteManager {
  static const String name = '';
  static const String home = '${App.name}/home';
  static const String detailService = 'detailService';
  static const String splash = '${App.name}/splash';
  static const String about = '${App.name}/about';
  static const String contact = '${App.name}/contact';
  static const String news = '${App.name}/news';

  final _shellFullRouteKey = GlobalKey<NavigatorState>(debugLabel: 'FullRoute');
  final _shellHomeKey = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
  final _shellMapsKey = GlobalKey<NavigatorState>(debugLabel: 'Maps');
  final _shellSettingsKey = GlobalKey<NavigatorState>(debugLabel: 'Settings');

  App() {
    addRoute(StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapper(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellHomeKey,
            routes: [
              GoRoute(
                path: App.home,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: HomeController(),
                ),
                routes: [
                  GoRoute(
                    path: App.detailService,
                    builder: (context, state) => ServiceDetailPage(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellMapsKey,
            routes: [
              GoRoute(
                path: App.about,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: AboutController(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellSettingsKey,
            routes: [
              GoRoute(
                path: App.contact,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ContactController(),
                ),
              ),
            ],
          ),
        ]));

    addRoute(GoRoute(
        path: App.splash,
        pageBuilder: (context, state) {
          return const MaterialPage(child: SplashMobileScreen());
        }));

    // addRoute(App.about, (context) => const AboutController());
    // addRoute(App.contact, (context) => const ContactController());
    // addRoute(App.news, (context) => const NewsController());
  }
}
