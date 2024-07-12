import 'package:barassage_app/features/admin_app/models/category.dart';
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

  Future<List<Service>> getAllServices() async {
    try {
      Response res = await _http.get(ApiEndpoint.serviceCollection);
      debugPrint('services: ${res.data}');
      if (res.statusCode == 200) {
        debugPrint('services data type: ${res.data.runtimeType}');
        if (res.data is List) {
          List<Service> services =
              (res.data as List).map((e) => Service.fromJson(e)).toList();
          return services;
        } else if (res.data['data'] is List) {
          List<Service> services = (res.data['data'] as List)
              .map((e) => Service.fromJson(e))
              .toList();
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
      Response res = await _http.get(ApiEndpoint.adminUsers);
      if (res.statusCode == 200) {
        debugPrint('users: ${res.data}');
        List<User> users =
            (res.data as List).map((e) => User.fromJson(e)).toList();
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

  // get list of categories
  Future<List<Category>?> getCategories() async {
    try {
      Response res = await _http.get(ApiEndpoint.categoriesCollection);
      if (res.statusCode == 200) {
        debugPrint('categories: ${res.data}');
        List<Category> categories = categoryFromJson(res.data);
        return categories;
      }
      throw Exception('Unexpected response format');
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('Failed to load categories');
    }
  }

  // add a new category
  Future<Category> addCategory(String name) async {
    try {
      Response res = await _http.post(ApiEndpoint.categories, data: {
        'name': name,
        'status': true,
      });
      if (res.statusCode == 201) {
        debugPrint('category: ${res.data}');
        return Category.fromJson(res.data);
      }
      throw Exception('Failed to add category');
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('Failed to add category');
    }
  }
}
