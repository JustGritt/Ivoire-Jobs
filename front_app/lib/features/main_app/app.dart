import 'package:barassage_app/config/app_config.dart';
import 'package:barassage_app/core/classes/app_context.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:barassage_app/features/auth_mod/screens/mobile/main_wrapper.dart';
import 'package:barassage_app/features/auth_mod/screens/mobile/splash_mobile_screen.dart';
import 'package:barassage_app/features/main_app/Screens/mobile/new_service.dart';
import 'package:barassage_app/features/main_app/Screens/mobile/services_details.dart';
import 'package:barassage_app/features/main_app/controllers/controller.dart';
import 'package:barassage_app/features/main_app/controllers/main/services_controller.dart';
import 'package:barassage_app/features/main_app/widgets/transition_page.dart';
// import 'package:barassage_app/features/main_app/controllers/main/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:place_picker/entities/localization_item.dart';
import 'package:place_picker/place_picker.dart';
import '../../core/classes/route_manager.dart';
// import 'controllers/controller.dart';

class App extends RouteManager {
  static const String name = '/app';
  static const String home = '${App.name}/home';
  static const String detailService = 'detailService';
  static const String services = '${App.name}/services';
  static const String placePicker = 'placesPicker';
  static const String serviceNew = 'newService';
  static const String splash = '${App.name}/splash';
  static const String contact = '${App.name}/contact';
  static const String news = '${App.name}/news';

  final _rootKey = serviceLocator<AppContext>().navigatorKey;
  final _shellHomeKey = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
  final _shellMapsKey = GlobalKey<NavigatorState>(debugLabel: 'Maps');
  final _shellSettingsKey = GlobalKey<NavigatorState>(debugLabel: 'Settings');

  App() {
    addRoute(StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootKey,
        builder: (context, state, navigationShell) {
          return MainWrapper(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: App.home,
                builder: (context, state) => const HomeController(),
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
            initialLocation: App.services,
            routes: [
              GoRoute(
                path: App.services,
                parentNavigatorKey: _shellMapsKey,
                builder: (context, state) => const ServicesController(),
                routes: [
                  GoRoute(
                    path: App.serviceNew,
                    parentNavigatorKey: _shellMapsKey,
                    pageBuilder: (context, state) =>
                        const PlatformTransitionPage(
                      child: NewServicePage(),
                    ).show(context),
                  ),
                  GoRoute(
                    name: 'placesPicker',
                    path: App.placePicker,
                    builder: (context, state) => PlacePicker(
                      Config.googleApiMaps,
                      localizationItem: LocalizationItem(
                        languageCode: 'en',
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          StatefulShellBranch(
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
