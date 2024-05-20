import '../../core/classes/route_manager.dart';
import 'controllers/controllers.dart';

class AuthApp extends RouteManager {
  static const String login = '/login';
  static const String profile = '/profile';
  static const String forget = '/forget';
  static const String register = '/register';

  AuthApp() {
    addRoute(AuthApp.login, (context) => const LoginController());
    addRoute(AuthApp.profile, (context) => const ProfileController());
    addRoute(AuthApp.forget, (context) => const ForgetController());
    addRoute(AuthApp.register, (context) => const RegisterController());
  }
}
