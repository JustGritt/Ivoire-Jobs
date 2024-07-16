import 'package:barassage_app/features/admin_app/models/category.dart';
import 'package:barassage_app/features/admin_app/models/log.dart';
import 'package:barassage_app/features/admin_app/models/member.dart';
import 'package:barassage_app/features/auth_mod/models/api_response.dart';
import 'package:barassage_app/features/admin_app/models/admin_user.dart';
import 'package:barassage_app/features/admin_app/models/service.dart';
import 'package:barassage_app/features/auth_mod/models/user.dart';
import 'package:barassage_app/config/api_endpoints.dart';
import 'package:barassage_app/config/app_http.dart';

import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';

import '../models/booking.dart';
import '../models/dashboard_stats.dart';

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
      Response res = await _http.get(ApiEndpoint.adminUsers + '?type=users');
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

  Future<List<User>?> getAllAdminUsers() async {
    try {
      Response res = await _http.get(ApiEndpoint.adminUsers + '?type=admin');
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
        throw Exception(
            'Failed to create admin user: ${e.response?.data['message'] ?? e.response?.statusMessage}');
      } else {
        throw Exception('Failed to create admin user: ${e.message}');
      }
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('Failed to create admin user: $e');
    }
  }

  // get list of categories
  Future<void> addCategory(String name) async {
    try {
      Response res =
          await _http.post(ApiEndpoint.categories, data: {'name': name});
      if (res.statusCode != 200) {
        throw Exception('Failed to add category');
      }
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('Failed to add category');
    }
  }

  Future<List<Category>> getCategories() async {
    try {
      Response res = await _http.get(ApiEndpoint.categoriesCollection);
      if (res.statusCode == 200) {
        List<Category> categories =
            (res.data as List).map((json) => Category.fromJson(json)).toList();
        return categories;
      }
      throw Exception('Unexpected response format');
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Member>> getMemberRequests() async {
    try {
      Response res = await _http.get(ApiEndpoint.memberRequests);
      if (res.statusCode == 200) {
        List<Member> members =
            (res.data as List).map((e) => Member.fromJson(e)).toList();
        return members;
      }
      throw Exception('Failed to load member requests');
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('Failed to load member requests');
    }
  }

  Future<void> approveMemberRequest(String id, String action) async {
    try {
      Response res = await _http
          .put(ApiEndpoint.approveMember.replaceAll(':id', id), data: {
        'status': action,
      });
      if (res.statusCode == 201) {
        return;
      }
      throw Exception('Failed to approve member request');
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('Failed to approve member request');
    }
  }

  Future<DashboardStats> fetchDashboardStats() async {
    final response = await _http.get(ApiEndpoint.adminDashboardStats);
    if (response.statusCode == 200) {
      final data = response.data;
      return DashboardStats.fromJson(data);
    } else {
      throw Exception('Failed to load dashboard stats');
    }
  }

  Future<List<Booking>> getBookings() async {
    try {
      Response res = await _http.get(ApiEndpoint.bookingsCollection);
      debugPrint('res-bookings: ${res.data}');
      if (res.statusCode == 200) {
        List<Booking> bookings =
        (res.data as List).map((e) => Booking.fromJson(e)).toList();
        print('AdminService - bookings: $bookings'); // Logging the bookings
        return bookings;
      }
      throw Exception('Failed to load bookings');
    } catch (e) {
      print('Error in AdminService: $e'); // Logging the error
      throw Exception('Failed to load bookings');
    }
  }

  Future<List<Log>> getLogs({required int page}) async {
    try {
      Response res = await _http.get(ApiEndpoint.logsCollection);
      debugPrint('res-logs: ${res.data}');
      if (res.statusCode == 200) {
        List<Log> logs =
        (res.data as List).map((e) => Log.fromJson(e)).toList();
        print('AdminService - logs: $logs');
        return logs;
      }
      throw Exception('Failed to load logs');
    } catch (e) {
      print('Error in AdminService: $e');
      throw Exception('Failed to load logs');
    }
  }
}
