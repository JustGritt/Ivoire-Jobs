import 'dart:convert';
import 'dart:developer';

import 'package:barassage_app/config/app_cache.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:barassage_app/features/auth_mod/models/api_response.dart';
import 'package:barassage_app/features/auth_mod/models/user.dart';
import 'package:barassage_app/features/auth_mod/models/user_login.dart';
import 'package:dio/dio.dart';

import '../../../config/api_endpoints.dart';
import '../../../config/app_config.dart';
import '../../../config/app_http.dart';
import '../models/user_signup.dart';

class UserService {
  String? token;
  UserService({this.token});
  final AppHttp _http = AppHttp(
    baseUrl: ApiEndpoint.baseUrl,
  );

  Future<User?> getAll() async {
    Response res = await _http.get(ApiEndpoint.enqueries);
    if (res.statusCode == 200) {
      User user = User.fromJson(res.data);
      return user;
    }
    return null;
  }

  Future<UserLoginResponse> getMyProfile() async {
    AppCache ac = serviceLocator<AppCache>();
    String? token = await ac.getToken();
    if (token == null) {
      throw 'Token is null';
    }
    _http.setToken(token);
    Response res = await _http
        .get(
          '${ApiEndpoint.api}${ApiEndpoint.appProfileUrl}',
        )
        .timeout(const Duration(seconds: 4));
    if (res.statusCode == 200) {
      ApiResponse apiResponse = ApiResponse.fromJson(res.data);
      UserLoginResponse userLogin =
          UserLoginResponse.fromJson(apiResponse.body);
      return userLogin;
    }
    throw res.data['message'];
  }

  Future<UserLoginResponse> getOne(int id) async {
    Response res = await _http.get(
      '${ApiEndpoint.enquery}/$id?populate=*',
    );
    if (res.statusCode == 200) {
      ApiResponse apiResponse = ApiResponse.fromJson(res.data);
      UserLoginResponse userLogin =
          UserLoginResponse.fromJson(apiResponse.body);
      return userLogin;
    }
    throw res.data['message'];
  }

  Future<User?> register(UserSignup userSignup) async {
    Map<String, dynamic> _data = userSignup.toJson();
    Response res = await _http.post(
      ApiEndpoint.enquery,
      data: jsonEncode(_data),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      User user = User.fromJson(res.data);
      return user;
    }
    return null;
  }

  Future<UserLoginResponse> login(UserLogin userLogin) async {
    Map<String, dynamic> _data = userLogin.toJson();
    Response res = await _http.post(
      '${ApiEndpoint.api}${ApiEndpoint.appLoginUrl}',
      data: jsonEncode(_data),
    );
    if (res.statusCode == 200) {
      ApiResponse apiResponse = ApiResponse.fromJson(res.data);
      UserLoginResponse userLogin =
          UserLoginResponse.fromJson(apiResponse.body);
      return userLogin;
    }
    throw res.data['message'];
  }
}
