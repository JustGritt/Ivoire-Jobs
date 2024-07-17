import 'package:barassage_app/features/admin_app/controllers/register_email_validation_controller_import.dart' as web;
import 'package:barassage_app/features/admin_app/controllers/manage_categories_controller.dart';
import 'package:barassage_app/features/admin_app/controllers/manage_bookings_controller.dart';
import 'package:barassage_app/features/admin_app/controllers/manage_members_controller.dart';
import 'package:barassage_app/features/admin_app/screens/desktop/splash_screen.dart';
import 'package:barassage_app/core/blocs/authentication/authentication_bloc.dart';
import 'package:barassage_app/features/admin_app/controllers/controllers.dart';
import 'package:barassage_app/core/classes/route_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/cupertino.dart';

import 'package:barassage_app/features/admin_app/controllers/logs_controller.dart';

class AdminApp extends RouteManager {
  static const String home = '/';
  static const String users = '/admin/users';
  static const String adminLogin = '/admin/login';
  static const String services = '/admin/services';
  static const String dashboard = '/admin/dashboard';
  static const String abuseClaims = '/admin/abuse-claims';
  static const String categories = '/admin/categories';
  static const String bookings = '/admin/booking';
  static const String splash = '/admin/splash';
  static const String teams = '/admin/teams';
  static const String settings = '/admin/settings';
  static const String banlist = '/admin/banlist';
  static const String members = '/admin/members';
  static const String reports = '/admin/reports';
  static const String emailValidation = '/auth/verify-email';
  static const String logs = '/admin/logs';

  AdminApp() {
    addRoute(GoRoute(
      path: AdminApp.home,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: HomeController());
      },
    ));

    addRoute(GoRoute(
      path: AdminApp.adminLogin,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: LoginDesktopController());
      },
    ));

    addRoute(GoRoute(
      path: AdminApp.dashboard,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: AdminDashboardController());
      },
      redirect: (context, state) {
        final authenticationState =
            BlocProvider.of<AuthenticationBloc>(context).state;
        if (authenticationState is! AuthenticationSuccessState) {
          return AdminApp.adminLogin;
        }
        return null;
      },
    ));

    addRoute(GoRoute(
      path: AdminApp.users,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: UsersController());
      },
      redirect: (context, state) {
        final authenticationState =
            BlocProvider.of<AuthenticationBloc>(context).state;
        if (authenticationState is! AuthenticationSuccessState) {
          return AdminApp.adminLogin;
        }
        return null;
      },
    ));

    addRoute(GoRoute(
      path: AdminApp.services,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: ServicesController());
      },
      redirect: (context, state) {
        final authenticationState =
            BlocProvider.of<AuthenticationBloc>(context).state;
        if (authenticationState is! AuthenticationSuccessState) {
          return AdminApp.adminLogin;
        }
        return null;
      },
    ));

    addRoute(GoRoute(
      path: AdminApp.teams,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: TeamManagerController());
      },
      redirect: (context, state) {
        final authenticationState =
            BlocProvider.of<AuthenticationBloc>(context).state;
        if (authenticationState is! AuthenticationSuccessState) {
          return AdminApp.adminLogin;
        }
        return null;
      },
    ));

    addRoute(GoRoute(
      path: AdminApp.members,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: MembersController());
      },
    ));

    addRoute(GoRoute(
      path: AdminApp.abuseClaims,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: AbuseClaimsController());
      },
      redirect: (context, state) {
        final authenticationState =
            BlocProvider.of<AuthenticationBloc>(context).state;
        if (authenticationState is! AuthenticationSuccessState) {
          return AdminApp.adminLogin;
        }
        return null;
      },
    ));

    addRoute(GoRoute(
        path: AdminApp.categories,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: CategoriesController());
        },
        redirect: (context, state) {
          final authenticationState =
              BlocProvider.of<AuthenticationBloc>(context).state;
          if (authenticationState is! AuthenticationSuccessState) {
            return AdminApp.adminLogin;
          }
          return null;
        }));

    addRoute(GoRoute(
      path: AdminApp.splash,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: SplashDesktopScreen());
      },
      redirect: (context, state) {
        final authenticationState =
            BlocProvider.of<AuthenticationBloc>(context).state;
        if (authenticationState is! AuthenticationSuccessState) {
          return AdminApp.home;
        }
        return null;
      },
    ));

    addRoute(GoRoute(
      path: AdminApp.bookings,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: BookingsController());
      },
      redirect: (context, state) {
        final authenticationState =
            BlocProvider.of<AuthenticationBloc>(context).state;
        if (authenticationState is! AuthenticationSuccessState) {
          return AdminApp.adminLogin;
        }
        return null;
      },
    ));

    addRoute(GoRoute(
      path: AdminApp.settings,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: AdminSettingsController());
      },
      redirect: (context, state) {
        final authenticationState =
            BlocProvider.of<AuthenticationBloc>(context).state;
        if (authenticationState is! AuthenticationSuccessState) {
          return AdminApp.adminLogin;
        }
        return null;
      },
    ));

    addRoute(GoRoute(
      path: AdminApp.banlist,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: BanListController());
      },
      redirect: (context, state) {
        final authenticationState =
            BlocProvider.of<AuthenticationBloc>(context).state;
        if (authenticationState is! AuthenticationSuccessState) {
          return AdminApp.banlist;
        }
        return null;
      },
    ));

    addRoute(GoRoute(
      path: AdminApp.reports,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: ReportsController());
      },
      redirect: (context, state) {
        final authenticationState =
            BlocProvider.of<AuthenticationBloc>(context).state;
        if (authenticationState is! AuthenticationSuccessState) {
          return AdminApp.reports;
        }
        return null;
      },
    ));

    addRoute(GoRoute(
      path: AdminApp.logs,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: LogsController());
      },
      redirect: (context, state) {
        final authenticationState =
            BlocProvider.of<AuthenticationBloc>(context).state;
        if (authenticationState is! AuthenticationSuccessState) {
          return AdminApp.logs;
        }
        return null;
      },
    ));

    addRoute(GoRoute(
        path: AdminApp.emailValidation,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: web.EmailValidationController());
        }));
  }
}
