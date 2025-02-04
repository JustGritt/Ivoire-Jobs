import 'package:barassage_app/features/lead_mod/controllers/controllers.dart';
import 'package:barassage_app/core/classes/route_manager.dart';
import 'package:barassage_app/features/features.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/cupertino.dart';

class LeadApp extends RouteManager {
  static const String name = '/lead';
  static const String home = '$name/';
  static const String search = '$name/search';
  static const String addEnquery = '$name/add_enquery';
  static const String editEnquery = '$name/edit_enquery';
  static const String viewEnquery = '$name/view_enquery';
  static const String followup = '$name/followup';

  LeadApp() {
    addRoute(GoRoute(
        path: LeadApp.home,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: DashboardController());
        }));

    addRoute(GoRoute(
        path: LeadApp.search,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: SearchController());
        }));

    addRoute(GoRoute(
        path: LeadApp.addEnquery,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: AddEnqueryController());
        }));

    addRoute(GoRoute(
        path: LeadApp.editEnquery,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: EditEnqueryController());
        }));

    addRoute(GoRoute(
        path: LeadApp.viewEnquery,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: ViewEnqueryController());
        }));

    addRoute(GoRoute(
        path: LeadApp.followup,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: FollowupController());
        }));

    addRoute(GoRoute(
        path: LeadApp.home,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: DashboardController());
        }));

    addRoute(GoRoute(
        path: LeadApp.search,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: SearchController());
        }));

    addRoute(GoRoute(
        path: LeadApp.addEnquery,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: AddEnqueryController());
        }));

    addRoute(GoRoute(
        path: LeadApp.editEnquery,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: EditEnqueryController());
        }));

    // addRoute(LeadApp.home, (context) => const DashboardController());
    // addRoute(LeadApp.search, (context) => const SearchController());
    // addRoute(LeadApp.addEnquery, (context) => const AddEnqueryController());
    // addRoute(LeadApp.editEnquery, (context) => const EditEnqueryController());
    // addRoute(LeadApp.viewEnquery, (context) => const ViewEnqueryController());
    // addRoute(LeadApp.followup, (context) => const FollowupController());
  }
}
