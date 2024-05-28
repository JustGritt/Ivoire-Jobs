import 'package:barassage_app/features/auth_mod/screens/mobile/splash_mobile_screen.dart';

import '../../core/classes/route_manager.dart';
import 'controllers/controllers.dart';

class AuthApp extends RouteManager {
  static const String login = '/auth/login';
  static const String profile = '/auth/getMyProfile';
  static const String splashScreen = '/auth/splashScreen';
  static const String forget = '/forget';
  static const String register = '/auth/register';

  AuthApp() {
    addRoute(AuthApp.login, (context) => const LoginController());
    addRoute(AuthApp.splashScreen, (context) => const SplashMobileScreen());
    addRoute(AuthApp.profile, (context) => const ProfileController());
    addRoute(AuthApp.forget, (context) => const ForgetController());
    addRoute(AuthApp.register, (context) => const RegisterController());
  }
}
