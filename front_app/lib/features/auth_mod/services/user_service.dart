import 'dart:convert';

import 'package:barassage_app/features/auth_mod/models/api_response.dart';
import 'package:barassage_app/features/auth_mod/models/user.dart';
import 'package:barassage_app/features/auth_mod/models/user_login.dart';
import 'package:dio/dio.dart';

import '../../../config/api_endpoints.dart';
import '../../../config/app_http.dart';
import '../models/user_signup.dart';

class UserService {
  String? token;
  UserService({this.token});
  final AppHttp _http = AppHttp();

  Future<User?> getAll() async {
    Response res = await _http.get(ApiEndpoint.enqueries);
    if (res.statusCode == 200) {
      User user = User.fromJson(res.data);
      return user;
    }
    return null;
  }

  Future<UserLoginResponse> getMyProfile() async {
    Response res = await _http
        .get(
          ApiEndpoint.appProfileUrl,
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
    Response res = await _http.post(
      ApiEndpoint.appRegisterUrl,
      data: userSignup.toJson(),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      ApiResponse apiResponse = ApiResponse.fromJson(res.data);
      return User.fromJson(apiResponse.body);
    }
    return null;
  }

  Future<UserLoginResponse> login(UserLogin userLogin) async {
    Map<String, dynamic> data = userLogin.toJson();
    Response res = await _http.post(
      ApiEndpoint.appLoginUrl,
      data: jsonEncode(data),
    );
    if (res.statusCode == 200) {
      ApiResponse apiResponse = ApiResponse.fromJson(res.data);
      UserLoginResponse userLogin =
          UserLoginResponse.fromJson(apiResponse.body);
      return userLogin;
    }
    throw res.data['message'];
  }

  Future<bool> verifyEmailToken(String token) async {
    Response res = await _http.get(
      '${ApiEndpoint.appEmailValidationUrl}?token=$token',
    );
    if (res.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<List<User>?> getUsers() async {
    Response res = await _http.get(ApiEndpoint.adminUsers);
    if (res.statusCode == 200) {
      List<User> users
      = (res.data as List)
          .map((e) => User.fromJson(e))
          .toList();
      return users;
    }
    return null;
  }
}
