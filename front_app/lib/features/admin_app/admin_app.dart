import 'package:barassage_app/features/admin_app/controllers/controllers.dart';
import 'package:barassage_app/features/admin_app/screens/desktop/login_desktop_screen.dart'; // Import your login screen
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../../core/classes/route_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/blocs/authentication/authentication_bloc.dart';
import 'package:barassage_app/features/admin_app/screens/desktop/splash_screen.dart';

class AdminApp extends RouteManager {
  static const String home = '/';
  static const String users = '/admin/users';
  static const String adminLogin = '/admin/login';
  static const String services = '/admin/services';
  static const String dashboard = '/admin/dashboard';
  static const String abuseClaims = '/admin/abuse-claims';
  static const String splash = '/admin/splash';
  static const String teams = '/admin/teams';
  static const String settings = '/admin/settings';

  AdminApp() {
    //add non authenticated routes
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
        final authenticationState = BlocProvider.of<AuthenticationBloc>(context).state;
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
        final authenticationState = BlocProvider.of<AuthenticationBloc>(context).state;
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
        final authenticationState = BlocProvider.of<AuthenticationBloc>(context).state;
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
        final authenticationState = BlocProvider.of<AuthenticationBloc>(context).state;
        if (authenticationState is! AuthenticationSuccessState) {
          return AdminApp.adminLogin;
        }
        return null;
      },
    ));

    addRoute(GoRoute(
      path: AdminApp.abuseClaims,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: AbuseClaimsController());
      },
      redirect: (context, state) {
        final authenticationState = BlocProvider.of<AuthenticationBloc>(context).state;
        if (authenticationState is! AuthenticationSuccessState) {
          return AdminApp.adminLogin;
        }
        return null;
      },
    ));

    addRoute(GoRoute(
      path: AdminApp.splash,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: SplashDesktopScreen());
      },
      redirect: (context, state) {
        final authenticationState = BlocProvider.of<AuthenticationBloc>(context).state;
        if (authenticationState is! AuthenticationSuccessState) {
          return AdminApp.home;
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
        final authenticationState = BlocProvider.of<AuthenticationBloc>(context).state;
        if (authenticationState is! AuthenticationSuccessState) {
          return AdminApp.adminLogin;
        }
        return null;
      },
    ));
  }
}
