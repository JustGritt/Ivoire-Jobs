import 'package:barassage_app/features/admin_app/models/service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../../config/api_endpoints.dart';
import '../../../config/app_http.dart';
import '../../auth_mod/models/api_response.dart';
import '../../auth_mod/models/user.dart';
import '../models/admin_user.dart';

class AdminService {
  String? token;

  AdminService({this.token});

  final AppHttp _http = AppHttp(
    baseUrl: ApiEndpoint.baseUrl,
  );

  Future<List<Service>> getAllServices() async {
    try {
      Response res = await _http.get(ApiEndpoint.serviceCollection);
      debugPrint('services: ${res.data}');
      if (res.statusCode == 200) {
        debugPrint('services data type: ${res.data.runtimeType}');
        if (res.data is List) {
          List<Service> services = (res.data as List).map((e) => Service.fromJson(e)).toList();
          return services;
        } else if (res.data['data'] is List) {
          List<Service> services = (res.data['data'] as List).map((e) => Service.fromJson(e)).toList();
          return services;
        }
        throw Exception('Unexpected response format');
      }
      throw Exception('Failed to load services');
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('Failed to load services');
    }
  }

  Future<List<User>?> getAllUsers() async {
    try {
      Response res = await _http.get(ApiEndpoint.adminUsers + '?type=users');
      if (res.statusCode == 200) {
        debugPrint('users: ${res.data}');
        List<User> users = (res.data as List).map((e) => User.fromJson(e)).toList();
        return users;
      }
      throw Exception('Unexpected response format');
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('Failed to load users');
    }
  }

  Future<List<User>?> getAllAdminUsers() async {
    try {
      Response res = await _http.get(ApiEndpoint.adminUsers + '?type=admin');
      if (res.statusCode == 200) {
        debugPrint('users: ${res.data}');
        List<User> users = (res.data as List).map((e) => User.fromJson(e)).toList();
        return users;
      }
      throw Exception('Unexpected response format');
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('Failed to load users');
    }
  }

  //ban a user
 Future<void> banUser(String userId, String reason) async {
    try {
      Response res = await _http.post(ApiEndpoint.banUser, data: {
        'userId': userId,
        'reason': reason,
      });
      if (res.statusCode == 201) {
        return;
      }
      throw Exception('Failed to ban user');
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('Failed to ban user');
    }
  }
  
  Future<AdminUser?> createAdminUser(AdminUser user) async {
    try {
      print(user.toJson());
      Response res = await _http.post(
        ApiEndpoint.addAdmin,
        data: user.toJson(),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        ApiResponse apiResponse = ApiResponse.fromJson(res.data);
        return AdminUser.fromJson(apiResponse.body);
      } else {
        throw Exception('Failed to create admin user: ${res.data}');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception('Failed to create admin user: ${e.response?.data['message'] ?? e.response?.statusMessage}');
      } else {
        throw Exception('Failed to create admin user: ${e.message}');
      }
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('Failed to create admin user: $e');
    }
  }
  
}
