import 'package:barassage_app/features/feature-2/controllers/controller.dart';
import 'package:barassage_app/core/classes/route_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/cupertino.dart';

class FeatureApp extends RouteManager {
  static const String name = '/feature';
  static const String home = FeatureApp.name;
  static const String about = '${FeatureApp.name}/about';
  static const String contact = '${FeatureApp.name}/contact';

  FeatureApp() {
    addRoute(GoRoute(
        path: FeatureApp.home,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: HomeController());
        }));

    addRoute(GoRoute(
        path: FeatureApp.about,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: AboutController());
        }));

    addRoute(GoRoute(
        path: FeatureApp.contact,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: ContactController());
        }));

    // addRoute(FeatureApp.home, (context) => const HomeController());
    // addRoute(FeatureApp.about, (context) => const AboutController());
    // addRoute(FeatureApp.contact, (context) => const ContactController());
  }
}
