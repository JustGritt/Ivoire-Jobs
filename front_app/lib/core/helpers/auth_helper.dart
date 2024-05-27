
import 'dart:developer';

import 'package:clean_architecture/core/exceptions/dio_exceptions.dart';
import 'package:clean_architecture/features/auth_mod/models/user.dart';
import 'package:clean_architecture/features/auth_mod/models/user_login.dart';
import 'package:clean_architecture/features/auth_mod/services/user_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:logger/logger.dart';

import '../../config/config.dart';
import '../core.dart';

doAuth(BuildContext context, String email, String password) async {

       var logger = Logger();
  AppCache ac = AppCache();
  UserService us = UserService();
  try {
  User? user = await us.login(UserLogin(email: email, password: password));


debugPrint('User: $user');
  }  on DioException catch (e) {
    logger.e(DioExceptionHandler(e).error.message);
    showError(context, DioExceptionHandler(e).title!);
  }
  // inspect('User: $user');
  if (await ac.isLogin()) {
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   Nav.to(context, '/');
    //   showMessage(context, 'Login Successful');
    // });
  }
}

Future<Map<String, String>> authData() async {
  AppCache ac = AppCache();

  return ac.auth();
}

void doLogout(BuildContext context) async {
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
