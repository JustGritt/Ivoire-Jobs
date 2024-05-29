import 'package:flutter/material.dart';

import '../../core/classes/route_manager.dart';
import 'controllers/controllers.dart';
import 'controllers/register_email_validation_controller.dart';

class AuthApp extends RouteManager {
  static const String login = '/auth/login';
  static const String profile = '/profile';
  static const String forget = '/forget';
  static const String register = '/auth/register';
  static const String emailValidation = '/auth/email-validation';
  static const String splash = '/splash';

  AuthApp() {
    addRoute(AuthApp.splash, (context) => const SplashController());
    addRoute(AuthApp.login, (context) => const LoginController());
    addRoute(AuthApp.emailValidation, (context) => const EmailValidationController());
    addRoute(AuthApp.profile, (context) => const ProfileController());
    addRoute(AuthApp.forget, (context) => const ForgetController());
    addRoute(AuthApp.register, (context) => const RegisterController());
  }
}
