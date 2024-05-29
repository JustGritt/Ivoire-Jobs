import 'package:barassage_app/core/classes/app_context.dart';
import 'package:barassage_app/core/exceptions/dio_exceptions.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:barassage_app/features/auth_mod/models/user.dart';
import 'package:barassage_app/features/auth_mod/models/user_login.dart';
import 'package:barassage_app/features/auth_mod/models/user_signup.dart';
import 'package:barassage_app/features/auth_mod/services/user_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:logger/logger.dart';

import '../../config/config.dart';
import '../core.dart';

BuildContext context = serviceLocator<AppContext>().navigatorContext;
var logger = Logger();

doAuth(String email, String password) async {
  AppCache ac = AppCache();
  UserService us = UserService();
  try {
    UserLoginResponse userLoginResponse =
        await us.login(UserLogin(email: email, password: password));
    ac.doLogin(userLoginResponse.user, userLoginResponse.accessToken);
  } on DioException catch (e) {
    logger.e(DioExceptionHandler(e).error.message);
    showError(context, DioExceptionHandler(e).title);
  }
  if (await ac.isLogin()) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Nav.to(context, '/');
      showMessage(context, 'Login Successful');
    });
  }
}

doRegister(UserSignup userSignup) async {
  UserService us = serviceLocator<UserService>();
  try {
    User? user = await us.register(userSignup);
    debugPrint('User: $user');
  } on DioException catch (e) {
    logger.e(DioExceptionHandler(e).error.message);
    showError(context, DioExceptionHandler(e).title);
  }
  if (await AppCache().isLogin()) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Nav.to(context, '/');
      showMessage(context, 'Register Successful');
    });
  }
}

Future<User?> getMyProfile() async {
  UserService us = serviceLocator<UserService>();
  try {
    UserLoginResponse userLogin = await us.getMyProfile();
    return userLogin.user;
  } on DioException catch (e) {
    logger.e(DioExceptionHandler(e).error.message);
    showError(context, DioExceptionHandler(e).title);
    return null;
  } catch (e) {
    print("here $e");
    logger.e(e);
    return null;
  }
}

void doLogout() async {
  AppCache ac = AppCache();
  ac.doLogout();
  checkLogin(context, auth: true);
  showMessage(context, 'Logout Successfull');
}

void checkLogin(
  BuildContext context, {
  bool? auth = false,
  String? loginUrl = ApiEndpoint.appLoginUrl,
}) {
  AppCache ac = AppCache();
  ac.isLogin().then((value) {
    if (value == false && auth! == true) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Nav.to(context, loginUrl!);
      });
    }
  });
}

void checkRegisterToken(BuildContext context, String token) {
  UserService us = UserService();
  us.verifyEmailToken(token).then((value) {
    if (value == false) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        // setState(() {
        //   isEmailValidated = false;
        //   isLoading = false;
        // });
      });
    }
  });
}
