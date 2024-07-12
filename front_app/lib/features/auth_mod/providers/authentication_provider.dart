import 'package:barassage_app/features/auth_mod/services/api_exceptions.dart';
import 'package:barassage_app/features/auth_mod/models/user.dart';
import 'package:barassage_app/core/classes/app_context.dart';
import 'package:barassage_app/core/helpers/auth_helper.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:barassage_app/config/app_cache.dart';
import 'package:barassage_app/config/app_http.dart';
import 'package:flutter/foundation.dart';

AppCache appCache = serviceLocator<AppCache>();
AppContext appContext = serviceLocator<AppContext>();

class AuthenticationProvider extends ChangeNotifier {
  User? _user;
  bool isLoading = false;
  ErrorResponse? error;

  final AppHttp _http = AppHttp();

  User? get user => _user;

  void authenticate(String email, String password) async {
    try {
      User? user = await doAuth(email, password);
      if (user != null) {
        _user = user;
        notifyListeners();
      } else {
        error = ErrorResponse(message: 'Login failed', code: 401);
      }
    } catch (e) {
      error = ErrorResponse(message: 'Login failed', code: 401);
      debugPrint(e.toString());
    }
  }
}
