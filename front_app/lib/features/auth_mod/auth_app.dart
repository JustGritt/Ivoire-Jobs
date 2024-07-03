import 'package:barassage_app/features/auth_mod/screens/mobile/splash_mobile_screen.dart';
import 'package:barassage_app/features/auth_mod/screens/mobile/welcome_mail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../core/classes/route_manager.dart';
import 'controllers/controllers.dart';
import 'controllers/register_email_validation_controller.dart';

class AuthApp extends RouteManager {
  static const String login = '/auth/login';
  static const String welcomeEmail = '/auth/emailWelcome';
  static const String profile = '/auth/me';
  static const String splashScreen = '/auth/splashScreen';
  static const String forget = '/forget';
  static const String register = '/auth/register';
  static const String emailValidation = '/auth/verify-email';
  static const String splash = '/splash';

  AuthApp() {
    addRoute(GoRoute(
        path: AuthApp.login,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: LoginController());
        }));
    addRoute(GoRoute(
        path: AuthApp.welcomeEmail,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: WelcomeMailScreen());
        }));

    addRoute(GoRoute(
        path: AuthApp.splashScreen,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: SplashMobileScreen());
        }));

    addRoute(GoRoute(
        path: AuthApp.forget,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: ForgetController());
        }));

    addRoute(GoRoute(
        path: AuthApp.register,
        pageBuilder: (context, state) {
          return const CupertinoPage(child: RegisterController());
        }));
    addRoute(GoRoute(
      path: AuthApp.emailValidation,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: EmailValidationController());
      }));
  }
}
