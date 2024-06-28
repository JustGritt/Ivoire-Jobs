import 'package:barassage_app/features/admin_app/models/service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../../config/api_endpoints.dart';
import '../../../config/app_http.dart';
import '../../auth_mod/models/user.dart';

class AdminService {
  String? token;

  AdminService({this.token});

  final AppHttp _http = AppHttp(
    baseUrl: ApiEndpoint.baseUrl,
  );

  // get an array of services
  Future<List<Service>> getAllServices() async {
    try {
      Response res = (await _http.get(ApiEndpoint.serviceCollection));
      debugPrint('services: $res');
      if (res.statusCode == 200) {
        List<Service> services =
            res.data.map((e) => Service.fromJson(e)).toList();
        return services;
      }
      throw Exception('Unexpected response format');
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('Failed to load services');
    }
  }

  Future<List<User>?> getAllUsers() async {
    try {
      Response res = await _http.get(ApiEndpoint.adminUsers);
      if (res.statusCode == 200) {
        List<User> users = res.data.map((e) => User.fromJson(e)).toList();
        return users;
      }
      throw Exception('Unexpected response format');
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('Failed to load users');
    }
  }
}
