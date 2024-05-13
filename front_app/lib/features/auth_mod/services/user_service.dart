import 'dart:convert';

import 'package:clean_architecture/features/auth_mod/models/user.dart';
import 'package:clean_architecture/features/auth_mod/models/user_login.dart';
import 'package:dio/dio.dart';

import '../../../config/api_endpoints.dart';
import '../../../config/app_config.dart';
import '../../../config/app_http.dart';
import '../models/user_signup.dart';

class UserService {
  final AppHttp _http = AppHttp(
    baseUrl: ApiEndpoint.baseUrl,
    headers: {'token': Config.token},
  );

  Future<User?> getAll() async {
    Response res = await _http.get(ApiEndpoint.enqueries);
    if (res.statusCode == 200) {
      User user = User.fromJson(res.data);
      return user;
    }
    return null;
  }

  Future<User?> getOne(int id) async {
    Response res = await _http.get(
      '${ApiEndpoint.enquery}/$id?populate=*',
    );
    if (res.statusCode == 200) {
      User user = User.fromJson(res.data);
      return user;
    }
    return null;
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

  // Future<User?> login(UserLogin userLogin) async {
  //   Map<String, dynamic> _data = userLogin.toJson();
  //   Response res = await _http.put(
  //     '${ApiEndpoint.enquery}/$id',
  //     data: jsonEncode(_data),
  //   );
  //   if (res.statusCode == 200 || res.statusCode == 201) {
  //     EnquerySingle enquery = EnquerySingle.fromJson(jsonEncode(res.data));
  //     return enquery;
  //   }
  //   return null;
  // }
}
